local router = require("resty.router")
local taskBLL = require("bll.taskBLL");
local authentication = require("utils.authentication")

local routes = router.new()

routes:post("/", authentication.authenticate, taskBLL.createTask)
routes:get("/", authentication.authenticate, taskBLL.getTasks)
routes:get("/:id", authentication.authenticate, taskBLL.getTask)
routes:put("/:id", authentication.authenticate, taskBLL.updateTask)
routes:delete("/:id", authentication.authenticate, taskBLL.deleteTask)

return routes
