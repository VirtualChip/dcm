#!/bin/csh -f
#set verbose=1
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

      case "-l":
      case "--LogFile":
        shift argv
        set log_file=$1
        shift argv
        
      default:
        set parse_option=0
      breaksw
  endsw
end 

exit 0
