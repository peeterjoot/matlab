include ../util/make.vars
include ../make.efig

CLEAN += a.netlist
CLEAN += *.mat
CLEAN += *.png

all : $(LOCALFILES)

include ../util/make.rules
include ../make.efigrules

clean: 
	rm -f $(CLEAN)
	rm -f $(LOCALFILES)

