class AddressSet
  include Enumerable
  attr_reader :addresses

  def initialize
    @addresses = []
    @stats = {}
  end

  def each
    addresses.each {|ad| yield ad}
  end

  def << address
    addresses << address
  end

  # TODO allow x number of address sets  
  def merge address_set
    unless address_set.class == self.class
      raise 'Can only merge another AddressSet'
    end
    address_set.each do |ad|
      addresses << ad
    end
  end

end
