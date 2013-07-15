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
    t.init_string = self.build_address_string(line, file)
    t.save
    set.tokenized_addresses << t
  end

  def self.build_address_string(line, file)
    #line right now is an array
    line[file.address_column_index]
  end

end
