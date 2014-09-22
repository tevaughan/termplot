
require 'optparse'
require 'ostruct'

# Representation of the command-line for the termplot program.
#
# The key word 'self' in the declaration of a method indicates that the method
# belongs to the *class* (and not to an instance of the class). This is like a
# static method in C++.
class TermplotCmdline
   # Construct a parser for the command line, and then run the parser.
   #
   # +args+:: List of command-line arguments to the program. ARGV is passed in
   #          here.
   def self.parse(args)
      options = getDefaultOptions
      parser = makeParser(options)
      parser.summary_width = 25
      parser.parse!(args)  # args (ARGV) will have options removed!
      options
   end

   private

   # Set a default for each value that may be specified on the command line.
   def self.getDefaultOptions
      defaults        = OpenStruct.new
      defaults.symbol = "x"     # Symbol representing independent variable.
      defaults.left   = 0.0     # Coordinate of left side of plot.
      defaults.right  = 1.0     # Coordinate of right side of plot.
      defaults.expr   = "x**2"  # Expression to plot.
      if (iCols = `tput cols`.to_i) < 3
         defaults.cols = 79
      else
         defaults.cols = iCols - 1
      end
      if (iRows = `tput lines`.to_i) < 3
         defaults.rows = 22
      else
         defaults.rows = iRows - 1
      end
      defaults
   end

   # Define what to do when the symbol for the independent variable be
   # specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.symbolHandler(parser, options)
      sDsc = "Symbol representing independent variable."
      sDef = "By default, <symbol>='#{options.symbol}'."
      parser.on("-s", "--symbol <symbol>", String, sDsc, sDef) do |symbol|
         if symbol =~ /^\w$/
            options.symbol = symbol
         else
            puts parser
            raise "Symbol must be a word, not '#{symbol}'."
         end
      end
   end

   # Define what to do when the coordinate for the left side of the plot be
   # specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.leftHandler(parser, options)
      lDsc = "Coordinate of left side of plot."
      lDef = "By default, <left>=#{options.left}."
      parser.on("-l", "--left <left>", Float, lDsc, lDef) do |left|
         options.left = left
      end
   end

   # Define what to do when the coordinate for the right side of the plot be
   # specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.rightHandler(parser, options)
      rDsc = "Coordinate of right side of plot."
      rDef = "By default, <right>=#{options.right}."
      parser.on("-r", "--right <right>", Float, rDsc, rDef) do |right|
         options.right = right
      end
   end

   # Define what to do when the expression to plot be specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.exprHandler(parser, options)
      fDsc = "Expression to plot."
      fDef = "By default, <expr>='#{options.expr}'."
      parser.on("-e", "--expr <expr>", String, fDsc, fDef) do |expr|
         options.expr = expr
      end
   end

   # Define what to do when the number of columns be specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.colsHandler(parser, options)
      cDsc = "Number of columns in plot."
      cDef = "By default, <cols>='#{options.cols}'."
      parser.on("-m", "--cols <cols>", String, cDsc, cDef) do |cols|
         if cols < 2
            puts parser
            raise "Number of columns must be at least 2, not #{cols}."
         end
         options.cols = cols
      end
   end

   # Define what to do when the number of rows be specified.
   # +parser+::  Parser to which definition will be attached.
   # +options+:: Option values loaded with defaults on entry.
   def self.rowsHandler(parser, options)
      rDsc = "Number of rows in plot."
      rDef = "By default, <rows>='#{options.rows}'."
      parser.on("-n", "--rows <rows>", String, rDsc, rDef) do |rows|
         if rows < 2
            puts parser
            raise "Number of rows must be at least 2, not #{rows}."
         end
         options.rows = rows
      end
   end

   # Define what to do when the user ask for help.
   # +parser+::  Parser to which definition will be attached.
   def self.helpHandler(parser)
      parser.on("-h", "--help", "Show this message.") do
         puts parser
         exit
      end
   end

   # Construct a parser for the command line.
   #
   # +options+:: Options to be set by parser. Default values have already been
   #             loaded in options before makeParser is called.
   def self.makeParser(options)
      return OptionParser.new do |parser|
         parser.banner = "\nUsage:  #{$0} [options]"
         parser.separator <<EOF

Send an ASCII plot to standard output.  The coordinates of the left and right
sides of the plot may be specified on the command line.  The expression to be
plotted may be specified on the command line. The width and height of the plot
are determined, respectively, by the COLUMNS and the LINES variables from the
environment. The ordinate is scaled automatically.

Options:

EOF
         symbolHandler(parser, options)
         parser.separator ""
         leftHandler(parser, options)
         parser.separator ""
         rightHandler(parser, options)
         parser.separator ""
         exprHandler(parser, options)
         parser.separator ""
         colsHandler(parser, options)
         parser.separator ""
         rowsHandler(parser, options)
         parser.separator ""
         helpHandler(parser)
         parser.separator ""
      end
   end
end

