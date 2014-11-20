FROMPS1 := changeTrace.m disableTrace.m enableTrace.m traceit.m backSubst.m forwardSubst.m noPivotLU.m withPivotLU.m isDebugEnabled.m

all : $(FROMPS1)

clean: 
	rm -f $(FROMPS1)
	rm -f ps2a.1b.netlist ps2a.1d.netlist tmp.netlist nodal.*.mat 'gershgorinPlotR1.000000e-01Fig6.png' gershgorinPlotR1Fig7.png gershgorinPlotR10Fig8.png 'gershgorinPlotPreconditionedR1.000000e-01Fig9.png' gershgorinPlotPreconditionedR1Fig10.png gershgorinPlotPreconditionedR10Fig11.png residualsByIterationR0.1Fig6.png residualsByIterationR1.0Fig7.png residualsByIterationR10.0Fig8.png

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

backSubst.m : ../ps1/backSubst.m
	cp $^ $@

forwardSubst.m : ../ps1/forwardSubst.m
	cp $^ $@

noPivotLU.m : ../ps1/noPivotLU.m
	cp $^ $@

withPivotLU.m : ../ps1/withPivotLU.m
	cp $^ $@

isDebugEnabled.m : ../ps1/isDebugEnabled.m
	cp $^ $@

