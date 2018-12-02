rtl_top := RED
objs := $(rtl_top)_tb.sv
wave_file := $(rtl_top).fsdb

lib_dir := -y ./ \
#    -y ~/remote/Vivado/data/verilog/src/unisims \
#	-y ~/remote/Vivado/data/verilog/src/unimacro \
#	-y ~/remote/Vivado/data/verilog/src/retarget \
#	-y ~/remote/Vivado/data/xsim/ip/xpm \

inc_dir := +incdir+\
#~/remote/Vivado/data/xsim/ip/xpm+./

lib_file := \
#	-v ./*.v 
#-v ./*.sv
    #-V ~/remote/Vivado/data/verilog/src/glbl.v \
    #-V ~/remote/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv \
    #-V ~/remote/Vivado/xpm_fifo.sv

#    -f ~/remote/Vivado/data/secureip/secureip_cell.list.f \
#    -f ~/remote/Vivado/data/secureip/secureip_sv_cell.list.f \

cflags := -no-pie -fPIC\
#cflags := -fPIC\

make : vcs sim

sim:
	./simv

vcs_rtl:
	vcs -full64 -sverilog -debug_all \
	-CFLAGS "$(cflags)" \
	-ld gcc \
	$(rtl_top).sv \
	$(inc_dir) \
	$(lib_dir) \
	$(lib_file) \
	+libext+.sv+.v \
	+define+DUMPFSDB \
	+vcs+loopreport \
	-P ${VERDI_HOME}/share/PLI/VCS/linux64/novas.tab ${VERDI_HOME}/share/PLI/VCS/linux64/pli.a \
	-LDFLAGS -Wl,--no-as-needed +memcbk +mda -Mupdate +lint=TFIPC-L \
	-l vcs_elab.log \
	-nc

vcs:
	vcs -full64 -sverilog -debug_all \
	-CFLAGS "$(cflags)" \
	-ld gcc \
	$(objs) \
	$(inc_dir) \
	$(lib_dir) \
	$(lib_file) \
	+libext+.sv+.v \
	+define+DUMPFSDB \
	+vcs+loopreport \
	-P ${VERDI_HOME}/share/PLI/VCS/linux64/novas.tab ${VERDI_HOME}/share/PLI/VCS/linux64/pli.a \
	-LDFLAGS -Wl,--no-as-needed +memcbk +mda -Mupdate +lint=TFIPC-L \
	-l vcs_elab.log \
	-nc

verdi:
	verdi -sv -f filelist -ssf $(wave_file) &

clean:
	rm -f $(wave_file) simv novas.conf *.log *.dump *.key *fsdb*
	rm -rf csrc/ simv.daidir/ verdilog/ simv.vdb/
