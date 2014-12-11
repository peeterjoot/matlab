COPYFROM += ../ps1/changeTrace.m
COPYFROM += ../ps1/disableTrace.m
COPYFROM += ../ps1/enableTrace.m
COPYFROM += ../ps1/traceit.m
COPYFROM += ../ps1/isDebugEnabled.m
COPYFROM += ../HarmonicBalanceSmallF/NodalAnalysis.m
COPYFROM += ../HarmonicBalanceSmallF/HarmonicBalance.m

# git clone git@github.com:ojwoodford/export_fig.git ~/export_fig
COPYFROM += $(wildcard $(HOME)/export_fig/*.m)

#COPYFROM += $(wildcard $(HOME)/plot2svg/cur/*.m)

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.pdf

LOCALFILES := $(notdir $(COPYFROM))

EPSFILES := $(wildcard *.eps)
PDFFILES := $(EPSFILES:.eps=.pdf)

all : copy

#.PHONY: copy
copy : $(LOCALFILES)

pdf : $(PDFFILES)

# This is a hack.  It is run for every file over and over.
$(LOCALFILES) :: $(COPYTARGETS)
	cp $(COPYFROM) .

clean: 
	rm -f $(CLEAN) $(LOCALFILES)

#%.pdf : %.eps
#	unix2dos $^
#	epstopdf $^ --outfile=$@
