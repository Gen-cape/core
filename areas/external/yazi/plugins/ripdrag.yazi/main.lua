local selected_or_hovered = ya.sync(function()
    local tab, paths = cx.active, {}
    for _, u in pairs(tab.selected) do
        paths[#paths + 1] = tostring(u)
    end
    if #paths == 0 and tab.current.hovered then
        paths[1] = tostring(tab.current.hovered.url)
    end

    return paths
end)

return {
    entry = function(_, job)
        local paths = selected_or_hovered()
        if #paths == 0 then
            return ya.notify({
                title = "ripdrag",
                content = "No files selected or hovered",
                timeout = 3,
                level = "warn",
            })
        end

        local cmd = Command("ripdrag"):arg("--and-exit")

        local args = (job and job.args) or {}
        for _, arg in ipairs(args) do
            if type(arg) == "string" then
                cmd:arg(arg)
            end
        end

        cmd:arg("--")
        for _, path in ipairs(paths) do
            cmd:arg(path)
        end

        local child, err = cmd:stderr(Command.PIPED):spawn()
        if not child then
            return ya.notify({
                title = "ripdrag",
                content = "Failed to spawn ripdrag: " .. tostring(err),
                timeout = 5,
                level = "error",
            })
        end

        local output, wait_err = child:wait_with_output()
        if not output then
            return ya.notify({
                title = "ripdrag",
                content = "Error waiting for ripdrag: " .. tostring(wait_err),
                timeout = 5,
                level = "error",
            })
        end

        if not output.status.success then
            return ya.notify({
                title = "ripdrag",
                content = output.stderr ~= "" and output.stderr or "Exited with code " .. tostring(output.status.code),
                timeout = 5,
                level = "error",
            })
        end
    end,
}
