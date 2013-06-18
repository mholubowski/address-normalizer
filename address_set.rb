class AddressSet
  include Enumerable
  attr_reader :addresses

  def initialize
    @addresses = [1,3]
  end

  def each
    addresses.each {|ad| yield ad}
  end

  def << address
    addresses << address
  end

  def merge address_set
    unless address_set.class == self.class
      raise 'Can only merge another AddressSet'
    end
    address_set.each do |ad|
      addresses << ad
    end
  end

end

a = AddressSet.new
b = AddressSet.new

p a.addresses
a.merge b
p a.addresses
