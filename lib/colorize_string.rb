class String
  def black = colorize(30)
  def red = colorize(31)
  def green = colorize(32)
  def yellow = colorize(33)
  def blue = colorize(34)
  def magenta = colorize(35)
  def cyan = colorize(36)
  def white = colorize(37)

  def bg_black = colorize(40)
  def bg_red = colorize(41)
  def bg_green = colorize(42)
  def bg_yellow = colorize(43)
  def bg_blue = colorize(44)
  def bg_magenta = colorize(45)
  def bg_cyan = colorize(46)
  def bg_white = colorize(47)

  private

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end
