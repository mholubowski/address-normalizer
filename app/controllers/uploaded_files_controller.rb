class UploadedFilesController < ApplicationController
  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    # Store file in S3
    @file = params[:uploaded_file][:thefile]
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
