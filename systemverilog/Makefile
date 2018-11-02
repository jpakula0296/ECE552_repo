.PHONY: all clean cpu

OUTDIR = ./iverilog
TBDIR = ./tb
FLAGS = -Wall

TESTBENCHES =  $(wildcard $(TBDIR)/*.v)
TESTBENCHES += $(wildcard $(TBDIR)/*.sv)

TESTBENCH_OBJECTS =  $(addprefix $(OUTDIR)/,$(notdir $(TESTBENCHES:.v=.vvp)))
TESTBENCH_OBJECTS := $(addprefix $(OUTDIR)/,$(notdir $(TESTBENCH_OBJECTS:.sv=.vvp)))

CPU_TB  = ./tb/project-phase2-testbench.v
CPU_OBJ = $(addprefix $(OUTDIR)/,$(notdir $(CPU_TB:.v=.vvp)))

MODULES =  $(wildcard ./*.v)
MODULES += $(wildcard ./RegisterFile_src/*.v)
MODULES += $(wildcard ./RegisterFile_src/*.sv)
MODULES += $(wildcard ./memory/*.v)

# compile and run every testbench in the tb directory
all: $(TESTBENCH_OBJECTS)
	for tb in $^ ; do \
		./$$tb;\
	done

# run top level cpu testbench
cpu: $(CPU_OBJ)
	./$^

# top level cpu testbench is named weird and in a weird directory, so we need a special rule for it
$(CPU_OBJ): $(CPU_TB) $(MODULES) | $(OUTDIR)
	iverilog -o $@ -s cpu_ptb $^ $(FLAGS)

# assumes the test bench module's name matches the file name before the file extension
$(OUTDIR)/%.vvp: $(TBDIR)/%.v $(MODULES) | $(OUTDIR)
	iverilog -o $@ -s $* $^ $(FLAGS)

# same as above for system verilog test benches
$(OUTDIR)/%.vvp: $(TBDIR)/%.sv $(MODULES) | $(OUTDIR)
	iverilog -o $@ -s $* $^ $(FLAGS)

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	-rm -rf $(OUTDIR) *.vcd *.log *.trace
