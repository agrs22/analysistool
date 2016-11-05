require 'test_helper'

class UsernamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @username = usernames(:one)
  end

  test "should get index" do
    get usernames_url
    assert_response :success
  end

  test "should get new" do
    get new_username_url
    assert_response :success
  end

  test "should create username" do
    assert_difference('Username.count') do
      post usernames_url, params: { username: { username: @username.username } }
    end

    assert_redirected_to username_url(Username.last)
  end

  test "should show username" do
    get username_url(@username)
    assert_response :success
  end

  test "should get edit" do
    get edit_username_url(@username)
    assert_response :success
  end

  test "should update username" do
    patch username_url(@username), params: { username: { username: @username.username } }
    assert_redirected_to username_url(@username)
  end

  test "should destroy username" do
    assert_difference('Username.count', -1) do
      delete username_url(@username)
    end

    assert_redirected_to usernames_url
  end
end
