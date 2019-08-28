require 'test_helper'

class SignupUserTest < ActionDispatch::IntegrationTest

    test "get signup form and signup" do
    get signup_url
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_url params: { user: { username: "Bob", email: "bob@example.com", password: "password"  } }
      assert_response :redirect
      follow_redirect!
    end
    get users_path
    assert_template 'users/index'
    assert_match "Bob", response.body
  end
end
