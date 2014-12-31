include ../util/make.vars
include ../make.efig

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.pdf
CLEAN += *.bak
CLEAN += *~

all : $(LOCALFILES)

include ../util/make.rules
include ../make.efigrules

clean: 
	rm -f $(CLEAN) $(LOCALFILES)
