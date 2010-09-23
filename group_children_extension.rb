class GroupChildrenExtension < Radiant::Extension
  version "1.0"
  description "Adds the ability to iterate over a page's children per n items."
  url "http://github.com/jomz/radiant-group_children-extension"
  
  def activate
    Page.send :include, GroupTags
  end
end
