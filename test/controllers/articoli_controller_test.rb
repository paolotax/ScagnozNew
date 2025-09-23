require "test_helper"

class ArticoliControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get articoli_index_url
    assert_response :success
  end

  test "should get show" do
    get articoli_show_url
    assert_response :success
  end

  test "should get new" do
    get articoli_new_url
    assert_response :success
  end

  test "should get create" do
    get articoli_create_url
    assert_response :success
  end

  test "should get edit" do
    get articoli_edit_url
    assert_response :success
  end

  test "should get update" do
    get articoli_update_url
    assert_response :success
  end

  test "should get destroy" do
    get articoli_destroy_url
    assert_response :success
  end
end
