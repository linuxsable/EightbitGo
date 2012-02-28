require 'treetop'
require 'kantan-sgf'
require 'bloops'
require 'feepogram'

class EightbitGo
  BOARD_SIZE_X = 19
  BOARD_SIZE_Y = 19

  X_NOTE_MAP = {
    1 => 'C',
    2 => 'D',
    3 => 'E',
    4 => 'F',
    5 => 'G',
    6 => 'A',
    7 => 'B',
    8 => 'C',
    9 => 'D',
    10 => 'E',
    11 => 'F',
    12 => 'G',
    13 => 'A',
    14 => 'B',
    15 => 'C',
    16 => 'D',
    17 => 'E',
    18 => 'F',
    19 => 'G'
  }

  def initialize(filename)
    @filename = filename
    @song = nil
    
    parse_sgf
    init_song
    puts get_game_header
    play_song
  end

  def parse_sgf
    @sgf = KantanSgf::Sgf.new(@filename)
    @sgf.parse
  end

  def get_game_header
    "Match: #{@sgf.player_black} vs. #{@sgf.player_white}."
  end

  def init_song
    bloops = Bloops.new
    bloops.tempo = 200

    @song = Feepogram.new(bloops) do
      sound :crunch, Bloops::NOISE do |s|
        s.punch = 0.5
      end

      sound :oooo, Bloops::SINE do |s|
        s.sustain = 2.0
      end

      sound :plink, Bloops::SQUARE do |s|
        s.punch = 1.0
      end

      phrase do
          
      end
    end
  end

  def play_song
    @song.play
  end
end

EightbitGo.new('sgfs/sirodango-Horcrux.sgf')

# do some magic with the move hash
# for move in sgf.move_list
#   puts "%s: (%i, %i)" % [move[:color], move[:x], move[:y]]
# end