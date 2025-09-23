require "test_helper"

class DocumentiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get documenti_index_url
    assert_response :success
  end

  test "should get show" do
    get documenti_show_url
    assert_response :success
  end

  test "should get new" do
    get documenti_new_url
    assert_response :success
  end

  test "should get create" do
    get documenti_create_url
    assert_response :success
  end

  test "should get edit" do
    get documenti_edit_url
    assert_response :success
  end

  test "should get update" do
    get documenti_update_url
    assert_response :success
  end

  test "should get destroy" do
    get documenti_destroy_url
    assert_response :success
  end
end
