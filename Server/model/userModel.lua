local sql = require("resty.sql")
local config = require("config")
local errorHandling = require("utils.errorHandling")
local jwt = require("utils.jwt")

-- Generic function to connect to the database
local function connectToDatabase()
    local db = sql.new()
    db:set_timeout(1000) -- Set a timeout value for database operations

    local ok, err, errcode, sqlstate = db:connect({
        host = config.database.host,
        port = config.database.port,
        database = config.database.database,
        user = config.database.username,
        password = config.database.password
    })
    if not ok then
        -- Handle the connection error
        return nil, errorHandling.handleConnectionError(err)
    end
    return db
end

local userModel = {}

-- Create a new user
function userModel.createUser(user)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Insert the user into the User table
    local response, err, errcode, sqlstate = db:query(string.format([[
        INSERT INTO User (username, password) VALUES ('%s', '%s')
    ]], user.username, user.password))

    if not response then
        -- Handle the query execution error
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()
    return response.insert_id
end

-- Function to get a user by username
function userModel.getUserByUsername(username)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Query the User table to fetch the user by username
    local query = string.format([[SELECT * FROM User WHERE username = '%s']], username)
    local response, err, errcode, sqlstate = db:query(query)

    if not response then
        -- Handle the query execution error
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()

    -- If a user is found, return the user object
    if #response > 0 then
        return response[1]
    else
        return nil
    end
end

-- Authenticate a username and password
function userModel.authenticateUserByUsernameAndPassword(username, password)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Query the User table to check if the username and password match
    local query = string.format([[SELECT * FROM User WHERE username = '%s' AND password = '%s']], username, password)
    local response, err, errcode, sqlstate = db:query(query)

    if not response or #response == 0 then
        -- Handle the query execution error
        return nil, errorHandling.handleAuthenticationError("Incorrect username or password")
    end

    db:close()

    -- Return the authenticated user data
    return response[1]
end

-- Authenticate a user by JWT
function userModel.authenticateUserByJWT(token)
    -- Verify the JWT token
    local decodedToken, err = jwt.verifyToken(token)
    if not decodedToken then
        -- Handle the JWT verification error
        return nil, errorHandling.handleTokenError(err)
    end

    -- Get the user by username from the decoded token
    local username = decodedToken.username
    local user = userModel.getUserByUsername(username)
    if not user then
        -- Handle the case when the user doesn't exist
        return nil, errorHandling.handleAuthenticationError("User not found")
    end

    -- Return the authenticated user data
    return user
end

-- Check if a user is authorized to perform an action
function userModel.isUserAuthorized(user, userId)
    -- Check if the user is authenticated and matches the provided userId
    if not user or user.userId ~= userId then
        return false
    end
    return true
end

-- Create a new task for the user
function userModel.createTask(userId, task)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Insert the task into the Task table, associating it with the specified userId
    local response, err, errcode, sqlstate = db:query(string.format([[
        INSERT INTO Task (title, description, completed, userId) VALUES ('%s', '%s', %d, %d)
    ]], task.title, task.description, task.completed and 1 or 0, userId))

    if not response then
        -- Handle the query error
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()
    return response.insert_id
end

-- Update a task for the user
function userModel.updateTask(userId, taskId, updatedTask)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Update the task with the specified taskId and associated with the specified userId
    local query = string.format([[
        UPDATE Task SET title = '%s', description = '%s', completed = %d
        WHERE id = %d AND userId = %d
    ]], updatedTask.title, updatedTask.description, updatedTask.completed and 1 or 0, taskId, userId)

    local response, err, errcode, sqlstate = db:query(query)
    if not response then
        -- Handle the query error
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()
    return true
end

-- Delete a task for the user
function userModel.deleteTask(userId, taskId)
    -- Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Delete the task with the specified taskId and associated with the specified userId
    local query = string.format([[DELETE FROM Task WHERE id = %d AND userId = %d]], taskId, userId)
    local response, err, errcode, sqlstate = db:query(query)

    if not response then
        -- Handle the query error
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()
    return true
end

return userModel
