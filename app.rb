require 'treetop'
require 'kantan-sgf'
require 'bloops'
require 'feepogram'
require './lib/keys'

class EightbitGo
  # Available octaves in bloops
  OCTAVES = [1, 2, 3, 4, 5, 6, 7, 8]

  BOARD_SIZE = { X: 19, Y: 19 }

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

  def create_note_map(key)
    map = {
      1 => key[0],
      2 => key[1],
      3 => key[2],
      4 => key[3],
      5 => key[4],
      6 => key[5],
      7 => key[6],
      8 => key[0],
      9 => key[1],
      10 => key[2],
      11 => key[3],
      12 => key[4],
      13 => key[5],
      14 => key[6],
      15 => key[0],
      16 => key[1],
      17 => key[2],
      18 => key[3],
      19 => key[4]
    }
  end

  def create_octave_map
    map = {
      1 => OCTAVES[0],
      2 => OCTAVES[0],
      3 => OCTAVES[0],
      4 => OCTAVES[1],
      5 => OCTAVES[1],
      6 => OCTAVES[2],
      7 => OCTAVES[2],
      8 => OCTAVES[3],
      9 => OCTAVES[3],
      10 => OCTAVES[4],
      11 => OCTAVES[4],
      12 => OCTAVES[4],
      13 => OCTAVES[5],
      14 => OCTAVES[5],
      15 => OCTAVES[6],
      16 => OCTAVES[6],
      17 => OCTAVES[7],
      18 => OCTAVES[7],
      19 => OCTAVES[7]
    }
  end

  def create_note_from_move(move)
    if move.include? :pass
      return nil
    end

    note_map = create_note_map(Keys::C_MAJ)
    octave_map = create_octave_map

    x = note_map[move[:x]]
    y = octave_map[move[:y]]

    types = [4, 8]
    type = types[rand(2)]

    "%s:%s%s" % [type, x, y]
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
    @song.tempo = 240

    black_instrument = @song.sound Bloops::SQUARE
    black_instrument.decay = 0.2
    black_instrument.sustain = 0.2
    black_instrument.volume = 0.40

    white_instrument = @song.sound Bloops::SINE
    white_instrument.sustain = 0.5
    white_instrument.decay = 0.2
    white_instrument.attack = 0.2

    puts 'Black Moves:'
    puts @black_notes.join(' ')

    puts 'White Moves:'
    puts @white_notes.join(' ')

    @song.tune(black_instrument, @black_notes.join(' '))
    @song.tune(white_instrument, @white_notes.join(' '))
  end

  def play_song
    @song.play
    sleep 1 while !@song.stopped?
  end
end

EightbitGo.new('sgfs/sirodango-Horcrux.sgf')