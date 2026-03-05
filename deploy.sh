#!/bin/bash
set -e

APP_NAME="djangotutorial-dev-v2"
ENV_NAME="djangotutorial-dev-v2-dev"
BUCKET="elasticbeanstalk-us-west-2-908324163690"
VERSION_LABEL="deploy-$TRAVIS_BUILD_NUMBER"
ZIP_FILE="$VERSION_LABEL.zip"

# Zip the app
zip -r $ZIP_FILE . -x "*.git*"

# Upload to S3
aws s3 cp $ZIP_FILE s3://$BUCKET/$APP_NAME/$ZIP_FILE

# Create a new app version
aws elasticbeanstalk create-application-version \
  --application-name $APP_NAME \
  --version-label $VERSION_LABEL \
  --source-bundle S3Bucket=$BUCKET,S3Key=$APP_NAME/$ZIP_FILE

# Deploy it
aws elasticbeanstalk update-environment \
  --environment-name $ENV_NAME \
  --version-label $VERSION_LABEL