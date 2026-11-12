-- Shared helpers for hyprland.lua, loaded with require("utils").
-- `hl` is a global provided by Hyprland, so required modules can use it directly.

local M = {}

-- The workspace's *actual* layout. Authoritative, unlike a window's cached layout
-- handle, which can lag behind after a window/workspace move or a reload.
-- Exposed by Hyprland as workspace.tiled_layout (Lua) / "tiledLayout" (hyprctl -j).
function M.activeLayout()
    local ws = hl.get_active_workspace()
    return ws and ws.tiled_layout
end

-- Toggle the focused window's column between 100% of the monitor width and its
-- previous width (scrolling layout). Widths are remembered per window.
local savedColumnWidths = {}

function M.toggleColumnWidth()
    local w = hl.get_active_window()
    if not w or M.activeLayout() ~= "scrolling" then return end -- colresize is scrolling-only
    local col = w.layout and w.layout.column
    if not col then return end

    if col.width >= 0.999 then
        local prev = savedColumnWidths[w.address] or 0.5
        savedColumnWidths[w.address] = nil
        hl.dispatch(hl.dsp.layout("colresize " .. string.format("%.5f", prev)))
    else
        savedColumnWidths[w.address] = col.width
        hl.dispatch(hl.dsp.layout("colresize 1.0"))
    end
end

-- Dwindle only: togglesplit is a dwindle layout message.
function M.toggleSplit()
    if M.activeLayout() == "dwindle" then
        hl.dispatch(hl.dsp.layout("togglesplit"))
    end
end

-- Selector for a workspace in a dispatch: numeric ones by id, named ones ("gaming")
-- by name, since those have no numeric id at all.
function M.workspaceSelector(ws)
    return ws.id ~= nil and tostring(ws.id) or ("name:" .. ws.name)
end

-- Move focus with mainMod + arrow keys. Left/right use the scrolling layout's own
-- "focus" message (which keeps the tape in view and, with wrap_focus = false, stops
-- at the edges) and Hyprland's native directional focus on every other layout.
function M.focusInWorkspace(dir)
    if M.activeLayout() == "scrolling" then
        hl.dispatch(hl.dsp.layout("focus " .. dir))
    else
        hl.dispatch(hl.dsp.focus({ direction = dir == "l" and "left" or "right" }))
    end
end

-- The monitor left/right of `mon`, decided by the monitors' horizontal centres, so
-- it follows the physical layout (HDMI-A-3 | DP-4 | DP-5) rather than their names.
function M.monitorInDirection(mon, dir)
    local centre = mon.x + mon.width / 2
    local best, bestDistance

    for _, other in ipairs(hl.get_monitors()) do
        if other.id ~= mon.id and other.enabled and not other.is_mirror then
            local distance = (other.x + other.width / 2) - centre
            if (dir == "l" and distance < 0) or (dir == "r" and distance > 0) then
                if not best or math.abs(distance) < bestDistance then
                    best, bestDistance = other, math.abs(distance)
                end
            end
        end
    end

    return best
end

-- Focus the workspace the output on that side is showing, which moves focus there.
function M.focusAdjacentMonitorWorkspace(dir)
    local mon = hl.get_active_monitor()
    if not mon then return end

    local target = M.monitorInDirection(mon, dir)
    local ws = target and target.active_workspace
    if not ws then return end -- only one output, nothing to step to

    hl.dispatch(hl.dsp.focus({ workspace = M.workspaceSelector(ws) }))
end

-- Move the focused window one step left/right. On the scrolling layout `movewindow`
-- pushes the window *into* the neighbouring column, turning it into a vertical
-- stack; its `swapcol` message swaps whole columns instead. Dwindle has no columns,
-- so there the native directional move is what we want.
function M.moveWindowInWorkspace(dir)
    if M.activeLayout() == "scrolling" then
        hl.dispatch(hl.dsp.layout("swapcol " .. dir))
        return
    end

    hl.dispatch(hl.dsp.window.move({ direction = dir == "l" and "left" or "right" }))
end

-- Send the focused window to the workspace shown on the output on that side and
-- follow it there. This is a normal (non-silent) move, so Hyprland focuses the
-- window and warps the cursor onto it.
function M.moveWindowToAdjacentMonitorWorkspace(dir)
    local mon = hl.get_active_monitor()
    if not mon then return end

    local target = M.monitorInDirection(mon, dir)
    local ws = target and target.active_workspace
    if not ws then return end -- only one output, nowhere to send it

    hl.dispatch(hl.dsp.window.move({ workspace = M.workspaceSelector(ws) }))
end

-- Workspaces on one output in a stable order: numeric ones by id, then named ones
-- by name.
function M.orderedWorkspacesOn(mon)
    local list = {}
    for _, ws in ipairs(hl.get_workspaces()) do
        if not ws.special and ws.monitor.id == mon.id then list[#list + 1] = ws end
    end

    table.sort(list, function(a, b)
        if a.id ~= nil and b.id ~= nil then return a.id < b.id end
        if a.id ~= nil then return true end -- numeric workspaces come first
        if b.id ~= nil then return false end
        return a.name < b.name
    end)

    return list
end

-- Next/previous workspace in this output's ordered list, or the id of the one to
-- create when stepping past the end. Returns nil when there is nowhere to go.
function M.neighbourWorkspace(mon, base, dir)
    local list = M.orderedWorkspacesOn(mon)

    local index
    for i, ws in ipairs(list) do
        if ws.addressable_name == base.addressable_name then
            index = i
            break
        end
    end

    local neighbour = index and list[index + dir]
    if neighbour then return neighbour end

    -- Named workspaces sit at the end of the chain and are terminal: there is no id
    -- to step past them, so don't guess at one.
    if base.id == nil then return nil end

    if (base.windows or 0) == 0 then return nil end -- don't create beyond an unused workspace

    local edge = dir > 0 and 0 or math.huge
    for _, ws in ipairs(list) do
        if ws.id ~= nil then edge = dir > 0 and math.max(edge, ws.id) or math.min(edge, ws.id) end
    end
    if edge == math.huge then return nil end

    local target = edge + dir
    if target < 1 then return nil end

    return target -- numeric: the workspace doesn't exist yet, ask for it to be created
end

-- Switch to the next/previous workspace on this output, creating one when stepping
-- past the last existing workspace.
function M.scrollWorkspace(dir)
    local mon = hl.get_active_monitor()
    local base = mon and mon.active_workspace -- monitor's workspace, so specials don't break it
    if not base then return end

    local target = M.neighbourWorkspace(mon, base, dir)
    if target == nil then return end

    if type(target) == "number" then
        hl.dispatch(hl.dsp.focus({ workspace = target, on_current_monitor = true }))
    else
        hl.dispatch(hl.dsp.focus({ workspace = M.workspaceSelector(target) }))
    end
end

-- Take the focused window along to the next/previous workspace on this output,
-- creating the next one when stepping past the last existing workspace.
function M.moveWindowWorkspace(dir)
    local mon = hl.get_active_monitor()
    local base = mon and mon.active_workspace
    if not base then return end

    local target = M.neighbourWorkspace(mon, base, dir)
    if target == nil then return end

    if type(target) == "number" then
        hl.dispatch(hl.dsp.window.move({ workspace = target }))
    else
        hl.dispatch(hl.dsp.window.move({ workspace = M.workspaceSelector(target) }))
    end
end

return M
