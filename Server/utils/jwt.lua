local jwt = require("jwt")
local config = require("config")
local userModel = require("model.userModel")
local errorHandling = require("utils.errorHandling")

local jwtUtil = {}

-- Generate a new JWT token
function jwtUtil.generateToken(username, password)
    local jwtSecret = config.jwt.secret
    local jwtAlgorithm = config.jwt.algorithm
    local jwtExpiration = config.jwt.expiration

    local payload = {
        username = username,
        password = password,
        exp = os.time() + jwtExpiration
    }

    local token, err = jwt:sign(
        jwtSecret,
        {
            header = { alg = jwtAlgorithm, typ = "JWT" },
            payload = payload
        }
    )

    if not token then
        -- Handle the token generation error
        return nil, errorHandling.handleTokenError(err)
    end

    return token
end

-- Verify the JWT for authentication
function jwtUtil.verifyToken(token)
    local jwtSecret = config.jwt.secret

    local verifiedToken = jwt:verify(jwtSecret, token)

    if not verifiedToken then
        -- Handle the JWT verification error
        return nil, errorHandling.handleTokenError("Failed to verify JWT")
    end

    return verifiedToken
end

-- Middleware to authenticate requests
function jwtUtil.authenticateRequest(req, res, next)
    -- Extract the JWT token from the request headers or query string
    local token = req.headers["Authorization"] or req.query.token
    if not token then
        res.status(401).json(errorHandling.formatError(401, "Unauthorized: Missing token"))
        return
    end

    -- Verify and decode the JWT token
    local decodedToken, err = jwtUtil.verifyToken(token)
    if not decodedToken then
        res.status(401).json(errorHandling.formatError(401, "Unauthorized: Invalid token"))
        return
    end

    -- Check if the user exists and is authenticated
    local userId = decodedToken.payload.userId
    local authenticated, authErr = userModel.authenticateUserById(userId)
    if not authenticated then
        res.status(401).json(errorHandling.formatError(401, "Unauthorized: " .. authErr))
        return
    end

    -- Attach the authenticated userId to the request for further processing
    req.userId = userId

    next()
end

return jwtUtil
