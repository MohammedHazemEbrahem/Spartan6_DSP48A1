vlib work
vlog DSP.v DSP_tb.v reg_mux.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all
#quit -sim