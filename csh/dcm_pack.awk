#!/usr/bin/gawk -f
BEGIN {
  print "--------------------------------------------------------"
  print "[dcm_pack]: BEGIN"
  print "--------------------------------------------------------"
  dcm_pkgs_target = ENVIRON["ICFDK_PKGS_TARGET"] 
  if (dcm_pkgs_target == "") {
      dcm_pkgs_target = "packages"
  }
  dcm_install_root = ENVIRON["ICFDK_HOME"]
  if (dcm_install_root == "") {
      dcm_install_root = "techLib"
  }

  dcm_collateral_source = ENVIRON["ICFDK_COLLATERAL"] 
  if (dcm_collateral_source == "") {
      dcm_collateral_source = "."
  }

  dcm_pack_option= ENVIRON["DCM_PACK_OPTION"]
  split(dcm_pack_option, dcm_options)
  for (option in dcm_options) {
      if (option == "--verbose") {
         mode_verbose = 1
      } else if (option == "--info") {
         mode_info = 1
      } else {
      }
  }
  


}
BEGINFILE {
  print "[dcm_pack]: Processing Collateral defintion file '"FILENAME"' ..."
  "basename "FILENAME" .csv" | getline bundleFile
  bundleFile = bundleFile".bundle"
  print "" > bundleFile

  req_kit_type = ""

  dcm_pkgs_total   = 0  
  dcm_pkgs_created = 0
  dcm_pkgs_error   = 0  

}

/^#/ {}
/^;KIT\s+NODE\s/      { kit_node = $3 }
/^;KIT\s+UPF\s/       { kit_upf  = $3 }

/^;REQUIRE\s+KIT\s/ {
  if ($2 == "KIT") {
     req_kit_type = $3
     if ($4 == "TOPDIR") {
        req_topdir = $5
     } else if ($4 == "VERSION") {
        req_version = $5
     } else {
        req_kit_type = ""
     }
  } else {
     req_kit_type = ""
  }
}

/^(FDK|FIP|AMS|HIP)\s/ {
  dcm_pkgs_total++

  kit_group = $1
  kit_type    = $2
  kit_topdir  = $3
  kit_basename  = $4
  kit_version = $5
  kit_origin  = $6
  kit_directory = $7
  

  print "[dcm_pack]: Packing Kit '"kit_basename"' ..." 
  system("mkdir -p "dcm_pkgs_target)
  kit_tgz = dcm_pkgs_target"/"kit_basename".tgz"

  category_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type
  dcm_install_dir = dcm_install_root"/"category_dir
  system("mkdir -p "dcm_install_dir"/"kit_topdir)
#  print "(cd "kit_directory"; tar -c -O . )|( cd "dcm_install_dir"/"kit_topdir"; tar -x )"
  system("(cd "kit_directory"; tar -c -O . )|( cd "dcm_install_dir"/"kit_topdir"; tar -x )")

#  print "(cd "dcm_install_dir"; tar -c -O -z "kit_topdir") > "kit_tgz
  system("(cd "dcm_install_dir"; tar -c -O -z "kit_topdir") > "kit_tgz) 

  "md5sum "kit_tgz | getline tgz_md5sum

  kit_dcm = dcm_pkgs_target"/"kit_basename".dcm"

  print "DCM\tFORMAT\t1.0"	> kit_dcm
  print "" >> kit_dcm
  print "KIT\tNODE\t"kit_node	>> kit_dcm
  print "KIT\tUPF\t"kit_upf	>> kit_dcm
  print "KIT\tGROUP\t"kit_group	>> kit_dcm
  print "KIT\tTYPE\t"kit_type	>> kit_dcm
  print "KIT\tTOPDIR\t"kit_topdir	>> kit_dcm
  print "KIT\tVERSION\t"kit_version	>> kit_dcm
  print "KIT\tORIGIN\t"kit_origin	>> kit_dcm
  print "" >> kit_dcm
  if ((req_kit_type != "") && (req_topdir != kit_topdir)) {
  print "REQUIRE\tKIT\t"req_kit_type"\tTOPDIR\t"req_topdir >> kit_dcm
  print "" >> kit_dcm
  }
  print "PACKAGE\tFILE\t"kit_basename".tgz" >> kit_dcm
  print "" >> kit_dcm
  print "DCM END" >> kit_dcm
 
  print kit_basename > bundleFile
   
  dcm_pkgs_created++
}
ENDFILE {
  print "[dcm_pack]: Total "dcm_pkgs_created"/"dcm_pkgs_total" dcm packages are created." 
  if (dcm_pkgs_error) {
  print "[dcm_pack]: Total "dcm_pkgs_error"/"dcm_pkgs_total" dcm files have missing package files. (error)"
  }
  print "--------------------------------------------------------"
}
END {
  print "[dcm_pack]: END"
  print "--------------------------------------------------------"
}