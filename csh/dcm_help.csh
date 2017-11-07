#!/bin/csh -f
set prog = $0:t
if (($1 == "")||($1 == "-h")||($1 == "--help")) then
   echo "Usage: $prog [name]"
   echo "  run     - copy testcsae 'run/01_case'"
   echo "  env     - show dcm environment variables"
   echo "  command - show dcm available commands"
   echo "  readme  - README.md"
   echo "  start   - quick starter guide"
   echo "  format  - docs/DCM_FORMAT.md"
   echo "  example - docs/DCM_EXAMPLE.txt"
   echo ""
   exit -1
endif
if ($?DCM_HOME == 0) then
   setenv DCM_HOME $0:h/..
endif

switch($1)
  case "command":
    foreach cmd (dcm_import dcm_install dcm_check)
      echo "======================================================="
      $cmd --help
    end
    breaksw
  case "env"
    echo "ICFDK_HOME = $ICFDK_HOME"
    echo "ICFDK_RELN = $ICFDK_RELN"
    echo "ICFDK_PKGS = $ICFDK_PKGS"
    breaksw
  case "readme":
    more $DCM_HOME/README.md
    breaksw
  case "start":
    xpdf $DCM_HOME/docs/DCM_QuickStart.pdf &
    breaksw
  case "format":
    more $DCM_HOME/docs/DCM_FORMAT.md
    breaksw
  case "example":
    more $DCM_HOME/docs/DCM_EXAMPLE.txt
    breaksw
  case "run":
  case "testcase":
    echo "INFO: copy testcase to run/ .."
    echo "INFO: % cd run/01_case; make help"
    cp -r $DCM_HOME/run run
    cd run/01_case; make help
    breaksw
endsw
