require 'test_helper'

class AssociationWithUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @association_with_user = association_with_users(:one)
  end

  test "should get index" do
    get association_with_users_url, as: :json
    assert_response :success
  end

  test "should create association_with_user" do
    assert_difference('AssociationWithUser.count') do
      post association_with_users_url, params: { association_with_user: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show association_with_user" do
    get association_with_user_url(@association_with_user), as: :json
    assert_response :success
  end

  test "should update association_with_user" do
    patch association_with_user_url(@association_with_user), params: { association_with_user: {  } }, as: :json
    assert_response 200
  end

  test "should destroy association_with_user" do
    assert_difference('AssociationWithUser.count', -1) do
      delete association_with_user_url(@association_with_user), as: :json
    end

    assert_response 204
  end
end
