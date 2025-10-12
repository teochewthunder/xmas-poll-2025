require "test_helper"

class PollControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get poll_index_url
    assert_response :success
  end
end
