class Loading < Stage
  def tick(_)
    configs
    establish_grid

    hero = Player.new(
      x: @game[:grid].at(x: 1, y: 19).x,
      y: @game[:grid].at(x: 1, y: 19).y,
      size: @game.config[:tile_size]
    )
    @game[:hero] = hero
    @game.stage = :maze
  end

  def draw
  end

  def configs
    @game.config = {
      tile_size: 16,
      grid_height: 21,
      grid_width: 19,

      player_move: 5.0
    }

    @game.config[:h_grid_size] = @game.config[:tile_size] * @game.config[:grid_width]
    @game.config[:v_grid_size] = @game.config[:tile_size] * @game.config[:grid_height]
    @game.config[:h_centering_offset] = (1280 - @game.config[:h_grid_size]) / 2
    @game.config[:v_centering_offset] = (720 - @game.config[:v_grid_size]) / 2
  end

  def establish_grid
    grid = CellMap.new(@game.config[:grid_width], @game.config[:grid_height]) do |x, y|
      Cell.new(
        x: x * @game.config[:tile_size] + @game.config[:h_centering_offset],
        y: y * @game.config[:tile_size] + @game.config[:v_centering_offset],
        size: @game.config[:tile_size],
        solid: solid?(x, y)
      )
    end
    @game[:grid] = grid
  end

  def solid?(x, y)
    layout = [
      "XXXXXXXXXXXXXXXXXXX",
      "X                 X",
      "X XXXXXX X XXXXXX X",
      "X    X   X   X    X",
      "XX X X XXXXX X X XX",
      "X  X           X  X",
      "X XX XXX X XXX XX X",
      "X        X        X",
      "XXXX X XXXXX X XXXX",
      "X  X X       X    X",
      "X XX X XXXXX X XX X",
      "X    X       X X  X",
      "XXXX   X X X   XXXX",
      "X    XXX X XXX    X",
      "X XX X   X   X XX X",
      "X  X X XXXXX X X  X",
      "XX X           X XX",
      "X  X X XXXXX X X  X",
      "X XX X X X X X XX X",
      "X    X   X   X    X",
      "XXXXXXXXXXXXXXXXXXX"
    ]

    layout[y][x] == "X"
  end
end
