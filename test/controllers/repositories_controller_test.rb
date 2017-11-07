require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:one)
  end

  test "should get index" do
    get repositories_url, as: :json
    assert_response :success
  end

  test "should create repository" do
    assert_difference('Repository.count') do
      post repositories_url, params: { repository: { name: @repository.name } }, as: :json
    end

    assert_response 201
  end

  test "should show repository" do
    get repository_url(@repository), as: :json
    assert_response :success
  end

  test "should update repository" do
    patch repository_url(@repository), params: { repository: { name: @repository.name } }, as: :json
    assert_response 200
  end

  test "should destroy repository" do
    assert_difference('Repository.count', -1) do
      delete repository_url(@repository), as: :json
    end

    assert_response 204
  end
end
