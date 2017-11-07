require 'test_helper'

class AssociationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @association = associations(:one)
  end

  test "should get index" do
    get associations_url, as: :json
    assert_response :success
  end

  test "should create association" do
    assert_difference('Association.count') do
      post associations_url, params: { association: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show association" do
    get association_url(@association), as: :json
    assert_response :success
  end

  test "should update association" do
    patch association_url(@association), params: { association: {  } }, as: :json
    assert_response 200
  end

  test "should destroy association" do
    assert_difference('Association.count', -1) do
      delete association_url(@association), as: :json
    end

    assert_response 204
  end
end
