module UploadedFilesHelper
  def time_to_address_set row_count
    time_per_row = 0.015
    seconds = row_count * time_per_row + 1
    seconds = seconds.round
    if seconds < 60
      "#{seconds} seconds"
    else
      "#{seconds/60} minutes #{seconds%60} seconds"
    end
  end
end
