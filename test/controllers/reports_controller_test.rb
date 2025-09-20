require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get barchart" do
    get reports_barchart_url
    assert_response :success
  end

  test "should get piechart" do
    get reports_piechart_url
    assert_response :success
  end

  test "should get linegraph" do
    get reports_linegraph_url
    assert_response :success
  end
end
