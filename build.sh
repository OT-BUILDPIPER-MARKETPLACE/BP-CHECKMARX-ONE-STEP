#!/bin/bash
source aws-functions.sh
source file-functions.sh
source git-functions.sh
source mi-functions.sh
source docker-functions.sh
source functions.sh
source log-functions.sh
source str-functions.sh

code="$WORKSPACE/$CODEBASE_DIR" 

if [ ! -d "$code/reports" ]; then
    mkdir -p "$code/reports"
fi


BUILD_GIT_BRANCH_NAME=`getGitBranch`

logInfoMessage "I'll do the scanning for $code"
logInfoMessage "Codebase size: $(du -sh "$code" | cut -f1) $code"
logInfoMessage "Executing command"
logInfoMessage "checkmarx-one-cli $code"
logInfoMessage "I'll scan $code for severities and publish report on CheckMarx Dashboard"

sleep $SLEEP_DURATION

if [ -d $code ];then
  ./cx scan create --project-name "$CODEBASE_DIR" --file-source "$code" --scan-types "$SCAN_TYPE" --apikey "$API_KEY" --base-uri "$SERVER_URL" --branch "$BUILD_GIT_BRANCH_NAME" --file-filter "$FILE_FILTER" --sast-incremental  --output-name checkmarx-one-scan-result --output-path "$code/reports" --report-format json --debug

  jq -r '.results[] | .severity' "$code/reports/checkmarx-one-scan-result.json" | sort | uniq -c | awk '{print $2 "," $1}' > "$code/reports/severity_counts_temp.csv"
  echo "HIGH,LOW,MEDIUM" > "$code/reports/severity_counts.csv"
  cat "$code/reports/severity_counts_temp.csv" | awk -F ',' '{print $2}' | paste -sd, >> "$code/reports/severity_counts.csv"
  rm "$code/reports/severity_counts_temp.csv"

  export base64EncodedResponse=$(encodeFileContent "$code/reports/severity_counts.csv")
  export application=$APPLICATION_NAME
  export environment=$(getProjectEnv)
  export service=$(getServiceName)
  export organization=$ORGANIZATION
  export source_key=$SOURCE_KEY
  export report_file_path=$REPORT_FILE_PATH

  generateMIDataJson /opt/buildpiper/data/mi.template gitleaks.mi
  cat gitleaks.mi
  sendMIData gitleaks.mi ${MI_SERVER_ADDRESS}


  logInfoMessage "Congratulations checkmarx scan succeeded!!!"
  generateOutput $ACTIVITY_SUB_TASK_CODE true "Congratulations checkmarx scan succeeded!!!"
else
if [ "$VALIDATION_FAILURE_ACTION" == "FAILURE" ]; then
  logErrorMessage "$code: No such directory exist"
  logErrorMessage "Please check checkmarx scan failed!!!"
  generateOutput $ACTIVITY_SUB_TASK_CODE false "Please check checkmarx scan failed!!!"
  exit 1
else
  logErrorMessage "$code: No such directory exist"
  logWarningMessage "Please check checkmarx scan failed!!!"
  generateOutput $ACTIVITY_SUB_TASK_CODE true "Please check checkmarx scan failed!!!"
fi
