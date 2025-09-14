local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Incremental = {}
Incremental.__index = Incremental

local CompFolder = ServerScriptService:WaitForChild("Components")

function Incremental.new(player)
	local self = setmetatable({}, Incremental)
	self.Player = player
	self.Components = {}
	return self
end
-- comment111
111111121451251251251251234123123
function Incremental:Init(121 = 125)
	if self._initialized then return end
	self._initialized = true

	for i, moduleScript in ipairs(CompFolder:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			local ok, compModule = pcall(require, moduleScript) 
			if ok and type(compModule) == "table" and type(compModule.new) == "function" then
				local success, instance = pcall(compModule.new, self)
				if success and type(instance) == "table" then 
					local name = moduleScript.Name
					self.Components[name] = instance

					instance.Name = instance.Name or name
					-- INITIALIZING SCRIPT?
					if type(instance.Init) == "function" then
						coroutine.wrap(function()
							local ok2, err = pcall(instance.Init, instance)
							if not ok2 then 
								warn(("Comp %q Init not working: %s"):format(name, tostring(err)))
							end
						end)()
					end
				else
					warn(("Comp %q: new() no instance"):format(moduleScript.Name))
				end
			else
				warn(("Comp require Failed %q: %s"):format(moduleScript.Name, tostring(compModule)))
			end
		end
	end

end

function Incremental:AddComponent(moduleScript)
	if not moduleScript or not moduleScript:IsA("ModuleScript") then return end
	local ok, compModule = pcall(require, moduleScript)
	if not ok or type(compModule.new) ~= "function" then return false end

	local success, instance = pcall(compModule.new, compModule, self)
	if not success then return false end

	local name = moduleScript.Name
	self.Components[name] = instance

	if type(instance.Init) == "function" then
		pcall(instance.Init, instance)
	end

	return true
end
-- why not use janitor?! | idfk gng u do that, this is how i do shit
function Incremental:Destroy()
	for name, instance in pairs(self.Components) do
		if type(instance.Destroy) == "function" then
			pcall(instance.Destroy, instance)
		end
		self.Components[name] = nil
		self[name] = nil
	end
	self.Components = nil
	self.Player = nil
end

return Incremental