#!/bin/csh -f
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options>"
   echo "  --packageSrcDir   <packageSourceDir>  (ICFDK_PKGS)"
   echo "  --releaseNoteDir  <releaseNoteDir>    (ICFDK_RELN)"
#   echo "  --targetLibDir    <techLibTargetDir>  (ICFDK_HOME)"
   echo "  --selectByCategory  <NODE/UPF/GROUP/TYPE>"
   echo "Description:"
   echo "  copy dcm config file to releaseNotes directory and sort by kit category"
   echo ""
   exit -1
endif

if ($?DCM_HOME == 0) then
   setenv DCM_HOME $0:h/..
endif

set log_file=dcm_import.log
source $DCM_HOME/csh/dcm_log.csh

echo "CMDS: $prog $*" | tee $log_file
echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh | tee -a $log_file

#echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN dcm_import.awk"
#set dcm_list = `find $ICFDK_PKGS -name *.dcm -print`
#set dcm_list = `ls -1 $ICFDK_PKGS/*.dcm`
set dcm_list = `echo $ICFDK_PKGS/*.dcm`
#set dcm_list = `glob  $ICFDK_PKGS/*.dcm`
$DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_import.awk $dcm_list | tee -a $log_file

#setenv DCM_PARSER_OPTION "--info"
#foreach dcm_file ($dcm_list)
# $DCM_HOME/csh/gawk -f $DCM_HOME/csh/dcm_parser.awk -v FILENAME=$dcm_file -- $dcm_file
#end

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
