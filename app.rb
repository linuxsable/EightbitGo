require 'treetop'
require 'kantan-sgf'
require 'bloops'
require 'feepogram'

class EightbitGo
  BOARD_SIZE_X = 19
  BOARD_SIZE_Y = 19

  X_NOTE_MAP = {
    0 => 'C',
    1 => 'D',
    2 => 'E',
    3 => 'F',
    4 => 'G',
    5 => 'A',
    6 => 'B',
    7 => 'C',
    8 => 'D',
    9 => 'E',
    10 => 'F',
    11 => 'G',
    12 => 'A',
    13 => 'B',
    14 => 'C',
    15 => 'D',
    16 => 'E',
    17 => 'F',
    18 => 'G'
  }

  def initialize(filename)
    @filename = filename
    @song = nil
    
    parse_sgf
    puts get_game_header
    create_player_melodies
    init_song
    play_song
  end

  def parse_sgf
    @sgf = KantanSgf::Sgf.new(@filename)
    @sgf.parse
  end

  def get_game_header
    "Match: #{@sgf.player_black} vs. #{@sgf.player_white}."
  end

  def create_note_from_move(move)
    if move.include? :pass
      return nil
    end

    x = X_NOTE_MAP[move[:x]]
    y = move[:y]

    if y > 5
      y = 5
    end

    "8:%s%s" % [x, y]
  end

  def create_player_melodies
    @white_notes = []
    @black_notes = []

    @sgf.move_list.each do |move|
      note = create_note_from_move(move)

      if !note.nil?
        if move[:color] == 'W'
          @white_notes << note
        else
          @black_notes << note
        end
      end
    end
  end

  def init_song
    @song = Bloops.new
    @song.tempo = 230

    black_instrument = @song.sound Bloops::SQUARE
    black_instrument.sustain = 0.4
    black_instrument.decay = 0.4

    white_instrument = @song.sound Bloops::SINE
    white_instrument.sustain = 2
    white_instrument.decay = 0.4

    p 'Black Moves:'
    p @black_notes.join(' ')

    p 'White Moves:'
    p @white_notes.join(' ')

    # @song.tune(black_instrument, @black_notes.join(' '))
    @song.tune(white_instrument, @white_notes.join(' '))
  end

  def play_song
    sleep 1
    @song.play
    sleep 1 while !@song.stopped?
  end
end

EightbitGo.new('sgfs/sirodango-Horcrux.sgf')