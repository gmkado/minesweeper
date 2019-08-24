class Tile
    attr_accessor :is_bomb, :bomb_neighbors, :state

    def initialize
        self.is_bomb = rand < 0.05 # TODO: this sets the difficulty
        self.state = :hidden
        self.bomb_neighbors = 0
    end

    def reveal
        self.state = :revealed
    end

    def toggle_flag
        if state == :flagged
            self.state = :hidden
        elsif state == :hidden
            self.state = :flagged
        end
    end
end