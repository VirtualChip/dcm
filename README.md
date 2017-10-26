# Design Collateral Management

## Global environment variables

Example:

	; central collateral installation directory
	setenv ICFDK_ROOT /nfs/pdx/disks/pdk/techlib

	; Collateral tar ball collection 
	setenv ICFDK_PKGS /nfs/pdx/disks/ftp/fdk_packages

	; Collateral release notes pool
	setenv ICFDK_RELN ./releaseNotes


## Step 1: import collateral release notes to $ICFDK_RELN/

Usage:

	% dcm_import --packageDir $ICFDK_PKGS --all

	% dcm_import <package>.releaseNote ...

	search & copy the release note files to $ICFDK_RELN directory.
	and categorize releaseNote files based on the process code.

  Eample:

	releaseNotes/
		|
		+-- 1222.2
		|	|
		|	+----- x1r2
		|	|	|
		|	|	+----- FDK
		|	|		|
		|	|		+----- PDK
		|	|		|	+---- aaa.releaseNote
		|	|		|
		|	|		+----- CTK
		|	|			+---- bbb.releaseNote
		|	|
		|	+----- x1r3
		|		|
		|		+----- FDK
		|		|	|
		|		|	+----- PDK
		|		|		+---- ccc.releaseNote
		|		|
		|		+----- FIP
		|			|
		|			+----- STDCELL
		|				+---- ddd.releaseNote
		|				+---- eee.releaseNote
		+-- 1273.6
			|
			+----- x1r3
				|
				+----- FDK
				|	|
				|	+----- PDK
				|		+---- fff.releaseNote
				|
				+----- FIP
					|
					+----- STDCELL
						+---- ggg.releaseNote
						+---- hhh.releaseNote


## Step 2: install selected packages to techlib directory $ICFDK_ROOT/

  Usage-1 (Interactive):

	% dcm_install [--releaseNoteDir $ICFDK_RELN] [--techNode NODE/UPF]

	User can specify the techNode,
	the tool will list all release notes of specied techNode under $ICFDK_RELN directory:

  Example:

	% dcm_install [--releaseNoteDir $ICFDK_RELN] --techNode 1222.2/x1r3

	INFO: Techology Node - [1222.2/x1r3] 

		1) FDK/PDK/ccc
		2) FIP/STDCELL/ddd
		3) FIP/STDCELL/eee

	QUESTION: Which packages would you like to install? 1 3

	INFO: Installing collateral package "ccc" ..
	INFO: Validating package integrity (MD5) ...
	INFO: Checking package dependcy ...

	INFO: Installing collateral package "eee" ..
	...


  Usage-2 (Package Name):

	% dcm_install <packageName> ...

	% dcm_install <directoryPath>/<packageName>.releaseNote ...


  Usage-3 (Package Name):

	% dcm_install --BundleList <BundlePackageListFile>

  Example:

	# name		
	packageName1					; 20171025_102531 
	packageName2					; 20171025_120123
	packageName3.releaseNote			; package name with file ext (.releaseNote)
	<directoryPath>/<packageName>.releaseNote	; package full path


## Step 3: post-installation check (TBD)

  Usage:

	% dcm_check [--installPkgDir $ICFDK_ROOT] -techNode 1222.3/x1r3

	% dcm_check [--preInstallCheck] --packageList <BundlePackageListFile>

