module Falkor
  class Player < Element
    def self.move = 2

    attr_reader :momentum

    def initialize(params)
      super(x: params[:x], y: params[:y], size: params[:size], path: "sprites/hero.png")
      @momentum = Momentum.new
    end

    def moving? = !@momentum.still?
    def still? = @momentum.still?

    def move_east
      @x += Player.move
      @momentum.east!
    end

    def move_west
      @x -= Player.move
      @momentum.west!
    end

    def move_north
      @y += Player.move
      @momentum.north!
    end

    def move_south
      @y -= Player.move
      @momentum.south!
    end

    def serialize
      {
        momentum: @momentum.to_s
      }
    end
  end
end
