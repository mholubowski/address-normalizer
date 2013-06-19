require 'csv'
require 'cmess/guess_encoding'
require_relative 'address_set.rb'
require_relative 'tokenized_address.rb'

class FileParser
	attr_accessor :address_index, :normalized_address_index

	def initialize
		@address_index = 0
		@normalized_address_index = 0
	end

	def create_address_set(filename)
		@set = AddressSet.new

		source_encoding = get_encoding(filename)

		process_csv(filename, source_encoding)

		return @set

		#TODO handle malformed (in address_set?)
		#     create Malformed class?
	end

  def get_encoding(filename)
    source_file     = File.read(filename)
    source_encoding = CMess::GuessEncoding::Automatic.guess(source_file)
    source_file 		= nil

    return source_encoding
  end

  def process_csv(filename, source_encoding)
    counter = 0
    IO.foreach(filename, :encoding => source_encoding) do |line|
      if counter == 0
        handle_first_row(line)
        puts "Here"
      else
        normalize_line(line)
        puts "Now here"
      end
      counter += 1
    end
  end

  def handle_first_row(line)
  	p line
    CSV.parse(line) do |row|
      # check if 'address' exists
      self.address_index = row.index("address")
      puts "ad index: #{address_index}"
      # row << "address_normalized"
      self.normalized_address_index = row.index("address_normalized")
      # Must handle first row in the address set class
    end
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
        @set << tokenized
        # file_out.write(CSV.generate_line(row))
      end
      # Rescue from problem rows
    rescue CSV::MalformedCSVError => er
      # self.errors << er.message
      # self.malformed_rows << line
    end
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