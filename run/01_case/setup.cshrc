#!/bin/csh -f
if ($?DCM_HOME == 0) then
   echo "ERROR: setenv DCM_HOME first before runing demo" 
endif

setenv ICFDK_HOME techLib
setenv ICFDK_PKGS packages
setenv ICFDK_RELN releaseNotes

echo "=========================================="
echo "ICFDK_HOME = $ICFDK_HOME"
echo "ICFDK_PKGS = $ICFDK_PKGS"
echo "ICFDK_RELN = $ICFDK_RELN"
echo "=========================================="

make help

