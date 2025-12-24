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
ExecStep $xv_path/bin/xsim VGA_Sim_behav -key {Behavioral:sim_1:Functional:VGA_Sim} -tclbatch VGA_Sim.tcl -log simulate.log
