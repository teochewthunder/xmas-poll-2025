require "httparty"
require "oauth2"

class PollController < ApplicationController
  ORDS_TOKEN_URL = ENV["ORDS_TOKEN_URL"]
  ORDS_CLIENT_ID = ENV["ORDS_CLIENT_ID"]
  ORDS_CLIENT_SECRET = ENV["ORDS_CLIENT_SECRET"]
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
        'Content-Type' => 'application/json'
      }
    )

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
Rails.logger.info ORDS_CLIENT_ID
Rails.logger.info ORDS_CLIENT_SECRET
Rails.logger.info ORDS_TOKEN_URL

    connection_opts = {
      request: {
        open_timeout: 15,  # Timeout in seconds for opening the connection
        read_timeout: 30   # Timeout in seconds for reading the response
      }
    }
  
    client = OAuth2::Client.new(
      ORDS_CLIENT_ID,
      ORDS_CLIENT_SECRET,
      token_url: ORDS_TOKEN_URL,
      connection_opts: connection_opts
    )
    
    begin
      token = client.client_credentials.get_token
      token.token
      rescue OAuth2::Error => e
        Rails.logger.error "OAuth2 Error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        nil
    end
  end
end
