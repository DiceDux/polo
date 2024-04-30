--------------------------------
------- Created by Hamza -------
-------------------------------- 

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'ESX Gouvernement Garage'
shared_script '@es_extended/imports.lua'

client_scripts {
	"@es_extended/locale.lua",
    "config.lua",
    "client.lua"
}
