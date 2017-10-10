

class ThNokoTestRunner
  

  def self.render(testfile)
  	require_relative '../../compare/thymeleaf-Noko/thymeleaf-Noko'
  	ThymeleafNoko::Template.new(testfile.th_template, testfile.context).render
  end
 
end