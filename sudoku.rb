class Sudoku

  attr_accessor :board_string, :values, :zeros_array, :row_sols, :col_sols, :box_sols, :board_hash, :row, :col, :box

  def initialize(board_string)
    @board_string = board_string
    @indexes = (0..80).to_a
    @values = @board_string.split(//).map { |s| s.to_i }
    @board_array = @indexes.zip(@values)
    @board_hash = {}
    @board_array.each {|index , value| @board_hash[index] = [ value , row_col_box(index) ]}
  end

  def row_col_box(index)
    [ calc_row(index) , calc_col(index) , calc_box(index) ]
  end

  def calc_row(index)
    @row = ( (index+1) / 9.0 ).ceil
  end
  
  def calc_col(index)
    @col = ( (index) % 9.0).ceil + 1
  end
  
  def calc_box(index)
    @box = ( (@col/3.0).ceil + ((@row - 0.5) / 3).floor * 3 )
  end
  
  def solve!
    solved = true
    solvable = nil
    @board_hash.each { |index , value| solved = false if value[0] == 0 }
    return board if solved == true
    puts "UNSOLVABLE" if solvable == 0
    solvable = 0
    @board_hash.each do |index , value|
      if value[0] == 0
        solutions = []
        cur_set = value[1]
        # p "cur_set:#{cur_set}"
          @board_hash.each do |index , value|
            solutions << value[0] if value[1][0] == cur_set[0] || value[1][1] == cur_set[1] || value[1][2] == cur_set[2]
          end
        solutions = ( (1..9).to_a - solutions ).flatten.uniq
        value[0] = solutions[0] if solutions.length == 1
        solvable = 1 if solutions.length == 1

        board
        puts
        puts "Row:#{value[1][0]} Col:#{value[1][1]} Box:#{value[1][1]} changed to #{value[0]}"
        puts
        puts "Press ENTER key to see next solution"
        gets   if value[0] > 0
        
      end
    end
    solve!
  end

  def board
    board_array2 = []
    @board_hash.each_value { |value| board_array2 << value[0] }
    
    print "\e[H"
    board_array2.each_slice(9) {|row| puts "\e[0K" + row.join(" | ") }
  end
  
end

board_string = File.readlines('sample.unsolved.txt').first.chomp

game = Sudoku.new(board_string)

game.solve!