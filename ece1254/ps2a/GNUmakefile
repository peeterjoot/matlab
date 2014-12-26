include ../util/make.vars

FROMPS1 += backSubst.m forwardSubst.m noPivotLU.m withPivotLU.m

LOCALFILES += $(FROMPS1)

include ../make.efig

all : $(LOCALFILES)

clean: 
	rm -f $(LOCALFILES)
	rm -f ps2a.1b.netlist ps2a.1d.netlist tmp.netlist nodal.*.mat 'gershgorinPlotR1.000000e-01Fig6.png' gershgorinPlotR1Fig7.png gershgorinPlotR10Fig8.png 'gershgorinPlotPreconditionedR1.000000e-01Fig9.png' gershgorinPlotPreconditionedR1Fig10.png gershgorinPlotPreconditionedR10Fig11.png residualsByIterationR0.1Fig6.png residualsByIterationR1.0Fig7.png residualsByIterationR10.0Fig8.png

include ../util/make.rules
include ../make.efigrules

$(FROMPS1) : %.m: ../ps1/%.m
	cp $< $@
