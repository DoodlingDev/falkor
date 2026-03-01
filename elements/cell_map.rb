module Falkor
  class CellMap
    include Enumerable

    COMPASS_ROSE = {
      north: {x: 0, y: 1},
      north_east: {x: 1, y: 1},
      east: {x: 1, y: 0},
      south_east: {x: 1, y: -1},
      south: {x: 0, y: -1},
      south_west: {x: -1, y: -1},
      west: {x: -1, y: 0},
      north_west: {x: -1, y: 1}
    }.freeze

    def self.north = COMPASS_ROSE[:north]

    def self.north_east = COMPASS_ROSE[:north_east]

    def self.east = COMPASS_ROSE[:east]

    def self.south_east = COMPASS_ROSE[:south_east]

    def self.south = COMPASS_ROSE[:south]

    def self.south_west = COMPASS_ROSE[:south_west]

    def self.west = COMPASS_ROSE[:west]

    def self.north_west = COMPASS_ROSE[:north_west]

    def self.direction_vector(direction)
      if COMPASS_ROSE.key? direction
        send(direction)
      end
    end

    def self.direction(vector)
      COMPASS_ROSE.invert[vector]
    end

    # self.move would return the coords without cell
    #   because it's independant of any data in the state
    #   like an instance of cell_map is

    def initialize(width, height, &block)
      @width = width
      @height = height
      @state = []

      @height.times do |y|
        row = []

        @width.times do |x|
          row << if block
            yield(x, y)
          else
            {}
          end
        end

        @state << row
      end
    end

    def each
      @state.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          yield cell, x, y
        end
      end
    end

    def random_cell
      col = Numeric.rand(0...@width)
      row = Numeric.rand(0...@height)
      @state[row][col]
    end

    def at(x:, y:)
      @state[y][x]
    end

    def origin = @state[0][0]

    def screen_to_grid(x:, y:)
      screen_x = x
      screen_y = y

      colsearch = (0..@width).find do |col|
        next_col = col + 1
        break @width - 1 if next_col == @width

        col_cursor_cell = at(x: col, y: 0)
        break 0 if screen_x <= col_cursor_cell.x

        col_next_cell = at(x: next_col, y: 0)

        screen_x.between?(col_cursor_cell.x, col_next_cell.x)
      end

      rowsearch = (0..@height).find do |row|
        next_row = row + 1
        break @height - 1 if next_row == @height

        row_cursor_cell = at(x: 0, y: row)
        break 0 if screen_y <= row_cursor_cell.y

        row_next_cell = at(x: 0, y: next_row)

        screen_y.between?(row_cursor_cell.y, row_next_cell.y)
      end

      {x: colsearch, y: rowsearch}
    end

    def column_x_values
    end

    def move(x, y, v)
      if v.is_a?(Symbol)
        return nil unless COMPASS_ROSE.key? v

        new_x = x + COMPASS_ROSE[v][:x]
        new_y = y + COMPASS_ROSE[v][:y]
      else
        new_x = x + v[:x]
        new_y = y + v[:y]
      end

      return nil if out_of_bounds?(new_x, new_y)

      @state[new_y][new_x] if @state[new_y]
    end

    def out_of_bounds?(x, y)
      x.negative? || y.negative? || x >= @width || y >= @height
    end

    def neighbors(x, y)
      {
        north: move(x, y, :north),
        north_east: move(x, y, :north_east),
        east: move(x, y, :east),
        south_east: move(x, y, :south_east),
        south: move(x, y, :south),
        south_west: move(x, y, :south_west),
        west: move(x, y, :west),
        north_west: move(x, y, :north_west)
      }
    end

    def ortiogonal_neighbors(x, y)
      {
        north: move(x, y, :north),
        east: move(x, y, :east),
        south: move(x, y, :south),
        west: move(x, y, :west)
      }
    end

    def diagonal_neighbors(x, y)
      {
        north_east: move(x, y, :north_east),
        south_east: move(x, y, :south_east),
        south_west: move(x, y, :south_west),
        north_west: move(x, y, :north_west)
      }
    end
  end
end
