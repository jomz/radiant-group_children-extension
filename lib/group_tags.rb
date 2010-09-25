module GroupTags
  include Radiant::Taggable
  
  class TagError < StandardError; end
  
  desc %{
    Cycles through groups of child pages. Inside this tag, children:each is available again.
    Takes the same parameters as a normal children:each, except for pagination.
    
    *Usage:*
    
    <pre><code><r:children:grouped [size="number"] [limit="number"]
     [by="published_at|updated_at|created_at|slug|title|keywords|description"]
     [order="asc|desc"] 
     [status="draft|reviewed|published|hidden|all"]
     >
     <div class="container"><r:children:each>...</r:children:each></div>
    </r:children:grouped>
    </code></pre>
  }
  tag 'children:grouped' do |tag|
    options = children_find_options(tag)
    group_size = tag.attr['size'].to_i || 2
    tag.locals.groups = tag.locals.children.all(options).inject([]) do |groups, value|
      groups << [] if !groups.last || groups.last.size >= group_size
      groups.last << value
      groups
    end
    result = []
    tag.locals.groups.map do |group|
      tag.locals.children = group
      tag.locals.first_group = group == tag.locals.groups.first
      tag.locals.last_group = group == tag.locals.groups.last
      result << tag.expand
    end
    result
  end
  
  tag 'children:grouped:if_first' do |tag|
    tag.expand if tag.locals.first_group
  end
  
  tag 'children:grouped:if_last' do |tag|
    tag.expand if tag.locals.last_group
  end
  
  tag 'children:grouped:children' do |tag|
    tag.expand
  end
  
  tag 'children:grouped:children:each' do |tag|
    result = []
    tag.locals.children.map do |page|
      tag.locals.child = page
      tag.locals.page = page
      tag.locals.first_child = page == tag.locals.children.first
      tag.locals.last_child = page == tag.locals.children.last
      result << tag.expand
    end
    result
  end
  
  tag 'children:grouped:children:each:if_first' do |tag|
    tag.expand if tag.locals.first_child
  end
  
  tag 'children:grouped:children:each:if_last' do |tag|
    tag.expand if tag.locals.last_child
  end
  
  private
    def children_find_options(tag)
      attr = tag.attr.symbolize_keys

      options = {}

      [:limit, :offset].each do |symbol|
        if number = attr[symbol]
          if number =~ /^\d{1,4}$/
            options[symbol] = number.to_i
          else
            raise TagError.new("`#{symbol}' attribute of `each' tag must be a positive number between 1 and 4 digits")
          end
        end
      end

      by = (attr[:by] || 'published_at').strip
      order = (attr[:order] || 'asc').strip
      order_string = ''
      if self.attributes.keys.include?(by)
        order_string << by
      else
        raise TagError.new("`by' attribute of `each' tag must be set to a valid field name")
      end
      if order =~ /^(asc|desc)$/i
        order_string << " #{$1.upcase}"
      else
        raise TagError.new(%{`order' attribute of `each' tag must be set to either "asc" or "desc"})
      end
      options[:order] = order_string

      status = (attr[:status] || ( dev?(tag.globals.page.request) ? 'all' : 'published')).downcase
      unless status == 'all'
        stat = Status[status]
        unless stat.nil?
          options[:conditions] = ["(virtual = ?) and (status_id = ?)", false, stat.id]
        else
          raise TagError.new(%{`status' attribute of `each' tag must be set to a valid status})
        end
      else
        options[:conditions] = ["virtual = ?", false]
      end
      options
    end
end
