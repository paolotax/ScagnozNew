require "test_helper"

class SoggettiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get soggetti_index_url
    assert_response :success
  end

  test "should get show" do
    get soggetti_show_url
    assert_response :success
  end

  test "should get new" do
    get soggetti_new_url
    assert_response :success
  end

  test "should get create" do
    get soggetti_create_url
    assert_response :success
  end

  test "should get edit" do
    get soggetti_edit_url
    assert_response :success
  end

  test "should get update" do
    get soggetti_update_url
    assert_response :success
  end

  test "should get destroy" do
    get soggetti_destroy_url
    assert_response :success
  end
end
