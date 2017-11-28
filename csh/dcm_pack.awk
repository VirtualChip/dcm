#!/usr/bin/gawk -f
function HEADER(message)  { print "\033[34;40m"message"\033[0m" }
function HILITE(message)  { print "\033[1m"message"\033[0m" }
function WARNING(message) { print "\033[34mWARNING: "message"\033[0m" }
function ERROR(message)   { print "\033[31;43mERROR: "message"\033[0m" }
function PRINT(message)   { print "\033[31m"message"\033[0m" }
function DEBUG(message)   { print "\033[35mDEBUG: "message"\033[0m" }

BEGIN {
  print "--------------------------------------------------------"
  print "[dcm_pack]: BEGIN"
  print "--------------------------------------------------------"

  dcm_pack_root = ENVIRON["DCM_PACK_TEMP"]
  if (dcm_pack_root == "") {
      dcm_pack_root = "tempLib"
  }

  dcm_pkgs_cfgs = ENVIRON["DCM_CFGS_DEST"] 
  if (dcm_pkgs_cfgs == "") {
      dcm_pkgs_cfgs = "configs"
  }

  dcm_pkgs_dest = ENVIRON["DCM_PKGS_DEST"] 
  if (dcm_pkgs_dest == "") {
      dcm_pkgs_dest = "packages"
  }

  dcm_pack_option= ENVIRON["DCM_PACK_OPTION"]
  split(dcm_pack_option, dcm_options)
  for (option in dcm_options) {
      if (option == "--verbose") {
         option_verbose = 1
      } else if (option == "--info") {
         option_info = 1
      } else if (option == "--test") {
         option_test = 1
      } else {
      }
  }
  


}
BEGINFILE {
  print "\033[34m"
  HILITE("[dcm_pack]: Processing Collateral Package file '"FILENAME"' ...")
  "basename "FILENAME" .csv" | getline bundleFile
  bundleFile = bundleFile".bundle"
  system("echo -n > "bundleFile)

  dcm_format = ""
  dcm_test_mode = 0
  
  kit_node   = "_"
  kit_upf    = "_"
  kit_group  = "_"
  kit_type   = "_"
  kit_topdir = "_"
  kit_version = "_"
  kit_origin  = "_"
  kit_location = "_"
  kit_content   = ""
  
  req_kit_SKU = "_"
  req_kit_type = "_"

  dcm_pkgs_total   = 0  
  dcm_pkgs_created = 0
  dcm_pkgs_error   = 0  

}

/^#/ {}
/^DCM\s+PACKAGE\s/	{ dcm_format = $3 }
/^DCM\s+MODE\s+TEST/	{ dcm_test_mode = 1 }
/^DCM\s+END\s/		{ nextfile }

/^KIT\s+NODE\s/      { kit_node = $3 }
/^KIT\s+UPF\s/       { kit_upf  = $3 }
/^KIT\s+GROUP\s/     { kit_group = $3 }
/^KIT\s+TYPE\s/      { kit_type = $3 }
/^KIT\s+TOPDIR\s/    { kit_topdir = $3 }
/^KIT\s+VERSION\s/   { kit_version = $3 }
/^KIT\s+ORIGIN\s/    { kit_origin = $3 }


/^REQUIRE\s+KIT\s/ {
  if ($2 == "KIT") {
     req_kit_type = $3
     if ($4 == "TOPDIR") {
        req_kit_topdir = $5
     } else if ($4 == "VERSION") {
        req_version = $5
     } else {
        req_kit_type = "_"
     }
  } else {
     req_kit_type = "_"
  }
}

/^(FULL|PATCH|MULTI)\s/ {
  dcm_pkgs_total++

  pack_type = $1
  kit_node = $2
  kit_upf = $3
  kit_group = $4
  kit_type    = $5
  kit_SKU   = $6
  kit_topdir  = $7
  kit_version = $8
  req_kit_SKU  = $9
  kit_location = $10
  kit_content = $11

  HILITE("["dcm_pkgs_total"]: Packing Kit '"kit_SKU"' ...")
  category_dir = kit_node"/"kit_upf"/"kit_group"/"kit_type

  system("mkdir -p "dcm_pkgs_cfgs)
  system("mkdir -p "dcm_pkgs_dest)
  kit_dcm = dcm_pkgs_cfgs"/"kit_SKU".dcm"
  kit_tgz = dcm_pkgs_dest"/"kit_SKU".tgz"

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

     if ((req_kit_SKU != "_") && (req_kit_SKU != "-")){
        if (req_kit_SKU != kit_SKU) {
           print "REQUIRE\tSKU\t"req_kit_SKU >> kit_dcm
        }
     }

     if ((req_kit_type != "_") && (req_kit_type != "-")) {
        if ((pack_type == "PATCH") || (req_kit_topdir != kit_topdir)) {
           print "REQUIRE\tKIT\t"req_kit_type"\tTOPDIR\t"req_kit_topdir >> kit_dcm
        }
     }
  dcm_pack_dir = dcm_pack_root"/"category_dir
  system("mkdir -p "dcm_pack_dir"/"kit_topdir)
     
  print "PACKAGE\tTYPE\t"pack_type	>> kit_dcm
  file_type = "FILE"
  if (dcm_test_mode == 1) {
     print "       Create test mode kit directory '"kit_topdir"' ..."
     system("cp "kit_dcm" "dcm_pack_dir"/"kit_topdir"/"kit_SKU".releaseNote")
     system("(cd "dcm_pack_dir"; tar -c -O -z "kit_topdir") > "dcm_pkgs_dest"/"kit_SKU"_test.tgz") 
     print "" >> kit_dcm
     print "PACKAGE\t"file_type"\t"kit_SKU"_test.tgz" >> kit_dcm
     print "" >> kit_dcm
     print "DCM END" >> kit_dcm
  } else if ((kit_location == "")||(kit_location == "-")||(kit_location == "_")) {
     print "       Create DCM file only ..."
     print "" >> kit_dcm
     print "PACKAGE\t"file_type"\t"kit_SKU".tgz" >> kit_dcm
     print "" >> kit_dcm
     print "DCM END" >> kit_dcm
  } else if (pack_type == "MULTI") {
     "ls -1 "kit_location"/*.tgz" | getline pkgs_files
     print "" >> kit_dcm
     print "PACKAGE\t"file_type"\t"pkgs_files >> kit_dcm
     print "" >> kit_dcm
     print "DCM END" >> kit_dcm
  } else if (system("test -f "kit_location) == 0) {
     print "       Use package file '"kit_location"' ..."
     print "" >> kit_dcm
     print "PACKAGE\t"file_type"\t"kit_location >> kit_dcm
     print "" >> kit_dcm
     print "DCM END" >> kit_dcm
  } else if (system("test -d "kit_location) == 0) {
     if (kit_content == "") { kit_content = "." }
     "basename "kit_location"" | getline kit_dir_base
     if (kit_dir_base == kit_topdir) {
        print "       Create package file '"kit_SKU".tgz' .."
        #print "(cd "kit_location"/..; tar -c -O -z "kit_topdir") > "kit_tgz
        system("(cd "kit_location"/..; tar -c -O -z "kit_topdir") > "kit_tgz) 
     } else {
        print "       Copy collateral to kit directory '"kit_topdir"' ..."
        #print "(cd "kit_location"; tar -c -O "kit_content" )|( cd "dcm_pack_dir"/"kit_topdir"; tar -x )"
        system("(cd "kit_location"; tar -c -O "kit_content" )|( cd "dcm_pack_dir"/"kit_topdir"; tar -x )")
        print "       Create package file '"kit_SKU".tgz' .."
        #print "(cd "dcm_pack_dir"; tar -c -O -z "kit_topdir") > "kit_tgz
        system("(cd "dcm_pack_dir"; tar -c -O -z "kit_topdir") > "kit_tgz) 
     }
     print "" >> kit_dcm
     print "PACKAGE\t"file_type"\t"kit_SKU".tgz" >> kit_dcm
     print "" >> kit_dcm
     print "DCM END" >> kit_dcm
     "md5sum "kit_tgz | getline tgz_md5sum
  } else {
     ERROR("Kit directory '"kit_location"' does not exist.")
     system("rm -fr "dcm_pack_dir"/"kit_topdir)
     dcm_pkgs_error++
  }
  if (system("test -d "dcm_pack_dir"/"kit_topdir) == 0 ) {
     print kit_SKU > bundleFile
     system("rm -fr "dcm_pack_dir"/"kit_topdir)
     dcm_pkgs_created++
  }
}

ENDFILE {
}
END {
  print "\033[1m\033[34m"
  print "--------------------------------------------------------"
  print "[dcm_pack]: Total "dcm_pkgs_created"/"dcm_pkgs_total" dcm packages are created." 
  if (dcm_pkgs_error) {
  print "[dcm_pack]: Total "dcm_pkgs_error"/"dcm_pkgs_total" dcm files have missing package files. (error)"
  }
  print "--------------------------------------------------------"
  print "\033[0m"
}