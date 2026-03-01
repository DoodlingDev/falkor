module Falkor
  class Stage
    def initialize(game)
      @game = game
      @state = {}
    end

    def self.create(name, game)
      stage = Utils.constantize(name)
      stage.new(game)
    end

    def tick(...)
      raise "#tick not defined on Stage #{self.class}"
    end

    def draw(...)
      raise "#draw not defined on Stage #{self.class}"
    end

    def name
      arr = self.class.to_s.chars
      name_buffer = ""
      arr.each_with_index do |char, i|
        name_buffer += char.downcase and next if i.zero?

        name_buffer += if char == char.downcase
          char
        else
          "_#{char.downcase}"
        end
      end
      name_buffer.to_sym
    end
  end
end
