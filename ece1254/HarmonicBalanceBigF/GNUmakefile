COPYFROM += ../ps1/changeTrace.m
COPYFROM += ../ps1/disableTrace.m
COPYFROM += ../ps1/enableTrace.m
COPYFROM += ../ps1/traceit.m
COPYFROM += ../ps1/isDebugEnabled.m
COPYFROM += ../HarmonicBalanceSmallF/NodalAnalysis.m
COPYFROM += ../HarmonicBalanceSmallF/HarmonicBalance.m
COPYFROM += $(wildcard $(HOME)/plot2svg/cur/*.m)
CLEAN += *.mat
CLEAN += *.png

LOCALFILES := $(notdir $(COPYFROM))

all : $(COPYTARGETS)
	cp $(COPYFROM) .

clean: 
	rm -f $(CLEAN) $(LOCALFILES)
