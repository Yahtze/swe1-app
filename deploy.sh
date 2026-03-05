#!/bin/bash
set -e

APP_NAME="djangotutorial-dev-v2"
ENV_NAME="djangotutorial-dev-v2-dev"
BUCKET="elasticbeanstalk-us-west-2-908324163690"
REGION="us-west-2"
VERSION_LABEL="deploy-$TRAVIS_BUILD_NUMBER"
ZIP_FILE="$VERSION_LABEL.zip"

# Zip the app (exclude junk files)
zip -r $ZIP_FILE . \
  -x "*.git*" \
  -x "*__pycache__*" \
  -x "*.pyc" \
  -x ".coverage" \
  -x "deploy.sh" \
  -x ".travis.yml"

# Upload to S3
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
AWS_DEFAULT_REGION=$REGION \
aws s3 cp $ZIP_FILE s3://$BUCKET/$APP_NAME/$ZIP_FILE

# Create a new app version
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
AWS_DEFAULT_REGION=$REGION \
aws elasticbeanstalk create-application-version \
  --application-name $APP_NAME \
  --version-label $VERSION_LABEL \
  --source-bundle S3Bucket=$BUCKET,S3Key=$APP_NAME/$ZIP_FILE \
  --region $REGION

# Deploy it
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
AWS_DEFAULT_REGION=$REGION \
aws elasticbeanstalk update-environment \
  --environment-name $ENV_NAME \
  --version-label $VERSION_LABEL \
  --region $REGION