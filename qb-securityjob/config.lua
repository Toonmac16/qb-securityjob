Config = {}

Config.UseTarget = false --GetConvar('UseTarget', 'false') == 'true'
Config.Jobname = 'changeme'
-- Price taken and given back when delivered a truck
Config.TruckPrice = 500

-- Want to give out a cryptostick per stop?
Config.GiveCryptoStick = false

-- Has to roll this number or higher to receive a cryptostick
Config.CryptoStickChance = 0

-- How many stops minimum should the job roll?
Config.MinStops = 5

-- Upper worth per bag
Config.BagUpperWorth = 550

-- Lower worth per bag
Config.BagLowerWorth = 75

-- Minimum bags per stop
Config.MinBagsPerStop = 2

-- Maximum bags per stop
Config.MaxBagsPerStop = 4

-- WIP: Do not use
-- If you want to use custom routes instead of random amount of stops stops set to true
Config.UsePreconfiguredRoutes = false

Config.Peds = {
    {
        model = 's_m_m_armoured_01',
        coords = vector4(0.94, -659.21, 32.48, 91.16),
        zoneOptions = { -- Used for when UseTarget is false
            length = 3.0,
            width = 3.0
        }
    }
}

Config.Locations = {
    ["main"] = {
        label = "Security Depot",
        coords = vector3(-6.49, -662.16, 33.48),
    },
    ["vehicle"] = {
        label = "Security Truck Storage",
        coords = { -- parking spot locations to spawn van
            [1] = vector4(-5.55, -670.1, 32.34, 184.61),
            [2] = vector4(-33.97, -672.67, 32.34, 181.19),
        },
    },
    ["paycheck"] = {
        label = "Payslip Collection",
        coords = vector3(-5.09, -654.04, 33.45),
    },
    ["cashbox"] ={
        [1] = {
            name = "grovestreet",
            coords = vector4(-43.42, -1748.3, 29.42, 50.51),
        },
        [2] = {
            name = "innocenceboulevard",
            coords = vector4(118.06, -1943.96, 20.43, 179.5),
        },
        [3] = {
            name = "legionbank",
            coords = vector4(147.46, -1044.87, 29.37, 250.85),
        },
        [4] = {
            name = "elranchoblvd",
            coords = vector4(1126.71, -980.17, 45.42, 12.2),
        },
        [5] = {
            name = "palominoave",
            coords = vector4(-709.69, -904.25, 19.22, 88.81),
        },
        [6] = {
            name = "prosperitystreet",
            coords = vector4(-1478.9, -375.33, 39.16, 225.05),
        },
        [7] = {
            name = "boulevarddelperro",
            coords = vector4(-1211.29, -335.29, 37.78, 298.19),
        },
        [8] = {
            name = "hawickave",
            coords = vector4(-353.31, -54.14, 49.04, 250.43),
        },
        [9] = {
            name = "meteorstreet",
            coords = vector4(311.77, -283.32, 54.16, 247.36),
        },
        [10] = {
            name = "mirrorparkblvd",
            coords = vector4(1159.51, -314.0, 69.21, 98.94),
        },
        [11] = {
            name = "clintonave",
            coords = vector4(381.02, 332.54, 103.57, 256.7),
        },
        [12] = {
            name = "palominofwy",
            coords = vector4(2549.5, 387.86, 108.62, 350.4),
        },
        [13] = {
            name = "greatoceanfwy",
            coords = vector4(-2959.58, 387.16, 14.04, 172.17),
        },
        [14] = {
            name = "greatoceanfwy2",
            coords = vector4(-2957.58, 481.88, 15.7, 0.91),
        },
        [15] = {
            name = "greatoceanfwy3",
            coords = vector4(-3048.65, 588.5, 7.91, 18.39),
        },
        [16] = {
            name = "barbarenoroad",
            coords = vector4(-3249.82, 1007.38, 12.83, 354.56),
        },
        [17] = {
            name = "banhamcanyondrive",
            coords = vector4(-1829.22, 798.86, 138.19, 138.68),
        },
        --[18] = {
        --    name = "magellanavenue",
        --    coords = vector4(-1243.73, -1359.72, 3.93, 287.5),
        --},
        --[19] = {
        --    name = "palominoavenue",
        --    coords = vector4(-845.87, -1113.07, 6.91, 253.5),
        --},
        --[20] = {
        --    name = "southrockforddrive",
        --    coords = vector4(-635.21, -1226.45, 11.8, 143.5),
        --},
        --[21] = {
        --    name = "southarsenalstreet",
        --    coords = vector4(-587.74, -1739.13, 22.47, 339.5),
        --},
    },
    ["routes"] = { -- Custom routes (WIP Do not use)
        [1] = {7, 6, 5, 15, 10},
        [2] = {11, 18, 7, 8, 15},
        [3] = {1, 7, 8, 17, 18},
        [4] = {16, 17, 4, 8, 21},
        [5] = {8, 2, 6, 17, 19},
        [6] = {3, 19, 1, 8, 11},
        [7] = {8, 19, 9, 6, 14},
        [8] = {14, 12, 20, 9, 11},
        [9] = {9, 18, 3, 6, 20},
        [10] = {9, 13, 7, 17, 16}
    }
}

Config.Vehicle = 'stockade' -- vehicle name used to spawn