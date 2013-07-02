require_relative 'tokenized_address'

class AddressSet
  include Enumerable

  attr_accessor :tokenized_addresses, :stats
  attr_reader :redis_id 

  def initialize (redis_id_default = nil)
    @tokenized_addresses = []
    @stats = {}
    @redis_id = redis_id_default if redis_id_default
  end

  def self.find_addresses(id)
    addr_ids = $redis.lrange("set_id:#{id}:address_ids", 0, -1)
    response = addr_ids.collect {|id| $redis.hgetall "address_id:#{id}:hash"}
  end

  def self.from_redis(id)
    set = AddressSet.new(id)
    puts "id: #{id}!!!!!"
    set.stats = $redis.hgetall("set_id:#{id}:stats")
    set.tokenized_addresses = AddressSet.find_addresses(id)
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

  def to_redis
    stats_to_redis 

    addr_ids = @tokenized_addresses.collect {|addr| addr.to_redis}

    # pipeline breaks things with setting the redis id
    # $redis.pipelined do
      addr_ids.each {|id| $redis.rpush "set_id:#{redis_id}:address_ids", id}
    # end
    CurrentUser::set_ids << redis_id
  end

  def stats_to_redis
    unless @stats == {}
      $redis.hmset("set_id:#{redis_id}:stats", *@stats.flatten) 
    end
  end


end
