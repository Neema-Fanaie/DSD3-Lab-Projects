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
ExecStep $xv_path/bin/xsim Helloworld_TB_behav -key {Behavioral:sim_1:Functional:Helloworld_TB} -tclbatch Helloworld_TB.tcl -log simulate.log
