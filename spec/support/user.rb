class User
  attr_accessor :id, :name

  def initialize(attrs = {})
    attrs.each_pair do |k, v|
      send("#{k}=", v)
    end
  end
end
