
local repo = 'https://raw.githubusercontent.com/hds536jhmk/YAGUI/'
local master = repo..'master/'

local APPS = {
    {
        NAME = 'YAGUI-mini',
        URL = 'YAGUI-mini.lua',
        PATH = '/YAGUI-mini.lua'
    },
    {
        NAME = 'WSS_listener',
        URL = 'examples/WSS_listener.lua',
        PATH = '/WSS_listener.lua'
    },
    {
        NAME = 'Note',
        URL = 'examples/Note.lua',
        PATH = '/Note.lua'
    }
}

local function better_print(text, fg, bg)
    local old_fg = term.getTextColor()
    local old_bg = term.getBackgroundColor()

    if fg then term.setTextColor(fg); end
    if bg then term.setBackgroundColor(bg); end
    if text then print(text); end

    term.setTextColor(old_fg)
    term.setBackgroundColor(old_bg)
end

local function download_as(URL, PATH)
    local text = http.get(URL).readAll()
    local file = fs.open(PATH, 'w')
    file.write(text)
    file.close()
end

local function download_apps_from(repo)
    for _, app in pairs(APPS) do
        download_as(repo..app.URL, app.PATH)
        better_print(app.NAME..' was downloaded!', colors.green)
    end
end

better_print('Removing APPS...', colors.orange)
for _, app in pairs(APPS) do
	if fs.exists(app.PATH) then
		fs.delete(app.PATH)
		better_print(app.NAME..' was removed.', colors.red)
	end
end

better_print('Downloading master...', colors.orange)
download_apps_from(master)
