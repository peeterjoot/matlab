include ../pd/make.vars

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

#LOCALFILES += $(EFIGFILENAMES)
#LOCALFILES += $(SVGSRCFILENAMES)
#LOCALFILES += $(SVGEXFILENAMES)

EPSFILES := $(wildcard *.eps)
PDFFILES := $(EPSFILES:.eps=.pdf)

all : $(LOCALFILES)

include ../pd/make.rules

pdf : $(PDFFILES)

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
