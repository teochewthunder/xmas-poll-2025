require "test_helper"

class PollControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_response :success
    assert_not_nil assigns(:api_data)
  end
end
