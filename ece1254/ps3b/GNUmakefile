include ../../util/make.vars
include ../../make.efig

FROMPS2a += tridiagonal.m
FROMPS3a += NodalAnalysis.m

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.netlist

all :: $(LOCALFILES)
all :: $(FROMPS2a)
all :: $(FROMPS3a)

include ../../util/make.rules
include ../../make.efigrules

clean: 
	rm -f $(FROMPS2a) $(FROMPS3a) $(CLEAN)
	rm -f $(LOCALFILES)

tridiagonal.m : ../ps2a/tridiagonal.m
	cp $^ $@

NodalAnalysis.m : ../ps3a/NodalAnalysis.m
	cp $^ $@
