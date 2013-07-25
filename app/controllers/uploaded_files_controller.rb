class UploadedFilesController < ApplicationController

  def index
  end

  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    file   = params[:uploaded_file][:thefile]
    @uploaded_file = UploadedFile.new {|u| u.file = file}
    if @uploaded_file.save # before_create
      redirect_to edit_uploaded_file_path(@uploaded_file)
    else
      # flash error
      # redirect_to new_uploaded_file_path
      render 'new'
    end
  end

  def edit
    @file = UploadedFile.find(params[:id])
  end

  def update
  end

  def destroy
  end

end
