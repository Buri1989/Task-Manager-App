local router = require("resty.router")
local userBLL = require("bll.userBLL")
local authentication = require("utils.authentication")

local routes = router.new()

routes:post("/", userBLL.createUser)
routes:post("/auth", userBLL.authenticateUser)

return routes
