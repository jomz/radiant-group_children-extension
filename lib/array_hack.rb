module ArrayHack
  def % len
    inject([]) do |groups, value|
      groups << [] if !groups.last || groups.last.size >= len
      groups.last << value
      groups
    end
  end
end