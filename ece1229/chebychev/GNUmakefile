include ../../util/make.vars
include ../../make.efig

#CLEAN += *.mat
#CLEAN += *.png
#CLEAN += *.pdf
#CLEAN += *.bak
CLEAN += *~

EPSFILES := $(wildcard *.eps)
PDFFILES := $(EPSFILES:.eps=.pdf)

all : $(LOCALFILES)

include ../../util/make.rules

pdf : $(PDFFILES)

include ../../make.efigrules

clean: 
	rm -f $(CLEAN) $(LOCALFILES)
