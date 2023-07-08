# qb-securityjob
A Cash Pickup Job Script for QBCore/FiveM using the QB-GarbageJob as a base then editing as required.

Credits to QB-Core for the original script, I merely edited to be used for another job.

Job will need to be edited via config and main.lua, open both and search for "changeme" then set your desired Job name.

Default vehicle is set to the Stockade but as this script was rewritten for a different vehicle in our server, you may need to change the offset for depositing cash into the truck, especially if you decide on another model, please do this by going to the main.lua and editing the offset values on line 227 ( local Coords = GetOffsetFromEntityInWorldCoords(securityVehicle, -2.0, 0.0, 0.0) )

To change the vehicle model simply change the model at the bottom of the config.lua and update the offset as stated above.

Drag and drop the resource into your resources folder and then add it to your server.cfg, update the job name as listed above and set the vehicle as listed above, then restart server and you're ready to start earning some money.

if you have any problems just contact me via Discord:
kazashimo

Original Script: https://github.com/qbcore-framework/qb-garbagejob

created for latest version of qb-core.

Visit the Ped at the Union Depository to begin working, a vehicle will be spawned for you and a waypoint to one of the shops or banks around the city.
Collect the money from their safe and deposit it into the van.
