local QBCore = exports['qb-core']:GetCoreObject()
local securityVehicle = nil
local hasBag = false
local currentStop = 0
local deliveryBlip = nil
local amountOfBags = 0
local securityObject = nil
local endBlip = nil
local securityBlip = nil
local canTakeBag = true
local currentStopNum = 0
local PZone = nil
local listen = false
local finished = false
local continueworking = false
local playerJob = {}
-- Handlers

-- Functions

local function setupClient()
    securityVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    amountOfBags = 0
    securityObject = nil
    endBlip = nil
    currentStopNum = 0
    if playerJob.name == Config.Jobname then
        securityBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(securityBlip, 550)
        SetBlipDisplay(securityBlip, 4)
        SetBlipScale(securityBlip, 0.0)
        SetBlipAsShortRange(securityBlip, true)
        SetBlipColour(securityBlip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(securityBlip)
    end
end



local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

local function BringBackCar()
    DeleteVehicle(securityVehicle)
    if endBlip then
        RemoveBlip(endBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    securityVehicle = nil
    hasBag = false
    currentStop = 0
    deliveryBlip = nil
    amountOfBags = 0
    securityObject = nil
    endBlip = nil
    currentStopNum = 0
end

local function DeleteZone()
    listen = false
    PZone:destroy()
end

local function SetRouteBack()
    local depot = Config.Locations["main"].coords
    endBlip = AddBlipForCoord(depot.x, depot.y, depot.z)
    SetBlipSprite(endBlip, 1)
    SetBlipDisplay(endBlip, 2)
    SetBlipScale(endBlip, 1.0)
    SetBlipAsShortRange(endBlip, false)
    SetBlipColour(endBlip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].label)
    EndTextCommandSetBlipName(endBlip)
    SetBlipRoute(endBlip, true)
    DeleteZone()
    finished = true
end

local function AnimCheck()
    CreateThread(function()
        local ped = PlayerPedId()
        while hasBag and not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man',3) do
            if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                ClearPedTasksImmediately(ped)
                LoadAnimation('missfbi4prepp1')
                TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Wait(1000)
        end
    end)
end

local function DeliverAnim()
    local ped = PlayerPedId()
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, GetEntityHeading(securityVehicle))
    canTakeBag = false
    SetTimeout(1250, function()
        DetachEntity(securityObject, 1, false)
        DeleteObject(securityObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        securityObject = nil
        canTakeBag = true
    end)
    if Config.UseTarget and hasBag then
        local CL = Config.Locations["cashbox"][currentStop]
        hasBag = false
        local pos = GetEntityCoords(ped)
        exports['qb-target']:RemoveTargetEntity(securityVehicle)
        if (amountOfBags - 1) <= 0 then
            QBCore.Functions.TriggerCallback('securityjob:server:NextStop', function(hasMoreStops, nextStop, newBagAmount)
                if hasMoreStops and nextStop ~= 0 then
                    -- Here he puts your next location and you are not finished working yet.
                    currentStop = nextStop
                    currentStopNum = currentStopNum + 1
                    amountOfBags = newBagAmount
                    SetSecurityRoute()
                    QBCore.Functions.Notify(Lang:t("info.all_bags"))
                    SetVehicleDoorShut(securityVehicle, 5, false)
                else
                    if hasMoreStops and nextStop == currentStop then
                        QBCore.Functions.Notify(Lang:t("info.depot_issue"))
                        amountOfBags = 0
                    else
                        -- You are done with work here.
                        QBCore.Functions.Notify(Lang:t("info.done_working"))
                        SetVehicleDoorShut(securityVehicle, 5, false)
                        RemoveBlip(deliveryBlip)
                        SetRouteBack()
                        amountOfBags = 0
                    end
                end
            end, currentStop, currentStopNum, pos)
        else
            -- You haven't delivered all bags here
            amountOfBags = amountOfBags - 1
            if amountOfBags > 1 then
                QBCore.Functions.Notify(Lang:t("info.bags_left", { value = amountOfBags }))
            else
                QBCore.Functions.Notify(Lang:t("info.bags_still", { value = amountOfBags }))
            end
            exports['qb-target']:AddCircleZone('cashpickup', vector3(CL.coords.x, CL.coords.y, CL.coords.z), 2.0,{
                name = 'cashpickup', debugPoly = false, useZ=true}, {
                options = {{label = Lang:t("target.grab_cashpickup"),icon = 'fa-solid fa-trash', action = function() TakeAnim() end}},
                distance = 2.0
            })
        end
    end
end

function TakeAnim()
    local ped = PlayerPedId()
    QBCore.Functions.Progressbar("bag_pickup", Lang:t("info.picking_bag"), math.random(3000, 5000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function()
        LoadAnimation('missfbi4prepp1')
        TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
        securityObject = CreateObject(`prop_money_bag_01`, 0, 0, 0, true, true, true)
        AttachEntityToEntity(securityObject, ped, GetPedBoneIndex(ped, 57005), 0.29, -0.29, -0.28, -44.56, -35.52, 0.0, true, true, false, true, 1, true)
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        AnimCheck()
        if Config.UseTarget and not hasBag then
            hasBag = true
            exports['qb-target']:RemoveZone("cashpickup")
            exports['qb-target']:AddTargetEntity(securityVehicle, {
            options = {
                {label = Lang:t("target.dispose_cash"),icon = 'fa-solid fa-truck',action = function() DeliverAnim() end,canInteract = function() if hasBag then return true end return false end, }
            },
            distance = 2.0
            })
        end
    end, function()
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        QBCore.Functions.Notify(Lang:t("error.cancled"), "error")
    end)
end

local function RunWorkLoop()
    CreateThread(function()
        local GarbText = false
        while listen do
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local DeliveryData = Config.Locations["cashbox"][currentStop]
            local Distance = #(pos - vector3(DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z))
            if Distance < 15 or hasBag then

                if not hasBag and canTakeBag then
                    if Distance < 1.5 then
                        if not GarbText then
                            GarbText = true
                            exports['qb-core']:DrawText(Lang:t("info.grab_cashpickup"), 'left')
                        end
                        if IsControlJustPressed(0, 51) then
                            hasBag = true
                            exports['qb-core']:HideText()
                            TakeAnim()
                        end
                    elseif Distance < 10 then
                        if GarbText then
                            GarbText = false
                            exports['qb-core']:HideText()
                        end
                    end
                else
                    if DoesEntityExist(securityVehicle) then
                        local Coords = GetOffsetFromEntityInWorldCoords(securityVehicle, -2.0, 0.0, 0.0)
                        local TruckDist = #(pos - Coords)
                        local TrucText = false

                        if TruckDist < 2 then
                            if not TrucText then
                                TrucText = true
                                exports['qb-core']:DrawText(Lang:t("info.dispose_cashpickup"), 'left')
                            end
                            if IsControlJustPressed(0, 51) and hasBag then
                                StopAnimTask(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 1.0)
                                DeliverAnim()
                                QBCore.Functions.Progressbar("deliverbag", Lang:t("info.progressbar"), 2000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        hasBag = false
                                        canTakeBag = false
                                        DetachEntity(securityObject, 1, false)
                                        DeleteObject(securityObject)
                                        FreezeEntityPosition(ped, false)
                                        securityObject = nil
                                        canTakeBag = true
                                        -- Looks if you have delivered all bags
                                        if (amountOfBags - 1) <= 0 then
                                            QBCore.Functions.TriggerCallback('securityjob:server:NextStop', function(hasMoreStops, nextStop, newBagAmount)
                                                if hasMoreStops and nextStop ~= 0 then
                                                    -- Here he puts your next location and you are not finished working yet.
                                                    currentStop = nextStop
                                                    currentStopNum = currentStopNum + 1
                                                    amountOfBags = newBagAmount
                                                    SetSecurityRoute()
                                                    QBCore.Functions.Notify(Lang:t("info.all_bags"))
                                                    listen = false
                                                    SetVehicleDoorShut(securityVehicle, 5, false)
                                                else
                                                    if hasMoreStops and nextStop == currentStop then
                                                        QBCore.Functions.Notify(Lang:t("info.depot_issue"))
                                                        amountOfBags = 0
                                                    else
                                                        -- You are done with work here.
                                                        QBCore.Functions.Notify(Lang:t("info.done_working"))
                                                        SetVehicleDoorShut(securityVehicle, 5, false)
                                                        RemoveBlip(deliveryBlip)
                                                        SetRouteBack()
                                                        amountOfBags = 0
                                                        listen = false
                                                    end
                                                end
                                            end, currentStop, currentStopNum, pos)
                                            hasBag = false
                                        else
                                            -- You haven't delivered all bags here
                                            amountOfBags = amountOfBags - 1
                                            if amountOfBags > 1 then
                                                QBCore.Functions.Notify(Lang:t("info.bags_left", { value = amountOfBags }))
                                            else
                                                QBCore.Functions.Notify(Lang:t("info.bags_still", { value = amountOfBags }))
                                            end
                                            hasBag = false
                                        end

                                        Wait(1500)
                                        if TrucText then
                                            exports['qb-core']:HideText()
                                            TrucText = false
                                        end
                                    end, function() -- Cancel
                                    QBCore.Functions.Notify(Lang:t("error.cancled"), "error")
                                end)

                            end
                        end
                    else
                        QBCore.Functions.Notify(Lang:t("error.no_truck"), "error")
                        hasBag = false
                    end
                end
            end
            Wait(1)
        end
    end)
end

local function CreateZone(x, y, z)
    CreateThread(function()
        PZone = CircleZone:Create(vector3(x, y, z), 15.0, {
            name = "NewRouteWhoDis",
            debugPoly = false,
        })

        PZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                if not Config.UseTarget then
                    listen = true
                    RunWorkLoop()
                end
                SetVehicleDoorOpen(securityVehicle,5,false,false)
            else
                if not Config.UseTarget then
                    exports['qb-core']:HideText()
                    listen = false
                end
                SetVehicleDoorShut(securityVehicle, 5, false)
            end
        end)
    end)
end

function SetSecurityRoute()
    local CL = Config.Locations["cashbox"][currentStop]
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    deliveryBlip = AddBlipForCoord(CL.coords.x, CL.coords.y, CL.coords.z)
    SetBlipSprite(deliveryBlip, 550)
    SetBlipDisplay(deliveryBlip, 2)
    SetBlipScale(deliveryBlip, 1.0)
    SetBlipAsShortRange(deliveryBlip, false)
    SetBlipColour(deliveryBlip, 0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["cashbox"][currentStop].name)
    EndTextCommandSetBlipName(deliveryBlip)
    SetBlipRoute(deliveryBlip, true)
    finished = false
    if Config.UseTarget and not hasBag then
        exports['qb-target']:AddCircleZone('cashpickup', vector3(CL.coords.x, CL.coords.y, CL.coords.z), 2.0,{
            name = 'cashpickup', debugPoly = false, useZ=true }, {
            options = {{label = Lang:t("target.grab_cashpickup"), icon = 'fa-solid fa-trash', action = function() TakeAnim() end }},
            distance = 2.0
        })
    end
    if PZone then
        DeleteZone()
        Wait(500)
        CreateZone(CL.coords.x, CL.coords.y, CL.coords.z)
    else
        CreateZone(CL.coords.x, CL.coords.y, CL.coords.z)
    end
end

local ControlListen = false
local function Listen4Control()
    ControlListen = true
    CreateThread(function()
        while ControlListen do
            if IsControlJustReleased(0, 38) then
                TriggerEvent("qb-securityjob:client:MainMenu")
            end
            Wait(1)
        end
    end)
end

local pedsSpawned = false
local function spawnPeds()
    if not Config.Peds or not next(Config.Peds) or pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        current.model = type(current.model) == 'string' and GetHashKey(current.model) or current.model
        RequestModel(current.model)
        while not HasModelLoaded(current.model) do
            Wait(0)
        end
        local ped = CreatePed(0, current.model, current.coords, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        current.pedHandle = ped

        if Config.UseTarget then
            exports['qb-target']:AddTargetEntity(ped, {
                options = {{type = "client", event = "qb-securityjob:client:MainMenu", label = Lang:t("target.talk"), icon = 'fa-solid fa-sack-dollar', job = "changeme",}},
                distance = 2.0
            })
        else
            local options = current.zoneOptions
            if options then
                local zone = BoxZone:Create(current.coords.xyz, options.length, options.width, {
                    name = "zone_cityhall_" .. ped,
                    heading = current.coords.w,
                    debugPoly = false
                })
                zone:onPlayerInOut(function(inside)
                    if LocalPlayer.state.isLoggedIn then
                        if inside then
                            exports['qb-core']:DrawText(Lang:t("info.talk"), 'left')
                            Listen4Control()
                        else
                            ControlListen = false
                            exports['qb-core']:HideText()
                        end
                    end
                end)
            end
        end
    end
    pedsSpawned = true
end

local function deletePeds()
    if not Config.Peds or not next(Config.Peds) or not pedsSpawned then return end
    for i = 1, #Config.Peds do
        local current = Config.Peds[i]
        if current.pedHandle then
            DeletePed(current.pedHandle)
        end
    end
end

-- Events

RegisterNetEvent('securityjob:client:SetWaypointHome', function()
    SetNewWaypoint(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y)
end)

RegisterNetEvent('qb-securityjob:client:RequestRoute', function()
    if securityVehicle then continueworking = true TriggerServerEvent('securityjob:server:PayShift', continueworking) end
    QBCore.Functions.TriggerCallback('securityjob:server:NewShift', function(shouldContinue, firstStop, totalBags)
        if shouldContinue then
            if not securityVehicle then
                local occupied = false
                for _,v in pairs(Config.Locations["vehicle"].coords) do
                    if not IsAnyVehicleNearPoint(vector3(v.x,v.y,v.z), 2.5) then
                        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
                            local veh = NetToVeh(netId)
                            SetVehicleEngineOn(veh, false, true)
                            securityVehicle = veh
                            SetVehicleNumberPlateText(veh, "QB-" .. tostring(math.random(1000, 9999)))
                            SetEntityHeading(veh, v.w)
                            exports['LegacyFuel']:SetFuel(veh, 100.0)
                            SetVehicleFixed(veh)
                            SetEntityAsMissionEntity(veh, true, true)
                            SetVehicleDoorsLocked(veh, 2)
                            currentStop = firstStop
                            currentStopNum = 1
                            amountOfBags = totalBags
                            SetSecurityRoute()
                            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
                            QBCore.Functions.Notify(Lang:t("info.deposit_paid", { value = Config.TruckPrice }))
                            QBCore.Functions.Notify(Lang:t("info.started"))
                            TriggerServerEvent("qb-securityjob:server:payDeposit")
                        end, Config.Vehicle, v, false)
                        return
                    else
                        occupied = true
                    end
                end
                if occupied then
                    QBCore.Functions.Notify(Lang:t("error.all_occupied"))
                end
            end
            currentStop = firstStop
            currentStopNum = 1
            amountOfBags = totalBags
            SetSecurityRoute()
        else
            QBCore.Functions.Notify(Lang:t("info.not_enough", { value = Config.TruckPrice }))
        end
    end, continueworking)
end)

RegisterNetEvent('qb-securityjob:client:RequestPaycheck', function()
    if securityVehicle then
        BringBackCar()
        QBCore.Functions.Notify(Lang:t("info.truck_returned"))
    end
    TriggerServerEvent('securityjob:server:PayShift')
end)

RegisterNetEvent('qb-securityjob:client:MainMenu', function()
    if playerJob.name == Config.Jobname then
        local MainMenu = {}
        MainMenu[#MainMenu+1] = {isMenuHeader = true,header = Lang:t("menu.header")}
        MainMenu[#MainMenu+1] = { header = Lang:t("menu.collect"),txt = Lang:t("menu.return_collect"),params = { event = 'qb-securityjob:client:RequestPaycheck',}}
        if not securityVehicle or finished then
            MainMenu[#MainMenu+1] = { header = Lang:t("menu.route"), txt = Lang:t("menu.request_route"), params = { event = 'qb-securityjob:client:RequestRoute',}}
        end
        exports['qb-menu']:openMenu(MainMenu)
    else
        QBCore.Functions.Notify(Lang:t("error.job"))
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerJob = QBCore.Functions.GetPlayerData().job
    setupClient()
    spawnPeds()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    playerJob = JobInfo
    if securityBlip then
        RemoveBlip(securityBlip)
    end
    if endBlip then
        RemoveBlip(endBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    endBlip = nil
    deliveryBlip = nil
    setupClient()
    spawnPeds()
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if securityObject then
            DeleteEntity(securityObject)
            securityObject = nil
        end
        deletePeds()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        playerJob = QBCore.Functions.GetPlayerData().job
        setupClient()
        spawnPeds()
    end
end)