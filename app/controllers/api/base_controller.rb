class Api::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :json_only

  respond_to :json

  protected

  def json_only
    request.format = 'json'
  end

end
