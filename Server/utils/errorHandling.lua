local errorHandling = {}

-- Function to handle and format errors
function errorHandling.formatError(statusCode, message)
    local errorResponse = {
        statusCode = statusCode,
        message = message
    }

    return errorResponse
end

-- Function to handle database connection errors
function errorHandling.handleConnectionError(err)
    local message = "Database connection error: " .. err
    return errorHandling.formatError(500, message)
end

-- Function to handle query execution errors
function errorHandling.handleQueryError(err)
    local message = "Query execution error: " .. err
    return errorHandling.formatError(500, message)
end

-- Function to handle authentication errors
function errorHandling.handleAuthenticationError(err)
    local message = "Authentication error: " .. err
    return errorHandling.formatError(401, message)
end

-- Function to handle authorization errors
function errorHandling.handleAuthorizationError(err)
    local message = "Authorization error: " .. err
    return errorHandling.formatError(403, message)
end

return errorHandling
