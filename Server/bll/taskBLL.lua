local taskModel = require("model.taskModel")
local userModel = require("model.userModel")
local errorHandling = require("utils.errorHandling")

local taskBLL = {}

-- Function to create a new task
function taskBLL.createTask(req, res, next)
    -- Check if the user exists and can create the task
    -- Create the task using taskModel.createTask
    -- Handle any errors and send appropriate responses
end

-- Function to retrieve all tasks
function taskBLL.getTasks(req, res, next)
    -- Check if a userId is provided in the query parameters
    -- Retrieve the tasks using taskModel.getTasks
    -- Handle any errors and send appropriate responses
end

-- Function to retrieve a specific task by id
function taskBLL.getTask(req, res, next)
    -- Retrieve the task by id using taskModel.getTaskById
    -- Handle the case when the task doesn't exist
    -- Handle any errors and send appropriate responses
end

-- Function to update a specific task by id
function taskBLL.updateTask(req, res, next)
    -- Retrieve the task by id using taskModel.getTaskById
    -- Check if the user is authorized to update the task
    -- Update the task using taskModel.updateTaskById
    -- Handle the case when the task doesn't exist
    -- Handle any errors and send appropriate responses
end

-- Function to delete a specific task by id
function taskBLL.deleteTask(req, res, next)
    -- Retrieve the task by id using taskModel.getTaskById
    -- Check if the user is authorized to delete the task
    -- Delete the task using taskModel.deleteTaskById
    -- Handle the case when the task doesn't exist
    -- Handle any errors and send appropriate responses
end

return taskBLL
