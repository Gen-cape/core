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

return {
  entry = function()
    ya.manager_emit("escape", { visual = true })
    local names = selected_or_hovered()
    local cmd = "ripdrag " .. table.concat(names, " ") .. " --and-exit"
    os.execute(cmd)
  end,
}
