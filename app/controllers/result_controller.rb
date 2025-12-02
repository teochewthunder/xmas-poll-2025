require "httparty"

class ResultController < ApplicationController
  ORDS_API_URL = ENV["ORDS_API_URL"] + "/results"

  def index
    response = HTTParty.get(
      ORDS_API_URL
    )

    if response.code == 200
      @api_data = response.parsed_response
    else
      flash.now[:alert] = "Error fetching data."
      @api_data = {}
    end
  end
end
