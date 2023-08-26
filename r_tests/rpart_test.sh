#!/bin/bash

RSCRIPTS=assets/scripts

perl -ne '
s/\s*#.*//;
s/^library\(([^)]*)\)/library($1, quiet=TRUE)/;
s|<<VAR_TARGET>>|rain_tomorrow|;
s|<<VAR_RISK>>|risk_mm|;
s|<<VARS_ID>>|"date", "location"|;
s|<<DATA_SPLIT_TR_TU_TE>>|0.70, 0.15, 0.15|g;
print unless /^#|^$|^<</
' \
     ${RSCRIPTS}/main.R \
     ${RSCRIPTS}/ds_load_weather.R \
     ${RSCRIPTS}/data_template.R \
     ${RSCRIPTS}/model_template.R \
     ${RSCRIPTS}/rpart_build.R \
     | cat
#     | R --no-save
