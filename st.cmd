#!../../bin/linux-x86_64/Rheometer

## You may have to change Rheometer to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/Rheometer.dbd"
Rheometer_registerRecordDeviceDriver pdbbase

drvAsynIPPortConfigure ("icp1","10.112.9.27:4001",0,0,0)
drvAsynIPPortConfigure ("RxFromHrdwr","10.112.9.28:4003",0,0,0)
drvAsynIPPortConfigure ("TxFromHrdwr","10.112.9.28:4002",0,0,0)




#This prints low level commands and responses
#asynSetTraceMask("icp1",0,0xFF)
#asynSetTraceIOMask("icp1",0,0xFF)
asynSetTraceMask("RxFromHrdwr",0,0xFF)
asynSetTraceIOMask("RxFromHrdwr",0,0xFF)
asynSetTraceMask("TxFromHrdwr",0,0xFF)
#asynSetTraceIOMask("TxFromHrdwr",0,0xFF)





## Load record instances
#dbLoadRecords("db/xxx.db","user=zmaHost")
dbLoadRecords(db/icp7002.db)
#dbLoadRecords(db/relayreset.db)
#no need to reset with db if using a bo high field
dbLoadRecords(db/rheometerspy.db)

cd ${TOP}/iocBoot/${IOC}
iocInit

var mediatorVerbosity 7

var mySubDebug 7



## Start any sequence programs
#seq sncxxx,"user=zmaHost"
