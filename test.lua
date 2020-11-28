s = "Battery 1: Unknown, 79%"
local cur_bat_no, cur_status, charge_str, time_str = string.match(s, ".*(%d): (%a+), (%d?%d?)%%?(.*)")
print(cur_bat_no)
print(cur_status)
print(charge_str)
print(time_str)
