# Automatic Generation of Lambda Packages

Ways to Package and Deploy Lambda Functions automatically

## Using SAM CLI

DIR: /sam_cli

Here, we have a simple lambda function code with few import statements to test if the packaging of dependencies
was successful. The requirements.txt file has a list of python pip installable dependencies.

For using AWS SAM CLI only for packaging the lambda code, we need a template.yaml file which defines resources. This
is only required for the SAM CLI to work, but we wont be using it for any deployment (which is usually the intention
for this file)

1. Put your lambda code file, requirements.txt and __init__.py in a single folder.
2. Run the command "sam build": This will create folder with dependencies in the .aws-sam/build directory
3. Upload your package to s3 using command: "sam package --s3-bucket <BUCKET_NAME>": This will create the deployment
package and upload with random name to specified bucket and prefix.
4. If you dont like the random name generated, or need to use a specific name to use as a dependency in another
deployment, update the lambda function package name using "aws s3 mv s3://<BUCKET_NAME>/<PACKAGE_NAME> s3://<BUCKET_NAME>/<NEW_NAME>"

## Using Shell script

DIR: /shell_script

REF: https://docs.aws.amazon.com/lambda/latest/dg/lambda-python-how-to-create-deployment-package.html

Command to use the shell script is: ./create_lambda_package.sh <FUNCTION_CODE_FILE> <BUCKET_NAME>

This script goes through following steps:
1. Creates a python virtualenv, and installs all the pip requirements in it.
2. Creates a zip package of the folder where pip installs all the python modules.
3. Adds the function code file inside the zip package.
4. Uploads the lambda package to the specified bucket name

There are no additional dependencies for this approach. If you are comfortable with shell scripting this approach
can scale to various cases of complex dependencies.
The downside is that it does not come with all the fancy features that SAM CLI provides out of the box like testing,
Lambda layers, etc.