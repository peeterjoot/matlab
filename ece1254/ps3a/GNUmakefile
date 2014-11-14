FROMPS1 := changeTrace.m disableTrace.m enableTrace.m trace.m isDebugEnabled.m
#backSubst.m forwardSubst.m noPivotLU.m withPivotLU.m 

all : $(FROMPS1)

clean: 
	rm -f $(FROMPS1)

# why is this recursing?  hacked around this by copying each manually below
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

#backSubst.m : ../ps1/backSubst.m
#	cp $^ $@
#
#forwardSubst.m : ../ps1/forwardSubst.m
#	cp $^ $@
#
#noPivotLU.m : ../ps1/noPivotLU.m
#	cp $^ $@
#
#withPivotLU.m : ../ps1/withPivotLU.m
#	cp $^ $@

isDebugEnabled.m : ../ps1/isDebugEnabled.m
	cp $^ $@

