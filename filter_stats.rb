require 'CSV'
require 'pry'

unfiltered_data = CSV.read('leagues_NL_2016-standard-batting_players_standard_batting.csv')
headers = unfiltered_data[1]

hundred_at_bats = unfiltered_data[2..-1].select do |row|
  row[6].to_i > 250 || (row[28] == '1' && row[6].to_i > 35)
end

hundred_at_bats = hundred_at_bats.map do |row|
  position = row[28].to_s
  if position.include?('7') || position.include?('8') || position.include?('9')
    row[28] = 7
  elsif position.include?('6')
    row[28] = 6
  elsif position.include?('5')
    row[28] = 5
  elsif position.include?('4')
    row[28] = 4
  elsif position.include?('3')
    row[28] = 3
  elsif position.include?('2')
    row[28] = 2
  elsif position.include?('1')
    row[28] = 1
  else
    row[28] = 0
  end
  row
end

#["Rk","Name","Age","Tm","G","PA","AB","R","H","2B","3B","HR","RBI","SB","CS","BB","SO","BA",
# "OBP","SLG","OPS","OPS+","TB","GDP","HBP","SH","SF","IBB","Pos"]
rows_to_export = headers + hundred_at_bats
headers_we_care_about = headers[1..2] + headers[6..13] + headers[15..18] + headers[28...29]

CSV.open("number_as_position_2016.csv", "w") do |csv|
  csv << headers_we_care_about
  hundred_at_bats.each { |player| csv << player[1..2] + player[6..13] + player[15..18] + player[28...29] }
end
