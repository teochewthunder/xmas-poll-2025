require "httparty"

class PollController < ApplicationController
  def index
    response = HTTParty.get("https://oracleapex.com/ords/teochewthunder/polls/poll/1")

    if response.code == 200
      @api_data = response.parsed_response
    else
      flash.now[:alert] = "Error fetching data: #{response.body}"
      @api_data = {}
    end
  end

  def submit
    # 1. Extract the data
    answers = params[:answers]

    # 2. Build the payload
    payload = {
      answers: answers
    }
Rails.logger.info "Payloa #{payload.to_json}"
    # 3. Make the POST request with httparty
    response = HTTParty.post(
      "https://oracleapex.com/ords/teochewthunder/polls/poll/1",
      body: payload.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    # 4. Handle the response
    if response.code == 200
      flash[:notice] = "Submission successful!"
    else
      flash[:alert] = "API error: #{response.code}"
    end

    redirect_to root_path
  end
end
