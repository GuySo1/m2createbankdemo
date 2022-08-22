# m2createbankdemo
Automatically creates a complete working environment with Micro Focus BankDemo application running on AWS Mainframe Modernization (M2)

## Prerequisites
**Note that all resources must be created in the same region (when applicabale)**
### Install and configure Boto3
Follow instruction [here](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html) - Installation and Configuration sections.

Make sure you able to access your AWS account.

The m2_create and m2_delete scripts use profiles to create the working session. If you don't use profiles, remove the profile parameter from the session creation call in the begining of the script.

### Create an S3 bucket and upload the content of m2_python folder to it.
If you name the S3 bucket m2-python, all configuration files and code will work as-is. If you name it differently:
- Adjust appdef.json, near the end of the file
- Adjust all S3 URIs in /m2-python/datasets.json
- Adjust m2_create.py create_data_set_import_task call arguments

FYI - More info on the S3 bucket content:
- Bankdemo runtime binaries and data are taken from [M2 runtime tutorial Prerequisites section](https://docs.aws.amazon.com/m2/latest/userguide/tutorial-runtime.html#Prerequisites)
- Application definition is based on [M2 runtime tutorial Create Application section](https://docs.aws.amazon.com/m2/latest/userguide/tutorial-runtime.html#tutorial-runtime-mf-app)
- Datasets import definition is based on [M2 runtime tutorial Import data sets section](https://docs.aws.amazon.com/m2/latest/userguide/tutorial-runtime.html#tutorial-runtime-mf-import)

### Create and configure an AWS Key Management Service key
Use the instructions [here](https://docs.aws.amazon.com/m2/latest/userguide/tutorial-runtime.html#tutorial-runtime-mf-key)

Get the ARN of the newly created key and paste it to m2_create.py instead of 
<<<"Your KMS ARN goes here">>>

### Create a custom PostgreSQL parameters group and change the max_prepared_transactions value
- Create a custom parameter group by following the instructions in [Creating a DB parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Creating)
- Change the max_prepared_transactions parameter value to 100 by following the instructions in [Modifying parameters in a DB parameter group](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithDBInstanceParamGroups.html#USER_WorkingWithParamGroups.Modifying).
- Paste the name of the parameter group you created into m2_create.py instead of <<<"Your parametr group name goes here">>>

## Usage
- Run m2_create.py and monitor the output
- When it is done (~9 minutes), you'll get the address and the port number of your application
- You'll need a TN3270 emulation software in order to connect to it

## Delete the environment
- In the end of the creation script, the needed deletion information is stored in a time stamped file
- Copy the file path
- Paste it into the m2_delete.py read_json call in the begining
- Run the m2_delete.py script to delete the environment



