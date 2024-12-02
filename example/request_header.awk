GET("/request-ids") { b["request_id"]=header("request-id"); res(200, b) }
