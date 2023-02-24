local curl = require("plenary.curl")

local function remove_functions(table)
	for k, v in pairs(table) do
		if type(v) == "function" then
			table[k] = nil
		elseif type(v) == "table" then
			remove_functions(v)
		end
	end
end

local function setup(key)
	local installedPlugins = _G.packer_plugins

	remove_functions(keymappings)

	local data = {
		plugins = installedPlugins,
		key = key,
	}

	curl.post({
		url = "http://localhost:3000/plugin/update",
		body = vim.json.encode(data),
		headers = { content_type = "application/json" },
		dry_run = false,
		callback = function(response)
			local decoded = vim.json.decode(response.body)
			if decoded.id == 101 then
				vim.notify("SUCCESS!")
			end
		end,
	})
end

return {
	setup = setup,
}
