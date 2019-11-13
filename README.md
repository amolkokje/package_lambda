# package_lambda

Ways to Package and Deploy Lambda Functions

## Using SAM CLI

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
deplopyment, update the lambda function package name using "aws s3 mv s3://<BUCKET_NAME>/<PACKAGE_NAME> s3://<BUCKET_NAME>/<NEW_NAME>"

## Using Shell script

