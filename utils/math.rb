module Falkor
  module Math
    def self.random_point_in_circle(horizontal_bounding_radius, vertical_bounding_radius = nil)
      vertical_bounding_radius ||= horizontal_bounding_radius

      t = 2 * ::Math::PI * Numeric.rand
      u = Numeric.rand + Numeric.rand
      r = if u > 1
        2 - u
      else
        u
      end

      [horizontal_bounding_radius * r * ::Math.cos(t), vertical_bounding_radius * r * ::Math.sin(t)]
    end

    def self.normal_rand(mean = 0.5, std_dev = 0.15)
      z = ::Math.sqrt(-2.0 * ::Math.log(Numeric.rand)) * ::Math.cos(2.0 * ::Math::PI * Numeric.rand)
      mean + std_dev * z
    end

    def self.normal_rand_clamped(mean = 0.5, std_dev = 0.15)
      normal_rand(mean, std_dev).clamp(0.0, 1.0)
    end

    def self.normal_in_range(x, y)
      mean = (x + y) / 2.0
      std_dev = (y - x) / 6.0
      normal_rand(mean, std_dev).clamp(x, y)
    end
  end
end
