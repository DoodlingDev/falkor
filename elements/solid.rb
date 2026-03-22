module Falkor
  class Solid < Element
    def initialize(params)
      # rubocop:disable Style/SuperArguments
      super(params)
      # rubocop:enable Style/SuperArguments

      @primitive_marker = :solid
    end
  end
end
