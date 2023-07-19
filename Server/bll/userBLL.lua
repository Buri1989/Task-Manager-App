local userModel = require("model.userModel")
local authentication = require("utils.jwt")
local errorHandling = require("utils.errorHandling")

local userBLL = {}

-- Function to create a new user
function userBLL.createUser(req, res, next)
    local user = {
        username = req.body.username,
        password = req.body.password
    }

    -- Check if the username already exists
    local existingUser = userModel.getUserByUsername(user.username)
    if existingUser then
        res.status(400).json(errorHandling.formatError(400, "Username already exists"))
        return
    end

    -- Call userModel.createUser to create the user
    local userId, err = userModel.createUser(user)
    if not userId then
        -- Handle the error from userModel
        res.status(500).json(errorHandling.formatError(500, "Failed to create user: " .. err))
        return
    end
    -- Send a success response
    res.status(201).json({ message = "User created successfully", userId = userId })
end

-- Function to authenticate a user
function userBLL.authenticateUser(req, res, next)
    local username = req.body.username
    local password = req.body.password

    -- Authenticate the user using userModel.authenticateUserByUsernameAndPassword
    local user = userModel.authenticateUserByUsernameAndPassword(username, password)
    if not user then
        -- Handle the authentication error
        res.status(401).json(errorHandling.formatError(401, "Incorrect username or password"))
        return
    end

    -- Generate a JWT token using authentication.createToken
    local token, tokenErr = authentication.createToken(username, password)
    if not token then
        -- Handle the token creation error
        res.status(500).json(errorHandling.formatError(500, "Failed to generate token: " .. tokenErr))
        return
    end

    -- Send the JWT token in the response
    res.status(200).json({ token = token })
end

-- Function to create a new task for the user
function userBLL.createTask(req, res, next)
    local userId = req.userId
    local task = {
        title = req.body.title,
        description = req.body.description,
        completed = req.body.completed
    }

    -- Create the task using userModel.createTask
    local taskId, err = userModel.createTask(userId, task)
    if not taskId then
        -- Handle the error from userModel
        res.status(500).json(errorHandling.formatError(500, "Failed to create task: " .. err))
        return
    end

    -- Send a success response
    res.status(201).json({ message = "Task created successfully", taskId = taskId })
end

-- Function to update a task for the user
function userBLL.updateTask(req, res, next)
    local userId = req.userId
    local taskId = req.params.taskId
    local updatedTask = {
        title = req.body.title,
        description = req.body.description,
        completed = req.body.completed
    }

    -- Update the task using userModel.updateTask
    local success, err = userModel.updateTask(userId, taskId, updatedTask)
    if not success then
        -- Handle the error from userModel
        res.status(500).json(errorHandling.formatError(500, "Failed to update task: " .. err))
        return
    end

    -- Send a success response
    res.status(200).json({ message = "Task updated successfully" })
end

-- Function to delete a task for the user
function userBLL.deleteTask(req, res, next)
    local userId = req.userId
    local taskId = req.params.taskId

    -- Delete the task using userModel.deleteTask
    local success, err = userModel.deleteTask(userId, taskId)
    if not success then
        -- Handle the error from userModel
        res.status(500).json(errorHandling.formatError(500, "Failed to delete task: " .. err))
        return
    end

    -- Send a success response
    res.status(200).json({ message = "Task deleted successfully" })
end

return userBLL
