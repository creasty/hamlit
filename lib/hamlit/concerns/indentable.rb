require 'hamlit/concerns/error'

module Hamlit
  EOF = -1

  module Concerns
    module Indentable
      include Concerns::Error

      def reset_indent
        @current_indent = 0
      end

      # Return nearest line's indent level since next line. This method ignores
      # empty line. It returns -1 if next_line does not exist.
      def next_indent
        count_indent(next_line)
      end

      def next_width
        count_width(next_line)
      end

      def with_indented(&block)
        @current_indent += 1
        result = block.call
        @current_indent -= 1

        result
      end

      def count_indent(line, strict: false)
        return EOF unless line
        width = count_width(line)

        return (width + 1) / 2 unless strict
        compile_error!('Expected to count even-width indent') if width.odd?

        width / 2
      end

      def count_width(line)
        return EOF unless line
        line[/\A +/].to_s.length
      end

      def same_indent?(line)
        return false unless line
        count_indent(line) == @current_indent
      end
    end
  end
end
