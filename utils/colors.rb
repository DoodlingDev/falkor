module Falkor
  module Color
    def self.values
      {
        maroon: {r: 128, g: 0, b: 0},
        dark_red: {r: 139, g: 0, b: 0},
        red: {r: 255, g: 0, b: 0},
        coral: {r: 255, g: 127, b: 80},
        dark_orange: {r: 255, g: 140, b: 0},
        orange: {r: 255, g: 165, b: 0},
        gold: {r: 255, g: 215, b: 0},
        khaki: {r: 240, g: 230, b: 140},
        olive: {r: 128, g: 128, b: 0},
        yellow: {r: 255, g: 255, b: 0},
        yellow_green: {r: 154, g: 205, b: 50},
        chartreuse: {r: 127, g: 255, b: 0},
        green_yellow: {r: 173, g: 255, b: 47},
        green: {r: 0, g: 128, b: 0},
        forest_green: {r: 34, g: 139, b: 34},
        lime: {r: 0, g: 255, b: 0},
        lime_green: {r: 50, g: 205, b: 50},
        seafoam: {r: 0, g: 250, b: 154},
        teal: {r: 0, g: 128, b: 128},
        cyan: {r: 0, g: 255, b: 255},
        turquoise: {r: 0, g: 206, b: 209},
        corn_flower: {r: 100, g: 149, b: 237},
        sky_blue: {r: 0, g: 191, b: 255},
        midnight_blue: {r: 25, g: 25, b: 112},
        blue: {r: 0, g: 0, b: 255},
        indigo: {r: 0, g: 0, b: 139},
        violet: {r: 148, g: 0, b: 211},
        purple: {r: 128, g: 0, b: 128},
        magenta: {r: 255, g: 0, b: 255},
        deep: {r: 255, g: 20, b: 147},
        hot: {r: 255, g: 105, b: 180},
        pink: {r: 255, g: 182, b: 193},
        white: {r: 255, g: 255, b: 255},
        black: {r: 0, g: 0, b: 0},
        brown: {r: 139, g: 69, b: 19},
        slate: {r: 112, g: 128, b: 144},
        honeydew: {r: 240, g: 255, b: 240},
        ivory: {r: 255, g: 255, b: 240},
        azure: {r: 240, g: 255, b: 255},
        grey_90: {r: 230, g: 230, b: 230},
        grey_80: {r: 205, g: 205, b: 205},
        grey_70: {r: 179, g: 179, b: 179},
        grey_60: {r: 154, g: 154, b: 154},
        grey_50: {r: 128, g: 128, b: 128},
        grey_40: {r: 102, g: 102, b: 102},
        grey_30: {r: 76, g: 76, b: 76},
        grey_20: {r: 51, g: 51, b: 51},
        grey_10: {r: 26, g: 26, b: 26}
      }
    end

    def self.value(name)
      values[name]
    end

    def self.rand_hue_name
      values.keys.sample
    end

    def self.rand_color_name
      values.keys.reject { |n| n.to_s.start_with?("grey", "black") }.sample
    end

    def self.rand
      value(rand_hue_name)
    end

    def self.rand_color
      value(rand_color_name)
    end
  end
end
