class Cell < Element
  def initialize(params)
    # rubocop:disable Style/SuperArguments
    @solid = params[:solid]

    super(params)
    @path = default_image_path
    # rubocop:enable Style/SuperArguments
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
