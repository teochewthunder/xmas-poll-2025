require "httparty"
require "oauth2"

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
Rails.logger.info "Payloa #{payload.to_json}"
    
    # 1. Obtain an access token
    access_token = get_access_token

    if access_token.nil?
      flash[:alert] = "Failed to obtain access token."
      redirect_to root_path
      return
    end

    # 2. Prepare and send the request with the access token
    answers = params[:answers]
    payload = { answers: answers }

    response = HTTParty.post(
      "https://oracleapex.com/ords/teochewthunder/polls/poll/1",
      body: payload.to_json,
      headers: { 
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
      }
    )

    # 3. Handle the response
    if response.code == 200
      flash[:notice] = "Submission successful!"
    else
      flash[:alert] = "API error: #{response.body}"
    end

    redirect_to root_path
  end

  private

  def get_access_token
    # This example uses a simple token retrieval. For production,
    # you would cache the token to avoid requesting a new one on every request.
    client = OAuth2::Client.new(
      ORDS_CLIENT_ID,
      ORDS_CLIENT_SECRET,
      token_url: ORDS_TOKEN_URL
    )
    
    begin
      token = client.client_credentials.get_token
      token.token
    rescue OAuth2::Error => e
      Rails.logger.error "OAuth2 Error: #{e.message}"
      nil
    end
  end
  end
end
