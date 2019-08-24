require_relative "tile"
require "yaml"

class Array
    def coordinates(element)
        each_with_index do |subarray, i|
            j = subarray.index(element)
            return i, j if j
        end
        nil
    end
end

class Board
    attr_accessor :pose,:grid 
    
    def generate_grid
        self.grid = Array.new(9){
            Array.new(9){
                Tile.new    
            }
        }

        grid.each do |row|
            row.each do |tile|
                if tile.is_bomb
                    each_neighbor(tile) {|neighbor| neighbor.bomb_neighbors+=1}
                    # grid.each do |row|
                    #     render_row(row)
                    #     print "\n"
                    # end
                end         
            end
        end   
    end

    def each_neighbor(tile, &prc) 
        # print "\n\n #{row_ind}, #{col_ind}\n"
        row_ind, col_ind = grid.coordinates(tile)
        row_range = ([row_ind-1,0].max..[row_ind+1, grid.length-1].min).to_a
        col_range = ([col_ind-1,0].max..[col_ind+1, grid[0].length-1].min).to_a
        row_range.each do |row|
            col_range.each do |col|
                prc.call(grid[row][col])
            end
        end
    end

    def initialize
        generate_grid
        self.pose = [0,0]
    end

    def render
        grid.each_with_index do |row, r_ind|
            render_row(row, r_ind)
            print "\n"
        end
    end

    def render_row(row, r_ind)
        row.each_with_index do |tile, c_ind|
            render_tile(tile, r_ind, c_ind)            
        end
    end

    def render_tile(tile, r_ind, c_ind)
        if [r_ind, c_ind] == pose
            print ">"
        else
            print "\s"
        end

        case tile.state
        when :flagged
            print "F"
        when :hidden
            print "*"
        when :revealed
            if tile.is_bomb
                print "X"
            else
                print tile.bomb_neighbors.to_s
            end
        end
    end

    def all_tiles
        grid.flatten
    end

    def move(move_coord)
        self.pose[0] = (pose[0] + move_coord[0]).clamp(0,grid.length-1)
        self.pose[1] = (pose[1] + move_coord[1]).clamp(0,grid[0].length-1)
    end
    
    def reveal(tile_to_reveal = tile_at_current_pose)
        tile_to_reveal.reveal
        if tile_to_reveal.bomb_neighbors == 0
            each_neighbor(tile_to_reveal) do |tile|
                if tile.state == :hidden
                    reveal(tile)
                end
            end
        end
    end

    def toggle_flag
        tile_at_current_pose.toggle_flag
    end

    def tile_at_current_pose
        grid[pose[0]][pose[1]]
    end
end

if $PROGRAM_NAME == __FILE__
    board = Board.new
    serialized_board = board.to_yaml
    board2 = YAML::load(serialized_board)
    board2.render
end