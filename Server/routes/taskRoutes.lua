local router = require("resty.router")
local taskBLL = require("bll.taskBLL");


local routes = router.new()

routes:post("/", taskBLL.createTask)
routes:get("/", taskBLL.getTasks)
routes:get("/:id", taskBLL.getTask)
routes:put("/:id", taskBLL.updateTask)
routes:delete("/:id", taskBLL.deleteTask)

return routes
