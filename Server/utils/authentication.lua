local jwt = require("jwt")
local config = require("config")
local userModel = require("model.userModel")

local authentication = {}

-- Function to generate a JWT token
function authentication.createToken(userId)
    local payload = {
        userId = userId,
        exp = os.time() + config.jwt.expiresIn
    }

    local token, err = jwt.encode(payload, config.jwt.jwtSecret, config.jwt.algorithm)
    if not token then
        -- Handle JWT encoding error
        return nil, "Failed to create token: " .. err
    end

    return token
end

-- Middleware to authenticate requests
function authentication.authenticateRequest(request)
    -- Extract the JWT token from the request headers or query string
    local token = request.headers["Authorization"] or request.query.token
    if not token then
        return false, "Unauthorized: Missing token"
    end

    -- Verify and decode the JWT token
    local decoded, err = jwt.decode(token, config.jwt.jwtSecret, config.jwt.algorithm)
    if not decoded then
        return false, "Unauthorized: Invalid token"
    end

    -- Check if the user exists and is authenticated
    local userId = decoded.userId
    local authenticated, authErr = userModel.authenticateUserById(userId)
    if not authenticated then
        return false, "Unauthorized: " .. authErr
    end

    -- Attach the authenticated userId to the request for further processing
    request.userId = userId

    return true
end

return authentication
