require "test_helper"

class MagazziniControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get magazzini_index_url
    assert_response :success
  end

  test "should get show" do
    get magazzini_show_url
    assert_response :success
  end

  test "should get new" do
    get magazzini_new_url
    assert_response :success
  end

  test "should get create" do
    get magazzini_create_url
    assert_response :success
  end

  test "should get edit" do
    get magazzini_edit_url
    assert_response :success
  end

  test "should get update" do
    get magazzini_update_url
    assert_response :success
  end

  test "should get destroy" do
    get magazzini_destroy_url
    assert_response :success
  end
end
