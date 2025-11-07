require "httparty"

class PollController < ApplicationController
  ORDS_API_URL = ENV["ORDS_API_URL"]

  def index
    response = HTTParty.get(
      ORDS_API_URL
    )

    if response.code == 200
      @api_data = response.parsed_response
    else
      flash.now[:alert] = "Error fetching data: #{response.body}"
      @api_data = {}
    end
  end

  def submit
    answers = params[:answers]
    payload = { answers: answers }

    response = HTTParty.post(
      ORDS_API_URL,
      body: payload.to_json,
      headers: { 
        "Content-Type" => "application/json"
      }
    )

    if response.code == 200
      flash[:notice] = "Submission successful!"
    else
      flash[:alert] = "API error: #{response.body}"
    end

    redirect_to root_path
  end
end
