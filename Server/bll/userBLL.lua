local userModel = require("model.userModel")
local authentication = require("utils.authentication")
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
    local userId = req.query.userId

    -- Authenticate the user using userModel.getUserByUsername
    local authenticated, err = userModel.authenticateUserById(userId)
    if not authenticated then
        -- Handle the authentication error
        res.status(401).json(errorHandling.formatError(401, "Failed to authenticate user: " .. err))
        return
    end
    -- Check if the username and password are correct

    -- Generate a JWT token using authentication.generateToken
    local token, tokenErr = authentication.createToken(username, password)
    if not token then
        -- Handle the token creation error
        res.status(500).json(errorHandling.formatError(500, "Failed to generate token: " .. tokenErr))
        return
    end

    -- Send the JWT token in the response
    res.status(200).json({ token = token })
end

return userBLL
