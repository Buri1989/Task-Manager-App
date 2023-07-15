local resty = require("resty")
local config = require("config")
local taskRoutes = require("routes.taskRoutes")
local userRoutes = require("routes.userRoutes")

local server = resty.new(config.server)

--Register task routes
server:use("/task", taskRoutes)
--Register user routes
server:use("/user", userRoutes)
--Start the server
server:start();
