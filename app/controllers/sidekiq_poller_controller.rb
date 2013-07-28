class SidekiqPollerController < ApplicationController

  def show
    job_id = params[:id]
    @status = Sidekiq::Status::get_all job_id
    respond_to do |format|
      format.json {render json: @status}
    end
  end

end
