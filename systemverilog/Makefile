.PHONY: all clean

OUTDIR = ./iverilog
TBDIR = ./tb
FLAGS = -Wall

TESTBENCHES = $(wildcard $(TBDIR)/*.v)
TESTBENCH_OBJECTS = $(addprefix $(OUTDIR)/,$(notdir $(TESTBENCHES:.v=.vvp)))
#MODULES = $(wildcard ./*.v)
MODULES = half_adder.v full_adder.v rca_4bit.v rca_16bit.v cla_4bit.v adder_cla_4bit.v adder_multifunc_16bit.v

# compile and run every testbench in the tb directory
all: $(TESTBENCH_OBJECTS)
	for tb in $^ ; do \
		./$$tb;\
	done

# assumes the test bench module's name matches the file name before the file extension
$(OUTDIR)/%.vvp: $(TBDIR)/%.v $(MODULES) | $(OUTDIR)
	iverilog -o $@ -s $* $^ $(FLAGS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	-rm -rf $(OUTDIR) *.vcd
