local config = {
    server   = {
        host = "127.0.0.1",
        port = 8080,
    },
    database = {
        host = "localhost",
        port = 3306,
        username = "root",         --Remove the username when done
        password = "Boris1898!",   --Remove the password when done
        database = "task manager", --Dont forget to export it and put in github also
    },
    jwt      = {
        jwtSecret = "secretkey",
        algorithm = "HS256", -- Specify the desired algorithm (e.g., HS256, RS256)
        expiresIn = 3600     -- Specify the expiration time for the token in seconds
    }

}

return config
