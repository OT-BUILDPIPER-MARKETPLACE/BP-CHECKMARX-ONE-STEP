# BP-CHECKMARX-ONE-STEP

This step will help you to upgrade bp-agent.

## Setup
* Clone the code available at [BP-CHECKMARX-ONE-STEP](https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-CHECKMARX-ONE-STEP.git)

```
git clone https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-CHECKMARX-ONE-STEP.git
```
* Build the docker image
```
git submodule init
git submodule update
docker build -t ot/bp-checkmarx-one:0.1 .
