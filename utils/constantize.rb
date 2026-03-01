class Utils
  def self.constantize(name)
    chars = name.to_s.chars
    name_buffer = ""
    should_capitalize = true
    chars.each do |char|
      if char == "_"
        should_capitalize = true
      elsif should_capitalize
        name_buffer += char.upcase
        should_capitalize = false
      else
        name_buffer += char
      end
    end
    Object.const_get name_buffer.to_sym
  end
end
