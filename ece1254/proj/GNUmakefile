# git clone git@github.com:ojwoodford/export_fig.git ~/export_fig
EFIGDIR := $(HOME)/export_fig
PS1DIR := ../ps1

PS1FILENAMES := changeTrace.m disableTrace.m enableTrace.m traceit.m isDebugEnabled.m
PS1PATHNAMES := $(addprefix $(PS1DIR)/,$(PS1FILENAMES))

EFIGPATHNAMES := $(wildcard $(EFIGDIR)/*.m)
EFIGFILENAMES := $(notdir $(EFIGPATHNAMES))

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.pdf
CLEAN += *.bak
CLEAN += *~

LOCALFILES := $(PS1FILENAMES) $(EFIGFILENAMES)

EPSFILES := $(wildcard *.eps)
PDFFILES := $(EPSFILES:.eps=.pdf)

all : $(LOCALFILES)

pdf : $(PDFFILES)

# static rules for these copies to avoid recursion.
# http://www.gnu.org/software/make/manual/make.html#Static-Pattern
$(PS1FILENAMES) : %.m: $(PS1DIR)/%.m
	cp $< $@

$(EFIGFILENAMES) : %.m: $(EFIGDIR)/%.m
	cp $< $@

clean: 
	rm -f $(CLEAN) $(LOCALFILES)

#%.pdf : %.eps
#	unix2dos $^
#	epstopdf $^ --outfile=$@
