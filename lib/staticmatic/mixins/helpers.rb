module StaticMatic::HelpersMixin
  # Loads any helpers present in the helpers dir and mixes them into the template helpers
  def load_helpers

    Dir["#{@src_dir}/helpers/**/*_helper.rb"].each do |helper|
      load_helper(helper)
    end
  end

  def load_helper(helper)
    load helper
    module_name = File.basename(helper, '.rb').gsub(/(^|\_)./) { |c| c.upcase }.gsub(/\_/, '')
    Haml::Helpers.class_eval("include #{module_name}")
  end
end
