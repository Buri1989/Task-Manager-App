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

local userModel = {}

--Create a new user
function userModel.createUser(user)
    --Using a function to connect to the database
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
        return nil, "Query execution error: " .. err
    end

    db:close()
    return response.insert_id
end

--Authenticate a user by id
function userModel.authenticateUserById(userId)
    --Using a function to connect to the database
    local db = connectToDatabase()
    if not db then
        -- Handle the connection error
        return nil, "Failed to connect to the database."
    end

    -- Query the User table to check if the username and password match
    local query = string.format([[SELECT * FROM User WHERE id = %d]], userId)
    local response, err, errcode, sqlstate = db:query(query)

    if not response then
        -- Handle the query execution error
        return false, "Query execution error: " .. err
    end

    db:close()

    -- If the result is not empty, authentication is successful and the user exists
    return #response > 0
end

return userModel
