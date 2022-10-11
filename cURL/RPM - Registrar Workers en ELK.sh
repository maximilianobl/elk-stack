#============================== CREAMOS LOS INDICES CON SUS MAPPINGS CORRESPONDIENTES ==================================
## Index --> executions
curl -L -X PUT 'http://10.20.128.201:9200/executions' \
-H 'Content-Type: application/json' \
--data-raw '{
    "settings" : {
        "number_of_shards" : 3,
        "number_of_replicas" : 1
    },
    "mappings" : {
        "dynamic": "strict",
        "properties" : {            
            "workerId" : { "type" : "keyword" },
            "owner" : { "type" : "keyword" },
            "startTs" : { "type" : "date" },
            "stopTs" : { "type" : "date" },
            "state" : { "type" : "keyword" },
            "result" : { "type" : "text" }
        }

    }
}'

## Index --> workers
curl -L -X PUT 'http://10.20.128.201:9200/workers' \
-H 'Content-Type: application/json' \
--data-raw '{
    "settings" : {
        "number_of_shards" : 3,
        "number_of_replicas" : 1
    },
    "mappings" : {
        "dynamic": "strict",
        "properties" : {
            "description": { "type" : "text" },
            "state": { "type" : "keyword" },
            "lastMessage": { "type" : "text" },
            "progress": { "type" : "integer" },
            "port": { "type" : "integer" },
            "pid": { "type" : "integer" },
            "ip": { "type" : "text" },
            "memoryUsage": { "type" : "integer" },
            "elapsed": { "type" : "integer" },
            "isCancelable" : { "type" : "boolean" },
            "isKillable" : { "type" : "boolean" },
            "isEnabled" : { "type" : "boolean" },
            "lastExecutionDate" :{ "type" : "date" },
            "lastState": { "type" : "keyword" },            
            "schedule": { "type": "keyword" },
            "retries": { "type": "integer" },
            "expires_at": {"type": "date"}
	    }
    }
}'

#============================== INSERT (BULK) DE LOS WORKERS ACTUALES =========================================
#PARA LOS NUEVOS WORKER, TOMAR UN INSERT DE EJEMPLO Y EDITARLO
curl -L -X POST 'http://10.20.128.201:9200/_bulk' \
-H 'Content-Type: application/json' \
--data-raw '{ "index" : { "_index" : "workers", "_id" : "test-worker"} }
{"description":"My Test Worker","state":"IDLE","lastMessage":"Worker with id test-worker has terminated","progress":43,"port":0,"pid":0,"ip":"","memoryUsage":30,"elapsed":13715,"isCancelable":true,"isKillable":true,"isEnabled":true, "lastExecutionDate":1656613636858, "lastState": "IDLE", "schedule": "0 23 1/1 * ? *", "retries": 3, "expires_at":1656613636858}
{ "index" : { "_index" : "workers", "_id" : "cambiopropuestacuotacero"} }
{"description":"Cambio Propuesta CUOTA CERO","state":"IDLE","lastMessage":"CambioPropuestaCuotaCero","progress":-1,"port":0,"pid":0,"ip":"","memoryUsage":21,"elapsed":10183,"isCancelable":true,"isKillable":true,"isEnabled":false, "lastExecutionDate":1656613636858, "lastState": "IDLE", "schedule": "@every 2m", "retries": 3, "expires_at":1656613636858}

'