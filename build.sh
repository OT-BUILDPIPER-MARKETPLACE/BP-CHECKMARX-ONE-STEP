#!/bin/bash
source functions.sh
source log-functions.sh
source str-functions.sh
source file-functions.sh
source aws-functions.sh

code="$WORKSPACE/$CODEBASE_DIR" 

BUILD_GIT_BRANCH_NAME=`getGitBranch`

logInfoMessage "I'll do the scanning for $code"
logInfoMessage "Codebase size: $(du -sh "$code" | cut -f1) $code"
logInfoMessage "Executing command"
logInfoMessage "checkmarx-one-cli $code"
logInfoMessage "I'll scan $code for severities and publish report on CheckMarx Dashboard"

sleep $SLEEP_DURATION

if [ -d $code ];then
  ./cx scan create --project-name "$CODEBASE_DIR" --file-source "$code" --scan-types "$SCAN_TYPE" --apikey "$API_KEY" --base-uri "$SERVER_URL" --branch "$BUILD_GIT_BRANCH_NAME"
  logInfoMessage "Congratulations checkmarx scan succeeded!!!"
  generateOutput $ACTIVITY_SUB_TASK_CODE true "Congratulations checkmarx scan succeeded!!!"
else
  if [ "$VALIDATION_FAILURE_ACTION" == "FAILURE" ]
  then
    logErrorMessage "$code: No such directory exist"
    logErrorMessage "Please check checkmarx scan failed!!!"
    generateOutput $ACTIVITY_SUB_TASK_CODE false "Please check checkmarx scan failed!!!"
    exit 1
  else
    logErrorMessage "$code: No such directory exist"
    logWarningMessage "Please check checkmarx scan failed!!!"
    generateOutput $ACTIVITY_SUB_TASK_CODE true "Please check checkmarx scan failed!!!"
  fi
fi
