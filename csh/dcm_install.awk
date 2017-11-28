#!/usr/bin/gawk -f
function HEADER(message)  { print "\033[34;40m"message"\033[0m" }
function HILITE(message)  { print "\033[1m"message"\033[0m" }
function WARNING(message) { print "\033[34mWARNING: "message"\033[0m" }
function ERROR(message)   { print "\033[31;43mERROR: "message"\033[0m" }
function PRINT(message)   { print "\033[31m"message"\033[0m" }
function DEBUG(message)   { print "\033[35mDEBUG: "message"\033[0m" }
function find_dcm_package(fname) {
  pkgs_file=""
  dcm_pkgs_source = ENVIRON["ICFDK_PKGS"] 
  split(dcm_pkgs_source, pkgs_path, ":")
  for (i in pkgs_path) {
      pkgs_file=pkgs_path[i]"/"fname
#      DEBUG("Checking file :"pkgs_file)
      if (system("test -e "pkgs_file)==0) {
#         DEBUG("Package Found :"pkgs_file)
         return pkgs_file
      }
  }
#  DEBUG("Package Not Found :"fname)
  return ""
}

BEGIN {
  print "--------------------------------------------------------"
  print "[dcm_install]: BEGIN "
  print "--------------------------------------------------------"
  dcm_install_root = ENVIRON["ICFDK_HOME"]
  if (dcm_install_root == "") {
      dcm_install_root = "techLib"
  }
  dcm_install_summary = dcm_install_root"/.dcm_install.summary"
  if ((system("mkdir -p "dcm_install_root"/.dcm_install/") != 0) ||
      (system("touch "dcm_install_summary) != 0)) {
      ERROR("no write permission on '"dcm_install_root"'.")
      exit -1
  }
  
  dcm_pkgs_source = ENVIRON["ICFDK_PKGS"] 
  if (dcm_pkgs_source == "") {
      dcm_pkgs_source = "."
  }

  dcm_pkgs_config = ENVIRON["ICFDK_CFGS"] 
  if (dcm_pkgs_config == "") {
      dcm_pkgs_config = "."
  }
  
  
  dcm_reln_root = ENVIRON["ICFDK_RELN"] 
  if (dcm_reln_root == "") {
      dcm_reln_root = "releaseNotes"
  }


  dcm_install_option= ENVIRON["DCM_INSTALL_OPTION"]
  split(dcm_install_option, dcm_options)
  for (option in dcm_options) {
      if (option == "--verbose") {
         mode_verbose = 1
      } else if (option == "--info") {
         mode_info = 1
      } else {
      }
  }
  
  dcm_intall_temp = ENVIRON["DCM_INSTALL_TEMP"]
  
  dcm_totoal   = 0
  dcm_created  = 0
  dcm_skipped  = 0
  dcm_conflict = 0
  dcm_modified = 0
  dcm_reqs_err = 0
  dcm_pkgs_err = 0
  
  color_warn = "\033[33m"
  color_err  = "\033[31m"
  color_off  = "\033[0m"
}

BEGINFILE {
  dcm_total++
  HILITE("["dcm_total"]: Reading '"FILENAME"' ...")
  dcm_format    = "1.0"
  kit_node      = _
  kit_upf       = _
  kit_group     = _
  kit_type      = _
  kit_version   = _
  kit_orgin     = _
  kit_topdir    = _
  kit_size      = _
  kit_md5sum    = _
  
  dcm_package_type = "FULL"

  kit_already_exist = 0
  kit_require_fail = 0
  
  base_num      = 0
  file_num      = 0
  pkgs_file_missing = 0

}
/^#/ { next }
/^DCM\s+FORMAT\s/	{ dcm_format = $3 }
/^DCM\s+END\s/		{ nextfile }

/^KIT\s+NODE\s/      { kit_node = $3 }
/^KIT\s+UPF\s/       { kit_upf  = $3 }
/^KIT\s+GROUP\s/     { kit_group = $3 }
/^KIT\s+TYPE\s/      { kit_type = $3 }
/^KIT\s+TOPDIR\s/    { kit_topdir = $3 }
/^KIT\s+VERSION\s/   { kit_version = $3 }
/^KIT\s+ORIGIN\s/    { kit_origin = $3 }
/^KIT\s+SIZE\s/      { kit_size = $3 }
/^KIT\s+MD5SUM\s/    { kit_md5sum = $3 }

/^REQUIRE\s+SKU\s/ {
  req_kit_SKU = $3
  if ((req_kit_SKU != "_") && (req_kit_SKU != "-")) {
     if (system("test -e "dcm_install_root"/.dcm_install/"req_kit_SKU".dcm") != 0) {
        PRINT("    : Required kit SKU '"req_kit_SKU"' has not been installed yet.")
        kit_require_fail++
     }
  }
}

/^REQUIRE\s+DIR\s+(\S+)/ {
  req_kit_dir = $3
  if ((req_kit_dir != "_") && (req_kit_dir != "-")) {
     if (system("test -e "dcm_install_root"/"req_kit_dir) != 0) {
        PRINT("    : Required kit dir '"req_kit_dir"' has not been installed yet.")
        kit_require_fail++
     }
  }
}


/^REQUIRE\s+KIT\s/ {
  req_kit_type = $3
  if (req_kit_SKU != "_") {
     if ($4 == "TOPDIR") {
        req_kit_dir = req_kit_type"/"$5
        if (system("test -e "dcm_install_root"/"req_kit_dir) != 0) {
           PRINT("    : Required kit dir '"req_kit_dir"' has not been installed yet.")
           kit_require_fail++
        }
     }
  }
}

/^PACKAGE\s+TYPE\s/ { 
  dcm_package_type = $3 
  if ($3 != "FULL") {
       print "    : Package type - "dcm_package_type
  }
}
/^PACKAGE\s+TARGET\s/ { 
  dcm_package_dir = $3 
}
/^PACKAGE\s+BASE\s/  {
    base_num++ 
    pkgs_base[base_num]=$3
    dcm_pkgs_base = dcm_pkgs_config"/"pkgs_base[base_num]".dcm"
    if (system("test -e "dcm_pkgs_base) != 0) {
       pkgs_file_missing++
       PRINT("    : Install base - "pkgs_base[base_num]" can not be found in package source.")
    } else {
       print "    : Install base - "dcm_pkgs_base
    }
}
/^PACKAGE\s+(FILE|FULL|MULTI|PATCH)\s/  {
    file_num++
    file_pack[file_name]=$2
    file_lst[file_num]=$3
    file_top[file_num]=$4
    file_md5[file_num]=$5
    file_tgz[file_num]=find_dcm_package($3)
    if (file_tgz[file_num] == "") {
       pkgs_file_missing++
       PRINT("    : Pacakge file - "file_lst[file_num]" can not be found in package source.")
    } else {
       print "    : Package file - "file_tgz[file_num]
    }
}


ENDFILE {
  if (verbose_mode == 1) {
     print "DCM FORMAT    "dcm_format
     print "KIT NODE      "kit_node
     print "KIT UPF       "kit_upf
     print "KIT GROUP     "kit_group
     print "KIT TYPE      "kit_type
     print "KIT VERSION   "kit_version
     print "KIT ORIGIN    "kit_origin
     print "KIT TOPDIR    "kit_topdir
     print "KIT SIZE      "kit_size
     print "KIT MD5SUM    "kit_md5sum
  }
  process_dir = kit_node"/"kit_upf
  category_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type
  "basename "FILENAME" .releaseNote" | getline BASEFILE
  "basename "BASEFILE" .dcm" | getline kit_SKU
  dcm_install_dir = dcm_install_root"/"category_dir

  if (system("test -e "dcm_install_dir"/"kit_topdir) == 0) {
     if (system("test -f "dcm_install_dir"/"kit_topdir"/"kit_SKU".releaseNote") == 0) {
        WARNING("Skip install '"kit_SKU"' (already installed)")
        dcm_skipped++
        kit_already_exist = 1
     } else if (dcm_package_type == "FULL") {
        ERROR("Kit directory '"kit_topdir"' already exist before installing full kit package.")
        dcm_conflict++
        kit_already_exist = 1
     } else {
        print "    : Directory '"dcm_install_dir"/"kit_topdir"' already exist."
     }
  } else {
     if (dcm_package_type == "PATCH") {
        WARNING("Base directory '"kit_topdir"' is missing for patch package.")
     }
  }
  if (kit_already_exist) {
  } else if (kit_require_fail) {
     ERROR("Can not install '"kit_SKU"' (dependency fail)")
     dcm_reqs_err++
  } else if (pkgs_file_missing) {
     ERROR("Can not install '"kit_SKU"' (missing pacakge)")
     dcm_pkgs_err++
  } else {
     system("mkdir -p "dcm_install_dir"/"kit_topdir)
     system("cp -f "FILENAME" "dcm_install_dir"/"kit_topdir"/"kit_SKU".releaseNote")
     system("ln -fs ../"category_dir"/"kit_topdir"/"kit_SKU".releaseNote "dcm_install_root"/.dcm_install/"kit_SKU".dcm")
     system("echo \"`date +%Y%m%d_%H%M%S` `whoami` % dcm_install "kit_SKU"\t;"FILENAME"\" >> "dcm_install_summary)
     if (i in pkgs_base) {
         dcm_pkgs_base = dcm_pkgs_config"/"pkgs_base[i]".dcm"
         print "INFO: Installing base kit '"dcm_pkgs_base"' ..."
         system("dcm_install "dcm_pkgs_base)
     }  
     for (i in file_tgz) {
        dcm_pkgs_file = file_tgz[i]
        print "INFO: Unpacking file '"dcm_pkgs_file"' ..."
        system("gunzip -c "dcm_pkgs_file" | (cd "dcm_install_dir"; tar xvf -)")
     }
     print kit_SKU >> dcm_install_root"/"process_dir"/.dcm_packages"
     dcm_created++
  }
  print ""
}

END {
  print "\033[1m\033[34m"
  print "------------------------------------------------------------------"
  if (dcm_created) {
  print "[dcm_install]: Total "dcm_created"/"dcm_total" kits are installed."
  }
  if (dcm_skipped) {
  print "[dcm_install]: Total "dcm_skipped"/"dcm_total" kits are skipped. (already exist)"
  }
  if (dcm_conflict) {
  print "[dcm_install]: Total "dcm_conflict"/"dcm_total" kits have conflict topdir. (error)"
  }
  if (dcm_reqs_err) {
  print "[dcm_install]: Total "dcm_reqs_err"/"dcm_total" kits require check fail. (error)"
  }
  if (dcm_pkgs_err) {
  print "[dcm_install]: Total "dcm_pkgs_err"/"dcm_total" kits have missing package files. (error)"
  }
  print "------------------------------------------------------------------"
  print "\033[0m"
}
