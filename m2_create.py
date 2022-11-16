from time import sleep
import boto3
import boto3.session
import json
from os import error
import time
from datetime import datetime 
from datetime import timedelta

# You need to be logged into your AWS account. (ie. running aws configure in the AWS CLI)

def create_bankdemo_runtime():
    start = time.time()
    date_time = datetime.fromtimestamp(start)
    timestamp = date_time.strftime("%d%m%y%H%M")

    # Create your own session
    my_session = boto3.session.Session(profile_name="<<<Your profile goes here>>>")
    # If you are not using profiles, use the below to create the session. 
    # my_session = boto3.session.Session()

    # Now we can create low-level clients or resource clients from our custom session
    m2 = my_session.client('m2')
    rds = my_session.client('rds')
    secretmanager = my_session.client('secretsmanager')


    envname = "m2" + timestamp
    dbname = "m2db" + timestamp
    secretname = "m2secret" + timestamp
    appname = "m2bankdemo" + timestamp
    kmskeyid = "<<<Your KMS ARN goes here>>>"
    
    secretstring = read_json("mfcreds.json")
    appdef = read_json("appdef.json")    
    secretpolicy = read_json("secretrespolicy.json")
        
    # Prepare deletion information
    delinfo = {"appname": appname, "dbname": dbname}

    print("Starting environment creation")
    res = m2.create_environment(    
        description='Created in Python',
        engineType='microfocus',    
        instanceType='M2.m5.large',
        name=envname,    
        publiclyAccessible=True,  
        # Uncomment and set you subnet IDs below for Highly Avaiable cluster
        # highAvailabilityConfig={
        # 'desiredCapacity': 2
        # },
        # subnetIds=[
        # '<<<Your 1st subnet ID goes here>>>', '<<<Your 2nd subnet ID goes here>>>'
        # ],  
    )

    print("Starting DB creation")
    res = rds.create_db_instance(    
        DBInstanceIdentifier=dbname,
        AllocatedStorage=20,
        DBInstanceClass='db.t3.small',
        Engine='postgres',
    # In case you need a specific PostgresQL engine version
    #    EngineVersion='13.3',
        MasterUsername='postgres',
        MasterUserPassword='postgres',    
        MultiAZ=False,    
        PubliclyAccessible=False,
    # Need to make sure the parameter group familty matches the PostgreSQL engine version
    #    DBParameterGroupName='m2-tutorial-pg-1'  
        DBParameterGroupName='<<<Your parametr group name goes here>>>'          
    )

    envid = wait_for_env_creation(m2,envname)
    print("Environment " + envid + " created!") 
    delinfo["envid"] = envid   

    dbhost = wait_for_db_creation(rds,dbname)
    
    print("DB " + dbname + " is available on address: " + dbhost)    

    secretstring["host"] = dbhost
    secretstring["dbInstanceIdentifier"] = dbname

    print("Starting secret creation")
    response = secretmanager.create_secret(
        Name=secretname,    
        KmsKeyId=kmskeyid,
        SecretString=json.dumps(secretstring)
    )
    
    secretarn = response["ARN"]
    print ("Secret with ARN: " + secretarn + " created!")
    delinfo["secretarn"] = secretarn

    response = secretmanager.put_resource_policy(
        SecretId=secretarn,
        ResourcePolicy=json.dumps(secretpolicy)       
    )
    
    print ("Applied policy to secret: " + secretarn)

    appdef["resources"][0]["properties"]["secret-manager-arn"] = secretarn
    appdef["resources"][4]["properties"]["secret-manager-arn"] = secretarn

    print("Starting application creation")
    response = m2.create_application(
        definition={
            'content': json.dumps(appdef),            
        },
        description='Created with Python',
        engineType='microfocus',
        name=appname        
    )

    appid = wait_for_app_creation(m2,appname)
    
    print("Application " + appid + " created!")
    delinfo["appid"] = appid

    print("Deploying application")
    response = m2.create_deployment(
        applicationId=appid,
        applicationVersion=1,        
        environmentId=envid
    )

    deploymentid = response["deploymentId"]
    
    wait_for_app_deployment(m2, appid, deploymentid)

    print("Deployment " + deploymentid + " succeeded!")

    print("Starting dataset import creation")
    response = m2.create_data_set_import_task(
        applicationId=appid,        
        importConfig={ 's3Location': 's3://m2-python/datasets.json' }    
    )
    
    datasetstaskid = response["taskId"]
    
    res = wait_for_datasets_import(m2, appid, datasetstaskid)
    
    print("Datasets import finished, taskid is " + datasetstaskid + " summary: " + json.dumps(res))

    print("Starting application")
    response = m2.start_application(
        applicationId=appid
    )

    appaddress = wait_for_application_running(m2,appid)

    end = time.time()
    delinfofilename = "delinfo" + timestamp + ".json"
    write_json(delinfofilename, delinfo)
    
    print("Application is running and ready for you on:")
    print("Address: " + appaddress)
    print("Port 6000")
    print("Total creation time is: " + str(timedelta(seconds=(end - start))))
    print("Enjoy!")
    print("Deletion info stored in: " + delinfofilename)

    return "Done"

def wait_for_env_creation(client, envname):
    while True:
        response = client.list_environments(        
            names=[
                envname,
            ],        
        )
        if response["environments"][0]["status"] == "Available":
            return response["environments"][0]["environmentId"]
        sleep(30)

def wait_for_db_creation(client, dbinstancename):
    while True:
        response = client.describe_db_instances(
            DBInstanceIdentifier=dbinstancename            
        )
        if response["DBInstances"][0]["DBInstanceStatus"] == "available":
            return response["DBInstances"][0]["Endpoint"]["Address"]
        sleep(30)

def wait_for_app_creation(client, appname):
    while True:
        response = client.list_applications(        
            names=[
                appname,
            ],        
        )
        if response["applications"][0]["status"] == "Available":
            return response["applications"][0]["applicationId"]
        sleep(30)

def wait_for_app_deployment(client, appid, deploymentid):
    while True:
        response = client.get_deployment(
            applicationId=appid,
            deploymentId=deploymentid
        )
        if response["status"] == "Succeeded":
            return "OK"
        sleep(30)

def wait_for_datasets_import(client, appid, datasetsimporttaskid):
    while True:
        response = client.get_data_set_import_task(
            applicationId=appid,
            taskId=datasetsimporttaskid
        )
        if response["status"] == "Completed":
            return response["summary"]
        sleep(30)

def wait_for_application_running(client, appid):
    while True:
        response = client.get_application(
            applicationId=appid
        )
        if response["status"] == "Running":
            return response["loadBalancerDnsName"]
        sleep(30)

def read_json(file_path):
    try:
        with open(file_path, 'r') as file:
            input_json = json.load(file)
    except IOError as exc:
        raise IOError from exc

    return input_json

def write_json(file_path, content):
    try:
        with open(file_path, 'w') as file:
            json.dump(content, file)
    except IOError as exc:
        raise IOError from exc

create_bankdemo_runtime()