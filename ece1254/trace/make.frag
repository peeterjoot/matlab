PDDIR := ../pd
PDFILENAMES += changeTrace.m
PDFILENAMES += disableTrace.m
PDFILENAMES += enableTrace.m
PDFILENAMES += traceit.m
PDFILENAMES += isDebugEnabled.m
PDFILENAMES += enableDebug.m
PDPATHNAMES := $(addprefix $(PDDIR)/,$(PDFILENAMES))

LOCALFILES += $(PDFILENAMES)

# static rules for these copies to avoid recursion.
# http://www.gnu.org/software/make/manual/make.html#Static-Pattern
$(PDFILENAMES) : %.m: $(PDDIR)/%.m
	cp $< $@
