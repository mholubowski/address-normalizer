def enforce_logged_in
	#TODO flash must be logged in
	redirect to('/login') unless session?
end

def send_csv options
  filename = options[:filename]
  content  = options[:content]

  headers "Content-Disposition" => "attachment;filename=#{filename}",
            "Content-Type" => "text/csv"
  content
end


