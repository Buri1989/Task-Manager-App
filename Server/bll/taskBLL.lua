local taskModel = require("model.taskModel")
local userModel = require("model.userModel")
local errorHandling = require("utils.errorHandling")

local taskBLL = {}

-- Function to create a new task
function taskBLL.createTask(req, res, next)
    local task = {
        title = req.body.title,
        description = req.body.description,
        completed = req.body.completed,
        userId = req.body.userId
    }

    -- Check if the user exists and can create the task
    local userExists = userModel.authenticateUserById(task.userId)
    if not userExists then
        res.status(404).json(errorHandling.formatError(404, "User not found"))
        return
    end

    -- Create the task using taskModel.createTask
    local taskId, err = taskModel.createTask(task)
    if not taskId then
        -- Handle the error from taskModel
        res.status(500).json(errorHandling.formatError(500, "Failed to create task: " .. err))
        return
    end
    -- Send a success response
    res.status(201).json({ message = "Task created successfully", taskId = taskId })
end

-- Function to retrieve all tasks
function taskBLL.getTasks(req, res, next)
    local userId = req.query.userId
    -- Check if a userId is provided in the query parameters
    if not userId then
        res.status(400).json(errorHandling.formatError(400, "Missing userId in query parameters"))
        return
    end
    -- Retrieve the tasks using taskModel.getTasks
    local tasks, err = taskModel.fetchTasks(userId)
    if not tasks then
        -- Handle the error from taskModel
        res.status(500).json(errorHandling.formatError(500, "Failed to retrieve tasks: " .. err))
        return
    end
    -- Send the tasks in the response
    res.status(200).json(tasks)
end

-- Function to retrieve a specific task by id
function taskBLL.getTask(req, res, next)
    local taskId = req.params.id
    -- Retrieve the task by id using taskModel.getTaskById
    local task = taskModel.fetchTaskById(taskId)
    if not task then
        -- Handle the case when the task doesn't exist
        res.status(404).json(errorHandling.formatError(404, "Task not found"))
    end
    -- Send the task in the response
    res.status(200).json(task)
end

-- Function to update a specific task by id
function taskBLL.updateTask(req, res, next)
    local taskId = req.params.id
    local updatedTask = {
        title = req.body.title,
        description = req.body.description,
        completed = req.body.completed,
        userId = req.body.userId
    }
    -- Retrieve the task by id using taskModel.getTaskById
    local task = taskModel.getTaskById(taskId)
    if not task then
        -- Handle the case when the task doesn't exist
        res.status(404).json(errorHandling.formatError(404, "Task not found"))
        return
    end
    -- Check if the user is authorized to update the task
    if task.userId ~= updatedTask.userId then
        res.status(403).json(errorHandling.formatError(403, "User is not authorized to update this task"))
        return
    end
    -- Update the task using taskModel.updateTaskById
    local success, err = taskModel.updateTaskById(taskId, updatedTask)
    if not success then
        -- Handle the error from taskModel
        res.status(500).json(errorHandling.formatError(500, "Failed to update task: " .. err))
        return
    end
    -- Send a success response
    res.status(200).json({ message = "Task updated successfully" })
end

-- Function to delete a specific task by id
function taskBLL.deleteTask(req, res, next)
    local taskId = req.params.id
    -- Retrieve the task by id using taskModel.getTaskById
    local task = taskModel.getTaskById(taskId)
    if not task then
        -- Handle the case when the task doesn't exist
        res.status(404).json(errorHandling.formatError(404, "Task not found"))
        return
    end
    -- Delete the task using taskModel.deleteTaskById
    local success, err = taskModel.deleteTaskById(taskId)
    if not success then
        -- Handle the error from taskModel
        res.status(500).json(errorHandling.formatError(500, "Failed to delete task: " .. err))
        return
    end
    -- Send a success response
    res.status(200).json({ message = "Task deleted successfully" })
end

return taskBLL
