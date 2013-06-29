require_relative 'tokenized_address'

class AddressSet
  #-- DataMapper
  # include DataMapper::Resource
  # has n, :tokenized_addresses, through: Resource

  # property :id, Serial
  #--

  include Enumerable

  attr_accessor :tokenized_addresses, :stats
  attr_reader :random_hash

  def initialize (stats = {})
    @tokenized_addresses = []
    @stats = stats
    @random_hash = SecureRandom.hex 5
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

end
