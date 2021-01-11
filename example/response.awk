# response can be responded by res()

# res(statuscode) send response without body
DELETE("/names/taro") { res(204) }
# res(statuscode, b) send response with marshaled json body
GET("/names/taro") { b["id"]=1234; res(200, b) }
