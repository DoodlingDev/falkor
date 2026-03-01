class Maze < Stage
  attr_reader :game, :inputs

  def tick(inputs)
    @inputs = inputs

    PlayerGridMovement.handle(
      hero: @game[:hero],
      grid: @game[:grid],
      game: @game
    )
  end

  def draw
    @game[:grid].each { |cell| @game.draw(cell) }

    @game.draw(@game[:hero])
  end

  private

  def color_hero_tile_red
    # set all tiles to white
    @game[:grid].each { |cell| cell.path = cell.default_image_path }
    player_loc = @game[:grid].screen_to_grid(
      x: @game[:hero].mid_x,
      y: @game[:hero].mid_y
    )

    # set the cell the player is in to red
    @game[:grid].at(x: player_loc[:x], y: player_loc[:y]).path = "sprites/red_tile.png"
  end
end
