#!/bin/bash

RSCRIPTS=assets/r

perl -ne '
s/\s*#.*//;
s/^library\(([^)]*)\)/library($1, quiet=TRUE)/;
s|<<VAR_TARGET>>|rain_tomorrow|;
s|<<VAR_RISK>>|risk_mm|;
s|<<VARS_ID>>|"date", "location"|;
s|<<DATA_SPLIT_TR_TU_TE>>|0.70, 0.15, 0.15|g;
s|<<PRIORS>>||;
s|<<LOSS>>||;
s|<<MINSPLIT>>||;
s|<<MINBUCKET>>||;
s|<<CP>>||;
print unless /^#|^$|^<</
' \
     ${RSCRIPTS}/main.R \
     ${RSCRIPTS}/data_load_weather.R \
     ${RSCRIPTS}/data_template.R \
     ${RSCRIPTS}/model_template.R \
     ${RSCRIPTS}/rpart_build.R \
     | R --no-save
