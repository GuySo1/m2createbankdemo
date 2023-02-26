from time import sleep
import boto3
import boto3.session
import json
from os import error

# You need to be logged into your AWS account. (ie. running aws configure in the AWS CLI)

def delete_bankdemo_runtime():
    # Create your own session
    my_session = boto3.session.Session(profile_name="<<<Your profile goes here>>>")
    # If you are not using profiles, use the below to create the session. 
    # my_session = boto3.session.Session()

    # Now we can create low-level clients or resource clients from our custom session    
    m2 = my_session.client('m2')
    rds = my_session.client('rds')
    secretmanager = my_session.client('secretsmanager')

    delinfo = read_json("delinfo2208221156.json")

    appname = delinfo["appname"]
    dbname = delinfo["dbname"]
    appid = delinfo["appid"]
    envid = delinfo["envid"]
    secretarn = delinfo["secretarn"]  

    print("Starting runtime deletion")  
    
    m2.stop_application(
        applicationId=appid        
    )   

    wait_for_application_stopping(m2,appid)
    print("Application " + appid + " stopped!")

    m2.delete_application(
        applicationId=appid
    )

    wait_for_app_deleted(m2,appname)
    print("Application " + appid + " deleted!")

    m2.delete_environment(
        environmentId=envid
    )
    print("Environment " + envid + " is being deleted!")

    secretmanager.delete_secret(
        SecretId=secretarn,        
        ForceDeleteWithoutRecovery=True
    )
    print ("Secret with ARN: " + secretarn + " is being deleted!")

    rds.delete_db_instance(
        DBInstanceIdentifier=dbname,
        SkipFinalSnapshot=True        
    )
    print("DB " + dbname + " is being deleted!")    
    
    return "Done"

def wait_for_app_deleted(client, appname):
    while True:
        response = client.list_applications(        
            names=[
                appname,
            ],        
        )
        if len(response["applications"]) == 0:
            return "Deleted"
        sleep(30)

def wait_for_application_stopping(client, appid):
    while True:
        response = client.get_application(
            applicationId=appid
        )
        if response["status"] == "Stopped":
            return "OK"
        sleep(30)

def read_json(file_path):
    try:
        with open(file_path, 'r') as file:
            input_json = json.load(file)
    except IOError as exc:
        raise IOError from exc

    return input_json

delete_bankdemo_runtime()