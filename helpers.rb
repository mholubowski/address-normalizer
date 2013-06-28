def enforce_logged_in
	#TODO flash must be logged in
	redirect to('/login') unless session?
end

class Array
	def find_set_by_oid(oid)
		index = self.find_index {|set| set.object_id == oid}
		self[index]
	end 

	def destroy_set_by_oid(oid)
		self.delete_if {|set| set.object_id == oid}
	end 
end