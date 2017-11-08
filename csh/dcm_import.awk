#!/usr/bin/gawk -f
BEGIN {
  print "[dcm_import]: BEGIN "
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

  dcm_import_option= ENVIRON["DCM_PACK_OPTION"]
  split(dcm_import_option, dcm_options)
  for (option in dcm_options) {
      if (option == "--verbose") {
         mode_verbose = 1
      } else if (option == "--info") {
         mode_info = 1
      } else if (option == "--skip_topdir") {
         skip_topdir = 1
      } else {
      }
  }
    
  dcm_totoal   = 0
  dcm_created   = 0
  dcm_skipped  = 0
  dcm_modified = 0
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


/^PACKAGE\s+TARGET\s/ { 
  dcm_target_dir = $3 
  }
/^PACKAGE\s+BASE\s/  {
    pkg_bn++ 
    pkg_base=$3 
    dcm_pkg_base = dcm_pkgs_source"/"pkg_base".dcm"
    if (system("test -e "dcm_pkg_base) != 0) {
       pkg_file_missing++
       print "ERROR: Install base "pkg_base".dcm can not be found in package source."
    } else {
       print "    : Install base - "dcm_pkg_base
    }
}
/^PACKAGE\s+FILE\s/  {
    pkg_fn++
    pkg_file[pkg_fn]=$3
    dcm_pkg_file = dcm_pkgs_source"/"pkg_file[pkg_fn]
    if (system("test -e "dcm_pkg_file) != 0) {
       pkg_file_missing++
       print "ERROR: Pacakge "pkg_file[pkg_fn]" can not be found in package source."
    } else {
       print "    : Package file - "dcm_pkg_file
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
     print "KIT MD5SUM    "kit_md5sum
     print "DCM END"
  }
  if (skip_topdir == 1) {
     reln_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type
  } else {
     reln_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type"/"kit_topdir
  }
  "basename "FILENAME" .dcm" | getline dcm_basename
  reln_file = reln_dir"/"dcm_basename".releaseNote"

  if (pkg_file_missing) {
     print "ERROR: Kit '"dcm_basename"' has "pkg_file_missing" missing pacakge files"
     dcm_pkgs_err++
  } else if (system("test -e "dcm_reln_root"/"reln_file) == 0) {
     print "WARNING: Skip copy "reln_file" (already exist)"
     if (system("diff "dcm_reln_root"/"reln_file" "FILENAME) !=0) {
        print "WARNING: kit '"dcm_basename"' in the DK_RELN has been modified"
        dcm_modified++
     }
     dcm_skipped++
  } else {
     if ((base_missing > 0) || (file_missing > 0)) {
        print "ERROR: Skipping "reln_file" (missing pacakge)"
     } else {
        print "    : Creating '"reln_file"' ("kit_version")"
        system("mkdir -p "dcm_reln_root"/"reln_dir)
        system("cp -f "FILENAME" "dcm_reln_root"/"reln_file)
        dcm_created++
        print kit_node" "kit_upf" "kit_group" "kit_type"\t"dcm_basename" "kit_topdir" "kit_version" "kit_origin >> dcm_reln_root"/.dcm_package_info.csv"
     }
  }
  print ""
}

END {
  print "------------------------------------------------------------------"
  print "SUMMARY: Total "dcm_created"/"dcm_total" dcm release notes are created." 
  if (dcm_pkgs_err) {
  print "SUMMARY: Total "dcm_pkgs_err"/"dcm_total" dcm files have missing package files. (error)"
  }
  if (dcm_skipped) {
  print "SUMMARY: Total "dcm_skipped"/"dcm_total" dcm files are skipped. (exist)"
  }
  if (dcm_modified) {
  print "SUMMARY: Total "dcm_modified"/"dcm_skipped" existing dcm files are modified.(warning)"
  }
  print "------------------------------------------------------------------"
  print "[dcm_import]: END"
  print "--------------------------------------------------------"
}
