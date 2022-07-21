local zoneNames = {AIRP = "Los Santos International Airport",ALAMO = "Alamo Sea",ALTA = "Alta",ARMYB = "Fort Zancudo",BANHAMC = "Banham Canyon Dr",BANNING = "Banning",BAYTRE = "Baytree Canyon", BEACH = "Vespucci Beach",BHAMCA = "Banham Canyon",BRADP = "Braddock Pass",BRADT = "Braddock Tunnel",BURTON = "Burton",CALAFB = "Calafia Bridge",CANNY = "Raton Canyon",CCREAK = "Cassidy Creek",CHAMH = "Chamberlain Hills",CHIL = "Vinewood Hills",CHU = "Chumash",CMSW = "Chiliad Mountain State Wilderness",CYPRE = "Cypress Flats",DAVIS = "Davis",DELBE = "Del Perro Beach",DELPE = "Del Perro",DELSOL = "La Puerta",DESRT = "Grand Senora Desert",DOWNT = "Downtown",DTVINE = "Downtown Vinewood",EAST_V = "East Vinewood",EBURO = "El Burro Heights",ELGORL = "El Gordo Lighthouse",ELYSIAN = "Elysian Island",GALFISH = "Galilee",GALLI = "Galileo Park",golf = "GWC and Golfing Society",GRAPES = "Grapeseed",GREATC = "Great Chaparral",HARMO = "Harmony",HAWICK = "Hawick",HORS = "Vinewood Racetrack",HUMLAB = "Humane Labs and Research",JAIL = "Bolingbroke Penitentiary",KOREAT = "Little Seoul",LACT = "Land Act Reservoir",LAGO = "Lago Zancudo",LDAM = "Land Act Dam",LEGSQU = "Legion Square",LMESA = "La Mesa",LOSPUER = "La Puerta",MIRR = "Mirror Park",MORN = "Morningwood",MOVIE = "Richards Majestic",MTCHIL = "Mount Chiliad",MTGORDO = "Mount Gordo",MTJOSE = "Mount Josiah",MURRI = "Murrieta Heights",NCHU = "North Chumash",NOOSE = "N.O.O.S.E",OCEANA = "Pacific Ocean",PALCOV = "Paleto Cove",PALETO = "Paleto Bay",PALFOR = "Paleto Forest",PALHIGH = "Palomino Highlands",PALMPOW = "Palmer-Taylor Power Station",PBLUFF = "Pacific Bluffs",PBOX = "Pillbox Hill",PROCOB = "Procopio Beach",RANCHO = "Rancho",RGLEN = "Richman Glen",RICHM = "Richman",ROCKF = "Rockford Hills",RTRAK = "Redwood Lights Track",SanAnd = "San Andreas",SANCHIA = "San Chianski Mountain Range",SANDY = "Sandy Shores",SKID = "Mission Row",SLAB = "Stab City",STAD = "Maze Bank Arena",STRAW = "Strawberry",TATAMO = "Tataviam Mountains",TERMINA = "Terminal",TEXTI = "Textile City",TONGVAH = "Tongva Hills",TONGVAV = "Tongva Valley",VCANA = "Vespucci Canals",VESP = "Vespucci",VINE = "Vinewood",WINDF = "Ron Alternates Wind Farm",WVINE = "West Vinewood",ZANCUDO = "Zancudo River",ZP_ORT = "Port of South Los Santos",ZQ_UAR = "Davis Quartz"}

function GetTheStreet()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    playerStreetsLocation = zoneNames[tostring(zone)]

    if not zone then
        zone = "UNKNOWN"
        zoneNames['UNKNOWN'] = zone
    elseif not zoneNames[tostring(zone)] then
        local undefinedZone = zone .. " " .. x .. " " .. y .. " " .. z
        zoneNames[tostring(zone)] = "Undefined Zone"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | " .. zoneNames[tostring(zone)]
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. zoneNames[tostring(zone)]
    else
        playerStreetsLocation = zoneNames[tostring(zone)]
    end

end

local currentJob = "police"
local disableNotifs = false

RegisterNetEvent('wf-alerts:clNotify')
AddEventHandler('wf-alerts:clNotify', function(pData)
    if pData ~= nil then
        if pData.recipientList then
            if currentJob == pData.recipientList[1].name or currentJob == pData.recipientList[2].name then
                SendNUIMessage({action = 'display', info = pData, job = currentJob})
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
        end
    end
end)

RegisterNetEvent('wl-alerts:civilian:notify')
AddEventHandler('wl-alerts:civilian:notify', function(alertType)
    street = GetTheStreet()
    --local job = exports["isPed"]:isPed("job") -- Replace this with however you wish to check for a job
        local src = source --added -sunny
	    local PlayerData = GetPlayerData(src) --added -sunny
        local job = GetJobType(PlayerData.job.name) --added -sunny
    local popo = false
    local ems = false
    if job == "police" then
        popo = true -- If you've amended the above, this will work fine
    end
    if job == "ambulance" then -- If you've amended the above, this will work fine
        ems = true
    end

    --if alertType == "Suspicious" and not popo or alertType == "Suspicious" and not ems then
    if alertType == "Suspicious" then
        data = {dispatchCode = '10-10', street = playerStreetsLocation}
        TriggerServerEvent('wf-alerts:svNotify', data)
    end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7500)
        TriggerEvent('wl-alerts:civilian:notify', 'Suspicious')
    end
end)
