local selected_or_hovered = ya.sync(function()
  local tab, names = cx.active, {}

  for _, u in pairs(tab.selected) do
    names[#names + 1] = tostring(u:name())
  end

  if #names == 0 and tab.current.hovered then
    names[1] = tostring(tab.current.hovered.name)
  end

  return names
end)

-- local escape_spaces_in_list = ya.sync(function(list)
--   local escapedList = {}
--   for _, str in ipairs(list) do
--     local escapedStr, _ = string.gsub(str, " ", "\\ ")
--     table.insert(escapedList, escapedStr)
--   end
--   return escapedList
-- end)

return {
  entry = function()
    ya.manager_emit("escape", { visual = true })
    local names = selected_or_hovered()
    local cmd = "ripdrag \"" .. table.concat(names, "\" \"") .. "\" --and-exit"
    os.execute(cmd)
  end,
}
