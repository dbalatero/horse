require 'bloops'

module Horse
  class Song < Bloops
    @thread, @song = nil
    def self.play
      return if @song

      @song = new
      @thread = Thread.new do
        @song.start
      end
    end

    def self.stop
      @thread.kill
      @song = nil
    end

    def initialize
      super
    end
  end

  class PettingSong < Song
    TUNE2 = %w{16:d3 16:g#3}
    TUNE = %w{g4 16:g4 a4 b4 8:b4 c#5 d#5 8:d#5 d5 b4 16:f#5 16:g5 8:f#5 16:d#5 
              f4 32:g#3 32:g#3 32:g#3 64:g} * 2 + %w{64:a 64:b 64:c 64:d 64:c 
              64:b 64:a 64:g}

    def start
      @tune = TUNE.dup
      @tune2 = TUNE2.dup

      self.tempo = 200

      s = sound(Bloops::SINE)
      s.punch = 0.5
      s.sustain = 0.5
      s.decay = 0.2
      s.lsweep = 0.1

      s2 = sound(Bloops::SQUARE)
      s2.slide = -0.1
      s2.phase = 0.1
      s2.psweep = 0.1
      s2.vibe = 0.5
      s2.dslide = 0.05
      s2.vdelay = 0.2

      loop do
        if stopped?
          clear
          note = @tune2.shift
          @tune2 << note
          s2.dslide = rand / 100 * 5
          tune(s2, note)
          note = @tune.shift
          @tune << note
          tune(s, note)
          play
        end
      end
    end
  end

  class ThemeSong < Song
    TUNE = %w{ g4 c5 e5 g5 g5 g5 g5 e5 e5 e5 c5 e5 c5 g4
               g4 c5 e5 g5 g5 g5 g5 e5 e5 e5 g4 g4 g4 c5 }
    RESTS = [4, 8, 16, 32, 64, 128]
    NOTES = [2, 4, 8, 16, 32, 64]
    BOTTOM = %w{c# d# f# a# g#}

    def start
      @tune = TUNE.dup

      self.tempo = 400

      s = sound(Bloops::SQUARE)
      s.punch = 0.5
      s.sustain = 0.5
      s.decay = 0.2

      s2 = sound(Bloops::SAWTOOTH)
      s2.sustain = 0.7
      s2.decay = 0.7

      loop do
        if stopped?
          note = @tune.shift
          @tune << note
          note = note.dup
          clear
          note = "#{NOTES[rand(NOTES.size)]}:#{note}" if rand > 0.7
          note = "#{RESTS[rand(RESTS.size)]} #{note}" if rand > 0.95
          note.gsub!(/(.)(.)/, '\1#\2') if rand > 0.85
          tune(s, note)
          tune(s2, "#{NOTES[rand(NOTES.size)]}:#{BOTTOM[rand(BOTTOM.size)]}3") if rand > 0.7
          play
        end
      end
    end
  end
end
