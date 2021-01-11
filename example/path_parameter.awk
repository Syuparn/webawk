# path parameter can be specified as ':hoge'
# the parameter value can be obtained by path()
GET("/names/:name") { b["name"]=path("name"); res(200, b) }
# path() can be also used as a pattern
DELETE("/names/:name") && path("name") == "admin" { e["error"]="permission denied"; res(403, e) }
DELETE("/names/:name") { res(204) }
