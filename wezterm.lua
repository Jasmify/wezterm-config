local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- OSの判定用関数
local function is_windows() return wezterm.target_triple:find("windows") ~= nil end
local function is_macos() return wezterm.target_triple:find("apple") ~= nil end

----------------------------------------------------------------
-- 外観・基本設定 (共通)
----------------------------------------------------------------
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.8
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.initial_cols = 120
config.initial_rows = 30
config.scrollback_lines = 10000

-- タブバー
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

----------------------------------------------------------------
-- OS固有の設定 (フォント・プログラム)
----------------------------------------------------------------
-- フォント設定
-- MS GothicなどのWindows専用フォントを含めても他OSで無視されるだけなのでそのままでもOKですが、
-- OSごとに最適なフォントを優先順位で並べるのが安全です。
config.font = wezterm.font_with_fallback {
    'HackGen Console NF',
    'Cica',
    is_windows() and 'MS Gothic' or nil, -- Windowsの時だけ追加
}
config.font_size = 14.0

-- デフォルトシェルの設定
if is_windows() then
    config.default_prog = { 'pwsh.exe' }
elseif is_macos() then
    config.default_prog = { 'zsh', '--login' } 
else
    config.default_prog = { 'bash', '--login' }
end
----------------------------------------------------------------
-- 入力・キーバインド (共通)
----------------------------------------------------------------
config.use_ime = true

config.keys = {
  -- タブ操作
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } },
  
  -- 分割
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- ペイン移動 (ALT + hjkl)
  { key = 'h', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'ALT', action = wezterm.action.ActivatePaneDirection 'Down' },
  
  -- ペインを閉じる
  { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentPane { confirm = true } },
}

return config
