module CurrentUser

	def self.set_ids=val
		@set_ids = val
	end

	def self.set_ids
		@set_ids ||= Set.new
	end

  def self.address_sets
    sets = []
    self.set_ids.each {|id| sets << AddressSet.find(id) }
    return sets
  end

end
