require "test_helper"

class ResultControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get result_page_url
    assert_response :success
    assert_not_nil assigns(:api_data)
  end
end
