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
source $DCM_HOME/csh/dcm_header.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog" | tee -a $log_file
echo "CMDS: $prog $*" | tee -a $log_file

source $DCM_HOME/csh/dcm_option.csh

set menu_mode=1
set menu_category = 1
set menu_list_all = 1

set name_list=
if ($bundleFile != "") then
   if {(test -e $bundleFile)} then
      set name_list = `cat $bundleFile`
   else 
      printf "\033[31mERROR: file not found - '$bundleFile‘.\033[0m\n"
      exit 1
   endif
endif

while($1 != "")
   set name_list = ($name_list $1)
   shift argv
end

if ("$name_list" != "") then
   set n=0
   set dcm_list=
   foreach dcm_name ($name_list)
     set n=`expr $n + 1`
     echo -n "[$n]: Checking dcm package - $dcm_name ..."
     if {(test -f $dcm_name)} then
       set dcm_file = $dcm_name
     else if {(test -f $ICFDK_CFGS/$dcm_name)} then
       set dcm_file = $ICFDK_CFGS/$dcm_name
     else if {(test -f $ICFDK_CFGS/$dcm_name.dcm)} then
       set dcm_file = $ICFDK_CFGS/$dcm_name.dcm
     else
       printf "\n\033[31mERROR: Can not find DCM config '$dcm_name' in '$ICFDK_CFGS'.\033[0m\n"
       exit 1
     endif
     set dcm_list = ($dcm_list $dcm_file )
     echo ""
   end
   $DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_install.awk $dcm_list | tee -a $log_file
   set menu_mode = 0
else
   if ($?ICFDK_RELN == 0) then
      printf "\033[31mERROR: releaseNote path env(ICFDK_RELN) is not specified.\033[0m\n"
      exit 1
   else if {(test -d $ICFDK_RELN)} then
   #   echo "INFO: ICFDK_RELN = $ICFDK_RELN"
   else
      printf "\033[31mERROR: releaseNote directory '$ICFDK_RELN' does not exist.\033[0m\n"
      exit 1
   endif
endif

while ($menu_mode == 1)
   while ($menu_category == 1) 
     clear
     echo "INFO: ICFDK_RELN = $ICFDK_RELN"
     echo "=============================================================="
     echo "INFO: Please specify Kit Category :"
     (cd $ICFDK_RELN; tree --noreport -C -d -L 4 .)
     echo -n "INPUT: Category = ($kit_category) ? " 
     set kit_category = "$<"
     echo $kit_category
     if {(test -d $ICFDK_RELN/$kit_category )} then
       set menu_category = 0
     else
       set kit_category = ""
     endif
   end

   
   set sel_list=
   set menu_package=1
   while ($menu_package == 1)
     echo "=============================================================="
     echo "INFO: Please select the following packages to be installed :"
     echo "[ $ICFDK_RELN/$kit_category ]:"
     set dcm_list = `cd $ICFDK_RELN; find $kit_category -name \*.releaseNote -print | sort`
     set n=0
     
     printf "\033[1m"
     echo "  $n) Go back to previous selection menu.."
     printf "\033[0m\033[34m"
     printf "   %4s %-40s :%-7s :%-20s\n" "----" "-----------------------------------" "-------" "--------------------"
     printf "   %4s %-40s :%-7s :%-20s\n" "#" "SKU" "TYPE" "TOPDIR"
     printf "   %4s %-40s :%-7s :%-20s\n" "----" "-----------------------------------" "-------" "--------------------"
     foreach dcm_file ($dcm_list)
        set kit_basename=$dcm_file:t:r
        set kit_topdir=$dcm_file:h:t
        set kit_type=$dcm_file:h:h:t
        if {(test -f $ICFDK_HOME/.dcm_install/$kit_basename.dcm)} then
           if ($menu_list_all) then
              set n=`expr $n + 1`
              printf "\033[0m\033[34m"
              printf "  *%3d) %-40s :%-7s :%-20s\n" $n $kit_basename $kit_type $kit_topdir
           endif
        else
           set n=`expr $n + 1`
           printf "\033[1m\033[34m"
           printf "   %3d) %-40s :%-7s :%s\n" $n $kit_basename $kit_type $kit_topdir
        endif
     end
     printf "\033[0m"
     if ($menu_list_all) then
     echo "  h) hide installed packages.."
     else
     echo "  a) list all packages.."
     endif
     echo "  t) print directory tree.."
     printf "\033[1m"
     echo "  q) quit.."
     printf "\033[0m"
     
     echo -n "INPUT: Select ? "
     set sel_list = "$<"
     set menu_package = 0
   end
   echo $sel_list
   echo "========================================================"

   foreach sel ($sel_list)
      if ($sel == "q") then
         set menu_mode = 0
         exit 0
      else if (($sel == "a")||($sel == "A")) then
         set menu_list_all = 1
      else if (($sel == "t")||($sel == "T")) then
         echo "=============================================================="
         echo "INFO: Current releaseNote directory: "
         tree -n  $ICFDK_RELN/$kit_category | less
      else if (($sel == "h")||($sel == "H")) then
         set menu_list_all = 0
      else if ($sel == 0) then
         set menu_category = 1
         echo "INFO: Reselect Catgory.."
      else if (`expr match $sel '[0-9]*'` == 0) then
         printf "\033[31mERROR: Invalid selection : $sel \033[0m\n" 
      else if ($sel > $n) then
         printf "\033[31mERROR: selection over the range : (1~$n) \033[0m\n" 
      else
         set dcm_file = $ICFDK_RELN/$dcm_list[$sel]
         if {(test -f $dcm_file)} then
            echo "INFO: Install kit '$dcm_list[$sel]' .."
            $DCM_HOME/bin/gawk -f $DCM_HOME/csh/dcm_install.awk $dcm_file | tee -a $log_file
         else
            printf "\033[31mERROR: file not found - $dcm_file \033[0m\n"
         endif
      endif       
   end
#   mkdir -p $ICFDK_HOME
#   tree --noreport -L 5 $ICFDK_HOME
end

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog" | tee -a $log_file
echo "========================================================" | tee -a $log_file
exit 0
