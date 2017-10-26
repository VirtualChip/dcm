#!/bin/csh -f
set prog=$0:t
if ($prog == "setup.cshrc") then
   setenv DCM_HOME `realpath $0:h`
else
   setenv DCM_HOME `pwd`
endif
echo "DCM_HOME = $DCM_HOME"

set path = ($DCM_HOME/bin $path)

setenv ICFDK_ROOT ../techlib
setenv ICFDK_PKGS ../fdk_packages
setenv ICFDK_RELN releaseNotes

