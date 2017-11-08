#!/usr/bin/gawk -f
BEGIN {
  dcm_pkgs_source = ENVIRON["ICFDK_PKGS"] 
  if (dcm_pkgs_source == "") {
      dcm_pkgs_source = "."
  }
  
  dcm_reln_root = ENVIRON["ICFDK_RELN"] 
  if (dcm_reln_root == "") {
      dcm_reln_root = "releaseNotes"
  }
  dcm_install_root = ENVIRON["ICFDK_HOME"]
  if (dcm_install_root == "") {
      dcm_install_root = "techLib"
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
  dcm_created   = 0
  dcm_skipped  = 0
  dcm_modified = 0
  dcm_reqs_err = 0
  dcm_pkgs_err = 0
}

BEGINFILE {
  dcm_total++
  print "["dcm_total"]: Reading "FILENAME
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

  kit_dir_exist = 0
  kit_require_fail = 0
  
  pkg_bn      = 0
  pkg_fn      = 0
  pkg_file_missing = 0

}
/^DCM\s+FORMAT\s/	{ dcm_format = $3 }
/^DCM\s+END\s/		{ nextfile }

/^KIT\s+NODE\s/      { kit_node = $3 }
/^KIT\s+UPF\s/       { kit_upf  = $3 }
/^KIT\s+GROUP\s/     { kit_group = $3 }
/^KIT\s+TYPE\s/      { kit_type = $3 }
/^KIT\s+VERSION\s/   { kit_version = $3 }
/^KIT\s+ORIGIN\s/    { kit_origin = $3 }
/^KIT\s+TOPDIR\s/    { kit_topdir = $3 }
/^KIT\s+SIZE\s/      { kit_size = $3 }
/^KIT\s+MD5SUM\s/    { kit_md5sum = $3 }

/^REQUIRE\s+DIR\s+(\S+)/ {
  req_kit_dir = $3
  if (system("test -e "dcm_install_root"/"req_kit_dir) != 0) {
     print "ERROR: required kit dir '"req_kit_dir"' has not been installed yet."
     kit_require_fail++
     nextfile
  }
}

/^REQUIRE\s+KIT\s/ {
  req_kit_type = $3
  if ($4 == "TOPDIR") {
     req_kit_dir = req_kit_type"/"$5
     if (system("test -e "dcm_install_root"/"req_kit_dir) != 0) {
        print "ERROR: required kit dir '"req_kit_dir"' has not been installed yet."
        kit_require_fail++
        nextfile
     }
  }
}

/^PACKAGE\s+TARGET\s/ { 
  dcm_package_dir = $3 
  }
/^PACKAGE\s+BASE\s/  {
    pkgs_bn++ 
    pkgs_base[pkgs_bn]=$3
    dcm_pkgs_base = dcm_pkgs_source"/"pkgs_base[pkgs_bn]".dcm"
    if (system("test -e "dcm_pkgs_base) != 0) {
       pkgs_file_missing++
       print "ERROR: Install base "pkgs_base[pkgs_bn]" can not be found in package source."
    } else {
       print "    : Install base - "dcm_pkgs_base
    }
}
/^PACKAGE\s+FILE\s/  {
    pkgs_fn++
    pkgs_file[pkgs_fn]=$3
    dcm_pkgs_file = dcm_pkgs_source"/"pkgs_file[pkgs_fn]
    if (system("test -e "dcm_pkgs_file) != 0) {
       pkgs_file_missing++
       print "ERROR: Pacakge "pkgs_file[pkgs_fn]" can not be found in package source."
    } else {
       print "    : Package file - "dcm_pkgs_file
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
     print "DCM END"
  }
  process_dir = kit_node"/"kit_upf
  category_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type
  "basename "FILENAME" .releaseNote" | getline DCMFILE
  "basename "DCMFILE" .dcm" | getline dcm_basename
  dcm_install_dir = dcm_install_root"/"category_dir

  if (system("test -e "dcm_install_dir"/"kit_topdir) == 0) {
     print "    : Directory '"dcm_install_dir"/"kit_topdir"' already exist."
     print "WARNING: Skip install '"dcm_basename"' (kit dir exist)"
     dcm_skipped++
  } else if (kit_require_fail) {
     print "ERROR: Skip install '"dcm_basename"' (dependency fail)"
     dcm_reqs_err++
  } else if (pkgs_file_missing) {
     print "ERROR: Skip install '"dcm_basename"' (missing pacakge)"
     dcm_pkgs_err++
  } else {
     system("mkdir -p "dcm_install_dir)
     system("echo \"`date +%Y%m%d%H%M%S` `whoami` % dcm_install "FILENAME"\" >> "dcm_install_root"/.dcm_install.summary")
     if (i in pkgs_base) {
         dcm_pkgs_base = dcm_pkgs_source"/"pkgs_base[i]".dcm"
         print "INFO: Installing base kit '"dcm_pkgs_base"' ..."
         system("dcm_install "dcm_pkgs_base)
     }  
     for (i in pkgs_file) {
        dcm_pkgs_file = dcm_pkgs_source"/"pkgs_file[i]
        print "INFO: Unpacking file '"dcm_pkgs_file"' ..."
        system("gunzip -c "dcm_pkgs_file" | (cd "dcm_install_dir"; tar xvf -)")
     }
     print dcm_basename >> dcm_install_root"/"process_dir"/.dcm_packages"
     dcm_created++
  }
  print ""
}

END {
  
  print "------------------------------------------------------------------"
  if (dcm_created) {
  print "SUMMARY: Total "dcm_created"/"dcm_total" kits are installed."
  }
  if (dcm_skipped) {
  print "SUMMARY: Total "dcm_skipped"/"dcm_total" kits already exist."
  }
  if (dcm_reqs_err) {
  print "SUMMARY: Total "dcm_reqs_err"/"dcm_total" kits require check fail. (error)"
  }
  if (dcm_pkgs_err) {
  print "SUMMARY: Total "dcm_pkgs_err"/"dcm_total" kits have missing package files. (error)"
  }
  print "------------------------------------------------------------------"
}
