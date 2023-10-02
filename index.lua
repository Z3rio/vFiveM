local M = {}

require("natives/index")

---@param fileContent string
---@param fileName string
M.IsServerFile = function(fileContent, fileName)
	local serverFound = fileContent.find(fileContent, "---@server")
	local clientFound = fileContent.find(fileContent, "---@client")

	if serverFound == true and clientFound == true then
		error("File " .. fileName .. " has both a server and client flag.")
		return nil
	elseif serverFound == false and clientFound == false then
		error("File " .. fileName .. " has neither a server or a client flag.")
		return nil
	else
		return serverFound == true
	end
end

---@param fileName string
M.RunFile = function(fileName)
	local f = io.open(fileName, "rb")
	if f == nil then
		return false
	end

	local content = f:read("*a")
	f:close()

	local isServerSided = M.IsServerFile(content, fileName)

	if isServerSided ~= nil then
		local loaded = load(content)

		if type(loaded) == "function" then
			local success, resp = pcall(loaded)

			if success == true then
				print("Successfully ran " .. fileName)
			else
				error(resp)
			end
		else
			error("Could not run " .. fileName)
		end
	end
end

M.init = function()
	M.RunFile("./test/server.lua")
	M.RunFile("./test/client.lua")
end

M.init()

return M
