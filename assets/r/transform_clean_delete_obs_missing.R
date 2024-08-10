# removes rows with any Na values
ds <- ds[complete.cases(ds),]
