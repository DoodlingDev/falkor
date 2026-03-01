class Debugger
  def initialize(game)
    @game = game
    @messages = []
  end

  def init_controls
    return if @controls

    @controls = {}
    @game.config[:debug][:controls].each { @controls[_1] = _2 }
  end

  def <<(message)
    add_msg(message)
  end

  def on?(value)
    @controls[value] ||= false
  end

  def menu
    @controls.each do |control, value|
      puts "#{control} => #{value}"
    end
  end

  def flip(control)
    @controls[control] = !@controls[control]
  end

  def add_msg(*message)
    @messages << if message.length > 1
                   "#{message[0]}: #{message[1]}"
                 else
                   message
                 end
  end

  def draw
    built_in_messages

    @messages.each_with_index do |msg, i|
      @game.add_label(
        @game.config[:debug][:message_x_start],
        @game.config[:debug][:message_y_start] - (i * 25),
        msg
      )
    end

    @messages = []
  end

  def built_in_messages
    @messages.prepend mouse_debug if on?(:mouse)
  end

  def mouse_debug
    "mouse: x(#{@game.mouse[:x].to_i.to_s.rjust(4)}) y(#{@game.mouse[:y].to_i.to_s.rjust(4)}) #{@game.mouse[:left] ? 'X' : '_'} #{@game.mouse[:right] ? 'X' : '_'}"
  end
end
