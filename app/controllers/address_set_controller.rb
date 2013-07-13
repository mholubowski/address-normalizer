class AddressSetController < ApplicationController
  def new
  end

  def create
    file = UploadedFile.find(id)
    set = FileParser.create_address_set file
    if set.save
      redirect_to address_set_path(set)
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
  end
end
