module Haml::Helpers
  def content(template, *args)
    file = "content/#{template.to_s}.md"
    doc = Maruku.new(File.read(file))
    return doc.to_html
  end
end
