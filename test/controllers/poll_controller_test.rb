require "test_helper"

class PollControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get poll_page_url
    assert_response :success
    assert_not_nil assigns(:api_data)
  end

  test "should submit results" do
    post submit_poll_form_url, params: { answers: { "1" => "3", "2" => "5", "3" => "2"} }
    assert_response :redirect
    assert_redirected_to root_path
    assert_not_nil flash[:notice]
  end
end
