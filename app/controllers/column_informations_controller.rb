class ColumnInformationsController < ApplicationController
  def create
    columns  = JSON.parse(params[:column_info])

    info = ColumnInformation.create(columns)

    @file = UploadedFile.find(params[:file_id])
    @file.column_information = info
  end
end
