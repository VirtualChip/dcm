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
   echo "  Install collateral package based on dcm config file."
   echo ""
   exit -1
endif

if ($?DCM_HOME == 0) then
   setenv DCM_HOME $0:h/..
endif

set log_file=dcm_install.log
source $DCM_HOME/csh/dcm_log.csh

echo "CMDS: $prog $*" | tee $log_file
echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh

set menu_mode=1

set dcm_list=
if ($bundleFile != "") then
   if {(test -e $bundleFile)} then
      set dcm_list = `cat $bundleFile`
   else 
      echo "ERROR: file not found '$bundleFile‘"
   endif
endif

while($1 != "")
   set dcm_list = ($dcm_list $1)
   shift argv
end

if ("$dcm_list" != "") then
   foreach dcm_file ($dcm_list)
     if {(test -e $ICFDK_PKGS/$dcm_file.dcm)} then
       $DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_install.awk $ICFDK_PKGS/$dcm_file.dcm | tee -a $log_file
     else if {(test -e $dcm_file)} then
       $DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_install.awk $dcm_file | tee -a $log_file
     else
       echo "ERROR: can not find '$dcm_file'."
       exit 1
     endif
   end
   set menu_mode = 0
endif

while ($menu_mode == 1)
   while ($menu_category == 1) 
     echo "=============================================================="
     echo "INFO: Please specify Kit Category :"
     set kit_category = ""
     (cd $ICFDK_RELN; tree -d -L 4 $kit_category)
     echo -n "INPUT: Category = ($kit_category) ? " 
     set kit_category = "$<"
     set menu_category = 0
   echo "=============================================================="
   echo "INFO: Current releaseNote directory:"
   tree $ICFDK_RELN/$kit_category 
   end

   
   set sel_list=
   set menu_package=1
   while ($menu_package == 1)
     echo "=============================================================="
     echo "INFO: Please select the following packages to be installed :"
     echo "[ $ICFDK_RELN/$kit_category ]:"
     set dcm_list = `cd $ICFDK_RELN/$kit_category; find . -name \*.releaseNote -print | sort`
     set n=0
     echo "  $n) Go back to previous selection menu.."
     foreach dcm_file ($dcm_list)
        set n=`expr $n + 1`
        echo "	$n) $dcm_file:t:r"
     end
     echo "  q) quit.."
     
     echo -n "INPUT: Select ? "
     set sel_list = "$<"
     set menu_package = 0
   end
#   echo $sel_list
   echo "========================================================"

   foreach sel ($sel_list)
      if ($sel == "q") then
         set menu_mode = 0
      else if ($sel == 0) then
         set menu_category = 1
         echo "INFO: Reselect Catgory.."
      else
         set dcm_file = $ICFDK_RELN/$kit_category/$dcm_list[$sel]
         if {(test -e $dcm_file)} then
            echo "INFO: Install kit '$dcm_file' .."
            $DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_install.awk $dcm_file | tee -a $log_file
         else
            echo "ERROR: Unknown selection - ($sel)"
         endif
      endif       
   end
   mkdir -p $ICFDK_HOME
   tree -L 5 $ICFDK_HOME
end

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
