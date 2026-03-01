class Yaml
  def self.parse(yaml_string)
    new.parse(yaml_string)
  end

  def initialize
    @pos = 0
    @input = ''
    @line = 1
    @col = 1
  end

  def parse(yaml_string)
    @input = yaml_string.strip
    @pos = 0
    @line = 1
    @col = 1

    return nil if @input.empty?

    # Handle document start marker
    if @input.start_with?('---')
      consume_chars(3)
      skip_whitespace
      skip_newlines
    end

    parse_value
  end

  private

  def current_char
    return nil if @pos >= @input.length

    @input[@pos]
  end

  def peek_char(offset = 1)
    pos = @pos + offset
    return nil if pos >= @input.length

    @input[pos]
  end

  def consume_char
    return nil if @pos >= @input.length

    char = @input[@pos]
    @pos += 1
    if char == "\n"
      @line += 1
      @col = 1
    else
      @col += 1
    end
    char
  end

  def consume_chars(count)
    count.times { consume_char }
  end

  def skip_whitespace
    consume_char while [' ', "\t"].include?(current_char)
  end

  def skip_newlines
    consume_char while ["\n", "\r"].include?(current_char)
  end

  def at_end?
    @pos >= @input.length
  end

  def parse_value
    skip_whitespace
    skip_newlines

    return nil if at_end?

    case current_char
    when '['
      parse_flow_sequence
    when '{'
      parse_flow_mapping
    when '"'
      parse_double_quoted_string
    when "'"
      parse_single_quoted_string
    when '|', '>'
      parse_block_scalar
    when '-'
      if [' ', "\n", "\t"].include?(peek_char)
        parse_block_sequence
      else
        parse_plain_scalar
      end
    else
      # Check if it's a mapping (key: value)
      saved_pos = @pos
      saved_line = @line
      saved_col = @col

      # Try to find a colon indicating this is a mapping
      temp_pos = @pos
      while temp_pos < @input.length
        char = @input[temp_pos]
        if char == ':'
          next_char = temp_pos + 1 < @input.length ? @input[temp_pos + 1] : nil
          if next_char == ' ' || next_char == "\n" || next_char == "\t" || next_char.nil?
            # Reset position and parse as mapping
            @pos = saved_pos
            @line = saved_line
            @col = saved_col
            return parse_block_mapping
          end
        elsif char == "\n"
          break
        end
        temp_pos += 1
      end

      parse_plain_scalar
    end
  end

  def parse_flow_sequence
    consume_char # consume '['
    result = []
    skip_whitespace

    return result if current_char == ']'

    loop do
      skip_whitespace
      break if current_char == ']'

      result << parse_value
      skip_whitespace

      if current_char == ','
        consume_char
        skip_whitespace
      elsif current_char == ']'
        break
      else
        raise "Expected ',' or ']' in flow sequence"
      end
    end

    consume_char if current_char == ']' # consume ']'
    result
  end

  def parse_flow_mapping
    consume_char # consume '{'
    result = {}
    skip_whitespace

    return result if current_char == '}'

    loop do
      skip_whitespace
      break if current_char == '}'

      key = parse_value
      skip_whitespace

      raise "Expected ':' after key in flow mapping" if current_char != ':'

      consume_char # consume ':'
      skip_whitespace

      value = parse_value
      result[convert_key_to_symbol(key)] = value
      skip_whitespace

      if current_char == ','
        consume_char
        skip_whitespace
      elsif current_char == '}'
        break
      else
        raise "Expected ',' or '}' in flow mapping"
      end
    end

    consume_char if current_char == '}' # consume '}'
    result
  end

  def parse_double_quoted_string
    consume_char # consume '"'
    result = ''

    while current_char && current_char != '"'
      if current_char == '\\'
        consume_char # consume '\'
        result += case current_char
                  when 'n'
                    "\n"
                  when 't'
                    "\t"
                  when 'r'
                    "\r"
                  when '\\'
                    '\\'
                  when '"'
                    '"'
                  else
                    current_char.to_s
                  end
        consume_char
      else
        result += consume_char
      end
    end

    consume_char if current_char == '"' # consume closing '"'
    result
  end

  def parse_single_quoted_string
    consume_char # consume "'"
    result = ''

    while current_char && current_char != "'"
      if current_char == "'" && peek_char == "'"
        # Double single quote becomes single quote
        consume_char
        consume_char
        result += "'"
      else
        result += consume_char
      end
    end

    consume_char if current_char == "'" # consume closing "'"
    result
  end

  def parse_block_scalar
    indicator = consume_char # consume '|' or '>'
    fold = indicator == '>'

    skip_whitespace
    skip_newlines

    # Get base indentation
    base_indent = get_current_indentation

    lines = []

    while !at_end? && get_current_indentation >= base_indent
      line = read_line
      next if line.strip.empty?

      # Remove base indentation
      if line.length >= base_indent
        lines << line[base_indent..-1] || ''
      else
        lines << line.strip
      end
    end

    if fold
      # Join lines with spaces, preserve paragraph breaks
      result = ''
      lines.each_with_index do |line, i|
        if i == 0
          result = line.rstrip
        elsif line.empty?
          result += "\n"
        else
          result += ' ' + line.lstrip
        end
      end
      result
    else
      lines.join("\n")
    end
  end

  def parse_block_sequence
    result = []
    base_indent = get_current_indentation

    while !at_end? && current_char == '-' &&
          [' ', "\n", "\t"].include?(peek_char)

      current_indent = get_current_indentation
      break if current_indent < base_indent

      consume_char # consume '-'
      skip_whitespace

      if current_char == "\n"
        # Multi-line item
        skip_newlines
        item_indent = get_current_indentation

        saved_pos = @pos
        saved_line = @line
        saved_col = @col

        # Collect all lines for this item
        item_lines = []
        while !at_end? && get_current_indentation >= item_indent
          line_start = @pos
          line = read_line

          # Check if this is a new sequence item
          if line.lstrip.start_with?('-') &&
             get_indentation_at(line_start) == base_indent
            # Rewind and break
            @pos = line_start
            rewind_line
            break
          end

          item_lines << line
        end

        if item_lines.empty?
          result << nil
        else
          # Parse the collected lines as YAML
          item_yaml = item_lines.join("\n")
          parser = Yaml.new
          result << parser.parse(item_yaml)
        end
      else
        # Single line item
        result << parse_value
        skip_to_next_line
      end

      skip_whitespace
      skip_newlines
    end

    result
  end

  def parse_block_mapping
    result = {}
    base_indent = get_current_indentation

    until at_end?
      current_indent = get_current_indentation
      break if current_indent < base_indent

      # Parse key
      key = parse_plain_scalar
      skip_whitespace

      break unless current_char == ':'

      consume_char # consume ':'

      skip_whitespace

      if current_char == "\n"
        # Multi-line value
        skip_newlines
        value_indent = get_current_indentation

        if value_indent <= base_indent
          result[convert_key_to_symbol(key)] = nil
        else
          # Collect value lines
          value_lines = []
          while !at_end? && get_current_indentation >= value_indent
            line_start = @pos
            line = read_line

            # Check if this is a new mapping key
            temp_pos = line_start
            while temp_pos < @input.length &&
                  [' ', "\t"].include?(@input[temp_pos])
              temp_pos += 1
            end

            if get_indentation_at(line_start) == base_indent
              # Look for key: pattern
              colon_pos = line.index(':')
              if colon_pos &&
                 (colon_pos + 1 >= line.length ||
                  line[colon_pos + 1] == ' ' ||
                  line[colon_pos + 1] == "\n" ||
                  line[colon_pos + 1] == "\t")
                # This is a new key, rewind and break
                @pos = line_start
                rewind_line
                break
              end
            end

            value_lines << line
          end

          if value_lines.empty?
            result[convert_key_to_symbol(key)] = nil
          else
            value_yaml = value_lines.join("\n")
            parser = Yaml.new
            result[convert_key_to_symbol(key)] = parser.parse(value_yaml)
          end
        end
      else
        # Single line value
        result[convert_key_to_symbol(key)] = parse_value
        skip_to_next_line
      end

      skip_whitespace
      skip_newlines
    end

    result
  end

  def parse_plain_scalar
    result = ''

    result += consume_char while current_char && !scalar_end_char?(current_char)

    result = result.strip

    # Convert to appropriate type
    convert_scalar_type(result)
  end

  def scalar_end_char?(char)
    ["\n", ':', ',', ']', '}', '#'].include?(char)
  end

  def convert_scalar_type(str)
    return nil if ['null', '~', ''].include?(str)
    return true if str == 'true'
    return false if str == 'false'

    # Try integer
    if str.chars.all? { |c| c >= '0' && c <= '9' } ||
       (str.start_with?('-') && str[1..-1].chars.all? { |c| c >= '0' && c <= '9' })
      return str.to_i
    end

    # Try float
    if str.include?('.') &&
       str.chars.all? { |c| (c >= '0' && c <= '9') || c == '.' || c == '-' }
      return str.to_f
    end

    str
  end

  def convert_key_to_symbol(key)
    case key
    when String
      key.to_sym
    when Symbol
      key
    else
      key.to_s.to_sym
    end
  end

  def get_current_indentation
    return 0 if at_end?

    temp_pos = @pos
    indent = 0

    while temp_pos < @input.length &&
          [' ', "\t"].include?(@input[temp_pos])
      indent += 1
      temp_pos += 1
    end

    indent
  end

  def get_indentation_at(pos)
    indent = 0
    temp_pos = pos

    while temp_pos < @input.length &&
          [' ', "\t"].include?(@input[temp_pos])
      indent += 1
      temp_pos += 1
    end

    indent
  end

  def read_line
    line = ''
    line += consume_char while current_char && current_char != "\n"
    consume_char if current_char == "\n" # consume newline
    line
  end

  def rewind_line
    @line -= 1 if @line > 1
    @col = 1
  end

  def skip_to_next_line
    consume_char while current_char && current_char != "\n"
    consume_char if current_char == "\n"
  end
end
