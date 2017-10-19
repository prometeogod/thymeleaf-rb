$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require_relative 'thymeleaftest_test'
require 'thymeleaf'
require 'thymeleaf_test'

# TODO: MiniTest Spec
class TestFileLibTest < TestThymeleafTestLib

  def test_testfile_of_testname
    file = get_filetest "valid_content"
    testfile = ThymeleafTest::TestFile.new file
    assert testfile.is_a? ThymeleafTest::TestFile

    assert testfile.context?
    assert_equal testfile.context, eval(TEST_DEFAULT_CONTEXT)
  end

  def test_testfile_of_file
    file = load_filetest "valid_content"
    testfile = ThymeleafTest::TestFile.new file
    assert testfile.is_a? ThymeleafTest::TestFile

    assert testfile.context?
    assert_equal testfile.context, eval(TEST_DEFAULT_CONTEXT)
  end

  def test_testfile_content
    ThymeleafTest::TestDir::find("**", TEST_FILETYPE) do |testfile|
      assert testfile.context?
      assert_equal testfile.context, eval(TEST_DEFAULT_CONTEXT)
    end
  end

  def test_testfile_no_th
    file = load_filetest "no_th"
    testfile = ThymeleafTest::TestFile.new file

    assert testfile.context?
    assert_equal testfile.context, eval(TEST_DEFAULT_CONTEXT)

    refute testfile.th?
    assert_nil testfile.th_template

    refute testfile.erb?
    assert_nil testfile.erb_template

    refute testfile.expected?
    assert_nil testfile.expected_fragment
  end

  def test_testfile_no_erb
    file = load_filetest "no_erb"
    testfile = ThymeleafTest::TestFile.new file

    assert testfile.context?
    assert_equal testfile.context, eval(TEST_DEFAULT_CONTEXT)

    assert testfile.th?
    assert_equal testfile.th_template, TEST_DEFAULT_TH

    refute testfile.erb?
    assert_nil testfile.erb_template

    assert testfile.expected?
    assert_equal testfile.expected_fragment, TEST_DEFAULT_EXPECTED
  end

  def test_testfile_name
    file1 = load_filetest "valid_content"
    file2 = load_filetest "no_erb"

    testfile1_1 = ThymeleafTest::TestFile.new file1.clone
    testfile1_2 = ThymeleafTest::TestFile.new file1
    testfile2 = ThymeleafTest::TestFile.new file2

    assert testfile1_1.test_name.eql? testfile1_2.test_name
    refute testfile1_1.test_name.eql? testfile2.test_name

    # Checks uniqueid generates an unique value for each call
    refute testfile1_1.test_name(:add_uniqueid).eql? testfile1_2.test_name(:add_uniqueid)
    refute testfile1_1.test_name(:add_uniqueid).eql? testfile1_1.test_name(:add_uniqueid)
    refute testfile1_2.test_name(:add_uniqueid).eql? testfile1_2.test_name(:add_uniqueid)

  end

  def test_testfile_render_test
    Thymeleaf.configure do |config|
      config.template.prefix = "test/templates/"
      config.template.suffix = '.th.html'
    end
    ThymeleafTest::TestDir::find("test/templates/**") do |file|
      if file != '.' && file != '..'
          assert_equal file.render_test, file.expected_fragment
      end
    end
  end

end