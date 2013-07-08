
class FileParser
  attr_accessor :address_index, :normalized_address_index, :addr_columns

  def initialize
    @normalized_address_index = 0
  end

  @@instance = FileParser.new

  def self.instance
    @@instance
  end

  #TODO line_limit for dev
  def create_address_set(options, line_limit=nil)
    filename = options[:filename]

    @set = AddressSet.new({filename: filename})

    source_encoding = get_encoding(filename)

    process_csv(filename, source_encoding, line_limit)
    return @set
    #TODO handle malformed (in address_set?)
    #     create Malformed class?
  end

  def get_encoding(filename)
    source_file     = File.read(filename)
    source_encoding = CMess::GuessEncoding::Automatic.guess(source_file)
    source_file     = nil

    return source_encoding
  end

  def process_csv(filename, source_encoding, line_limit)
    counter = 0
    IO.foreach(filename, :encoding => source_encoding) do |line|
      if counter == 0
        handle_first_row(line)
      else
        return if (line_limit && counter == line_limit)
        normalize_line(line)
      end
      counter += 1
    end
  end

  def handle_first_row(line)
    CSV.parse(line) do |row|
      row.map! {|e| e.downcase}
      # check if 'address' FUZZY exists
      # if row.index("address")
      #   self.address_index = row.index("address")
      # else # else try to smart piece together columns into an address! :)
      #   guess_address_columns(row)
      # end
      guess_address_columns(row)
    end
  end

  # takes an array of column headers
  # tries to order them into a proper address
  # 6587 Del Playa Drive Unit 3 Goleta, CA, 90045
  def guess_address_columns(row)
    indexes = match_addr_columns_in_row(row)
    # {street_num} {street_name} {street_type} {*Unit_type} {*Unit_number} {*City}, {*State}, {*zip/postal} ??-> country; PO box;
    self.addr_columns = indexes
  end

  def normalize_line(line)
    begin
      CSV.parse(line) do |row|
        begin
          # if self.address_index
          #   tokenized = TokenizedAddress.new(row[address_index])
          # elsif self.addr_columns
          #   # use indexes to build concatenate columns into an address string
          #   tokenized = TokenizedAddress.new(build_address_string(row))
          # else
          #   p "WTF"
          # end
          # Catch empty address

          tokenized = TokenizedAddress.new(build_address_string(row))
        rescue NoMethodError
          strt_ad = ""
        end
        @set.tokenized_addresses << tokenized
        # file_out.write(CSV.generate_line(row))
      end
      # Rescue from problem rows
    rescue CSV::MalformedCSVError => er
      # self.errors << er.message
      # self.malformed_rows << line
    end
  end

  private_class_method :new

  def match_addr_columns_in_row(row)
    indexes = {}
    column_regexes.each do |key, val|
      indexes[key] = find_index_with_regex(row, val)
    end
    indexes
  end

  def find_index_with_regex(array, regex)
    array.index do |x|
      regex =~ x
    end
  end

  def column_regexes
    {
      full_address: /address/,
      street_num: /num/,
      street_name: /str.*name/,
      street_type: /str.*type/,
      unit_type: /unit.*type/,
      unit_number: /unit.*num|ap.*num/,
      city: /city/,
      state: /state/,
      zip: /zip|post/,
      country: /country/,
      po_box: /box/
    }
  end

  def build_address_string(row)
     "#{addr_prop(row, :full_address)} #{addr_prop(row, :street_num)} #{addr_prop(row, :street_name)} #{addr_prop(row, :street_type)} #{addr_prop(row, :unit_type)} #{addr_prop(row, :unit_number)} #{addr_prop(row, :city)}, #{addr_prop(row, :state)} #{addr_prop(row, :zip)} #{addr_prop(row, :country)} #{addr_prop(row, :po_box)}"
  end

  def addr_prop row, key
    return nil if self.addr_columns[key].nil?
    row[self.addr_columns[key]]
  end

  # def handle_malformed_rows
  #   puts "Errors: #{errors.to_s}\n\n\n" unless errors.empty?

  #   malformed_row_output_file = File.open("AddressNormalizer_MalformedRows_#{timestamp}.txt", "w")
  #   puts "Malformed rows:"
  #   malformed_rows.each do |row|
  #     puts row
  #     malformed_row_output_file.write(row + "\n")
  #   end
  #   puts "Malformed rows saved to disk in #{malformed_row_output_file.path}."

  #   malformed_row_output_file.close
  # end

end
