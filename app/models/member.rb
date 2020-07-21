class Member < ApplicationRecord
  def full_name=(name)
    split_name = name.split(" ")
    self.first_name = split_name[0...-1].reduce(""){|memo, substr| "#{memo} #{substr}"}.strip
    self.last_name = split_name[-1]
    save
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.add_from_csv_file(path)
    open(path, "r") { |csv| add_from_csv(csv.read) }
  end

  def self.add_from_csv(csv_string)
    # Environment variable should be formatted as "(CSV_column1, intended_variable1)(CSV_column2, intended_variable2)..."
    # Ex. "(first, first_name)(last, last_name)(street, street)(city, city)..."
    column_tuples = ENV["COLUMNS_TO_VARIABLES"].split(/[\(\)]\s*/).filter{|sub| sub.size > 0}
    column_tuples.map! do |tuple| 
      items = tuple.split(/,\s*/)
      {csv: items[0], var_name: "#{items[1]}=".to_sym}
    end
    csv_lines = csv_string.split(/\n/)
    csv_headers = csv_lines[0].split(/,/).map{ |word| word.gsub(/"/, "") } # strip quotes out
    columns_with_indexes = column_tuples.map do |tuple| 
      {var_name: tuple[:var_name], index: csv_headers.find_index(tuple[:csv])}
    end.filter { |item| !item[:index].nil? }
    csv_lines[1..].each do |item|
      line_entries = item.split(/,/).map{ |word| word.gsub(/"/, "") }
      new_member = Member.new
      columns_with_indexes.each do |entry|
        new_member.send(entry[:var_name], line_entries[entry[:index]])
      end
      new_member.save
    end
  end
end
