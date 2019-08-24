require_relative 'board'
class Game
    attr_accessor :board

    def initialize
        self.board = Board.new()
    end

    def run
        until game_over?
            board.render
            take_turn
        end

        board.render
        if lost?
            print "You lose"
        else
            print "You win"
        end
    end

    def take_turn        
        input = gets.chomp
        case input
        when "a"
            board.move([0,-1])
        when"w"
            board.move([-1,0])
        when "d"
            board.move([0,1])
        when "s"
            board.move([1,0])
        when "r"
            board.reveal
        when "f"
            board.flag
        end
    end

    def game_over?
        lost? || won?
    end

    def lost?
        board.all_tiles.any?{|tile| tile.state == :revealed && tile.is_bomb}
    end

    def won?
        board.all_tiles.none?{|tile| tile.state == :hidden} && !lost?
    end
end

if $PROGRAM_NAME == __FILE__
    game = Game.new
    game.run
end