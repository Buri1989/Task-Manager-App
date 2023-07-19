# Task-Manager-App

Server side:
1.Make sure you have LuaRocks installed on your system. If you don't have it, you can download and install it from the LuaRocks website (https://luarocks.org/).

2.Open a command prompt or terminal window.

3.Navigate to the root directory of your Lua project, where the package.json file is located.

4.Run the following command to install the Lua dependencies specified in the :
"luarocks install --tree lua_modules --lua-version lua5.1 --lua-dir /path/to/your/lua-interpreter"

Replace /path/to/your/lua-interpreter with the actual path to your Lua interpreter. The --tree option specifies the installation directory for the Lua dependencies (in this case, lua_modules),
and the --lua-version option specifies the Lua version you're using.
LuaRocks will read the package.json file and install the Lua dependencies listed in it, along with their required dependencies, into the lua_modules directo

5.After the installation is complete, you should see the lua_modules folder in your project directory. You can now use the Lua dependencies in your project by requiring them in your Lua scripts.

By following these steps, you can install Lua dependencies from the package.json file into the lua_modules folder, even if it's not present initially.

and to start it : 
1.Open a command prompt or terminal window.
2.Navigate to the root directory of your Lua project, where your Lua scripts are located.
3.Use the Lua interpreter to run your main Lua script
For Lua 5.1: lua5.1 server.lua (this is the version here)

Make sure you have the Lua interpreter installed on your system and properly set up in your environment variables. If you encounter any issues, double-check your Lua installation and ensure that the Lua interpreter command is accessible from the command prompt or terminal.

Note: If your Lua project has additional dependencies on external modules or libraries, make sure they are installed and properly set up in your Lua environment. This may involve additional steps specific to those dependencies.


Client Side:
You need to write npm i in order to download all the packages included in its activation. And after that write npm start, to start the app

*The DB is in the DB folder
