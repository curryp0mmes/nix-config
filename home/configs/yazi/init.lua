-- Open mount points on startup
ya.emit("plugin", { "mount-tabs" })

require("zoxide"):setup {
	update_db = true,
}
