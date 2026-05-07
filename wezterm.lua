local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme  = 'Catppuccin Mocha'

-- 【核心设置】指定默认启动程序为 PowerShell
-- Windows PowerShell 的路径通常是 powershell.exe
config.default_prog = { 'powershell.exe', '-NoLogo' }

-- 进阶：如果你安装了更强大的 PowerShell 7 (推荐)，请改用下面的：t
-- config.default_prog = { 'pwsh.exe' }

-- 可选：设置启动时的默认目录（比如你的项目目录）
-- config.default_cwd = "D:/MyProjects"

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

  -- 主窗格最大化
  window:gui_window():maximize()
  
  -- 水平分割主窗格
  local right_pane = pane:split { direction = 'Right', size = 0.6 }

  -- 在下方水平分割
  right_pane:split { direction = 'Bottom', size = 0.6 }  

end)

-- ===================== 快捷键配置 =====================
local act = wezterm.action
config.keys = {
  { key = "h", mods = "ALT", action = act.SplitHorizontal {} },
  { key = "v", mods = "ALT", action = act.SplitVertical {} },
  { key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection "Left" },
  { key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection "Right" },
  { key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection "Up" },
  { key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection "Down" },
  { key = "q", mods = "ALT", action = act.CloseCurrentPane { confirm = false } },
  { key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain' },
  { key = 'w', mods = 'ALT', action = act.CloseCurrentTab { confirm = false } },
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i), mods = 'CTRL', action = act.ActivateTab(i-1)
  })
end

return config
