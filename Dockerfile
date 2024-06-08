FROM openjdk:19-jdk-alpine
RUN apk add --no-cache --upgrade bash
RUN apk add jq curl gettext libintl 
RUN apk add coreutils
RUN apk add unzip
COPY ast-cli_2.0.63_linux_x64.tar.gz .
COPY build.sh .
COPY BP-BASE-SHELL-STEPS .
RUN tar -xzvf ast-cli_2.0.63_linux_x64.tar.gz && rm ast-cli_2.0.63_linux_x64.tar.gz
RUN chmod +x build.sh
ENV FILE_FILTER "!vendor,!img,!storage,!images,!*.min.js"
ENV SERVER_URL ""
ENV API_KEY ""
ENV SCAN_TYPE "sast,sca"
ENV SLEEP_DURATION 0s
ENV APPLICATION_NAME ""
ENV ORGANIZATION ""
ENV SOURCE_KEY ""
ENV REPORT_FILE_PATH ""
ENV MI_SERVER_ADDRESS ""
ENV VALIDATION_FAILURE_ACTION WARNING
ENV ACTIVITY_SUB_TASK_CODE BP-CheckMarx-One-TASK
ENTRYPOINT [ "./build.sh" ]

