.PHONY: all clean

OUTDIR = ./iverilog
TBDIR = ./tb
FLAGS = -Wall

TESTBENCHES = $(wildcard $(TBDIR)/*.v)

$(OUTDIR)/PC_tb.vvp: $(TBDIR)/PC_tb.v PC.v adder.v | $(OUTDIR)
	iverilog -o $@ $^ $(FLAGS)

$(OUTDIR)/adder_cla_4bit_tb.vvp: $(TBDIR)/adder_cla_4bit_tb.v adder.v | $(OUTDIR)
	iverilog -o $@ $^ $(FLAGS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	-rm -rf $(OUTDIR) *.vcd
