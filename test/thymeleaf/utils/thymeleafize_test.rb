$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'thymeleaf-test'

class TestUtilsThymeleafize < TestThymeleaf
	require 'thymeleaf/utils/thymeleafize'
	
	def self.add_test name, &block
	    define_method "test_thymeleafize_#{name}", &block
	end
end

	# Correct thymeleaf expresions
	{
	  :dataThText             => '<div data-th-text="${}"></div>'
	  
	}.each_pair do |test_name, test_word|
	  TestUtilsThymeleafize.add_test test_name.to_s do
	    assert (thymeleafize test_word)
	  end
	end

	# No thymeleaf expressions
	{
	   :divsimple    => '<div attr=""></div>' ,
	   :tablerow     => '<tr><td>Nombre</td><td>Precio</td></tr>'
	}.each_pair do |test_name, test_word|
	  TestUtilsThymeleafize.add_test test_name.to_s do
	    refute (thymeleafize test_word)
	  end
	end
