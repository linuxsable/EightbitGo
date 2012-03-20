# Mario Kart Theme (SNES)

require 'rubygems'
require 'bloops'

b = Bloops.new
b.tempo = 360

melody = b.sound Bloops::SQUARE
b.tune melody, <<EOF
2 2:e f 4 f g 4 g 4 g a b + c - e
2 2:e f 4 f g 4 g 4 g f e d e
2 2:e f 4 f g 4 g 4 g a b + c - e
2 2:e f 4 f g 4 g 4 g f e d 2:e
EOF

bass = b.sound Bloops::SQUARE
b.tune bass, <<EOF
- c 2 c d 2 d e 2 e 2:f - 2:b +
c 2 c d 2 d e 2 e 2:d - 2:b +
c 2 c d 2 d e 2 e 2:f - 2:b +
c 2 c d 2 d e 2 e 2:d - 2:b +
1:c
EOF

b.play
sleep 1 while !b.stopped?