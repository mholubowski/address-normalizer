class UploadedFilesController < ApplicationController
  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    @file = params[:uploaded_file][:thefile].tempfile
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
