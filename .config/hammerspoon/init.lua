local hk = require 'hs.hotkey'

-- key bindings
hk.bind('cmd', '1', function()
  hs.application.launchOrFocus('iTerm')
end)

hk.bind('cmd', '2', function()
  hs.application.launchOrFocus('Firefox')
end)

hk.bind('cmd', '3', function()
  hs.application.launchOrFocus('Obsidian')
end)
