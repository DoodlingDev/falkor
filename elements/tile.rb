module Falkor
  class Tile < Element
    def initialize(params)
      # DragonRuby does not implement super with arguments
      #   the way rubocop/lsp want it to be done. so disable
      #
      # rubocop:disable Style/SuperArguments
      super(params)
      # rubocop:enable Style/SuperArguments

      @solid = params[:solid]
      @path = default_image_path
    end

    def navigable?
      !@solid
    end

    def default_image_path
      if @solid
        "sprites/solid_cell.png"
      else
        "sprites/open_cell.png"
      end
    end
  end
end
