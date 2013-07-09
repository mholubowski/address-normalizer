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

def time_to_verify count
  seconds = count * 1.6 + 1
  seconds = seconds.round
  if seconds < 60
    "#{seconds} sec"
  else
    "#{seconds/60} min #{seconds%60} sec"
  end
end


