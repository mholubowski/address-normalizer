class FileParser

  def self.create_address_set_from_file uploaded_file
    set = AddressSet.new
    set.uploaded_file = uploaded_file

    # source_encoding = get_encoding(filename)

    self.process_csv(uploaded_file, set)
    return set
    #TODO handle malformed (in address_set?)
    #     create Malformed class?
  end

  private

  def self.process_csv(file, set)
    counter = 0
    CSV.parse(file.content).each do |line|
      if counter == 0
        # do nothing
      else
        self.normalize_line(line, file, set)
      end
      counter += 1
    end
  end

  def self.normalize_line(line, file, set)
    t = TokenizedAddress.new
    if file.column_information.single_column_address
      t.init_string = line[file.column_information.single_column_index]
    else # pass the column_information to the address
      t.init_string = self.build_address_string_from_column_indexes(line, file.column_information)
    end
    t.save
    set.tokenized_addresses << t
  end

  # line = ["Mike", " 7462", " Denrock Avenue", " Los Angeles", " CA", " 90045"]
  # require 'ostruct'
  # columns = OpenStruct.new(attributes: {single_column_address: false, single_column_index: nil, number_index: 1, street_index: 2, street_type_index: 2, unit_index: nil, unit_prefix_index: nil, suffix_index: nil, prefix_index: nil, city_index: 3, state_index: 4, postal_code_index: 5, postal_code_ext_index: 5})

  def self.build_address_string_from_column_indexes(line, columns)
    # Shitty, cryptic code.. made with love by Mike
    # get all the '_index' keys that have a value
    keys = columns.attributes.delete_if {|key, val| !key.to_s.include?('index') || val.nil?}
    first_occurances = keys.values.uniq.map {|val| keys.key(val)}
    uniq = keys.select {|key| first_occurances.include? key}
    # set the last value to a blank string, use that string if key doesn't exist in uniq
    line.push '' # also maybe strip extra whitespace?
    uniq.default = line.length - 1
    # build the string using the values in uniq keys. If the key doesn't exist, leave blank.

    string = "#{line[uniq['number_index']]} #{line[uniq['street_index']]} #{line[uniq['street_type_index']]} #{line[uniq['unit_index']]} #{line[uniq['city_index']]}, #{line[uniq['state_index']]} #{line[uniq['postal_code_index']]} #{line[uniq['postal_code_ext_index']]}"
    # binding.pry
  end

end
