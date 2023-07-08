local Translations = {
    error = {
        ["cancled"] = "Canceled",
        ["no_truck"] = "You have no truck!",
        ["not_enough"] = "Not Enough Money (%{value} required)",
        ["too_far"] = "You are too far away from the drop-off point",
        ["early_finish"] = "Due to early finish (Completed: %{completed} Total: %{total}), your deposit will not be returned.",
        ["never_clocked_on"] = "You never clocked on!",
        ["all_occupied"] = "All parking spots are occupied",
        ["job"] = "You must get the job from the job center",
    },
    success = {
        ["clear_routes"] = "Cleared users routes they had %{value} routes stored",
        ["pay_slip"] = "You got $%{total}, your payslip %{deposit} got paid to your bank account!",
    },
    target = {
        ["talk"] = 'Talk to Security Guard',
        ["grab_cashpickup"] = "Grab Money bag",
        ["dispose_cashpickup"] = "Deposit Money Bag",
    },
    menu = {
        ["header"] = "Security Main Menu",
        ["collect"] = "Collect Paycheck",
        ["return_collect"] = "Return truck and collect paycheck here!",
        ["route"] = "Request Route",
        ["request_route"] = "Request a Cash Route",
    },
    info = {
        ["payslip_collect"] = "[E] - Payslip",
        ["payslip"] = "Payslip",
        ["not_enough"] = "You have not enough money for the deposit.. Deposit costs are $%{value}",
        ["deposit_paid"] = "You have paid $%{value} deposit!",
        ["no_deposit"] = "You have no deposit paid on this vehicle..",
        ["truck_returned"] = "Truck returned, collect your payslip to receive your pay and deposit back!",
        ["bags_left"] = "There are still %{value} bags left!",
        ["bags_still"] = "There is still %{value} bag over there!",
        ["all_bags"] = "All Money bags are done, proceed to the next location!",
        ["depot_issue"] = "There was an issue at the depot, please return immediately!",
        ["done_working"] = "You are done working! Go back to the depot.",
        ["started"] = "You have started working, location marked on GPS!",
        ["grab_cashpickup"] = "[E] Grab a Money bag",
        ["stand_grab_cashpickup"] = "Stand here to grab a Money bag.",
        ["dispose_cashpickup"] = "[E] Deposit Money Bag",
        ["progressbar"] = "Putting bag in van ..",
        ["cashpickup_in_truck"] = "Put the bag in your truck..",
        ["stand_here"] = "Stand here..",
        ["found_crypto"] = "You found a cryptostick on the floor",
        ["payout_deposit"] = "(+ $%{value} deposit)",
        ["store_truck"] =  "[E] - Store Security Truck",
        ["get_truck"] =  "[E] - Security Truck",
        ["picking_bag"] = "Grabbing Money bag..",
        ["talk"] = "[E] Talk to Security Guard",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
