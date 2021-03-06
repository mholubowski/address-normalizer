module Exporter

  def export
    puts "The setting is: #{self.exporter}"
  end

  def accepted
    [:just_addresses, :addon_address, :seperate_columns]
  end

  def export_content(export_type = :addon_address)
    unless self.accepted.include? export_type
      raise ArgumentError, "Invalid export_type. Try one of these: \n \t #{self.accepted.join ' '}" 
    end
    
    result = self.parsed_content.each_with_index.map do |row, i|
      if i == 0
        self.export_column_headers(export_type) 
      else
        handle_row(row, i, export_type)
      end
    end
  end

  # Logic for column_headers for each export type
  def export_column_headers(export_type = :addon_address)
    unless self.accepted.include? export_type
      raise ArgumentError, "Invalid export_type. Try one of these: \n \t #{self.accepted.join ' '}" 
    end
    #todo make this private or add check for export_type
    headers = self.parsed_content[0]

    case export_type
    when :addon_address then headers += ['NORMALIZED']
    when :just_addresses then headers = ['Normalized Addresses']
    when :seperate_columns 
      keys = self.tokenized_addresses.first.to_hash.keys
      headers = keys.map { |key| key.to_s}
    end
  end

  private
  

  def handle_row(row, i, export_type)
    case export_type
    when :just_addresses
      return [self.tokenized_addresses[i-1].address]
    when :addon_address
      return row + [self.tokenized_addresses[i-1].address]
    when :seperate_columns
      keys = self.tokenized_addresses.first.to_hash.keys
      addr = self.tokenized_addresses[i-1]
      return keys.map { |key| addr[key] }
    end

  end

end

## Set Exporter types

class AddressSet < ActiveRecord::Base
  has_one :uploaded_file, dependent: :destroy
  has_many :tokenized_addresses, dependent: :destroy
  attr_accessor :content

  include Exporter

  def error_count
    self.tokenized_addresses.where(address: 'ERROR').count
  end

  def uniq_addresses
    self.tokenized_addresses.to_a.uniq
  end

  def parsed_content 
    @parsed_content ||= CSV.parse(self.uploaded_file.content)
  end

  def to_csv(export_type)
    CSV.generate do |csv|
      self.export_content(export_type).each do |row|
        csv << row
      end
    end
  end

end

