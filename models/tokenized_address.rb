require 'street_address'
require_relative 'address_set'

class TokenizedAddress
  #-- DataMapper
  # include DataMapper::Resource
  # has n, :address_sets, through: Resource

  # property :id, Serial
  # property :address, String
  # property :number, String
  # property :street, String
  # property :street_type, String
  # property :unit, String
  # property :unit_prefix, String
  # property :suffix, String
  # property :prefix, String
  # property :city, String
  # property :state, String
  # property :postal_code, String
  # property :postal_code_ext, String
  # property :init_string, String
  # #--

  # before :save, :create_using_street_address_gem

  attr_accessor :address, :number, :street, :street_type, :unit, 
                :unit_prefix, :suffix, :prefix, :city, :state, 
                :postal_code, :postal_code_ext

  def initialize (string, options = {informal: true})

    obj = StreetAddress::US.parse(string, options)
    #TODO catch malformed
    return if obj.nil?

    @address          = obj.to_s
    @number           = obj.number 
    @street           = obj.street
    @street_type      = obj.street_type
    @unit             = obj.unit
    @unit_prefix      = obj.unit_prefix
    @suffix           = obj.suffix
    @prefix           = obj.prefix
    @city             = obj.city
    @state            = obj.state
    @postal_code      = obj.postal_code
    @postal_code_ext  = obj.postal_code_ext
  end

  def == (other_object)
    self.to_hash == other_object.to_hash
  end

  def to_hash
    obj = {}

    obj[:address]         = @address          
    obj[:number]          = @number           
    obj[:street]          = @street           
    obj[:street_type]     = @street_type      
    obj[:unit]            = @unit             
    obj[:unit_prefix]     = @unit_prefix      
    obj[:suffix]          = @suffix           
    obj[:prefix]          = @prefix           
    obj[:city]            = @city             
    obj[:state]           = @state            
    obj[:postal_code]     = @postal_code      
    obj[:postal_code_ext] = @postal_code_ext

    return obj  
  end

  def hash
    self.to_hash.hash
  end

  def eql? (other_object)
    self == other_object
  end

  def to_redis
    id = $redis.incr 'global:address_id'
    $redis.hmset("address_id:#{id}:hash", *self.to_hash.flatten)
    return id
  end

def redis
  RedisDb.instance
end
end
