class VerifiedAddress
  attr_accessor :address

  def initialize str
    @address = str
  end

  def to_hash
    {address: @address}
  end

  def save
    id = $redis.incr 'global:verified_address_id'
    $redis.hmset("verified_address_id:#{id}:hash", *self.to_hash.flatten)
    return id
  end

end
