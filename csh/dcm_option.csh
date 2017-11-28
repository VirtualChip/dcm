#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog <options>"
   echo "  --targetLibDir    <techLibDir>  	(ICFDK_HOME)"
   echo "  --packageCfgDir   <packageConfigDir>	(ICFDK_CFGS)"
   echo "  --packageSrcDir   <packageSourceDir>	(ICFDK_PKGS)"
   echo "  --releaseNoteDir  <releaseNoteDir>	(ICFDK_RELN)"
   echo "  --bundleFile      <BundleListFile>"
   echo "  --selectCategory  <NODE/UPF/GROUP/TYPE>"
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

      case "-c":
      case "--packageCfgDir":
        shift argv
        setenv ICFDK_CFGS $1
        echo "INFO:   --packageCfgDir	$ICFDK_CFGS"
        shift argv
      breaksw 

      case "-p":
      case "--packageSrcDir":
        shift argv
        setenv ICFDK_PKGS $1
        echo "INFO:   --packageSrcDir	$ICFDK_PKGS"
        shift argv
      breaksw 

      case "-r":
      case "--releaseNoteDir":
        shift argv
        setenv ICFDK_RELN $1
        echo "INFO:   --releaseNoteDir	$ICFDK_RELN"
        shift argv
      breaksw 

      case "-t":
      case "--targetLibDir":
        shift argv
        setenv ICFDK_HOME $1
        echo "INFO:   --targetLibDir	$ICFDK_HOME"
        shift argv
      breaksw 

      case "--packCfgDir":
      case "--packCfgsDir":
        shift argv
        setenv DCM_CFGS_DEST $1
        echo "INFO:   --packCfgDir	$DCM_CFGS_DEST"
        shift argv
      breaksw 

      case "--packDestDir":
        shift argv
        setenv DCM_PKGS_DEST $1
        echo "INFO:   --packDestDir	$DCM_PKGS_DEST"
        shift argv
      breaksw 

      case "--packTempDir":
        shift argv
        setenv DCM_PACK_TEMP $1
        echo "INFO:   --packTempDir	$DCM_PACK_TEMP"
        shift argv
      breaksw 

      case "-c":
      case "--selectByCategory":
      case "--selectCategory":
        shift argv
        set kit_category=$1
        echo "INFO:   --selectCategory	$kit_category"
        shift argv
      breaksw 

      case "-b":
      case "--bundleFile":
      case "--bundleList":
        shift argv
        set bundleFile=$1
        echo "INFO:   --bundleFile	$bundleFile"
        shift argv
      breaksw 

      default:
        set parse_option=0
      breaksw
  endsw
end 

if ($?ICFDK_HOME == 0) then
   setenv ICFDK_HOME "techLib"
endif

if ($?ICFDK_RELN == 0) then
   setenv ICFDK_RELN "releaseNotes"
endif

if ($?ICFDK_PKGS == 0) then
   setenv ICFDK_PKGS "packages"
endif

if ($?ICFDK_CFGS == 0) then
   setenv ICFDK_CFGS $ICFDK_PKGS
endif

if ($?DCM_PKGS_DEST == 0) then
   setenv DCM_PKGS_DEST "packages"
endif

if ($?DCM_CFGS_DEST == 0) then
   setenv DCM_CFGS_DEST $DCM_PKGS_DEST
endif

if ($?kit_category == 0) then
   set kit_category=""
endif

if ($?bundleFile == 0) then
   set bundleFile=""
endif

if ($?info_mode) then
   echo "ICFDK_HOME = $ICFDK_HOME"
   echo "ICFDK_RELN = $ICFDK_RELN"
   echo "ICFDK_PKGS = $ICFDK_PKGS"
   echo "ICFDK_CFGS = $ICFDK_PKGS"
endif

echo "--------------------------------------------------------"
exit 0
