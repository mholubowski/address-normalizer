require_relative 'tokenized_address'
require_relative 'verified_address'

class AddressSet
  include Enumerable

  attr_accessor :tokenized_addresses, :verified_addresses, :stats
  attr_reader :redis_id

  def initialize (options={})
    options = {filename: "", id: nil}.merge(options)
    @tokenized_addresses = []
    @verified_addresses = []
    @stats = {filename: options[:filename]}
    @redis_id = options[:id] if options[:id]
  end

  def self.find_addresses(id)
    addr_ids = $redis.lrange("set_id:#{id}:address_ids", 0, -1)
    addresses = addr_ids.map {|id| $redis.hgetall "address_id:#{id}:hash"}
    addresses.map {|addr| addr.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}
  end

  def self.find_verified_addresses(id)
    addr_ids = $redis.lrange("set_id:#{id}:verified_address_ids", 0, -1)
    addresses = addr_ids.map {|id| $redis.hgetall "verified_address_id:#{id}:hash"}
    addresses.map {|addr| addr.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}
  end

  def self.find(id)
    set = AddressSet.new({id: id})
    set.stats = $redis.hgetall("set_id:#{id}:stats")
    set.stats = set.stats.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    set.tokenized_addresses = AddressSet.find_addresses(id)
    set.tokenized_addresses.map {|addr| addr.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}

    set.verified_addresses = AddressSet.find_verified_addresses(id)
    set.verified_addresses.map {|addr| addr.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}
    set
  end

  def each
    @tokenized_addresses.each {|ad| yield ad}
  end

  # TODO allow x number of address sets
  def merge(other_set)
    unless other_set.class == self.class
      raise 'Can only merge another AddressSet'
    end
    other_set.each do |ad|
      self << ad
    end
  end

  def +(other_set)
    @tokenized_addresses + other_set.tokenized_addresses
  end

  def concat(other_set)
    @tokenized_addresses.concat other_set.tokenized_addresses
  end

  def count_unique_occurences
    h = Hash.new(0)
    self.each {|address| h[address] += 1}
    return h
  end

  def to_ary
    @tokenized_addresses
  end

  # def &(other_set)
  #   self.tokenized_addresses & other_set.tokenized_addresses
  # end

  #TODO refactor this into separate methods
  # What about when updating individual things?
  def redis_id
    @redis_id ||= $redis.incr 'global:set_id'
  end

  def save
    persist_stats

    save_tokenized_addresses

    CurrentUser::set_ids << redis_id
  end

  def persist_stats
    unless @stats == {}
      $redis.hmset("set_id:#{redis_id}:stats", *@stats.flatten)
    end
  end

  def save_tokenized_addresses
    addr_ids = @tokenized_addresses.collect {|addr| addr.save}
    # pipeline breaks things with setting the redis id
    # $redis.pipelined do
    addr_ids.each {|id| $redis.rpush "set_id:#{redis_id}:address_ids", id}
    # end
  end

  def simple_export
    csv_content = CSV.generate do |csv|
      csv << ["address"]
      self.each do |addr|
        csv << [addr[:address]]
      end
    end

    csv_content
    # send_file "/exports/test.csv"
  end

  def addon_export
    # UPLOADS = Dir.pwd
    file = @stats[:filename]

    csv_content = CSV.generate do |csv|
      count = 0
      CSV.foreach(file) do |row|
        if count == 0
          csv << row + ['NORMALIZED']
          count += 1
          next
        end
        csv << row + [@tokenized_addresses[count-1][:address]]
        count += 1
      end
    end

    csv_content
  end

  def addon_verified_columns
    # UPLOADS = Dir.pwd
    file = @stats[:filename]

    csv_content = CSV.generate do |csv|
      count = 0
      CSV.foreach(file) do |row|
        if count == 0
          csv << row + ['NORMALIZED'] + ['VERIFIED (EasyPost)']
          count += 1
          next
        end
        csv << row + [@tokenized_addresses[count-1][:address]] + [@verified_addresses[count-1][:address]]
        count += 1
      end
    end

    csv_content
  end

  # these names are embarassing...
  def addon_seperate_columns
    file = @stats[:filename]

    csv_content = CSV.generate do |csv|
      count = 0
      CSV.foreach(file) do |row|
        if count == 0
          csv << row + ['Normalized Address'] + TokenizedAddress.attributes
          count += 1
          next
        end
        all_attributes = TokenizedAddress.attributes.map {|attr| @tokenized_addresses[count-1][attr.to_sym]}
        csv << row + [@tokenized_addresses[count-1][:address]] + all_attributes
        count += 1
      end
    end

    csv_content
  end

  def verify_addresses
    @verified_addresses = @tokenized_addresses.map do |addr|

      r = ApiAddressVerifier.instance.verify_with_easypost(addr)
      #TODO split these up into attributes just like the tokenized_addresses
      if r[:error]
        addr_string = "#{r[:error]}"
      else
        addr_string = "#{r[:street1]} #{r[:street2]} #{r[:city]}, #{r[:state]} #{r[:zip]} #{r[:country]}"
      end
      VerifiedAddress.new(addr_string)
    end
  end

  def save_verified_addresses
    addr_ids = @verified_addresses.collect {|addr| addr.save}
    $redis.del "set_id:#{redis_id}:verified_address_ids"
    addr_ids.each {|id| $redis.rpush "set_id:#{redis_id}:verified_address_ids", id}
  end

end
