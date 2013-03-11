# This is a helper that inserts a markdown document from the content/
# directory into a page. Like such:
#
# = content :faq
#
# For an example, check out views/faq.haml.
module Haml::Helpers
  def content(template, *args)
    file = "content/#{template.to_s}.md"
    doc = Maruku.new(File.read(file))
    return doc.to_html
  end
end
