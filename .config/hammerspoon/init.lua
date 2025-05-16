local hk = require 'hs.hotkey'

-- key bindings
hk.bind('cmd', '1', function()
  hs.application.launchOrFocus('WezTerm')
end)

hk.bind('cmd', '2', function()
  hs.application.launchOrFocus('Brave Browser')
end)

hk.bind('cmd', '3', function()
  hs.application.launchOrFocus('Obsidian')
end)

hk.bind('cmd', '4', function()
  hs.application.launchOrFocus('Finder')
end)
