require 'date'
require 'optparse'

params = ARGV.getopts("y:m:")
input_year = params["y"]
input_mon = params["m"]

if input_year != nil
  year = input_year.to_i
else 
  year = Date.today.year 
end

if input_mon != nil
  mon = input_mon.to_i
else 
  mon = Date.today.mon 
end

head = (mon).to_s + "月 " + (year).to_s 
firstday_wday = Date.new(year, mon, 1).wday # Sun is 0, Sat is 7
lastday_date = Date.new(year, mon, -1).day # -1 means the last day of the month
week_jap = ["日", "月", "火", "水", "木", "金", "土"]

puts head.center(20) # set the position of "*月 ****"
puts week_jap.join(" ") # put spaces between day of the week
# put spaces in front of the first day
# the size of each space is 3*half-width space
print "   " * firstday_wday  
wday = firstday_wday 
days = 1..lastday_date

days.each do |num|
  print num.to_s.rjust(2) + " " # right-justify the days
  wday = wday+1
  if wday % 7 == 0 # if it's Sat, start a new line                    
    print "\n"
  end
end
print "\n"

