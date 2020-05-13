
local repo = 'https://raw.githubusercontent.com/hds536jhmk/YAGUI/'
local master = repo..'master/'

local PROGRAMS = {
    {
        NAME = 'YAGUI',                 -- Name to be displayed
        URL = master..'YAGUI-mini.lua', -- URL to the file
        PATH = '/YAGUI.lua'             -- Path where to save the file
    },
    {
        NAME = 'WSS_Client',
        URL = master..'examples/WSS_Client.lua',
        PATH = '/WSS_Client.lua'
    },
    {
        NAME = 'HPainter',
        URL = master..'examples/HPainter.lua',
        PATH = '/HPainter.lua'
    },
    {
        NAME = 'Note',
        URL = master..'examples/Note-mini.lua',
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

local function download_programs()
    for _, program in next, PROGRAMS do
        download_as(program.URL, program.PATH)
        better_print(program.NAME..' was downloaded!', colors.green)
    end
end

local function remove_programs()
    for _, program in next, PROGRAMS do
        if fs.exists(program.PATH) then
            fs.delete(program.PATH)
            better_print(program.NAME..' was removed.', colors.red)
        end
    end
end

better_print('Removing old Programs...', colors.orange)
remove_programs()
better_print('Downloading Programs...', colors.orange)
download_programs()
