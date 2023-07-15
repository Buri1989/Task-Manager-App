local sql = require("resty.mysql")
local config = require("config")

local userModel = {}

--Create a new user
function userModel.createUser(user)
    --Todo:Create a new user into the DB
end

--Get a user by his username
function userModel.fetchUserByUsername()
    --Todo:Fetch user data from the DB by username
end

return userModel
