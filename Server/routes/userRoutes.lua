local router = require("resty.router")
local userBLL = require("bll.userBLL")
local authentication = require("utils.jwt")

local routes = router.new()

routes:post("/signup", userBLL.createUser)
routes:post("/auth", userBLL.authenticateUser)
routes:post("/tasks", authentication.authenticateRequest, userBLL.createTask)
routes:put("/tasks/:taskId", authentication.authenticateRequest, userBLL.updateTask)
routes:delete("/tasks/:taskId", authentication.authenticateRequest, userBLL.deleteTask)

return routes
