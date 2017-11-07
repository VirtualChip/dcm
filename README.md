# Design Collateral Management Quick Start Guide V2017.1101

## Specify following environment variables in the shell:

	ICFDK_PKGS	- package source directory (*.tgz and *.dcm)
	ICFDK_RELN	- release note respository directory (sorted collection)
	ICFDK_HOME	- target techLib directory (where you plan to install)

## Step 0：Prepare collateral DCM release note:

Example:
	
	::::::::::::::
	STDCELL_lib222_7t_base_e.2.0.dcm
	::::::::::::::
	DCM	FORMAT	1.0
	KIT	NODE	1222.2
	KIT	UPF	x1r0
	KIT	GROUP	FIP
	KIT	TYPE	STDCELL
	KIT	VERSION	7t_base_e.2.0
	KIT	ORIGIN	7t_base_e.1.1
	KIT	TOPDIR	lib222_7t_base_e20
	KIT	SIZE	10000
	KIT     MD5SUM	11ba9bfa12c16459bc242c005c351b6f

	REQUIRE	KIT	1222.2/x1r0/FDK/PDK	TOPDIR	pdk222_r10HF7

	; If the kit size is huge, it could be split to multiple package files
	PACKAGE	FILE	STDCELL_lib222_7t_base_e.2.0-1.tgz  
	PACKAGE	FILE	STDCELL_lib222_7t_base_e.2.0-2.tgz  
	PACKAGE	FILE	STDCELL_lib222_7t_base_e.2.0-3.tgz  

	DCM END 
	; below this line, there are human readable docs which will be ignored by tool

## Step 1: Import collateral DCM to release notes repository:

	% dcm_import [--packageSrcDir $ICFDK_PKGS] [--releaseNoteDir $ICFDK_RELN]

	% dcm_import <package>.dcm ...

	1. Search DCM config file (*.dcm) in ICFDK_PKGS directory 
	2. Copy the DCM config file to $ICFDK_RELN directory as a releaseNote file
	   and categorize the releaseNote files based on the collateral category.

  Eample:

	releaseNotes/
		|
		+-- 1222.2
			|
			+----- x1r2
			|	|
			|	+----- FDK
			|		|
			|		+----- PDK
			|		|	+---- aaa.releaseNote
			|		|
			|		+----- CTK
			|			+---- bbb.releaseNote
			+----- x1r3
				|
				+----- FDK
				|	|
				|	+----- PDK
				|		+---- ccc.releaseNote
				+----- FIP
					|
					+----- STDCELL
						+---- ddd.releaseNote
						+---- eee.releaseNote


## Step 2: Install selected packages to techlib directory:

  Usage-1 (Package Name):

	% dcm_install <packageName> ...  ; search the dcm from $ICFDK_PKGS
	% dcm_install <directoryPath>/<packageName>.dcm ...


  Usage-2 (Bundle File):

	% dcm_install --bundleFile <packageBundleListFile>

	  Search the package config file and tar kit in $ICFDK_PKGS and install 
	these package follow the sequence. If any package fail to be installed,
	the process will stop. After fixing the problem, same bundleFile could
	be used, package already installed will be kept as is.

  Example:

	packageName1
	packageName2
	packageName3


  Usage-3 (Interactive):

	% dcm_install [--releaseNoteDir $ICFDK_RELN] [--selectByCategory NODE/UPF/GROUP/TYPE]

	User can specify kit category and then select the packages.
	The tool will list all release notes of selected category under $ICFDK_RELN directory:

  Example:

	% dcm_install [--releaseNoteDir $ICFDK_RELN] --selectByCategory 1222.2/x1r3

	INFO: Cateogry - [1222.2/x1r3] 

		1) FDK/PDK/ccc
		2) FIP/STDCELL/ddd
		3) FIP/STDCELL/eee

	QUESTION: Which packages would you like to install? 1 3

	INFO: Installing collateral package "ccc" ..
	INFO: Validating package integrity ...
	INFO: Checking package dependcy ...
	INFO: Unpacking package files "ccc-1.tgz" ...
	INFO: Unpacking package files "ccc-2.tgz" ...

	INFO: Installing collateral package "eee" ..
	...

  Logfle:

	dcm_install.log  =>  detail installation log 
	$ICFDK_HOME/.dcm_install.csv            => CSV table to track pacakge installation info
	$ICFDK_HOME/<NODE>/<UPF>/.dcm_packages  => package list which has been installed


## Step 3: Verify post-installation check (NOT IMPLEMETNTED YET)

	% dcm_check <installed_kit_topdir>    (<NODE>/<UPF>/<GROUP>/<TYPE>/<kit_top_dir>)

	% dcm_check --bundleFile <packageBundleListFile>

	% dcm_check [--targetLibDir $ICFDK_HOME] --techNode <NODE/UPF>

