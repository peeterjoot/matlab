FROMPS1 := changeTrace.m disableTrace.m enableTrace.m trace.m

all : $(FROMPS1)

clean: 
	rm -f $(FROMPS1)
	rm -f ps2a.1.netlist

# why is this recursing?
#%.m : ../ps1/%.m
#	cp $^ $@

changeTrace.m : ../ps1/changeTrace.m
	cp $^ $@

disableTrace.m : ../ps1/disableTrace.m
	cp $^ $@

enableTrace.m : ../ps1/enableTrace.m
	cp $^ $@

trace.m : ../ps1/trace.m
	cp $^ $@
