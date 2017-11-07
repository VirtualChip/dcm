#!/bin/csh -f
set prog=$0:t
if ($prog == "setup.cshrc") then
   setenv DCM_HOME `realpath $0:h`
else
   setenv DCM_HOME `pwd`
endif

echo "=========================================="
echo "DCM_HOME = $DCM_HOME"
set path = ($DCM_HOME/bin $path)

setenv ICFDK_PKGS $DCM_HOME/packages
setenv ICFDK_RELN releaseNotes
setenv ICFDK_HOME targetLib

echo "=========================================="
echo "ICFDK_PKGS = $ICFDK_PKGS"
echo "ICFDK_RELN = $ICFDK_RELN"
echo "ICFDK_HOME = $ICFDK_HOME"
echo "=========================================="

dcm_help
