
class TermplotScreen
   attr_reader :numCols, :numRows

   def initialize(numCols: 79, numRows: 23)
      @numCols = numCols
      @numRows = numRows
      raise "numCols=#{numCols} < 2" if numCols < 2
      raise "numRows=#{numRows} < 2" if numRows < 2
      @lines = []
      (0..(numCols - 1)).each do |cc|
         @lines[cc] = []
         (0..(numRows - 1)).each do |rr|
            @lines[cc][rr] = " "
         end
      end
   end

   def set(col:, row:)
      raise "col=#{col} < 0" if col < 0
      raise "row=#{row} < 0" if row < 0
      raise "col=#{col} > #{@numCols - 1}" if col > @numCols - 1
      raise "row=#{row} > #{@numRows - 1}" if row > @numRows - 1
      @lines[col][row] = "@"
   end

   def print
      (1..@numRows).each do |row|
         rr = @numRows - row
         (0..(@numCols - 1)).each do |cc|
            printf("%s", @lines[cc][rr])
         end
      end
   end
end

