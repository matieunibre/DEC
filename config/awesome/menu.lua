-- An applications menu
-- Required depends: awesome-freedesktop or xdg_menu
-- awesome-freedesktop : automatic
-- xdg_menu : manual
-- Your choice

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local apps = require('apps')

local hotkeys_popup = require('awful.hotkeys_popup').widget

terminal = apps.default.terminal
web_browser = apps.default.web_browser
file_manager = apps.default.file_manager
text_editor = apps.default.text_editor
editor_cmd = terminal .. " -e " .. (os.getenv("EDITOR") or "nano")


-- icon theme is in `awesome/theme/default-theme.lua`
-- Search for `theme.icon_theme`

-- Check first if freedesktop module is installed
-- `awesome-freedesktop-git` is in AUR
-- https://github.com/lcpz/awesome-freedesktop
-- Check on your distro's repo

-- Checks if module exists, it will also checks syntax. 
-- Will return false if syntax error in module
local function is_module_available(name)
	if package.loaded[name] then
		return true
	else
		for _, searcher in ipairs(package.searchers or package.loaders) do
			local loader = searcher(name)
			if type(loader) == 'function' then
				package.preload[name] = loader
				return true
			end
		end
		return false
	end
end

-- Create a launcher widget and a main menu
myawesomemenu = {
	{ "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "Edit config", editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{ "Quit", function() awesome.quit() end },
}


-- Screenshot menu
local screenshot = {
	{"Full", function() 
		awful.spawn.easy_async_with_shell(apps.bins.full_screenshot, 
			function() 
			end
		)
	end},
	{"Area", function() 
		awful.spawn.easy_async_with_shell(apps.bins.area_screenshot, 
			function() 
			end
		)
	end}
}


-- Generate a list of app
if is_module_available("freedesktop") == true then

	-- A menu generated by awesome-freedesktop
	-- https://github.com/lcpz/awesome-freedesktop

	local freedesktop = require("freedesktop")
	local menubar = require("menubar")

	mymainmenu = freedesktop.menu.build({
		-- Not actually the size, but the quality of the icon
		icon_size = 48,

		before = {
			{ "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
			{ "Web browser", web_browser, menubar.utils.lookup_icon("webbrowser-app") },
			{ "File Manager", file_manager, menubar.utils.lookup_icon("system-file-manager") },
			{ "Text Editor", text_editor, menubar.utils.lookup_icon("accessories-text-editor") },
			-- other triads can be put here
		},
		after = {
			{"Awesome", myawesomemenu, beautiful.awesome_icon},
			{"Take a Screenshot", screenshot, menubar.utils.lookup_icon("accessories-screenshot") },
			{"End Session", function() _G.exit_screen_show() end, menubar.utils.lookup_icon("system-shutdown") },
			-- other triads can be put here
		}

	})
	mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })


else

	-- A menu generated by xdg_menu

	-- These are only example of the list generated by xdg_menu!
	-- Change it manually!

	local menu98edb85b00d9527ad5acebe451b3fae6 = {
		{"Archive Manager", "file-roller "},
		{"Calculator", "gnome-calculator"}
	}

	local menu251bd8143891238ecedc306508e29017 = {
		{"BomberClone", "bomberclone", "/usr/share/pixmaps/bomberclone.png" },
		{"Citra", "citra-qt "}
	}

	local menud334dfcea59127bedfcdbe0a3ee7f494 = {
		{"GNU Image Manipulation Program", "gimp-2.10 ", "/usr/share/icons/hicolor/16x16/apps/gimp.png" },
		{"Inkscape", "inkscape ", "/usr/share/icons/hicolor/16x16/apps/inkscape.png" }
	}

	local menuc8205c7636e728d448c2774e6a4a944b = {
		{"Avahi SSH Server Browser", "/usr/bin/bssh", "/usr/share/icons/gnome/16x16/devices/network-wired.png" },
		{"Avahi VNC Server Browser", "/usr/bin/bvnc", "/usr/share/icons/gnome/16x16/devices/network-wired.png" }
	}

	local menue6f43c40ab1c07cd29e4e83e4ef6bf85 = {
		{"Android Studio", "android-studio ", "/usr/share/pixmaps/android-studio.png" },
		{"CMake", "cmake-gui ", "/usr/share/icons/hicolor/32x32/apps/CMakeSetup.png" }
	}

 	local menu52dd1c847264a75f400961bfb4d1c849 = {
		{"Calf Plugin Pack for JACK", "calfjackhost", "/usr/share/icons/hicolor/16x16/apps/calf.png" },
		{"Cheese", "cheese"}
	}

	local menuee69799670a33f75d45c57d1d1cd0ab3 = {
	 {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover", "/usr/share/icons/gnome/16x16/devices/network-wired.png" },
	 {"GParted", "/usr/bin/gparted ", "/usr/share/icons/hicolor/16x16/apps/gparted.png" }
	}

	-- The instruction to generate a list of menu
	-- You can remove this
	local instruction = {
		{"Show instruction", function() 
			require('naughty').notification({
				title = 'Generate a list of menu',
				message = "xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu MENU.lua",
				app_name = 'System Notification',
				timeout = 0,
				urgency = 'critical'
			})
		end}
	}


	mymainmenu = awful.menu({
		items = {
			{ "Terminal", terminal },
			{ "Web browser", web_browser },
			{ "File Manager", file_manager },
			{ "Text Editor", text_editor },

			-- Replace the table name with the one generated by xdg_menu
			{"Replace this!"},
			{"Example 1", menu98edb85b00d9527ad5acebe451b3fae6},
			{"Example 2", menu251bd8143891238ecedc306508e29017},
			{"Example 3", menud334dfcea59127bedfcdbe0a3ee7f494},
			{"Example 4", menuc8205c7636e728d448c2774e6a4a944b},
			{"Example 5", menue6f43c40ab1c07cd29e4e83e4ef6bf85},
			{"Example 6", menu52dd1c847264a75f400961bfb4d1c849},
			{"Example 7", menuee69799670a33f75d45c57d1d1cd0ab3},
			{'!! INSTRUCTION !!', instruction },
			--

			{"Awesome", myawesomemenu},
			{"Take a Screenshot", screenshot },
			{"End Session", function() _G.exit_screen_show() end }
		}
	})

	mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

end

-- Embed mouse bindings
root.buttons(
	gears.table.join(
		awful.button(
			{}, 
			3, 
			function () 
				mymainmenu:toggle() 
			end
		),
		awful.button(
			{}, 
			1,
		 	function()
				mymainmenu:hide()
		 	end
		)
	)
)
