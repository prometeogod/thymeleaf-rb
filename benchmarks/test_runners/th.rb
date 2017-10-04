require_relative '../../lib/thymeleaf'

class ThTestRunner

  def self.render(testfile)

    #Thymeleaf::Template.new(testfile.th_template, testfile.context).render
   	Thymeleaf::Template.new(testfile.th_template, testfile.context).render(testfile.test_path)
  end

end
