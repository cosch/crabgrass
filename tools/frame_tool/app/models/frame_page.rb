
class FramePage < Page
  alias_method :frame, :data

  def external_url=(foo)
    frame.url=foo
    frame.save!
  end

  def external_url
    frame.url
  end

  # def create_frame(foo)
  #   puts "foo: #{foo}"
  #   foo = "http://www.heise.de" unless foo
  #   foo = foo[:url] if foo.is_a?(Hash)
  #   puts "foo: #{foo}"
  #   self.data = Frame.new do | f |      
  #     f.url=foo
  #     f.name=foo[0..10]
  #     f.save!
  #   end
  # end
  
end
