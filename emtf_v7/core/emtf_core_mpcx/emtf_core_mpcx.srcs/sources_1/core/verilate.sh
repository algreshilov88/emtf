FILES="\
best_delta.sv \
best_tracks.sv \
coord_delay.sv \
deltas_sector.sv \
deltas.sv \
extender.sv \
extend_sector.sv \
find_segment.sv \
match_ph_segments.sv \
ph_pattern_sector.sv \
ph_pattern.sv \
prim_conv11.sv \
prim_conv_sector.sv \
prim_conv.sv \
ptlut_address.sv \
single.sv \
sort_sector.sv \
sort_zone.sv \
spbits.sv \
sp.sv \
sp_tf.sv \
two_mu.sv \
zone_best3.sv \
zones.sv"

INCLUDE="\
-I../../sim_1/new/ \
-I../../sim_1/imports/emtf_core_2019-02-12/ \
-I../mpcx/ \
-I../services/"

verilator $INCLUDE -Wall --cc --exe --build sim_main.cpp $FILES
