-- polo © License | Discord : https://discord.gg/htfpJZN
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
-- polo © License | Discord : https://discord.gg/htfpJZN
local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = exports["es_extended"]:getSharedObject()
-- polo © License | Discord : https://discord.gg/htfpJZN
Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomGardeMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroomgarde', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroomgarde'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomPresidentMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroompresident', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroompresident'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomPremierMinistreMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroompremierministre', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroompremierministre'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomMinistreMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroomministre', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroomministre'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomAssistantMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroomassistant', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroomassistant'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomAssistanteMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('gouvernement_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroomassistante', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroomassistante'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenCloakroomJugeMenuPolo()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = _U('bullet_wear'), value = 'bullet_wear' }
	}

	if grade == 'assistant' then
		table.insert(elements, {label = _U('assistant_wear'), value = 'assistant_wear'})
	elseif grade == 'assistante' then
		table.insert(elements, {label = _U('assistante_wear'), value = 'assistante_wear'})
	elseif grade == 'garde' then
		table.insert(elements, {label = _U('garde_wear'), value = 'garde_wear'})
	elseif grade == 'ministre' then
		table.insert(elements, {label = _U('ministre_wear'), value = 'ministre_wear'})
	elseif grade == 'juge' then
		table.insert(elements, {label = _U('juge_wear'), value = 'juge_wear'})
	elseif grade == 'premierministre' then
		table.insert(elements, {label = _U('premierministre_wear'), value = 'premierministre_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('president_wear'), value = 'president_wear'})
	end

	if Config.EnableNonFreemodePeds then
		--table.insert(elements, {label = 'Sheriff wear', value = 'freemode_ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'})
		--table.insert(elements, {label = 'Police wear', value = 'freemode_ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'})
		--table.insert(elements, {label = 'Tenue SWAT', value = 'freemode_ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroomjuge', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')

						TriggerServerEvent('esx_service:disableService', 'gouvernement')
						TriggerEvent('polo_gouvernementjob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'gouvernement')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'gouvernement')
							TriggerEvent('polo_gouvernementjob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'gouvernement')

				else
					serviceOk = true
				end
			end, 'gouvernement')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if data.current.value == 'premierministre_wear' or
			data.current.value == 'president_wear' or
			data.current.value == 'assistant_wear' or
			data.current.value == 'assistante_wear' or
			data.current.value == 'garde_wear' or
			data.current.value == 'ministre_wear' or
			data.current.value == 'juge_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'civil_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroomjuge'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
	local elements = {
		{label = _U('buy_weapons'), value = 'buy_weapons'}
	}

	if Config.EnableArmoryManagement then
		table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		table.insert(elements, {label = _U('put_weapon'),     value = 'put_weapon'})
		table.insert(elements, {label = _U('remove_object'),  value = 'get_stock'})
		table.insert(elements, {label = _U('deposit_object'), value = 'put_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		elseif data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

function StoreNearbyVehicle(playerCoords)
	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

	if #vehicles > 0 then
		for k,v in ipairs(vehicles) do

			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
				table.insert(vehiclePlates, {
					vehicle = v,
					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
				})
			end
		end
	else
		ESX.ShowNotification(_U('garage_store_nearby'))
		return
	end

	ESX.TriggerServerCallback('polo_gouvernementjob:storeNearbyVehicle', function(storeSuccess, foundNum)
		if storeSuccess then
			local vehicleId = vehiclePlates[foundNum]
			local attempts = 0
			ESX.Game.DeleteVehicle(vehicleId.vehicle)
			IsBusy = true

			Citizen.CreateThread(function()
				while IsBusy do
					Citizen.Wait(0)
					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
				end
			end)

			-- Workaround for vehicle not deleting when other players are near it.
			while DoesEntityExist(vehicleId.vehicle) do
				Citizen.Wait(500)
				attempts = attempts + 1

				-- Give up
				if attempts > 30 then
					break
				end

				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
				if #vehicles > 0 then
					for k,v in ipairs(vehicles) do
						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
							ESX.Game.DeleteVehicle(v)
							break
						end
					end
				end
			end

			IsBusy = false
			ESX.ShowNotification(_U('garage_has_stored'))
		else
			ESX.ShowNotification(_U('garage_has_notstored'))
		end
	end, vehiclePlates)
end

function GetAvailableVehicleSpawnPoint(station, part, partNum)
	local spawnPoints = Config.GouvernementStations[station][part][partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenShopMenu(elements, restoreCoords, shopCoords)
	local playerPed = PlayerPedId()
	isInShopMenu = true

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		css      = 'gouvernement',
		title    = _U('vehicleshop_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
			align    = 'top-left',
			elements = {
				{label = _U('confirm_no'), value = 'no'},
				{label = _U('confirm_yes'), value = 'yes'}
		}}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
				local vehicle  = GetVehiclePedIsIn(playerPed, false)
				local props    = ESX.Game.GetVehicleProperties(vehicle)
				props.plate    = newPlate

				ESX.TriggerServerCallback('polo_gouvernementjob:buyJobVehicle', function (bought)
					if bought then
						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

						isInShopMenu = false
						ESX.UI.Menu.CloseAll()
						DeleteSpawnedVehicles()
						FreezeEntityPosition(playerPed, false)
						SetEntityVisible(playerPed, true)

						ESX.Game.Teleport(playerPed, restoreCoords)
					else
						ESX.ShowNotification(_U('vehicleshop_money'))
						menu2.close()
					end
				end, props, data.current.type)
			else
				menu2.close()
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		isInShopMenu = false
		ESX.UI.Menu.CloseAll()

		DeleteSpawnedVehicles()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)

		ESX.Game.Teleport(playerPed, restoreCoords)
	end, function(data, menu)
		DeleteSpawnedVehicles()

		WaitForVehicleToLoad(data.current.model)
		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
			table.insert(spawnedVehicles, vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)

			if data.current.livery then
				SetVehicleModKit(vehicle, 0)
				SetVehicleLivery(vehicle, data.current.livery)
			end
		end)
	end)

	WaitForVehicleToLoad(elements[1].model)
	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
		table.insert(spawnedVehicles, vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)

		if elements[1].livery then
			SetVehicleModKit(vehicle, 0)
			SetVehicleLivery(vehicle,elements[1].livery)
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

function DeleteSpawnedVehicles()
	while #spawnedVehicles > 0 do
		local vehicle = spawnedVehicles[1]
		ESX.Game.DeleteVehicle(vehicle)
		table.remove(spawnedVehicles, 1)
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
		end
	end
end

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

function OpenGouvernementActionsMenuGarde()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gouvernement_actions', {
		css      = 'gouvernement',
		title    = 'Gouvernement',
		align    = 'top-left',
		elements = {
			{label = '<span style="color:orange;">👨‍✈️ Agent Status <span style="color:blue;"> >', value = 'status'},
			{label = '<span style="color:#0BF4B8;"> 🙎 Citizen Interaction.<span style="color:blue;"> >', value = 'citizen_interaction'},
			{label = '<span style="color:#F4C60B;"> 🚗 Vehicle interaction<span style="color:blue;"> >', value = 'vehicle_interaction'},
			{label = '<span style="color:red;">💬 Swat / Police Emergency Chat <span style="color:blue;"> >', value = 'chaturgence'},
			{label = '<span style="color:pink;">👨‍✈️  Escort menu <span style="color:blue;"> >', value = 'securitymenu'},
			{label = '<span style="color:#0BF427;"> 📦 Place objects<span style="color:blue;"> >', value = 'object_spawner'}
	}}, function(data, menu)
		
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = 'ID card', value = 'identity_card'},
				{label = 'search', value = 'body_search'},
				{label = 'handcuff / unmount', value = 'handcuff'},
				{label = 'Escort', value = 'drag'},
				{label = 'Put in Vehicle', value = 'put_in_vehicle'},
				{label = 'Out the Vehicle', value = 'out_the_vehicle'},
                {label = 'Fine (Choice of amount)', value = 'billing'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('handcuff2'))
						TriggerServerEvent('polo_gouvernementjob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('polo_gouvernementjob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'billing' then
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'billing',
							{
								title = _U('invoice_amount')
							},
								function(data, menu)
									local amount = tonumber(data.value)
										if amount == nil then
											ESX.ShowNotification(_U('amount_invalid'))
										else
											menu.close()
											local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
												if closestPlayer == -1 or closestDistance > 3.0 then
													ESX.ShowNotification(_U('no_players_nearby'))
												else
													TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_gouvernor', _U('gouvernement'), amount)
												end
										end
								end,
							function(data, menu)
								menu.close()
							end
						)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'), value = 'impound'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				css      = 'gouvernement',
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
						-- is the script busy?
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
					{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if data2.current.model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'chaturgence' then
			local elements  = {}
			local playerPed = PlayerPedId()

			local elements = {
				{label = '<span style="color:gold;">--------- 👨‍✈️ President 👩‍✈️ ---------<span style="color:red;">', value = 'text'},
				{label = '<span style="color:green;">💭 Yellow Alert <span style="color:red;">', value = 'chat1'},
                {label = '<span style="color:red;">💭 Red Alert<span style="color:red;">', value = 'chat2'},
                {label = '<span style="color:black;">💭 Black Alert <span style="color:red;">', value = 'chat3'},
                {label = '<span style="color:gold;">-------- 👨‍✈️ Prime Minister 👩‍✈️ --------<span style="color:red;">', value = 'text'},
                {label = '<span style="color:green;">💭 Yellow Alert <span style="color:red;">', value = 'chat4'},
                {label = '<span style="color:red;">💭 Red Alert <span style="color:red;">', value = 'chat5'},
                {label = '<span style="color:black;">💭 Black Alert <span style="color:red;">', value = 'chat6'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'status_service', {
				title    = 'Status Service',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				local name = GetPlayerName(PlayerId())

				if action == 'chat1' then
					local info = 'chat1'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				elseif action == 'chat2' then
					local info = 'chat2'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				elseif action == 'chat3' then
					local info = 'chat3'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				elseif action == 'chat4' then
					local info = 'chat4'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				elseif action == 'chat5' then
					local info = 'chat5'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				elseif action == 'chat6' then
					local info = 'chat6'
					TriggerServerEvent('gouvernement:ChatEntreSwatPoliceGouv', info)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
        elseif data.current.value == 'securitymenu' then 
      local elements  = {}

      local elements = {
        {label = '<span style="color:green;"> | Security agent (1)<span style="color:green;"> |', value = 'spawn'}, 
        {label = '<span style="color:green;"> | Safety motorcycle (1)<span style="color:green;"> |', value = 'spawn2'},  
    	{label = '<span style="color:green;"> | Intervention team (1)<span style="color:green;"> |', value = 'spawn3'},
    	{label = '<span style="color:green;"> | Helicopter Safety (1)<span style="color:green;"> |', value = 'spawn5'},
        {label = '<span style="color:green;"> | 🔫 Give weapons<span style="color:green;"> |', value = 'giveweapons'},
        {label = '<span style="color:green;"> | 🗡️ Attack the closest player<span style="color:green;"> |', value = 'playerattack'}, 
        {label = '<span style="color:green;"> | 🚗 Get into the vehicle<span style="color:green;"> |', value = 'goincar'},   
        {label = '<span style="color:green;"> | 🚗 Get out of the vehicle<span style="color:green;"> |', value = 'leavecar'},
        {label = '<span style="color:green;"> | 🔊  Follow me<span style="color:green;"> |', value = 'follow'},
        {label = '<span style="color:green;"> | 🗑️ Remove<span style="color:green;"> |', value = 'delete'},
      }
      
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'securitymenu', {
        css      = 'gouvernement',
        title    = '🚔 Menu Sécurité 🚔',
        align    = 'top-left',
        elements = elements
      }, function(data2, menu2)

        local action = data2.current.value

        if action == 'spawn' then
          SpawnVehicle1()
          SpawnVehicle6()
          SpawnVehicle7()
          SpawnVehicle8()
        elseif action == 'spawn2' then
          SpawnVehicle2() 
        elseif action == 'spawn3' then
          SpawnVehicle3()
          SpawnVehicle9()
          SpawnVehicle10()
          SpawnVehicle11()
          SpawnVehicle12()
          SpawnVehicle13()
          SpawnVehicle15()  
        elseif action == 'spawn5' then
          SpawnVehicle5()
        elseif action  == 'giveweapons' then
          GiveWeaponToPed(chasePed, config.weapon1, 250, false, true)
          GiveWeaponToPed(chasePed2, config.weapon2, 250, false, true)
          GiveWeaponToPed(chasePed3, config.weapon3, 250, false, true)
          GiveWeaponToPed(chasePed6, config.weapon6, 250, false, true)
          GiveWeaponToPed(chasePed7, config.weapon7, 250, false, true)
          GiveWeaponToPed(chasePed8, config.weapon8, 250, false, true)
          GiveWeaponToPed(chasePed9, config.weapon9, 250, false, true)
          GiveWeaponToPed(chasePed10, config.weapon10, 250, false, true)
          GiveWeaponToPed(chasePed11, config.weapon11, 250, false, true)
          GiveWeaponToPed(chasePed12, config.weapon12, 250, false, true)
          GiveWeaponToPed(chasePed13, config.weapon13, 250, false, true)
          GiveWeaponToPed(chasePed14, config.weapon14, 250, false, true)
          GiveWeaponToPed(chasePed15, config.weapon15, 250, false, true)
        elseif action == 'playerattack' then
          closestPlayer = ESX.Game.GetClosestPlayer()
          target = GetPlayerPed(closestPlayer)
          TaskShootAtEntity(chasePed, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed, target, 0, 16)
          SetEntityAsMissionEntity(chasePed, true, true)
          SetPedHearingRange(chasePed, 15.0)
          SetPedSeeingRange(chasePed, 15.0)
          SetPedAlertness(chasePed, 15.0)
          SetPedFleeAttributes(chasePed, 0, 0)
          SetPedCombatAttributes(chasePed, 46, true)
          SetPedFleeAttributes(chasePed, 0, 0)
          TaskShootAtEntity(chasePed2, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed2, target, 0, 16)
          SetEntityAsMissionEntity(chasePed2, true, true)
          SetPedHearingRange(chasePed2, 15.0)
          SetPedSeeingRange(chasePed2, 15.0)
          SetPedAlertness(chasePed2, 15.0)
          SetPedFleeAttributes(chasePed2, 0, 0)
          SetPedCombatAttributes(chasePed2, 46, true)
          SetPedFleeAttributes(chasePed2, 0, 0) 
          TaskShootAtEntity(chasePed3, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed3, target, 0, 16)
          SetEntityAsMissionEntity(chasePed3, true, true)
          SetPedHearingRange(chasePed3, 15.0)
          SetPedSeeingRange(chasePed3, 15.0)
          SetPedAlertness(chasePed3, 15.0)
          SetPedFleeAttributes(chasePed3, 0, 0)
          TaskShootAtEntity(chasePed6, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed6, target, 0, 16)
          SetEntityAsMissionEntity(chasePed6, true, true)
          SetPedHearingRange(chasePed6, 15.0)
          SetPedSeeingRange(chasePed6, 15.0)
          SetPedAlertness(chasePed6, 15.0)
          SetPedFleeAttributes(chasePed6, 0, 0)
          TaskShootAtEntity(chasePed7, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed7, target, 0, 16)
          SetEntityAsMissionEntity(chasePed7, true, true)
          SetPedHearingRange(chasePed7, 15.0)
          SetPedSeeingRange(chasePed7, 15.0)
          SetPedAlertness(chasePed7, 15.0)
          SetPedFleeAttributes(chasePed7, 0, 0)
          TaskShootAtEntity(chasePed8, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed8, target, 0, 16)
          SetEntityAsMissionEntity(chasePed8, true, true)
          SetPedHearingRange(chasePed8, 15.0)
          SetPedSeeingRange(chasePed8, 15.0)
          SetPedAlertness(chasePed8, 15.0)
          SetPedFleeAttributes(chasePed8, 0, 0)
          TaskShootAtEntity(chasePed9, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed9, target, 0, 16)
          SetEntityAsMissionEntity(chasePed9, true, true)
          SetPedHearingRange(chasePed9, 15.0)
          SetPedSeeingRange(chasePed9, 15.0)
          SetPedAlertness(chasePed9, 15.0)
          SetPedFleeAttributes(chasePed9, 0, 0)
          TaskShootAtEntity(chasePed10, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed10, target, 0, 16)
          SetEntityAsMissionEntity(chasePed10, true, true)
          SetPedHearingRange(chasePed10, 15.0)
          SetPedSeeingRange(chasePed10, 15.0)
          SetPedAlertness(chasePed10, 15.0)
          SetPedFleeAttributes(chasePed10, 0, 0)
          TaskShootAtEntity(chasePed11, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed11, target, 0, 16)
          SetEntityAsMissionEntity(chasePed11, true, true)
          SetPedHearingRange(chasePed11, 15.0)
          SetPedSeeingRange(chasePed11, 15.0)
          SetPedAlertness(chasePed11, 15.0)
          SetPedFleeAttributes(chasePed11, 0, 0)
          TaskShootAtEntity(chasePed12, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed12, target, 0, 16)
          SetEntityAsMissionEntity(chasePed12, true, true)
          SetPedHearingRange(chasePed12, 15.0)
          SetPedSeeingRange(chasePed12, 15.0)
          SetPedAlertness(chasePed12, 15.0)
          SetPedFleeAttributes(chasePed12, 0, 0)
          TaskShootAtEntity(chasePed13, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed13, target, 0, 16)
          SetEntityAsMissionEntity(chasePed13, true, true)
          SetPedHearingRange(chasePed13, 15.0)
          SetPedSeeingRange(chasePed13, 15.0)
          SetPedAlertness(chasePed13, 15.0)
          SetPedFleeAttributes(chasePed13, 0, 0)
          TaskShootAtEntity(chasePed14, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed14, target, 0, 16)
          SetEntityAsMissionEntity(chasePed14, true, true)
          SetPedHearingRange(chasePed14, 15.0)
          SetPedSeeingRange(chasePed14, 15.0)
          SetPedAlertness(chasePed14, 15.0)
          SetPedFleeAttributes(chasePed14, 0, 0)
          TaskShootAtEntity(chasePed15, target, 60, 0xD6FF6D61);
          TaskCombatPed(chasePed15, target, 0, 16)
          SetEntityAsMissionEntity(chasePed15, true, true)
          SetPedHearingRange(chasePed15, 15.0)
          SetPedSeeingRange(chasePed15, 15.0)
          SetPedAlertness(chasePed15, 15.0)
          SetPedFleeAttributes(chasePed15, 0, 0)
       	elseif action  == 'leavecar' then
          TaskLeaveVehicle(chasePed6, chaseVehicle, -1)
          TaskLeaveVehicle(chasePed7, chaseVehicle, -1)
          TaskLeaveVehicle(chasePed8, chaseVehicle, -1)
          TaskLeaveVehicle(chasePed9, chaseVehicle3, -1)
          TaskLeaveVehicle(chasePed10, chaseVehicle3, -1)
          TaskLeaveVehicle(chasePed11, chaseVehicle3, -1)
          TaskLeaveVehicle(chasePed12, chaseVehicle3, -1)
          TaskLeaveVehicle(chasePed13, chaseVehicle3, -1)
          TaskLeaveVehicle(chasePed15, chaseVehicle3, -1)
       	elseif action  == 'goincar' then
          TaskWarpPedIntoVehicle(chasePed6, chaseVehicle, 0)
          TaskWarpPedIntoVehicle(chasePed7, chaseVehicle, 1)
          TaskWarpPedIntoVehicle(chasePed8, chaseVehicle, 2)
          TaskWarpPedIntoVehicle(chasePed9, chaseVehicle3, 3)
          TaskWarpPedIntoVehicle(chasePed10, chaseVehicle3, 4)
          TaskWarpPedIntoVehicle(chasePed11, chaseVehicle3, 5)
          TaskWarpPedIntoVehicle(chasePed12, chaseVehicle3, 1)
          TaskWarpPedIntoVehicle(chasePed13, chaseVehicle3, 0)
          TaskWarpPedIntoVehicle(chasePed15, chaseVehicle3, 2)
        elseif action  == 'fix' then
          SetVehicleFixed(chaseVehicle)
          SetVehicleFixed(chaseVehicle2)
          SetVehicleUndriveable(chaseVehicle, false)
          SetVehicleUndriveable(chaseVehicle2, false)
        elseif action ==  'delete' then
          DeleteVehicle(chaseVehicle)
          DeletePed(chasePed)
          DeleteVehicle(chaseVehicle2)
          DeletePed(chasePed2)
          DeleteVehicle(chaseVehicle3)
          DeletePed(chasePed3)
          DeleteVehicle(chaseVehicle5)
          DeletePed(chasePed5)
          DeletePed(chasePed6)
          DeletePed(chasePed7)
          DeletePed(chasePed8)
          DeletePed(chasePed9)
          DeletePed(chasePed10)
          DeletePed(chasePed11)
          DeletePed(chasePed12)
          DeletePed(chasePed13)
          DeletePed(chasePed14)
          DeletePed(chasePed15)
        elseif action ==  'follow' then
          local playerPed = PlayerPedId()
          TaskVehicleFollow(chasePed, chaseVehicle, playerPed, 50.0, 1, 5)
          TaskVehicleFollow(chasePed2, chaseVehicle2, playerPed, 50.0, 1, 5)
          TaskVehicleFollow(chasePed3, chaseVehicle3, playerPed, 50.0, 1, 5)
          TaskVehicleFollow(chasePed5, chaseVehicle5, playerPed, 50.0, 1, 5)
          PlayAmbientSpeech1(chasePed, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
          PlayAmbientSpeech1(chasePed2, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
          PlayAmbientSpeech1(chasePed3, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
          PlayAmbientSpeech1(chasePed5, "Chat_Resp", "SPEECH_PARAMS_FORCE", 1)
        elseif action ==  'exit' then
          menu.close()
       end
	end, function(data, menu)
		menu.close()
	end)
		elseif data.current.value == 'status' then
			local elements  = {}

			local elements = {
				{label = '<span style="color:green;">Socket<span style="color:white;"> on duty', value = 'prise'},
				{label = '<span style="color:red;">End<span style="color:white;"> on duty', value = 'fin'},
				{label = '<span style="color:orange;">Pause<span style="color:white;"> on duty', value = 'pause'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'status_service', {
				title    = 'Status Service',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'prise' then
					local info = 'prise'
					TriggerServerEvent('gouvernement:InfoService', info)
				elseif action == 'fin' then
					local info = 'fin'
					TriggerServerEvent('gouvernement:InfoService', info)
				elseif action == 'pause' then
					local info = 'pause'
					TriggerServerEvent('gouvernement:InfoService', info)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGouvernementActionsMenuPresident()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gouvernement_actions', {
		css      = 'gouvernement',
		title    = 'Gouvernement',
		align    = 'top-left',
		elements = {
			{label = '<span style="color:#0BF4B8;"> 🙎 Citizen Interaction.<span style="color:blue;"> >', value = 'citizen_interaction'},
			{label = '<span style="color:red;">💬 Chat President<span style="color:blue;"> >', value = 'chatentreprise'},
			{label = '<span style="color:#0BF427;"> 📦 Place objects<span style="color:blue;"> >', value = 'object_spawner'}
	}}, function(data, menu)
		
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = 'ID card', value = 'identity_card'},
				{label = 'search', value = 'body_search'},
				{label = 'handcuff / unmount', value = 'handcuff'},
				{label = 'Escort', value = 'drag'},
				{label = 'Put in Vehicle', value = 'put_in_vehicle'},
				{label = 'Out the Vehicle', value = 'out_the_vehicle'},
                {label = 'Fine (Choice of amount)', value = 'billing'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('handcuff2'))
						TriggerServerEvent('polo_gouvernementjob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('polo_gouvernementjob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'billing' then
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'billing',
							{
								title = _U('invoice_amount')
							},
								function(data, menu)
									local amount = tonumber(data.value)
										if amount == nil then
											ESX.ShowNotification(_U('amount_invalid'))
										else
											menu.close()
											local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
												if closestPlayer == -1 or closestDistance > 3.0 then
													ESX.ShowNotification(_U('no_players_nearby'))
												else
													TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_gouvernor', _U('gouvernement'), amount)
												end
										end
								end,
							function(data, menu)
								menu.close()
							end
						)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
					{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if data2.current.model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'chatentreprise' then
			local elements  = {}
			local playerPed = PlayerPedId()

			local elements = {
				{label = '<span style="color:gold;">--------- 👨‍✈️ President 👩‍✈️ ---------<span style="color:red;">', value = 'text'},
				{label = '<span style="color:green;">💭 End of Month Tax<span style="color:red;">', value = 'chat1'},
				{label = '<span style="color:green;">💭 Business Boss Meeting<span style="color:red;">', value = 'chat2'},
                {label = '<span style="color:red;">💭 Covid-19 announcement<span style="color:red;">', value = 'chat3'},
                {label = '<span style="color:red;">💭 President Election Announcement<span style="color:red;">', value = 'chat4'},
                {label = '<span style="color:red;">💭 President Election Announcement<span style="color:red;">', value = 'chat5'},
                {label = '<span style="color:blue;">💭 Law enforcement meeting<span style="color:red;">', value = 'chat6'},
                {label = '<span style="color:blue;">💭 Government Meeting<span style="color:red;">', value = 'chat7'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'status_service', {
				title    = 'Status Service',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				local name = GetPlayerName(PlayerId())

				if action == 'chat1' then
					local info = 'chat1'
					TriggerServerEvent('gouvernement:ChatEntreprise', info)
				elseif action == 'chat2' then
					local info = 'chat2'
					TriggerServerEvent('gouvernement:ChatEntreprise', info)
				elseif action == 'chat3' then
					local info = 'chat3'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				elseif action == 'chat4' then
					local info = 'chat4'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				elseif action == 'chat5' then
					local info = 'chat5'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				elseif action == 'chat6' then
					local info = 'chat6'
					TriggerServerEvent('gouvernement:ChatForceDeLordre', info)
				elseif action == 'chat7' then
					local info = 'chat7'
					TriggerServerEvent('gouvernement:ChatGouvernementale', info)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGouvernementActionsMenuPremierMinistre()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gouvernement_actions', {
		css      = 'gouvernement',
		title    = 'Gouvernement',
		align    = 'top-left',
		elements = {
			{label = '<span style="color:#0BF4B8;"> 🙎 Citizen Interaction<span style="color:blue;"> >', value = 'citizen_interaction'},
			{label = '<span style="color:red;">💬 Chat Prime Minister<span style="color:blue;"> >', value = 'chatpremierministre'},
			{label = '<span style="color:#0BF427;"> 📦 Place objects<span style="color:blue;"> >', value = 'object_spawner'}
	}}, function(data, menu)
		
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = 'ID card', value = 'identity_card'},
				{label = 'search', value = 'body_search'},
				{label = 'handcuff / unmount', value = 'handcuff'},
				{label = 'Escort', value = 'drag'},
				{label = 'Put in Vehicle', value = 'put_in_vehicle'},
				{label = 'Out the Vehicle', value = 'out_the_vehicle'},
                {label = 'Fine (Choice of amount)', value = 'billing'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('handcuff2'))
						TriggerServerEvent('polo_gouvernementjob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('polo_gouvernementjob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'billing' then
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'billing',
							{
								title = _U('invoice_amount')
							},
								function(data, menu)
									local amount = tonumber(data.value)
										if amount == nil then
											ESX.ShowNotification(_U('amount_invalid'))
										else
											menu.close()
											local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
												if closestPlayer == -1 or closestDistance > 3.0 then
													ESX.ShowNotification(_U('no_players_nearby'))
												else
													TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_gouvernor', _U('gouvernement'), amount)
												end
										end
								end,
							function(data, menu)
								menu.close()
							end
						)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
					{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if data2.current.model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'chatpremierministre' then
			local elements  = {}
			local playerPed = PlayerPedId()

			local elements = {
				{label = '<span style="color:gold;">-------- 👨‍✈️ Prime Minister 👩‍✈️ --------<span style="color:red;">', value = 'text'},
				{label = '<span style="color:yellow;">💭 Yellow Alert<span style="color:red;">', value = 'chat9'},
                {label = '<span style="color:red;">💭 Red Alert<span style="color:red;">', value = 'chat10'},
                {label = '<span style="color:black;">💭 Black Alert<span style="color:red;">', value = 'chat11'},
                {label = '<span style="color:green;">💭 Military meeting<span style="color:red;">', value = 'chat12'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'status_service', {
				title    = 'Status Service',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				local name = GetPlayerName(PlayerId())

				if action == 'chat9' then
					local info = 'chat9'
					TriggerServerEvent('gouvernement:ChatEntreprise', info)
				elseif action == 'chat10' then
					local info = 'chat10'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				elseif action == 'chat11' then
					local info = 'chat11'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				elseif action == 'chat12' then
					local info = 'chat12'
					TriggerServerEvent('gouvernement:ChatPopulation', info)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGouvernementActionsMenuGouvernement()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gouvernement_actions', {
		css      = 'gouvernement',
		title    = 'Gouvernement',
		align    = 'top-left',
		elements = {
			{label = '<span style="color:#0BF4B8;"> 🙎 Citizen Interaction<span style="color:blue;"> >', value = 'citizen_interaction'},
			{label = '<span style="color:#0BF427;"> 📦 Place objects<span style="color:blue;"> >', value = 'object_spawner'}
	}}, function(data, menu)
		
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = 'ID card', value = 'identity_card'},
				{label = 'search', value = 'body_search'},
				{label = 'handcuff / unmount', value = 'handcuff'},
				{label = 'Escort', value = 'drag'},
				{label = 'Put in Vehicle', value = 'put_in_vehicle'},
				{label = 'Out the Vehicle', value = 'out_the_vehicle'},
                {label = 'Fine (Choice of amount)', value = 'billing'}	
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'handcuff' then
						TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(closestPlayer), _U('handcuff2'))
						TriggerServerEvent('polo_gouvernementjob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('polo_gouvernementjob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('polo_gouvernementjob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'billing' then
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'billing',
							{
								title = _U('invoice_amount')
							},
								function(data, menu)
									local amount = tonumber(data.value)
										if amount == nil then
											ESX.ShowNotification(_U('amount_invalid'))
										else
											menu.close()
											local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
												if closestPlayer == -1 or closestDistance > 3.0 then
													ESX.ShowNotification(_U('no_players_nearby'))
												else
													TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_gouvernor', _U('gouvernement'), amount)
												end
										end
								end,
							function(data, menu)
								menu.close()
							end
						)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'gouvernement',
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
					{label = _U('cash'), model = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if data2.current.model == 'prop_roadcone02a' then
					z = z - 2.0
				end

				ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('polo_gouvernementjob:getOtherPlayerData', function(data)
		local elements = {}
		local nameLabel = _U('name', data.name)
		local jobLabel, sexLabel, dobLabel, heightLabel, idLabel

		if data.job.grade_label and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config.EnableESXIdentity then
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
		end

		local elements = {
			{label = nameLabel},
			{label = jobLabel}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel})
			table.insert(elements, {label = dobLabel})
			table.insert(elements, {label = heightLabel})
			table.insert(elements, {label = idLabel})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('polo_gouvernementjob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = _U('guns_label')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('polo_gouvernementjob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = _U('traffic_offense'), value = 0},
			{label = _U('minor_offense'),   value = 1},
			{label = _U('average_offense'), value = 2},
			{label = _U('major_offense'),   value = 3}
	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('polo_gouvernementjob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_gouvernor', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('polo_gouvernementjob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('polo_gouvernementjob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end

		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('polo_gouvernementjob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('polo_gouvernementjob:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('polo_gouvernementjob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('polo_gouvernementjob:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('polo_gouvernementjob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.AuthorizedWeapons[PlayerData.job.grade_name]) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then
					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('polo_gouvernementjob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'top-left',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('polo_gouvernementjob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('polo_gouvernementjob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('gouvernement_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('polo_gouvernementjob:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('polo_gouvernementjob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('polo_gouvernementjob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('gouvernement:InfoServiceGarde')
AddEventHandler('gouvernement:InfoServiceGarde', function(service, nom)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Gouvernement INFORMATIONS', '~b~Service plug', '~y~Agent name: ~g~'..nom..'\n~y~Information: ~g~Service plug.', 'CHAR_MULTIPLAYER', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Gouvernement INFORMATIONS', '~b~End of service', '~y~Agent name: ~g~'..nom..'\n~y~Information: ~g~End of service.', 'CHAR_MULTIPLAYER', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('Gouvernement INFORMATIONS', '~b~Break in service', '~y~Agent name: ~g~'..nom..'\n~y~Information: ~g~Break in service.', 'CHAR_MULTIPLAYER', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

RegisterNetEvent('gouvernement:InfoChatGouv')
AddEventHandler('gouvernement:InfoChatGouv', function(service, nom, streetName)
	if service == 'chat1' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Special Force Cat', '~y~Yellow Alert', '~y~The President is on the move.\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat2' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Special Force Cat', '~r~Red alert', '~r~The President comes under fire!\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat3' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Special Force Cat', '~v~Black Alert', '~r~The President is removed!\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat4' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Special Force Cat', '~y~Yellow Alert', '~y~The Prime Minister is on the move.\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)		
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat5' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Chat Force Spécial', '~r~Red alert', '~r~The Prime Minister comes under fire!\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat6' then
    local pos = GetEntityCoords(PlayerPedId())
    local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    streetName = GetStreetNameFromHashKey(streetName)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~r~Chat Force Spécial', '~v~Black Alert', '~r~The Prime Minister is kidnapped!\n~v~Position: ~r~'..streetName..'', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	end
end)

RegisterNetEvent('gouvernement:InfoChatGouvernement')
AddEventHandler('gouvernement:InfoChatGouvernement', function(service, nom)
	if service == 'chat1' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~y~Hello Dear Business Owner, dont forget the 15% tax at the end of the month.', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat2' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~g~Hello Dear Business Owner Meeting on November 5th to take stock of your business.', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat3' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~r~Hello, We remind you to respect the barrier gestures for the safety of all.', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat4' then
	local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~y~Hello Dear Citizens, The presidential elections will take place on January 3rd.', 'CHAR_MP_FM_CONTACT', 8)		
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat5' then
	local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~y~Hello Dear Citizens, dont forget the mayoral elections on February 14, 2021.', 'CHAR_MP_FM_CONTACT', 8)	
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'chat6' then
	local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~r~Hello Agent, Meeting on December 10 in relation to the means you have available.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	elseif service == 'chat7' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~President of the Republic', '~r~Hello Dear Member of the Government, I am meeting you on December 16 about our city.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	elseif service == 'chat9' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~Prime Minister', '~y~We go to Yellow Alert. Your turn to General.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	elseif service == 'chat10' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~Prime Minister', '~r~We go to Red Alert. It your turn to play General.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	elseif service == 'chat11' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~Prime Minister', '~v~We go to Black Alert. Your turn to General.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	elseif service == 'chat12' then
    local pos = GetEntityCoords(PlayerPedId())
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('~b~Government', '~g~Prime Minister', '~g~Military meeting in 1 hour for high ranking officers at the Military Base.', 'CHAR_MP_FM_CONTACT', 8)
		Wait(1000)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('polo_gouvernementjob:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_gouvernement'),
		number     = 'gouvernement',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('polo_gouvernementjob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomPresident' then
		CurrentAction     = 'menu_cloakroompresident'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomPremierMinistre' then
		CurrentAction     = 'menu_cloakroompremierministre'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomMinistre' then
		CurrentAction     = 'menu_cloakroomministre'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomAssistant' then
		CurrentAction     = 'menu_cloakroomassistant'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomAssistante' then
		CurrentAction     = 'menu_cloakroomassistante'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomJuge' then
		CurrentAction     = 'menu_cloakroomjuge'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'CloakroomGarde' then
		CurrentAction     = 'menu_cloakroomgarde'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('polo_gouvernementjob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('polo_gouvernementjob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job and PlayerData.job.name == 'gouvernement' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('polo_gouvernementjob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('polo_gouvernementjob:handcuff')
AddEventHandler('polo_gouvernementjob:handcuff', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then
				if handcuffTimer.active then
					ESX.ClearTimeout(handcuffTimer.task)
				end

				StartHandcuffTimer()
			end
		else
			if Config.EnableHandcuffTimer and handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('polo_gouvernementjob:unrestrain')
AddEventHandler('polo_gouvernementjob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('polo_gouvernementjob:drag')
AddEventHandler('polo_gouvernementjob:drag', function(copId)
	if not IsHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('polo_gouvernementjob:putInVehicle')
AddEventHandler('polo_gouvernementjob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('polo_gouvernementjob:OutVehicle')
AddEventHandler('polo_gouvernementjob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.GouvernementStations) do
		if v.Blip then
			local blip = AddBlipForCoord(v.Blip.Coords)

			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, v.Blip.Display)
			SetBlipScale  (blip, v.Blip.Scale)
			SetBlipColour (blip, v.Blip.Colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('map_blip'))
			EndTextCommandSetBlipName(blip)
		else
			print("Blip field not defined for station:", k)
		end
	end
end)


-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job and PlayerData.job.name == 'gouvernement' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.GouvernementStations) do

				for i=1, #v.Armories, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

					if distance < Config.DrawDistance then
						--DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'boss' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsPresident, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsPresident[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsPresident[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomPresident', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'premierministre' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsPremierMinistre, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsPremierMinistre[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsPremierMinistre[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomPremierMinistre', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'ministre' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsMinistre, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsMinistre[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsMinistre[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomMinistre', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistant' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsAssistant, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsAssistant[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsAssistant[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomAssistant', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistante' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsAssistante, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsAssistante[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsAssistante[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomAssistante', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'juge' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsJuge, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsJuge[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsJuge[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomJuge', i
						end
					end
				end
			end

			if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'garde' then

				for k,v in pairs(Config.GouvernementStations) do

					for i=1, #v.CloakroomsGarde, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.CloakroomsGarde[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(20, v.CloakroomsGarde[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'CloakroomGarde', i
						end
					end
				end
			end

				if Config.EnablePlayerManagement and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('polo_gouvernementjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('polo_gouvernementjob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('polo_gouvernementjob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('polo_gouvernementjob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('polo_gouvernementjob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'boss' then

				if CurrentAction == 'menu_cloakroompresident' then
					OpenCloakroomPresidentMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'premierministre' then

				if CurrentAction == 'menu_cloakroompremierministre' then
					OpenCloakroomPremierMinistreMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'ministre' then

				if CurrentAction == 'menu_cloakroomministre' then
					OpenCloakroomMinistreMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistant' then

				if CurrentAction == 'menu_cloakroomassistant' then
					OpenCloakroomAssistantMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistante' then

				if CurrentAction == 'menu_cloakroomassistante' then
					OpenCloakroomAssistanteMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'juge' then

				if CurrentAction == 'menu_cloakroomjuge' then
					OpenCloakroomJugeMenuPolo()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'garde' then

				if CurrentAction == 'menu_cloakroomgarde' then
					OpenCloakroomGardeMenu()
				end
			end

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'gouvernement' then

				if CurrentAction == 'menu_armory' then
					if Config.MaxInService == -1 then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'gouvernement', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'garde' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGarde()
			elseif playerInService then
				OpenGouvernementActionsMenuGarde()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'boss' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuPresident()
			elseif playerInService then
				OpenGouvernementActionsMenuPresident()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'premierministre' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuPremierMinistre()
			elseif playerInService then
				OpenGouvernementActionsMenuPremierMinistre()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'ministre' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGouvernement()
			elseif playerInService then
				OpenGouvernementActionsMenuGouvernement()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistant' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGouvernement()
			elseif playerInService then
				OpenGouvernementActionsMenuGouvernement()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'juge' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGouvernement()
			elseif playerInService then
				OpenGouvernementActionsMenuGouvernement()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'assistante' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGouvernement()
			elseif playerInService then
				OpenGouvernementActionsMenuGouvernement()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'gouvernement' and PlayerData.job.grade_name == 'juge' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gouvernement_actions') then
			if Config.MaxInService == -1 then
				OpenGouvernementActionsMenuGouvernement()
			elseif playerInService then
				OpenGouvernementActionsMenuGouvernement()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 38) and currentTask.busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(currentTask.task)
			ClearPedTasks(PlayerPedId())

			currentTask.busy = false
		end
	end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_gouvernement:updateBlip')
AddEventHandler('esx_gouvernement:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.MaxInService ~= -1 and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end

	-- Is the player a cop? In that case show all the blips for other cops
	if PlayerData.job and PlayerData.job.name == 'gouvernement' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'gouvernement' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('polo_gouvernementjob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('polo_gouvernementjob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('polo_gouvernementjob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'gouvernement')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'gouvernement')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.handcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('polo_gouvernementjob:unrestrain')
		handcuffTimer.active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	--local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	ESX.Game.DeleteVehicle(vehicle)
	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end



--[[---------------------------------------------------------------------------------
||                                                                                  ||
||                          SPEEDCAMERA SCRIPT - GTA5 - FiveM                       ||
||                                   Author = Shedow                                ||
||                            Created for N3MTV community                           ||
||                                                                                  ||
----------------------------------------------------------------------------------]]--
 
local maxSpeed = 0
-- local minSpeed = 0
local info = ""
local isRadarPlaced = false -- bolean to get radar status
local Radar -- entity object
local RadarBlip -- blip
local RadarPos = {} -- pos
local RadarAng = 0 -- angle
local LastPlate = ""
local LastVehDesc = ""
local LastSpeed = 0
local LastInfo = ""
 
local function GetPlayers2()
    local players = {}
    for i = 0, 59 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end
 
local function GetClosestDrivingPlayerFromPos(radius, pos)
    local players = GetPlayers2()
    local closestDistance = radius or -1
    local closestPlayer = -1
    local closestVeh = -1
    for _ ,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local ped = GetPlayerPed(value)
            if GetVehiclePedIsUsing(ped) ~= 0 then
                local targetCoords = GetEntityCoords(ped, 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], pos["x"], pos["y"], pos["z"], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestVeh = GetVehiclePedIsUsing(ped)
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
    end
    return closestPlayer, closestVeh, closestDistance
end
 
 
function radarSetSpeed(defaultText)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", defaultText or "", "", "", "", 5)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local gettxt = tonumber(GetOnscreenKeyboardResult())
        if gettxt ~= nil then
            return gettxt
        else
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~Please enter a correct number!")
            DrawSubtitleTimed(3000, 1)
            return
        end
    end
    return
end
 
 
local function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
 
function POLICE_radar()
    if isRadarPlaced then -- remove the previous radar if it exists, only one radar per cop
       
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), RadarPos.x, RadarPos.y, RadarPos.z, true) < 0.9 then -- if the player is close to his radar
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(GetPlayerPed(-1), "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
       
            Citizen.Wait(2000) -- prevent spam radar + synchro spawn with animation time
       
            SetEntityAsMissionEntity(Radar, false, false)
           
            DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
            Radar = nil
            RadarPos = {}
            RadarAng = 0
            isRadarPlaced = false
           
            RemoveBlip(RadarBlip)
            RadarBlip = nil
            LastPlate = ""
            LastVehDesc = ""
            LastSpeed = 0
            LastInfo = ""
           
        else
           
            ClearPrints()
            SetTextEntry_2("STRING")
            AddTextComponentString("~r~You are not next to your Radar!")
            DrawSubtitleTimed(3000, 1)
           
            Citizen.Wait(1500) -- prevent spam radar
       
        end
   
    else -- or place a new one
        maxSpeed = radarSetSpeed("50")
       
        Citizen.Wait(200) -- wait if the player was in moving
        RadarPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.5, 0)
        RadarAng = GetEntityRotation(GetPlayerPed(-1))
       
        if maxSpeed ~= nil then -- maxSpeed = nil only if the player hasn't entered a valid number
       
            RequestAnimDict("anim@apt_trans@garage")
            while not HasAnimDictLoaded("anim@apt_trans@garage") do
               Wait(1)
            end
            TaskPlayAnim(GetPlayerPed(-1), "anim@apt_trans@garage", "gar_open_1_left", 1.0, -1.0, 5000, 0, 1, true, true, true) -- animation
           
            Citizen.Wait(1500) -- prevent spam radar placement + synchro spawn with animation time
           
            RequestModel("prop_cctv_pole_01a")
            while not HasModelLoaded("prop_cctv_pole_01a") do
               Wait(1)
            end
           
            Radar = CreateObject(1927491455, RadarPos.x, RadarPos.y, RadarPos.z - 7, true, true, true) -- http://gtan.codeshock.hu/objects/index.php?page=1&search=prop_cctv_pole_01a
            SetEntityRotation(Radar, RadarAng.x, RadarAng.y, RadarAng.z - 115)
            -- SetEntityInvincible(Radar, true) -- doesn't work, radar still destroyable
            -- PlaceObjectOnGroundProperly(Radar) -- useless
            SetEntityAsMissionEntity(Radar, true, true)
           
            FreezeEntityPosition(Radar, true) -- set the radar invincible (yeah, SetEntityInvincible just not works, okay FiveM.)
 
            isRadarPlaced = true
           
            RadarBlip = AddBlipForCoord(RadarPos.x, RadarPos.y, RadarPos.z)
            SetBlipSprite(RadarBlip, 380) -- 184 = cam
            SetBlipColour(RadarBlip, 1) -- https://github.com/Konijima/WikiFive/wiki/Blip-Colors
            SetBlipAsShortRange(RadarBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Radar")
            EndTextCommandSetBlipName(RadarBlip)
       
        end
       
    end
end
 
Citizen.CreateThread(function()
    while true do
        Wait(0)
 
        if isRadarPlaced then
       
            if HasObjectBeenBroken(Radar) then -- check is the radar is still there
               
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
            end
           
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), RadarPos.x, RadarPos.y, RadarPos.z, true) > 100 then -- if the player is too far from his radar
           
                SetEntityAsMissionEntity(Radar, false, false)
                SetEntityVisible(Radar, false)
                DeleteObject(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
                DeleteEntity(Radar) -- remove the radar pole (otherwise it leaves from inside the ground)
               
                Radar = nil
                RadarPos = {}
                RadarAng = 0
                isRadarPlaced = false
               
                RemoveBlip(RadarBlip)
                RadarBlip = nil
               
                LastPlate = ""
                LastVehDesc = ""
                LastSpeed = 0
                LastInfo = ""
               
                ClearPrints()
                SetTextEntry_2("STRING")
                AddTextComponentString("~r~You've gone too far from your Radar!")
                DrawSubtitleTimed(3000, 1)
               
            end
           
        end
       
        if isRadarPlaced then
 
            local viewAngle = GetOffsetFromEntityInWorldCoords(Radar, -8.0, -4.4, 0.0) -- forwarding the camera angle, to increase or reduce the distance, just make a cross product like this one :  ( X * 11.0 ) / 20.0 = Y   gives  (Radar, X, Y, 0.0)
            local ply, veh, dist = GetClosestDrivingPlayerFromPos(20, viewAngle) -- viewAngle
 
            -- local debuginfo = string.format("%s ~n~%s ~n~%s ~n~", ply, veh, dist)
            -- drawTxt(0.27, 0.1, 0.185, 0.206, 0.40, debuginfo, 255, 255, 255, 255)
 
            if veh ~= nil then
           
                local vehPlate = GetVehicleNumberPlateText(veh) or ""
                local vehSpeedKm = GetEntitySpeed(veh)*3.6
                local vehDesc = GetDisplayNameFromVehicleModel(GetEntityModel(veh))--.." "..GetVehicleColor(veh)
                if vehDesc == "CARNOTFOUND" then vehDesc = "" end
               
                -- local vehSpeedMph= GetEntitySpeed(veh)*2.236936
                -- if vehSpeedKm > minSpeed then            
                     
                if vehSpeedKm < maxSpeed then
                    info = string.format("~b~Vehicle  ~w~ %s ~n~~b~Plate     ~w~ %s ~n~~y~Km/h        ~g~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                else
                    info = string.format("~b~Vehicle  ~w~ %s ~n~~b~Plate     ~w~ %s ~n~~y~Km/h        ~r~%s", vehDesc, vehPlate, math.ceil(vehSpeedKm))
                    if LastPlate ~= vehPlate then
                        LastSpeed = vehSpeedKm
                        LastVehDesc = vehDesc
                        LastPlate = vehPlate
                    elseif LastSpeed < vehSpeedKm and LastPlate == vehPlate then
                            LastSpeed = vehSpeedKm
                    end
                    LastInfo = string.format("~b~Vehicle  ~w~ %s ~n~~b~Plate    ~w~ %s ~n~~y~Km/h        ~r~%s", LastVehDesc, LastPlate, math.ceil(LastSpeed))
                end
                   
				DrawRect(0.76, 0, 0.185, 0.38, 204, 204, 204, 210)   
				   
                DrawRect(0.76, 0.0455, 0.18, 0.09, 255, 255, 255, 180)
                drawTxt(0.77, 0.1, 0.185, 0.206, 0.40, info, 255, 255, 255, 255)
               
                DrawRect(0.76, 0.140, 0.18, 0.09, 255, 255, 255, 180)
                drawTxt(0.77, 0.20, 0.185, 0.206, 0.40, LastInfo, 255, 255, 255, 255)
                 
                -- end
               
            end
           
        end
           
    end  
end)

---TELEPORT PRISON

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'gouvernement' or PlayerData.job ~= nil and PlayerData.job.name == 'gouvernement' or PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end


AddEventHandler('gouvernement:teleportMarkers', function(position)
  SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if hintIsShowed == true then
      SetTextComponentFormat("STRING")
      AddTextComponentString(hintToDisplay)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
  end
end)

Config.TeleportZones = {
    { Pos = { x = 100.0, y = 200.0, z = 300.0 }, Size = { x = 10.0, y = 10.0, z = 10.0 }, Teleport = { x = 150.0, y = 250.0, z = 350.0 }, Color = { r = 255, g = 0, b = 0 }, Marker = 1, Hint = "Sample Teleport Zone 1" },
    { Pos = { x = 200.0, y = 300.0, z = 400.0 }, Size = { x = 15.0, y = 15.0, z = 15.0 }, Teleport = { x = 250.0, y = 350.0, z = 450.0 }, Color = { r = 0, g = 255, b = 0 }, Marker = 2, Hint = "Sample Teleport Zone 2" },
    -- Add more sample teleport zones as needed
}

-- Display teleport markers
Citizen.CreateThread(function()
   while true do
     Wait(0)

     --if IsJobTrue() then

         local coords = GetEntityCoords(GetPlayerPed(-1))
         for k,v in pairs(Config.TeleportZones) do
           if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
             DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v. Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
           end
         end

     --end

   end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
	while true do
	  Wait(0)
	  local coords = GetEntityCoords(GetPlayerPed(-1))
	  local position = nil
	  local zone = nil
 
	  --if IsJobTrue() then
 
	  print("Value of Config.TeleportZones:", Config.TeleportZones)
	  print("Value of pairs:", pairs)
	  for k,v in pairs(Config.TeleportZones) do
		if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
		  isInPublicMarker = true
		  position = v. Teleport
		  zone = v
		  break
		else
		  isInPublicMarker = false
		end
	  end
 
	  if IsControlJustReleased(0, Keys["E"]) and isInPublicMarker then
		TriggerEvent('government:teleportMarkers', position)
	  end
 
	  -- hide or show top left zone hints
	  if isInPublicMarker then
		  hintToDisplay = zone.Hint
		  hintIsShown = true
	  else
		  if not isInMarker then
			  hintToDisplay = "no hint to display"
			  hintIsShown = false
		  end
	  end
 
	  --end
 
	end
 end)
 


-----

------------------------ Sécurité Menu -------------------------

function SpawnVehicle1()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey = GetHashKey(config.ped1)
  pedType = GetPedType(hashKey)
  RequestModel(hashKey)
  while not HasModelLoaded(hashKey) do
    RequestModel(hashKey)
    Citizen.Wait(100)
  end
  chasePed = CreatePed(pedType, hashKey, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle1, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle)
    chaseVehicle = callback_vehicle
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle, false)
    SetVehicleEngineOn(chaseVehicle, true, true)
    while not chasePed do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed, chaseVehicle, -1)
    TaskVehicleFollow(chasePed, chaseVehicle, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed, 786468)
    SetVehicleSiren(chaseVehicle, true)
  end)
end
-- polo © License | Discord : https://discord.gg/czW6Jqj

function SpawnVehicle2()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey2 = GetHashKey(config.ped2)
  pedType2 = GetPedType(hashKey)
  RequestModel(hashKey2)
  while not HasModelLoaded(hashKey2) do
    RequestModel(hashKey2)
    Citizen.Wait(100)
  end
  chasePed2 = CreatePed(pedType2, hashKey2, PedPosition.x + 4,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle2, {
    x = PedPosition.x + 15 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle2)
    chaseVehicle2 = callback_vehicle2
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle2, false)
    SetVehicleEngineOn(chaseVehicle2, true, true)
    while not chasePed2 do Citizen.Wait(100) end;
    while not chaseVehicle2 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed2, chaseVehicle2, -1)
    TaskVehicleFollow(chasePed2, chaseVehicle2, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed2, 786468)
    SetVehicleSiren(chaseVehicle2, true)
  end)
end

function SpawnVehicle3()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey3 = GetHashKey(config.ped3)
  pedType3 = GetPedType(hashKey)
  RequestModel(hashKey3)
  while not HasModelLoaded(hashKey3) do
    RequestModel(hashKey3)
    Citizen.Wait(100)
  end
  chasePed3 = CreatePed(pedType3, hashKey3, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle3, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle3)
    chaseVehicle3 = callback_vehicle3
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle3, false)
    SetVehicleEngineOn(chaseVehicle3, true, true)
    while not chasePed3 do Citizen.Wait(100) end;
    while not chaseVehicle3 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed3, chaseVehicle3, -1)
    TaskVehicleFollow(chasePed3, chaseVehicle3, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed3, 786468)
    SetVehicleSiren(chaseVehicle3, true)
  end)
end

function SpawnVehicle5()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey5 = GetHashKey(config.ped5)
  pedType5 = GetPedType(hashKey)
  RequestModel(hashKey5)
  while not HasModelLoaded(hashKey5) do
    RequestModel(hashKey5)
    Citizen.Wait(100)
  end
  chasePed5 = CreatePed(pedType5, hashKey5, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle5, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle5)
    chaseVehicle5 = callback_vehicle5
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle5, false)
    SetVehicleEngineOn(chaseVehicle5, true, true)
    while not chasePed5 do Citizen.Wait(100) end;
    while not chaseVehicle5 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed5, chaseVehicle5, -1)
    TaskVehicleFollow(chasePed5, chaseVehicle5, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed5, 786468)
    SetVehicleSiren(chaseVehicle5, true)
  end)
end

function SpawnVehicle6()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey6 = GetHashKey(config.ped6)
  pedType6 = GetPedType(hashKey)
  RequestModel(hashKey6)
  while not HasModelLoaded(hashKey6) do
    RequestModel(hashKey6)
    Citizen.Wait(100)
  end
  chasePed6 = CreatePed(pedType6, hashKey6, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle6, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle6)
    chaseVehicle6 = callback_vehicle6
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle6, false)
    SetVehicleEngineOn(chaseVehicle6, true, true)
    while not chasePed6 do Citizen.Wait(100) end;
    while not chaseVehicle6 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed6, chaseVehicle6, -1)
    TaskVehicleFollow(chasePed6, chaseVehicle6, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed6, 786468)
    SetVehicleSiren(chaseVehicle6, true)
  end)
end

function SpawnVehicle7()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey7 = GetHashKey(config.ped7)
  pedType7 = GetPedType(hashKey)
  RequestModel(hashKey7)
  while not HasModelLoaded(hashKey7) do
    RequestModel(hashKey7)
    Citizen.Wait(100)
  end
  chasePed7 = CreatePed(pedType7, hashKey7, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle7, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle7)
    chaseVehicle7 = callback_vehicle7
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle7, false)
    SetVehicleEngineOn(chaseVehicle7, true, true)
    while not chasePed7 do Citizen.Wait(100) end;
    while not chaseVehicle7 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed7, chaseVehicle7, -1)
    TaskVehicleFollow(chasePed7, chaseVehicle7, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed7, 786468)
    SetVehicleSiren(chaseVehicle7, true)
  end)
end

function SpawnVehicle8()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey8 = GetHashKey(config.ped8)
  pedType8 = GetPedType(hashKey)
  RequestModel(hashKey8)
  while not HasModelLoaded(hashKey8) do
    RequestModel(hashKey8)
    Citizen.Wait(100)
  end
  chasePed8 = CreatePed(pedType8, hashKey8, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle8, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle8)
    chaseVehicle8 = callback_vehicle8
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle8, false)
    SetVehicleEngineOn(chaseVehicle8, true, true)
    while not chasePed8 do Citizen.Wait(100) end;
    while not chaseVehicle8 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed8, chaseVehicle8, -1)
    TaskVehicleFollow(chasePed8, chaseVehicle8, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed8, 786468)
    SetVehicleSiren(chaseVehicle8, true)
  end)
end

function SpawnVehicle9()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey9 = GetHashKey(config.ped9)
  pedType9 = GetPedType(hashKey)
  RequestModel(hashKey9)
  while not HasModelLoaded(hashKey9) do
    RequestModel(hashKey9)
    Citizen.Wait(100)
  end
  chasePed9 = CreatePed(pedType9, hashKey9, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle9, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle9)
    chaseVehicle9 = callback_vehicle9
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle9, false)
    SetVehicleEngineOn(chaseVehicle9, true, true)
    while not chasePed9 do Citizen.Wait(100) end;
    while not chaseVehicle9 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed9, chaseVehicle9, -1)
    TaskVehicleFollow(chasePed9, chaseVehicle9, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed9, 786468)
    SetVehicleSiren(chaseVehicle9, true)
  end)
end

function SpawnVehicle10()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey10 = GetHashKey(config.ped10)
  pedType10 = GetPedType(hashKey)
  RequestModel(hashKey10)
  while not HasModelLoaded(hashKey10) do
    RequestModel(hashKey10)
    Citizen.Wait(100)
  end
  chasePed10 = CreatePed(pedType10, hashKey10, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle10, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle10)
    chaseVehicle10 = callback_vehicle10
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle10, false)
    SetVehicleEngineOn(chaseVehicle10, true, true)
    while not chasePed10 do Citizen.Wait(100) end;
    while not chaseVehicle10 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed10, chaseVehicle10, -1)
    TaskVehicleFollow(chasePed10, chaseVehicle10, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed10, 786468)
    SetVehicleSiren(chaseVehicle10, true)
  end)
end

function SpawnVehicle11()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey11 = GetHashKey(config.ped11)
  pedType11 = GetPedType(hashKey)
  RequestModel(hashKey11)
  while not HasModelLoaded(hashKey11) do
    RequestModel(hashKey11)
    Citizen.Wait(100)
  end
  chasePed11 = CreatePed(pedType11, hashKey11, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle11, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle11)
    chaseVehicle11 = callback_vehicle11
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle11, false)
    SetVehicleEngineOn(chaseVehicle11, true, true)
    while not chasePed11 do Citizen.Wait(100) end;
    while not chaseVehicle11 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed11, chaseVehicle11, -1)
    TaskVehicleFollow(chasePed11, chaseVehicle11, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed11, 786468)
    SetVehicleSiren(chaseVehicle11, true)
  end)
end

function SpawnVehicle12()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey12 = GetHashKey(config.ped12)
  pedType12 = GetPedType(hashKey)
  RequestModel(hashKey12)
  while not HasModelLoaded(hashKey12) do
    RequestModel(hashKey12)
    Citizen.Wait(100)
  end
  chasePed12 = CreatePed(pedType12, hashKey12, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle12, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle12)
    chaseVehicle12 = callback_vehicle12
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle12, false)
    SetVehicleEngineOn(chaseVehicle12, true, true)
    while not chasePed12 do Citizen.Wait(100) end;
    while not chaseVehicle12 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed12, chaseVehicle12, -1)
    TaskVehicleFollow(chasePed12, chaseVehicle12, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed12, 786468)
    SetVehicleSiren(chaseVehicle12, true)
  end)
end

function SpawnVehicle13()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey13 = GetHashKey(config.ped13)
  pedType13 = GetPedType(hashKey)
  RequestModel(hashKey13)
  while not HasModelLoaded(hashKey13) do
    RequestModel(hashKey13)
    Citizen.Wait(100)
  end
  chasePed13 = CreatePed(pedType13, hashKey13, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle13, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle13)
    chaseVehicle13 = callback_vehicle13
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle13, false)
    SetVehicleEngineOn(chaseVehicle13, true, true)
    while not chasePed13 do Citizen.Wait(100) end;
    while not chaseVehicle13 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed13, chaseVehicle13, -1)
    TaskVehicleFollow(chasePed13, chaseVehicle13, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed13, 786468)
    SetVehicleSiren(chaseVehicle13, true)
  end)
end

function SpawnVehicle14()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey14 = GetHashKey(config.ped14)
  pedType14 = GetPedType(hashKey)
  RequestModel(hashKey14)
  while not HasModelLoaded(hashKey14) do
    RequestModel(hashKey14)
    Citizen.Wait(100)
  end
  chasePed14 = CreatePed(pedType14, hashKey14, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle14, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle14)
    chaseVehicle14 = callback_vehicle14
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle14, false)
    SetVehicleEngineOn(chaseVehicle14, true, true)
    while not chasePed14 do Citizen.Wait(100) end;
    while not chaseVehicle14 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed14, chaseVehicle14, -1)
    TaskVehicleFollow(chasePed14, chaseVehicle14, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed14, 786468)
    SetVehicleSiren(chaseVehicle14, true)
  end)
end

function SpawnVehicle15()
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  hashKey15 = GetHashKey(config.ped15)
  pedType15 = GetPedType(hashKey)
  RequestModel(hashKey15)
  while not HasModelLoaded(hashKey15) do
    RequestModel(hashKey15)
    Citizen.Wait(100)
  end
  chasePed15 = CreatePed(pedType15, hashKey15, PedPosition.x + 2,  PedPosition.y,  PedPosition.z, 250.00, 1, 1)
  ESX.Game.SpawnVehicle(config.vehicle15, {
    x = PedPosition.x + 10 ,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle15)
    chaseVehicle15 = callback_vehicle15
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(chaseVehicle15, false)
    SetVehicleEngineOn(chaseVehicle15, true, true)
    while not chasePed15 do Citizen.Wait(100) end;
    while not chaseVehicle15 do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(chasePed15, chaseVehicle15, -1)
    TaskVehicleFollow(chasePed15, chaseVehicle15, playerPed, 50.0, 1, 5)
    SetDriveTaskDrivingStyle(chasePed15, 786468)
    SetVehicleSiren(chaseVehicle15, true)
  end)
end

------------------------ Fin Sécurité Menu -------------------------