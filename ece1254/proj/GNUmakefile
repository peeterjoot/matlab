include ../../util/make.vars
#include ../../make.svg
include ../../make.efig

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.pdf
CLEAN += *.bak
CLEAN += *~

#LOCALFILES += $(SVGSRCFILENAMES)
#LOCALFILES += $(SVGEXFILENAMES)

EPSFILES := $(wildcard *.eps)
PDFFILES := $(EPSFILES:.eps=.pdf)

all : $(LOCALFILES)

include ../../util/make.rules
#include ../../make.svgrules

pdf : $(PDFFILES)

include ../../make.svgrules
include ../../make.efigrules

clean: 
	rm -f $(CLEAN) $(LOCALFILES)

#%.pdf : %.eps
#	unix2dos $^
#	epstopdf $^ --outfile=$@
