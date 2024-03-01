FROM openjdk:19-jdk-alpine
RUN apk add --no-cache --upgrade bash
RUN apk add jq
RUN apk add coreutils
RUN apk add unzip
COPY ast-cli_2.0.63_linux_x64.tar.gz .
COPY build.sh .
COPY BP-BASE-SHELL-STEPS .
RUN tar -xzvf ast-cli_2.0.63_linux_x64.tar.gz && rm ast-cli_2.0.63_linux_x64.tar.gz
RUN chmod +x build.sh
ENV SERVER_URL ""
ENV API_KEY ""
ENV SCAN_TYPE "sast,iac-security,sca,api-security"
ENV FILE_FILTER "!vendor"
ENV SLEEP_DURATION 0s
ENV VALIDATION_FAILURE_ACTION WARNING
ENV ACTIVITY_SUB_TASK_CODE BP-CheckMarx-One-TASK
ENTRYPOINT [ "./build.sh" ]
