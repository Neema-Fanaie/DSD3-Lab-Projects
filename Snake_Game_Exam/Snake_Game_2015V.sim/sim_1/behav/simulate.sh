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
ExecStep $xv_path/bin/xsim Target_ControlTB_behav -key {Behavioral:sim_1:Functional:Target_ControlTB} -tclbatch Target_ControlTB.tcl -log simulate.log
