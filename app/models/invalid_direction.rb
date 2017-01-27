class InvalidDirection < StandardError
  def initialize(msg="The direction must be :left, :right, :top, or :bottom")
    super
  end
end
