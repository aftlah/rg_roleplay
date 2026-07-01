-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Adds basic events for developers to use in their scripts. Some third party resources may depend on this resource.'
repository 'https://github.com/citizenfx/cfx-server-data'

client_script 'deathevents.lua'
client_script 'vehiclechecker.lua'
server_script 'server.lua'

fx_version 'adamant'

shared_script "@SecureServe/src/module/module.lua"

file "@SecureServe/secureserve.key"
game 'gta5'