class UploadedFilesController < ApplicationController
  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    # Store file in S3
    @file = params[:uploaded_file][:thefile].tempfile
    binding.pry
    # @uploaded_file = UploadedF
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
