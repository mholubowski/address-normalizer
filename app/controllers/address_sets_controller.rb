class AddressSetsController < ApplicationController
  def new
  end

  def create
    file_id = params[:uploaded_file_id]
    file = UploadedFile.find(file_id)
    # TODO BUG @set is nil in the view
    set = FileParser.create_address_set_from_file file
    binding.pry
    if set.save
      redirect_to address_set_path(set)
    end
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
end
