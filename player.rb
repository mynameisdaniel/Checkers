class Player
  
  attr_reader :color
  
  def initialize(color)
    @color = color    
  end

# validations
  
  def gets_move
    begin
      puts "Please select a #{color} piece, eg. 00 = row 0, col 0"
      input1 = gets.chomp.split("").map(&:to_i) #[1, 1]
      raise "Please choose 2 numbers" if input1.count != 2
    rescue => e
      puts e.message
      retry
    end
    
    begin
      puts "Please where the piece will go, eg. 00 = row 0, col 0"
      input2 = gets.chomp.split("").map(&:to_i)
      raise "Please choose 2 numbers" if input2.count != 2
    rescue => e
      puts e.message
      retry
    end
    [input1, input2]  
  end

  def move
    begin
      puts "Please where you want to jump to, eg. 00 = row 0, col 0"
      input2 = gets.chomp.split("").map(&:to_i) #[1, 1]
      raise "Please choose 2 numbers" if input2.count != 2
    rescue => e
      puts e.message
      retry    
    end
    input2
  end
    
end