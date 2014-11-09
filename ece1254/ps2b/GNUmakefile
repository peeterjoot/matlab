FROMPS1 := changeTrace.m disableTrace.m enableTrace.m trace.m isDebugEnabled.m

all : $(FROMPS1)

clean: 
	rm -f $(FROMPS1)

changeTrace.m : ../ps1/changeTrace.m
	cp $^ $@

disableTrace.m : ../ps1/disableTrace.m
	cp $^ $@

enableTrace.m : ../ps1/enableTrace.m
	cp $^ $@

trace.m : ../ps1/trace.m
	cp $^ $@

isDebugEnabled.m : ../ps1/isDebugEnabled.m
	cp $^ $@

