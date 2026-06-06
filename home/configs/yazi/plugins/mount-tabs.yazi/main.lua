return {
	entry = function()
		local user = os.getenv("USER") or "simon"
		local mount_path = "/run/media/" .. user .. "/"
		
		local output = Command("ls"):arg("-1"):arg(mount_path):stderr(Command.PIPED):output()
		
		if not output or not output.status.success then
			return
		end

		local count = 0
		for line in output.stdout:gmatch("[^\r\n]+") do
			-- Basic check to ensure it's a directory (ls -1 already gives names, 
			-- but we want to be sure we are hitting directories under the mount path)
			local full_path = mount_path .. line
			ya.emit("tab_create", { full_path })
			count = count + 1
		end

		if count > 0 then
			ya.notify({
				title = "Mount Tabs",
				content = "Opened " .. count .. " mount point(s)",
				timeout = 2,
			})
		end
	end,
}
