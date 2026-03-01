module Falkor
  class Game
    attr_accessor :config

    # rubocop:disable Style/GlobalVars
    def initialize(stage: Stage, initial_stage: :loading, args: $args)
      # rubocop:enable Style/GlobalVars
      @args = args
      @stage_klass = stage
      @stage = @stage_klass.create(initial_stage, self)
      @state = {}
      @config = {}
      @tick = 0
    end

    def stage = @stage.name

    def tick_num = @tick

    def inputs = @args.inputs

    def []=(key, value)
      @state[key] = value
    end

    def [](key)
      @state[key]
    end

    def tick
      @stage.tick
      @stage.draw

      update_stage if @next_stage
      @tick += 1
    end

    def debug(message)
      @args.outputs.debug << message
    end

    def label(x, y, message)
      @args.outputs.labels << [x, y, message]
    end

    def draw(primitive)
      @args.outputs.primitives << primitive
    end

    def stage=(stage_slug)
      @next_stage = stage_slug
    end

    def mouse
      {x: @args.mouse.x,
       y: @args.mouse.y,
       left: @args.mouse.button_left,
       right: @args.mouse.button_right}
    end

    def mouse_inside?(element)
      @args.inputs.mouse.inside_rect? element
    end

    def method_missing(method_name, *arguments, &block)
      if @args.gtk.respond_to?(method_name)
        @args.gtk.send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @args.gtk.respond_to?(method_name) || super
    end

    private

    def draw_cursor
      hide_cursor if cursor_shown?
      add_sprite({
        x: mouse[:x] - 14,
        y: mouse[:y] - 38,
        w: 48,
        h: 48,
        path: "sprites/cursor.png"
      })
    end

    def update_stage
      @stage = @stage_klass.create(@next_stage, self)
      @state[@stage.name] ||= {}
      @next_stage = nil
    end
  end
end
