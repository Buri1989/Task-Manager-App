local sql = require("resty.sql")
local config = require("config")
local errorHandling = require("utils.errorHandling")

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
        return nil, errorHandling.handleConnectionError(err)
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
        return nil, errorHandling.handleQueryError(err)
    end

    db:close()
    return response.insert_id
end

-- Function to get a user by username
function userModel.getUserByUsername(username)
    --Using a function to connect to the database
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

--Authenticate a username and password
function userModel.authenticateUserByUsernameAndPassword(username, password)
    --Using a function to connect to the database
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
    --Return the authenticated user data
    return #response[1]
end

return userModel
