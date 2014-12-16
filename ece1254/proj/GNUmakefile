PS1DIR := ../ps1
PS1FILENAMES += changeTrace.m
PS1FILENAMES += disableTrace.m
PS1FILENAMES += enableTrace.m
PS1FILENAMES += traceit.m
PS1FILENAMES += isDebugEnabled.m
PS1PATHNAMES := $(addprefix $(PS1DIR)/,$(PS1FILENAMES))

# git clone git@github.com:ojwoodford/export_fig.git ~/export_fig
EFIGDIR := $(HOME)/export_fig
EFIGPATHNAMES := $(wildcard $(EFIGDIR)/*.m)
EFIGFILENAMES := $(notdir $(EFIGPATHNAMES))

# git clone git@github.com:jschwizer99/plot2svg.git ~/plot2svg
SVGDIR := $(HOME)/plot2svg
SVGSRCPATHNAMES := $(wildcard $(SVGDIR)/src/*.m)
SVGSRCFILENAMES := $(notdir $(SVGSRCPATHNAMES))
SVGEXPATHNAMES := $(wildcard $(SVGDIR)/example/*.m)
SVGEXFILENAMES := $(notdir $(SVGEXPATHNAMES))

CLEAN += *.mat
CLEAN += *.png
CLEAN += *.pdf
CLEAN += *.bak
CLEAN += *~

LOCALFILES += $(PS1FILENAMES)
LOCALFILES += $(EFIGFILENAMES)
#LOCALFILES += $(SVGSRCFILENAMES)
#LOCALFILES += $(SVGEXFILENAMES)

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

$(SVGSRCFILENAMES) : %.m: $(SVGDIR)/src/%.m
	cp $< $@

$(SVGEXFILENAMES) : %.m: $(SVGDIR)/example/%.m
	cp $< $@

clean: 
	rm -f $(CLEAN) $(LOCALFILES)

#%.pdf : %.eps
#	unix2dos $^
#	epstopdf $^ --outfile=$@
