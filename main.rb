# prints debugging statements about require calls
# $gtk.debug_require!

require_relative "utils/require"
require_relative "lib/erebor"
Require.recursive_from "app"

# rubocop:disable Style/GlobalVars
$g = Game.new

# Useful console messages

# allows for opening the dragonruby console with `
$gtk.enable_console

def tick(_)
  $g.tick
end
# rubocop:enable Style/GlobalVars
