--------------------------------
------- Created by Hamza -------
-------------------------------- 

ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- Blip on Map for Car Garages:
Citizen.CreateThread(function()
	if Config.EnableCarGardeGarageBlip == true then	
		for k,v in pairs(Config.CarGardeZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarGardeGarageSprite)
				SetBlipDisplay(blip, Config.CarGardeGarageDisplay)
				SetBlipScale  (blip, Config.CarGardeGarageScale)
				SetBlipColour (blip, Config.CarGardeGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarGardeGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarPresidentGarageBlip == true then	
		for k,v in pairs(Config.CarPresidentZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarPresidentGarageSprite)
				SetBlipDisplay(blip, Config.CarPresidentGarageDisplay)
				SetBlipScale  (blip, Config.CarPresidentGarageScale)
				SetBlipColour (blip, Config.CarPresidentGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarPresidentGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarPremierMinistreGarageBlip == true then	
		for k,v in pairs(Config.CarPremierMinistreZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarPremierMinistreGarageSprite)
				SetBlipDisplay(blip, Config.CarPremierMinistreGarageDisplay)
				SetBlipScale  (blip, Config.CarPremierMinistreGarageScale)
				SetBlipColour (blip, Config.CarPremierMinistreGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarPremierMinistreGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarMinistreGarageBlip == true then	
		for k,v in pairs(Config.CarMinistreZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarMinistreGarageSprite)
				SetBlipDisplay(blip, Config.CarMinistreGarageDisplay)
				SetBlipScale  (blip, Config.CarMinistreGarageScale)
				SetBlipColour (blip, Config.CarMinistreGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarMinistreGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarAssistantGarageBlip == true then	
		for k,v in pairs(Config.CarAssistantZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarAssistantGarageSprite)
				SetBlipDisplay(blip, Config.CarAssistantGarageDisplay)
				SetBlipScale  (blip, Config.CarAssistantGarageScale)
				SetBlipColour (blip, Config.CarAssistantGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarAssistantGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarAssistanteGarageBlip == true then	
		for k,v in pairs(Config.CarAssistanteZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarAssistanteGarageSprite)
				SetBlipDisplay(blip, Config.CarAssistanteGarageDisplay)
				SetBlipScale  (blip, Config.CarAssistanteGarageScale)
				SetBlipColour (blip, Config.CarAssistanteGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarAssistanteGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

Citizen.CreateThread(function()
	if Config.EnableCarBossGarageBlip == true then	
		for k,v in pairs(Config.CarBossZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarBossGarageSprite)
				SetBlipDisplay(blip, Config.CarBossGarageDisplay)
				SetBlipScale  (blip, Config.CarBossGarageScale)
				SetBlipColour (blip, Config.CarBossGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarBossGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

-- Blip on Map for Boat Garages:
Citizen.CreateThread(function()
	if Config.EnableBoatGarageBlip == true then
		for k,v in pairs(Config.BoatZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.BoatGarageSprite)
				SetBlipDisplay(blip, Config.BoatGarageDisplay)
				SetBlipScale  (blip, Config.BoatGarageScale)
				SetBlipColour (blip, Config.BoatGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.BoatGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

local insideMarker = false

-- Core Thread Function:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
		
		if (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'garde' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarGardeZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarGardeMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarGardeMarkerScale.x, Config.GouvernementCarGardeMarkerScale.y, Config.GouvernementCarGardeMarkerScale.y, Config.GouvernementCarGardeMarkerColor.r,Config.GouvernementCarGardeMarkerColor.g,Config.GouvernementCarGardeMarkerColor.b,Config.GouvernementCarGardeMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarGardeDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarGardeGarage) then
							GouvernementGarage('cargarde')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarPresidentZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarPresidentMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarPresidentMarkerScale.x, Config.GouvernementCarPresidentMarkerScale.y, Config.GouvernementCarPresidentMarkerScale.y, Config.GouvernementCarPresidentMarkerColor.r,Config.GouvernementCarPresidentMarkerColor.g,Config.GouvernementCarPresidentMarkerColor.b,Config.GouvernementCarPresidentMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarPresidentDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarPresidentGarage) then
							GouvernementGarage('carpresident')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'premierministre' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarPremierMinistreZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarPremierMinistreMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarPremierMinistreMarkerScale.x, Config.GouvernementCarPremierMinistreMarkerScale.y, Config.GouvernementCarPremierMinistreMarkerScale.y, Config.GouvernementCarPremierMinistreMarkerColor.r,Config.GouvernementCarPremierMinistreMarkerColor.g,Config.GouvernementCarPremierMinistreMarkerColor.b,Config.GouvernementCarPremierMinistreMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarPremierMinistreDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarPremierMinistreGarage) then
							GouvernementGarage('carpremierministre')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'ministre' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarMinistreZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarMinistreMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarMinistreMarkerScale.x, Config.GouvernementCarMinistreMarkerScale.y, Config.GouvernementCarMinistreMarkerScale.y, Config.GouvernementCarMinistreMarkerColor.r,Config.GouvernementCarMinistreMarkerColor.g,Config.GouvernementCarMinistreMarkerColor.b,Config.GouvernementCarMinistreMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarMinistreDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarMinistreGarage) then
							GouvernementGarage('carministre')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'assistant' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarAssistantZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarAssistantMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarAssistantMarkerScale.x, Config.GouvernementCarAssistantMarkerScale.y, Config.GouvernementCarAssistantMarkerScale.y, Config.GouvernementCarAssistantMarkerColor.r,Config.GouvernementCarAssistantMarkerColor.g,Config.GouvernementCarAssistantMarkerColor.b,Config.GouvernementCarAssistantMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarAssistantDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarAssistantGarage) then
							GouvernementGarage('carassistant')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'juge' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarAssistantZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarAssistantMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarAssistantMarkerScale.x, Config.GouvernementCarAssistantMarkerScale.y, Config.GouvernementCarAssistantMarkerScale.y, Config.GouvernementCarAssistantMarkerColor.r,Config.GouvernementCarAssistantMarkerColor.g,Config.GouvernementCarAssistantMarkerColor.b,Config.GouvernementCarAssistantMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarAssistantDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarAssistantGarage) then
							GouvernementGarage('carassistant')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'assistante' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarAssistanteZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarAssistanteMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarAssistanteMarkerScale.x, Config.GouvernementCarAssistanteMarkerScale.y, Config.GouvernementCarAssistanteMarkerScale.y, Config.GouvernementCarAssistanteMarkerColor.r,Config.GouvernementCarAssistanteMarkerColor.g,Config.GouvernementCarAssistanteMarkerColor.b,Config.GouvernementCarAssistanteMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarAssistanteDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarAssistanteGarage) then
							GouvernementGarage('carassistante')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.CarBossZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementCarBossMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementCarBossMarkerScale.x, Config.GouvernementCarBossMarkerScale.y, Config.GouvernementCarBossMarkerScale.y, Config.GouvernementCarBossMarkerColor.r,Config.GouvernementCarBossMarkerColor.g,Config.GouvernementCarBossMarkerColor.b,Config.GouvernementCarBossMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarBossDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarBossGarage) then
							GouvernementGarage('carboss')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'garde' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.HeliGardeZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementHeliGardeMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.95, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementHeliGardeMarkerScale.x, Config.GouvernementHeliGardeMarkerScale.y, Config.GouvernementHeliGardeMarkerScaleGouvernementHeliGardeMarkerScaleGouvernementHeliGardeMarkerScale.z, Config.GouvernementHeliGardeMarkerColor.r,Config.GouvernementHeliGardeMarkerColor.g,Config.GouvernementHeliGardeMarkerColor.b,Config.GouvernementHeliGardeMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 3.0 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.HeliGardeDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenHeliGardeGarage) then
							GouvernementGarage('helicoptergarde')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end

		elseif (ESX.PlayerData.job and ESX.PlayerData.job.grade_name == 'boss' and ESX.PlayerData.job.name == 'gouvernement') then
			for k,v in pairs(Config.BoatZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 50.0) and insideMarker == false then
						DrawMarker(Config.GouvernementBoatMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.GouvernementBoatMarkerScale.x, Config.GouvernementBoatMarkerScale.y, Config.GouvernementBoatMarkerScale.z, Config.GouvernementBoatMarkerColor.r,Config.GouvernementBoatMarkerColor.g,Config.GouvernementBoatMarkerColor.b,Config.GouvernementBoatMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 3.0 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.BoatDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenBoatGarage) then
							GouvernementGarage('boat')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end
		end
	end
end)

-- Gouvernement Garage Menu:
GouvernementGarage = function(type)
	local elements = {
		{ label = Config.LabelStoreVeh, action = "store_vehicle" },
		{ label = Config.LabelGetVeh, action = "get_vehicle" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_gouvernementGarage_menu",
		{
			title    = Config.TitleGouvernementGarage,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		local action = data.current.action
		if action == "get_vehicle" then
			if type == 'cargarde' then
				VehicleMenu('cargarde')
			elseif type == 'carpresident' then
				VehicleMenu('carpresident')
			elseif type == 'carpremierministre' then
				VehicleMenu('carpremierministre')
			elseif type == 'carministre' then
				VehicleMenu('carministre')
			elseif type == 'carassistant' then
				VehicleMenu('carassistant')
			elseif type == 'carassistante' then
				VehicleMenu('carassistante')
			elseif type == 'carboss' then
				VehicleMenu('carboss')
			elseif type == 'boat' then
				VehicleMenu('boat')
			end
		elseif data.current.action == 'store_vehicle' then
			local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
			if dist < 3 then
				DeleteEntity(veh)
				ESX.ShowNotification(Config.VehicleParked)
			else
				ESX.ShowNotification(Config.NoVehicleNearby)
			end
			insideMarker = false
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Vehicle Spawn Menu:
VehicleMenu = function(type)
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(ped)
	
	if type == 'cargarde' then
		for k,v in pairs(Config.GouvernementVehiclesGarde) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'cargarde'})
		end
	elseif type == 'carpresident' then
		for k,v in pairs(Config.GouvernementVehiclesPresident) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carpresident'})
		end
	elseif type == 'carpremierministre' then
		for k,v in pairs(Config.GouvernementVehiclesPremierMinistre) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carpremierministre'})
		end
	elseif type == 'carministre' then
		for k,v in pairs(Config.GouvernementVehiclesMinistre) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carministre'})
		end
	elseif type == 'carassistant' then
		for k,v in pairs(Config.GouvernementVehiclesAssistant) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carassistant'})
		end
	elseif type == 'carassistante' then
		for k,v in pairs(Config.GouvernementVehiclesAssistante) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carassistante'})
		end
	elseif type == 'carboss' then
		for k,v in pairs(Config.GouvernementVehiclesBoss) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'carboss'})
		end
	elseif type == 'boat' then
		for k,v in pairs(Config.GouvernementBoats) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'boat'})
		end
	end
		
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_gouvernementGarage_vehicle_garage",
		{
			title    = Config.TitleGouvernementGarage,
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		insideMarker = false
		local plate = exports['esx_vehicleshop']:GeneratePlate()
		VehicleLoadTimer(data.current.model)
		local veh = CreateVehicle(data.current.model,pos.x,pos.y,pos.z,GetEntityHeading(playerPed),true,false)
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetVehicleNumberPlateText(veh,plate)
		
		if type == 'carpresident' then
			ESX.ShowNotification(Config.CarPresidentOutFromPolGar)
		elseif type == 'cargarde' then
			ESX.ShowNotification(Config.CarGardeOutFromPolGar)
		elseif type == 'carpremierministre' then
			ESX.ShowNotification(Config.CarPremierMinistreOutFromPolGar)
		elseif type == 'carministre' then
			ESX.ShowNotification(Config.CarMinistreOutFromPolGar)
		elseif type == 'carassistant' then
			ESX.ShowNotification(Config.CarAssistantOutFromPolGar)
		elseif type == 'carassistante' then
			ESX.ShowNotification(Config.CarAssistanteOutFromPolGar)
		elseif type == 'carboss' then
			ESX.ShowNotification(Config.CarBossOutFromPolGar)
		elseif type == 'boat' then
			ESX.ShowNotification(Config.BoatOutFromPolGar)
		end
		
		TriggerEvent("fuel:setFuel",veh,100.0)
		SetVehicleDirtLevel(veh, 0.1)		
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Load Timer Function for Vehicle Spawn:
function VehicleLoadTimer(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText(Config.VehicleLoadText, 255, 255, 255, 255)
		end
	end
end

-- Loading Text for Vehicles Function:
function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end