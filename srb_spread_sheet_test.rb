require "test/unit"
require "srb_spread_sheet"

class SrbSpreadSheetTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  #test spreadsheet file name
  def test_file_name
    file_name = SrbSpreadSheet.get_full_xls_file_name
    assert_equal('/Users/benjaminleadholm/Documents/CliffBaseball.xls',file_name,"file name not equal")
  end
  #test spreadsheet load
  def test_get_xl_workbook
    book = SrbSpreadSheet.get_workbook
    assert_not_nil(book,"no workbook found")
  end
  #test spreadsheet
  # Fake test
  #def test_fail
  #
  #  # To change this template use File | Settings | File Templates.
  #  fail("Not implemented")
  #end
end