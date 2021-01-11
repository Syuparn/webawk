# query() checks whether query is specified
GET("/names") && !query("tag") { b1["names"][1]="taro"; b1["names"][2]="hanako"; res(200, b1) }
# if 2nd argument is specified, check whether any of queries has the value
GET("/names") && query("tag", "engineer") { b2["names"][1]="hanako"; res(200, b2) }
# all query parameters can be obtained by getquery() (assigned to 2nd argument)
GET("/queries") { getquery("q", q1); res(200, q1) }
