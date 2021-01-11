# explore request body by body()
# NOTE: body() expects JSON request body and requires jq-style filter!
# (because jq is internally used ;)

POST("/comments") && !body(".comment") { e1["error"]="comment required"; res(400, e1) }
POST("/comments") && length(body(".comment")) > 20 { e2["error"]="too long"; res(400, e2) }
POST("/comments") && (c=body(".comment")) { b1["comment"]=c; res(201, b1) }
