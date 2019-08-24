require_relative 'board'
class Game
    attr_accessor :board

    def get_board
        self.board = nil;

        until board
            print "\nnew (n) or load(l) board? "            
            input = gets.chomp

            case input
            when "n"
                self.board = Board.new
            when "l"
                begin
                    self.board = YAML.load(File.read("saved.yml"))                    
                rescue => exception
                    print "no file saved"
                end
            end
        end
    end

    def run
        keep_playing = true
        while(keep_playing)
            play_game

            print "play again? (y/n)"
            keep_playing = gets.chomp == "y"
        end
    end

    def play_game
        get_board   

        until game_over?
            board.render
            take_turn
        end

        if board
            print_results
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
            board.toggle_flag
        when "save"
            save_board
        end
    end

    def game_over?
        board.nil? || lost? || won?
    end

    def lost?
        !no_revealed_bombs?
    end

    def won?
        no_hidden_tiles? && no_revealed_bombs? && all_flags_are_bombs?
    end

    def no_hidden_tiles?
        board.all_tiles.none?{|tile| tile.state == :hidden}
    end

    def no_revealed_bombs?
        board.all_tiles.none?{|tile| tile.state == :revealed && tile.is_bomb}
    end

    def all_flags_are_bombs?
        board.all_tiles.select{|tile| tile.state == :flagged}.all?{|tile| tile.is_bomb}
    end

    def print_results
        board.render
        if lost?
            print "You lose!\n"
        else
            print "You win!\n"
        end
    end

    def save_board        
        File.open("saved.yml", "w") { |file| file.write(board.to_yaml) }
        self.board = nil
    end
end

if $PROGRAM_NAME == __FILE__
    game = Game.new
    game.run
end