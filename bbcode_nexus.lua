--[[
Pandoc writer for Nexus Mods BBCode
]]

---@diagnostic disable:unused-local

function Blocksep()
    return "\n\n"
end

function Doc(body, title, authors, date, variables)
    return body .. "\n"
end

function Str(s)
    return s
end

function Plain(s)
    return s
end

function Space()
    return " "
end

function LineBreak()
    return " "
end

function SoftBreak()
    return " "
end

function Para(s)
    return s
end

function Strong(s)
    return "[b]" .. s .. "[/b]"
end

function Emph(s)
    return "[i]" .. s .. "[/i]"
end

function Header(lev, s, attr)
    if lev == 1 then
        return "[center][b][size=6]" .. s .. "[/size][/b][/center]"
    elseif lev == 2 then
        return "[b][size=5]" .. s .. "[/size][/b]"
    elseif lev == 3 then
        return "[b][size=4]" .. s .. "[/size][/b]"
    else
        return s
    end
end

function BulletList(items)
    local buffer = {}
    for _, item in ipairs(items) do
        table.insert(buffer, "[*]" .. item)
    end
    return "[list]\n" .. table.concat(buffer, "\n") .. "\n[/list]"
end

function Code(s, attr)
    return "[i]" .. s .. "[/i]"
end

function CodeBlock(s, attr)
    return "[code]" .. s .. "[/code]"
end

function BlockQuote(s)
    return "[quote]" .. s .. "[/quote]"
end

function Link(s, src, tit)
    local code = "[url"
    if s then
        code = code .. "=" .. src
    else
        s = src
    end
    code = code .. "]" .. s .. "[/url]"
    return code
end

function Image(s, src, tit)
    return "[img=" .. tit .. "]" .. src .. "[/img]"
end

-- Checks whether all required functions are defined
local meta = {}
meta.__index = function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n", key))
    return function()
        return ""
    end
end
setmetatable(_G, meta)
