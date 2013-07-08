
class FileParser
  attr_accessor :address_index, :normalized_address_index

  def initialize
    @address_index = 0
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
      if row.index("address")
        self.address_index = row.index("address")
      else # else try to smart piece together columns into an address! :)
        guess_address_columns(row)
      end
    end
  end

  # takes an array of column headers
  # tries to order them into a proper address
  # 6587 Del Playa Drive Unit 3 Goleta, CA, 90045
  def guess_address_columns(row)
    # KEY: * = optional
    # {street_num} {street_name} {street_type} {*Unit_type} {*Unit_number} {*City}, {*State}, {*zip/postal} ??-> country; PO box;

  end

  def normalize_line(line)
    begin
      CSV.parse(line) do |row|
        begin
          tokenized = TokenizedAddress.new(row[address_index])
          # Catch empty address
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



  def find_index_with_regex(array, regex)
    array.index do |x|
      regex =~ x
    end
  end

  def column_regexes
    {
      street_num: /num|/,
      street_name: /str.*name/,
      street_type: /str.*type/,
      unit_type: /unit.*type/,
      unit_number: /unit.*num|ap.*num/,
      city: /city/,
      state: /state/,
      zip: /zip|post/,
      country: //,
      po_box: /p.*o|box/
    }
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
