# if multiple requests are declared, only one matched first is responded.

# dummy responses for /names
POST("/names") && (n=body(".name")) { b1["name"]=n; res(201, b1) }
POST("/names")                      { e["error"]="name required"; res(400, e) }
GET("/names")                       { b2["names"][1]="Taro"; res(200, b2) }
DELETE("/names/:name")              { res(204) }
