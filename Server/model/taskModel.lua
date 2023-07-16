local sql = require("resty.sql")
local config = require("config")

--Generic function to connect to the database
local function connectToDatabase()
    local db = sql.new()
    db:set_timeout(1000) --Set a timeout value for database operations

    local ok, err, errcode, sqlstate = db:connect({
        host = config.database.host,
        port = config.database.port,
        database = config.database.database,
        user = config.database.username,
        password = config.database.password
    })

    if not ok then
        -- Handle the connection error
        return nil, "Connection error: " .. err
    end
end

local taskModel = {}


--Create a new task
function taskModel.createTask(task)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end
    --Insert the task into the Task table , associating it with the specified userId
    local response, err, errcode, sqlstate = db:querty(string.format([[
        INSER INTO Task (title,description,completed,userId)VALUES('%s','%s',%d,%d)
    ]], task.title, task.description, task.completed and 1 or 0, task.userId))

    if not response then
        -- Handle the query error
        return nil, "Query execution error: " .. err
    end

    db:close()
    return response.inser_id
end

--Get all the task from the DB
function taskModel.fetchTasks(userId)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    --Fetching all tasks associated with the specified userId or all tasks if userId is not provided
    local query = [[SELECT * FROM Task]]
    if userId then
        query = string.format([[SELECT * FROM Task WHERE userId = %d]], userId)
    end

    local response, err, errcode, sqlstate = db:query(query)
    if not response then
        -- Handle the query error
        return nil, "Query execution error: " .. err
    end

    db:close()
    return response
end

--Get the tasks by task id
function taskModel.fetchTaskById(taskId)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end
    --Geting the task with a specified id
    local query = string.format([[SELECT * FROM Task WHERE id=%d]], taskId)
    local response, err, errcode, sqlstate = db:query(query)

    if not response then
        -- Handle the query error
        return nil, "Query execution error: " .. err
    end

    db:close()
    return response[1] -- Assuming id is unique, return the first (and only) result
end

--Update task by task id
function taskModel.updateTaskById(taskId, task)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end
    -- Update the task with the specified id
    local query = string.format([[
    UPDATE Task SET title = '%s', description = '%s', completed = %d WHERE id = %d
  ]], task.title, task.description, task.completed and 1 or 0, taskId)

    local response, err, errcode, sqlstate = db:query(query)
    if not response then
        -- Handle the query error
        return nil, "Query execution error: " .. err
    end

    db:close()
    return true
end

--Delete task by id
function taskModel.deleteTaskByID(taskId)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Delete the task with the specified id
    local query = string.format([[DELETE FROM Task WHERE id = %d]], taskId)
    local response, err, errcode, sqlstate = db:query(query)

    if not response then
        -- Handle the query error
        return nil, "Query execution error: " .. err
    end

    db:close()

    return true
end

return taskModel
