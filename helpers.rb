def enforce_logged_in
	#TODO flash must be logged in
	redirect to('/login') unless session?
end

class Array
	def find_set_by_hash(hash)
		index = self.find_index {|set| set.random_hash == hash}
		self[index]
	end 

	def destroy_set_by_hash(hash)
		self.delete_if {|set| set.random_hash == hash}
	end 
end

