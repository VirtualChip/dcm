#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options> <pacakge.dcm>"
   echo "  --packageSrcDir   <packageSourceDir>	(ICFDK_PKGS)"
   echo "  --releaseNoteDir  <releaseNoteDir>	(ICFDK_RELN)"
   echo "  --targetLibDir    <techLibDir>  	(ICFDK_HOME)"
   echo "  --bundleFile      <BundleListFile>"
   echo "  --selectByCategory  <NODE/UPF/GROUP/TYPE>"
   echo "Description:"
   echo "  Install collateral package base on package.dcm file."
   echo ""
   exit -1
endif

if ($?DCM_HOME == 0) then
   setenv DCM_HOME $0:h/..
endif

set log_file=dcm_install.log
source $DCM_HOME/csh/dcm_header.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file
echo "CMDS: $prog $*" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
