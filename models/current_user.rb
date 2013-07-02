module CurrentUser

	def self.set_ids=val
		@set_ids = val
	end

	def self.set_ids
		@set_ids ||= []
	end

end