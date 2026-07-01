fx_version 'cerulean'

shared_script "@SecureServe/src/module/module.lua"

file "@SecureServe/secureserve.key"
game 'gta5'
lua54 'yes'

name 'qb-target'
description 'Compatibility bridge: qb-target API on top of ox_target (qtarget)'
version '1.0.0'

dependency 'ox_target'

client_script 'client.lua'
