#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options>"
   echo "  --packageSrcDir   <packageSourceDir>  (ICFDK_PKGS)"
   echo "  --packageTgtDir   <packageSourceDir>  (ICFDK_TARGET)"
   echo "  --targetLibDir    <techLibTargetDir>  (ICFDK_HOME)"
   echo "  --selectByCategory  <NODE/UPF/GROUP/TYPE>"
   echo "Description:"
   echo "  copy dcm config file to releaseNotes directory and sort by kit category"
   echo ""
   exit -1
endif

if ($?DCM_HOME == 0) then
   setenv DCM_HOME $0:h/..
endif

set log_file=dcm_pack.log
source $DCM_HOME/csh/dcm_header.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file
echo "CMDS: $prog $*" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh 

set file_list=
while ($1 != "" )
  set file_list=($file_list $1)
  shift argv
end

$DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_pack.awk $file_list | tee -a $log_file

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
