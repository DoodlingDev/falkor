class Element
  class Blendmode
    ENUM = {
      none: 0,
      alpha: 1,
      additive: 2,
      modulo: 3,
      multiply: 4
    }.freeze

    def self.all
      ENUM.keys
    end

    def self.to_enum(name)
      return default if name.nil?

      ENUM[name]
    end

    def self.default
      ENUM[:alpha]
    end
  end

  class ScaleQuality
    ENUM = {
      nearest_neighbor: 0,
      linear: 1,
      anti_aliasing: 2
    }.freeze

    def self.all
      ENUM.keys
    end

    def self.to_enum(name)
      return default if name.nil?

      ENUM[name]
    end

    def self.default
      nil
    end
  end

  attr_accessor :x, :y, :h, :w, :a, :r, :g, :b, :blendmode_enum,
    :scale_quality_enum, :tile_x, :tile_y, :tile_w, :tile_h,
    :source_x, :source_y, :source_w, :source_h, :flip_horizontally,
    :flip_vertically, :anchor_x, :anchor_y, :angle, :angle_anchor_x,
    :angle_anchor_y, :path, :primitive_marker

  def initialize(params)
    @x = params[:x]
    @y = params[:y]
    @size = params[:size]
    @h = params[:h] || @size
    @w = params[:w] || @size
    @a = params[:a] || 255
    @r = params[:r] || 255
    @g = params[:g] || 255
    @b = params[:b] || 255
    @blendmode_enum = params[:blendmode_enum] ||
      Blendmode.to_enum(params[:blendmode])
    @scale_quality_enum = params[:scale_quality_enum] ||
      ScaleQuality.to_enum(params[:scale_quality])
    @tile_x = params[:tile_x]
    @tile_y = params[:tile_y]
    @tile_w = params[:tile_w]
    @tile_h = params[:tile_h]
    @source_x = params[:source_x]
    @source_y = params[:source_y]
    @source_w = params[:source_w]
    @source_h = params[:source_h]
    @flip_horizontally = params[:flip_horizontally] || false
    @flip_vertically = params[:flip_vertically] || false
    @anchor_x = params[:anchor_x]
    @anchor_y = params[:anchor_y]
    @angle = params[:angle] || 0
    @angle_anchor_x = params[:angle_anchor_x] || 0
    @angle_anchor_y = params[:angle_anchor_y] || 0
    @path = params[:path]
    @primitive_marker = params[:primitive_marker] || :sprite
  end

  def left_edge = @x
  def right_edge = @x + @w
  def bottom_edge = @y
  def top_edge = @y + h

  def mid_x
    @x + (@w / 2)
  end

  def mid_y
    @y + (@h / 2)
  end

  def hitbox
    {x: x, y: y, h: h, w: w}
  end
end
