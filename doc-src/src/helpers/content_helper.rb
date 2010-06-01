module ContentHelper
  def content_navigation(*pages)
    output = "<ul>"
    pages.each do |page|
      anchor = page.downcase.gsub(/\s+/, "_").gsub(/\W+/, "")
      output << %Q{<li><a href="##{anchor}">#{page}</a></li>}
    end
    output << "</ul>"
  end
end