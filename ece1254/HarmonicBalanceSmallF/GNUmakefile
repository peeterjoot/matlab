FROMPS1 += changeTrace.m
FROMPS1 += disableTrace.m
FROMPS1 += enableTrace.m
FROMPS1 += traceit.m
FROMPS1 += isDebugEnabled.m
FROMPS2a += tridiagonal.m
CLEAN += *.mat
CLEAN += *.png
CLEAN += *~
CLEAN += *.pdf
CLEAN += $(FROMPS1)
CLEAN += $(FROMPS2a)

all :: $(FROMPS1)
all :: $(FROMPS2a)

clean: 
	rm -f $(CLEAN)

# why is this recursing?  hacked around this by copying each manually below
#%.m : ../ps1/%.m
#	cp $^ $@

changeTrace.m : ../ps1/changeTrace.m
	cp $^ $@

disableTrace.m : ../ps1/disableTrace.m
	cp $^ $@

enableTrace.m : ../ps1/enableTrace.m
	cp $^ $@

traceit.m : ../ps1/traceit.m
	cp $^ $@

isDebugEnabled.m : ../ps1/isDebugEnabled.m
	cp $^ $@

tridiagonal.m : ../ps2a/tridiagonal.m
	cp $^ $@

