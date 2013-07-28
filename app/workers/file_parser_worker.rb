class FileParserWorker 
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  
  def perform(uploaded_file_id)
    file = UploadedFile.find(uploaded_file_id)
    set = FileParser.create_address_set_from_file file
    set.save

    store address_set_id: set.id

    at 5, 100, "Almost done"
  end

end
