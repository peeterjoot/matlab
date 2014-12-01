FROMPS1 += changeTrace.m
FROMPS1 += disableTrace.m
FROMPS1 += enableTrace.m
FROMPS1 += traceit.m
FROMPS1 += isDebugEnabled.m
FROMPS2a += tridiagonal.m
FROMPS3a += NodalAnalysis.m
CLEAN += *.mat
CLEAN += *.png

all :: $(FROMPS1)
all :: $(FROMPS2a)
all :: $(FROMPS3a)

clean: 
	rm -f $(FROMPS1) $(CLEAN)

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

NodalAnalysis.m : ../ps3a/NodalAnalysis.m
	cp $^ $@
