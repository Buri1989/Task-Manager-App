local config = {
    server    = {
        host = "127.0.0.1",
        port = 8080,
    },
    database  = {
        host = "localhost",
        port = 3306,
        username = "root",         --Remove the username when done
        password = "Boris1898!",   --Remove the password when done
        database = "task manager", --Dont forget to export it and put in github also
    },
    jwtSecret = "your-secret-key",
}

return config