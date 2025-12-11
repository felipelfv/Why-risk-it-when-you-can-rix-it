-- Formats level 4 and 5 headers for APA format.

-- Safe: works with any Pandoc inline
local function ends_with(elt, ending)
  local txt = pandoc.utils.stringify(elt)
  if not txt or txt == "" then
    return false
  end
  return txt:sub(-#ending) == ending
end

function Header(hx)
  if hx.level > 3 then
    -- Add a period unless already present
    local last = hx.content[#hx.content]
    if not (ends_with(last, ".") or ends_with(last, "?") or ends_with(last, "!")) then
      hx.content[#hx.content + 1] = pandoc.Str(".")
    end

    if FORMAT == "docx" then
      local htext = pandoc.utils.stringify(hx.content)
      local prefix = "<w:p><w:pPr><w:pStyle w:val=\"Heading" ..
      hx.level .. "\"/><w:rPr><w:vanish/><w:specVanish/></w:rPr></w:pPr><w:r><w:t>"
      local suffix = "</w:t></w:r><w:r><w:t xml:space=\"preserve\"> </w:t></w:r></w:p>"
      return pandoc.RawBlock('openxml', prefix .. htext .. suffix)
    end
    return hx
  end
end
