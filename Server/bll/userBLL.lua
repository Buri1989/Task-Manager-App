local userModel = require("model.userModel")
local authentication = require("utils.authentication")
local errorHandling = require("utils.errorHandling")

local userBLL = {}

-- Function to create a new user
function userBLL.createUser(req, res, next)
    -- Check if the username already exists
    -- Create the user using userModel.createUser
    -- Handle any errors and send appropriate responses
end

-- Function to authenticate a user
function userBLL.authenticateUser(req, res, next)
    -- Authenticate the user using userModel.getUserByUsername
    -- Check if the username and password are correct
    -- Generate a JWT token using authentication.generateToken
    -- Handle any errors and send appropriate responses
end

return userBLL
