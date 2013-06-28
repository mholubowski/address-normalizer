def enforce_logged_in
	#TODO flash must be logged in
	redirect to('/login') unless session?
end
