#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options>"
   echo "  --packageCfgDir   <packageConfigDir>  (ICFDK_CFGS)"
   echo "  --packageSrcDir   <packageSourceDir>  (ICFDK_PKGS)"
   echo "  --releaseNoteDir  <releaseNoteDir>    (ICFDK_RELN)"
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
source $DCM_HOME/csh/dcm_header.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file
echo "CMDS: $prog $*" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh 

set dcm_list=
while ($1 != "" )
  if {(test -d $1)} then
     set fl=`ls -1 $1/*.dcm`
     foreach f ($fl) 
       set dcm_list=($dcm_list $f)
     end
  else if {(test -f $1)} then
     set dcm_list=($dcm_list $1)
  else
     set SKU=`basename $1 .dcm`
     set dcm_list=($dcm_list `glob $ICFDK_CFGS/$SKU.dcm`)
  endif
  shift argv
end

if ("$dcm_list" == "") then
echo "INFO: Search dcm file in '$ICFDK_CFGS'..."
#set dcm_list = `find $ICFDK_CFGS -name *.dcm -print`
#set dcm_list = (glob  $ICFDK_CFGS/*.dcm)
set dcm_list = `ls -1 $ICFDK_CFGS/*.dcm`
#set dcm_list = `echo $ICFDK_CFGS/*.dcm`
endif

if ( "$dcm_list" != "") then
$DCM_HOME/bin/dcm_gawk -f $DCM_HOME/csh/dcm_import.awk $dcm_list | tee -a $log_file
endif


echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
