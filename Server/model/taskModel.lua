local sql = require("resty.mysql")
local config = require("config")

local taskModel = {}

--Create a new task
function taskModel.createTask(task)
    --Todo:Insert task into the DB
end

--Get all the task from the DB
function taskModel.fetchTasks()
    --Todo:Fetch all the tasks from the DB
end

--Get the tasks by task id
function taskModel.fetchTaskById(taskId)
    --Todo:Fetch task by id from the DB
end

--Update task by task id
function taskModel.updateTaskById(taskId, task)
    --Todo:Update task by id from the DB
end

--Delete task by id
function taskModel.deleteTaskByID(taskId)
    --Todo:Delete task by id from the DB
end

return taskModel
