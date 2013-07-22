class AddressSetsController < ApplicationController
  def new
  end

  def create
    #todo move to sidekiq
    file_id = params[:uploaded_file_id]

    FileParserWorker.perform_async(file_id)




    # file = UploadedFile.find(file_id)
    # TODO BUG @set is nil in the view
    
    # set = FileParser.create_address_set_from_file file

    # if set.save
      # redirect_to address_set_path(set)
    # end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
  end

  def show
    @set = AddressSet.find(params[:id])
  end

  # used to fetch over ajax
  def exporter
    @set = AddressSet.find(params[:id])
    @export_type = params[:export_type].parameterize.underscore.to_sym
    filename = 'NORMALIZED_' + @set.uploaded_file.filename
    respond_to do |format|
      format.html { render partial: 'address_sets/exporter/default' }
      format.csv  { send_data(@set.to_csv(@export_type), filename: filename) }
    end
  end

end
