class AddressSet
  include Enumerable
  attr_accessor :addresses

  def initialize
    @addresses = []
    @stats = {}
  end

  def each
    @addresses.each {|ad| yield ad}
  end

  def <<(address)
    @addresses << address
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
    addresses + other_set.addresses
  end

  def concat(other_set)
    addresses.concat other_set.addresses
  end

  def count_unique_occurences
    h = Hash.new(0)
    addresses.each {|address| h[address] += 1}
    return h      
  end

  def to_ary
    addresses
  end

  def &(other_set)
    @addresses & other_set.addresses
  end

end