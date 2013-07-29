class FileParserWorker 
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  
  def perform(uploaded_file_id)
    # (1..100).each do |i|
    #   at i, 100, 'Working'
    #   sleep 1
    # end

    file = UploadedFile.find(uploaded_file_id)
    row_count = file.row_count
    store row_count: row_count

    status_proc = Proc.new {|current, total| at current, total}


    set = FileParser.create_address_set_from_file file, status_proc

    set.save

    store address_set_id: set.id

  end

end
