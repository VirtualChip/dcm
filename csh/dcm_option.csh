#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options>"
   echo "  --packageSrcDir   <packageSourceDir>	(ICFDK_PKGS)"
   echo "  --releaseNoteDir  <releaseNoteDir>	(ICFDK_RELN)"
   echo "  --targetLibDir    <techLibDir>  	(ICFDK_HOME)"
   echo "  --bundleFile      <BundleListFile>"
   echo "  --selectByCategory  <NODE/UPF/GROUP/TYPE>"
   echo "Description:"
   echo "  "
   exit -1
endif

set parse_option=1
while ($parse_option) 
  switch($1)
      case "-v":
      case "--verbose":
        set verbose_mode=1
        shift argv
      breaksw

      case "-i":
      case "--info":
        set info_mode=1
        shift argv
      breaksw

      case "-p":
      case "--packageSrcDir":
        shift argv
        setenv ICFDK_PKGS $1
        shift argv
      breaksw 

      case "-r":
      case "--releaseNoteDir":
        shift argv
        setenv ICFDK_RELN $1
        shift argv
      breaksw 

      case "-t":
      case "--targetLibDir":
        shift argv
        setenv ICFDK_HOME $1
        shift argv
      breaksw 

      case "-s":
      case "--selectByCategory":
      case "--selectCategory":
        shift argv
        set kit_category=$1
        set menu_category=0
        shift argv
      breaksw 

      case "-b":
      case "--bundleFile":
      case "--bundleList":
        shift argv
        set bundleFile=$1
        shift argv
      breaksw 

      case "-l":
      case "--LogFile":
        shift argv
        set dcm_log=$1
        shift argv
      default:
        set parse_option=0
      breaksw
  endsw
end 

if ($?ICFDK_PKGS == 0) then
   setenv ICFDK_PKGS ""
endif

if ($?ICFDK_RELN == 0) then
   setenv ICFDK_RELN "releaseNotes/"
endif

if ($?ICFDK_HOME == 0) then
   setenv ICFDK_HOME "techlib/"
endif

if ($?kit_category == 0) then
   set kit_category=""
   set menu_category=1
endif

if ($?bundleFile == 0) then
   set bundleFile=""
endif

if ($?info_mode) then
   echo "ICFDK_HOME = $ICFDK_HOME"
   echo "ICFDK_RELN = $ICFDK_RELN"
   echo "ICFDK_PKGS = $ICFDK_PKGS"
endif

echo "--------------------------------------------------------"
exit 0
