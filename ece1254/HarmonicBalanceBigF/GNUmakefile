FROMPS1 += changeTrace.m
FROMPS1 += disableTrace.m
FROMPS1 += enableTrace.m
FROMPS1 += traceit.m
FROMPS1 += isDebugEnabled.m
FROMSM += NodalAnalysis.m
CLEAN += *.mat
CLEAN += *.png

COPYTARGETS += $(FROMPS1)
COPYTARGETS += $(FROMSM)

all :: $(COPYTARGETS)

clean: 
	rm -f $(CLEAN) $(COPYTARGETS)

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

NodalAnalysis.m : ../HarmonicBalanceSmallF/NodalAnalysis.m
	cp $^ $@
