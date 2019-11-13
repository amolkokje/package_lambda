#!/bin/bash

# --------------------------
# Constant Env Vars
# --------------------------

# virtualenv name
VENV="lambda_venv"

# current working dir
CWD=$(pwd)

# lambda function python file
LAMBDA_FUNCTION=$1

# lambda function name
LAMBDA_PACKAGE=$(echo $LAMBDA_FUNCTION | sed 's/.py/.zip/g')

# full path to lambda function python file
LAMBDA_FUNCTION_FULL_PATH=$CWD/$LAMBDA_FUNCTION

# full path to lambda function package
LAMBDA_PACKAGE_FULL_PATH=$CWD/$LAMBDA_PACKAGE

# lambda package staging bucket
LAMBDA_BUCKET=$2

# --------------------------
# Utils
# --------------------------

# function to generate log lines
log()
{
    echo "$(date +"%T.%3"): [$1] $2"
}

# function to execute command
cmd()
{
    CMD="$@"
    log "CMD" "$CMD"
    $CMD
}


# --------------------------
# Main
# --------------------------


log "MAIN" "VENV=$VENV"
log "MAIN" "FUNCTION=$LAMBDA_FUNCTION_FULL_PATH"
log "MAIN" "PACKAGE=$LAMBDA_PACKAGE_FULL_PATH"

####

log "MAIN" "delete old package"
cmd "rm $LAMBDA_PACKAGE_FULL_PATH"

log "MAIN" "remove existing and create new virtualenv"
cmd "rm -rf $VENV"
virtualenv $VENV

####

log "MAIN" "activate virtualenv, install python modules"

cd $VENV
source bin/activate

pip install -r $CWD/requirements.txt
pip freeze

####

log "MAIN" "add python package dependencies from the virtualenv to a zip"

cmd "cd lib/python2.7/site-packages/"
cmd "zip -r9 $LAMBDA_PACKAGE_FULL_PATH ."

####

log "MAIN" "add function file to zip"

# have to be in the folder where the function exists, or else it will package with the whole folder
cmd "cd $CWD"
cmd "zip -g $LAMBDA_PACKAGE $LAMBDA_FUNCTION"

####

log "MAIN" "copy the lambda function to S3 bucket for staging"

cmd "aws s3 cp $LAMBDA_PACKAGE_FULL_PATH s3://$LAMBDA_BUCKET"

####

cmd "rm -rf $VENV"
cmd "cd $CWD"
