#
# publish dcm.tcl to lib/
publish: 
	cp lib/dcm.tcl ../lib/dcm.tcl

# concat tcl script to lib/dcm.tcl
merge:
	bin/genlib.tcl -cfg genlib.cfg -o lib/dcm.tcl 

# split dcm.tcl to individual tcl file
split:
	bin/split.tcl lib/ddm.tcl


