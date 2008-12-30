require File.dirname(__FILE__) + "/test_helper"

class StaticMatic::TemplateTest < Test::Unit::TestCase
  
  context "old style template names" do
  

    should "determine path to html template" do
      assert_equal "hello_world.erb", StaticMatic::Template.template_path_for("hello_world.html")
    end
  
    should "determine path to css template" do
      assert_equal "stylesheets/application.erb", StaticMatic::Template.template_path_for("stylesheets/application.css")
    end
  end
  
  # StaticMatic::Template.register_extensions(StaticMatic::Template::Erubis, ["erb"])
  should "register template exentions" do
  end
end