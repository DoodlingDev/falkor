class PlayerGridMovement
  def self.handle(game:, hero:, grid:)
    new(game: game, hero: hero, grid: grid).call
  end

  def initialize(game:, hero:, grid:)
    @game = game
    @hero = hero
    @grid = grid
  end

  def call
    @game.debug "hero momentum: #{@hero.serialize[:momentum]}"

    if @hero.still?
      handle_movement_input
    else
      handle_player_momentum
    end
  end

  def handle_movement_input
    if @game.inputs.up
      target_cell = @grid.move(hero_grid[:x], hero_grid[:y], :north)
      @hero.move_north if target_cell.navigable?

    elsif @game.inputs.down
      target_cell = @grid.move(hero_grid[:x], hero_grid[:y], :south)
      @hero.move_south if target_cell.navigable?

    elsif @game.inputs.right
      target_cell = @grid.move(hero_grid[:x], hero_grid[:y], :east)
      @hero.move_east if target_cell.navigable?

    elsif @game.inputs.left
      target_cell = @grid.move(hero_grid[:x], hero_grid[:y], :west)
      @hero.move_west if target_cell.navigable?

    end
  end

  def handle_player_momentum
    hero_center_x = @hero.mid_x
    hero_center_y = @hero.mid_y
    hero_cell = @grid.at(x: hero_grid[:x], y: hero_grid[:y])

    if @hero.momentum.east?
      if hero_center_x == hero_cell.mid_x
        @hero.momentum.still!
      else
        diff = hero_cell.mid_x - hero_center_x
        @hero.x += [Player.move, diff].max
      end
    end

    if @hero.momentum.north?
      if hero_center_y == hero_cell.mid_y
        @hero.momentum.still!
      else
        diff = hero_cell.mid_y - hero_center_y
        @hero.y += [Player.move, diff].max
      end
    end

    if @hero.momentum.west?
      if hero_center_x == hero_cell.mid_x
        @hero.momentum.still!
      else
        diff = hero_center_x - hero_cell.mid_x
        @hero.x -= [Player.move, diff].max
      end
    end

    if @hero.momentum.south?
      if hero_center_y == hero_cell.mid_y
        @hero.momentum.still!
      else
        diff = hero_center_y - hero_cell.mid_y
        @hero.y -= [Player.move, diff].max
      end
    end
  end

  private

  def hero_grid
    @hero_grid ||= @grid.screen_to_grid(
      x: @hero.mid_x,
      y: @hero.mid_y
    )
  end
end
