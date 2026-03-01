class Momentum
  def initialize(direction = nil)
    @direction = nil
  end

  def momentum? = !@direction.nil?
  def still? = @direction.nil?
  def east? = @direction == :east
  def west? = @direction == :west
  def south? = @direction == :south
  def north? = @direction == :north

  def north! = @direction = :north
  def south! = @direction = :south
  def east! = @direction = :east
  def west! = @direction = :west
  def still! = @direction = nil

  def to_s = @direction || "nil"
end
