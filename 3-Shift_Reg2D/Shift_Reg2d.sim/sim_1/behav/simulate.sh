#!/bin/sh -f
xv_path="/opt/Xilinx/Vivado/2015.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim Shift_reg2DTB_behav -key {Behavioral:sim_1:Functional:Shift_reg2DTB} -tclbatch Shift_reg2DTB.tcl -log simulate.log
