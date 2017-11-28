# DCM utility testcase 1

  This testcase will guide you through the dcm release note validation prcocess
by importing dcm file into releaseNotes/ directory. (make import)
  Then you can start install the collateral to the techLib/ directory using the
interactive installation method. (make install)
  At the end you can use the package log stored in the techLib to reproduce the
installation proceduce and make sure the result are consistent. (make bundle)

Step 0 - Check the collateral package and dcm config file :

	% make env

	==========================================
	ICFDK_HOME = techLib
	ICFDK_CFGS = configs
	ICFDK_PKGS = packages
	ICFDK_RELN = releaseNotes
	==========================================


	% ls packages

	GPIO_lib222_e.0.6.1.dcm
	GPIO_lib222_e.0.6.1.tgz
	GPIO_lib222_e.0.6.dcm
	MEMORY_lib222_2PRF_e.0.6.dcm
	MEMORY_lib222_2PRF_e.0.6.tgz
	P1222.2ADF_r0.6.1.dcm
	P1222.2ADF_r0.6.1.tgz
	P1222.2CTK_r0.6.1.dcm
	P1222.2CTK_r0.6.1.tgz
	P1222.2PDK_r0.6.1.dcm
	P1222.2PDK_r0.6.1.tgz
	P1222.2PDK_r1.0.1.dcm
	P1222.2PDK_r1.0.1.tgz
	P1222.2PDK_r1.0HF4.dcm
	P1222.2PDK_r1.0HF4.tgz
	P1222.2PDK_r1.0hf5.tgz
	P1222.2PDK_r1.0hf6.tgz
	P1222.2PDK_r1.0hf7.dcm
	P1222.2PDK_r1.0hf7.tgz
	STDCELL_lib222_6t_base_e.1.0.dcm
	STDCELL_lib222_6t_base_e.1.0.tgz
	STDCELL_lib222_7t_base_e.2.0.dcm
	STDCELL_lib222_7t_base_e.2.0-1.tgz
	STDCELL_lib222_7t_base_e.2.0-2.tgz
	STDCELL_lib222_7t_base_e.2.0-3.tgz

***
Step 1 - Import the dcm configuration file to releaseNotes directory :

	==========================
	% make import
	==========================
	CMDS: dcm_import --packageSrcDir packages --releaseNoteDir releaseNotes --targetLibDir techLib
	TIME: @20171109_015748 BEGIN dcm_import
	[dcm_import]: BEGIN 
	[1]: Reading packages/GPIO_lib222_e.0.6.1.dcm
	    : Package file - packages/GPIO_lib222_e.0.6.1.tgz
	    : Creating '1222.2/x1r0/HIP/GPIO/ip222_gpio_r061/GPIO_lib222_e.0.6.1.releaseNote' (r0.6.1)

	[2]: Reading packages/GPIO_lib222_e.0.6.dcm
	ERROR: Pacakge GPIO_lib222_e.0.6.tgz can not be found in package source.    
	ERROR: Kit 'GPIO_lib222_e.0.6' has 1 missing pacakge files	<=== This is intended to show

	[3]: Reading packages/MEMORY_lib222_2PRF_e.0.6.dcm
	    : Package file - packages/MEMORY_lib222_2PRF_e.0.6.tgz
	    : Creating '1222.2/x1r0/FIP/MEMORY/mem222_2prf_r061/MEMORY_lib222_2PRF_e.0.6.releaseNote' (r0.6.1)

	.....
	.....
	[11]: Reading packages/STDCELL_lib222_7t_base_e.2.0.dcm
	    : Package file - packages/STDCELL_lib222_7t_base_e.2.0-1.tgz
	    : Package file - packages/STDCELL_lib222_7t_base_e.2.0-2.tgz
	    : Package file - packages/STDCELL_lib222_7t_base_e.2.0-3.tgz
	    : Creating '1222.2/x1r0/FIP/STDCELL/lib222_7t_base_e20/STDCELL_lib222_7t_base_e.2.0.releaseNote' (7t_base_e.2.0)
	
	------------------------------------------------------------------
	SUMMARY: Total 10/11 dcm release notes are created.
	SUMMARY: Total 1/11 dcm files have missing package files. (error)	<=== This is intended to show
	------------------------------------------------------------------
	[dcm_import]: END
	--------------------------------------------------------
	TIME: @20171109_015754 END   dcm_import
	========================================================


	==========================
	% tree releaseNotes
	==========================

	releaseNotes/
	└── 1222.2
	    └── x1r0
	        ├── FDK
	        │   ├── ADF
	        │   │   └── adf222_r061
	        │   │       └── P1222.2ADF_r0.6.1.releaseNote
	        │   ├── CTK
	        │   │   └── ctk222_r061
	        │   │       └── P1222.2CTK_r0.6.1.releaseNote
	        │   └── PDK
	        │       ├── pdk222_r061
	        │       │   └── P1222.2PDK_r0.6.1.releaseNote
	        │       ├── pdk222_r101
	        │       │   └── P1222.2PDK_r1.0.1.releaseNote
	        │       ├── pdk222_r10HF4
	        │       │   └── P1222.2PDK_r1.0HF4.releaseNote
	        │       └── pdk222_r10HF7
	        │           └── P1222.2PDK_r1.0hf7.releaseNote
	        ├── FIP
	        │   ├── MEMORY
	        │   │   └── mem222_2prf_r061
        	│   │       └── MEMORY_lib222_2PRF_e.0.6.releaseNote
	        │   └── STDCELL
	        │       ├── lib222_6t_base_e10
	        │       │   └── STDCELL_lib222_6t_base_e.1.0.releaseNote
	        │       └── lib222_7t_base_e20
	        │           └── STDCELL_lib222_7t_base_e.2.0.releaseNote
	        └── HIP
	            └── GPIO
	                └── ip222_gpio_r061
        	            └── GPIO_lib222_e.0.6.1.releaseNote

	21 directories, 10 files

***
Step 2 - Install collateral package refer to releaseNotes directory :

	==========================
	% make install           <= enter interactive mode if there is no input file specifed
	==========================

	==============================================================
	INFO: Please specify Kit Category :
	.
	└── 1222.2
	    └── x1r0
		├── FDK
		│   ├── ADF
		│   ├── CTK
		│   └── PDK
		├── FIP
		│   ├── MEMORY
		│   └── STDCELL
		└── HIP
		    └── GPIO

	11 directories
	INPUT: Category = () ? 1222.2/x1r0/FDK
	
	==============================================================
	INFO: Current releaseNote directory: 1222.2/x1r0/FDK
	releaseNotes/1222.2/x1r0/FDK
	├── ADF
	│   └── adf222_r061
	├── CTK
	│   └── ctk222_r061
	└── PDK
	    ├── pdk222_r061
	    ├── pdk222_r101
	    ├── pdk222_r10HF4
	    └── pdk222_r10HF7

	9 directories, 6 files
	==============================================================
	INFO: Please select the following packages to be installed :
	[ releaseNotes/1222.2/x1r0/FDK ]:
	  0) Go back to previous selection menu..
		1) P1222.2ADF_r0.6.1	(adf222_r061)
		2) P1222.2CTK_r0.6.1	(ctk222_r061)
		3) P1222.2PDK_r0.6.1	(pdk222_r061
		4) P1222.2PDK_r1.0.1	(pdk222_r101)
		5) P1222.2PDK_r1.0HF4	(pdk222_r10HF4)
		6) P1222.2PDK_r1.0hf7	(pdk222_r10HF7)
	  q) quit..
	INPUT: Select ? 1
	========================================================
	INFO: Install kit 'releaseNotes/1222.2/x1r0/FDK/./ADF/adf222_r061/P1222.2ADF_r0.6.1.releaseNote' ..
	[1]: Reading releaseNotes/1222.2/x1r0/FDK/./ADF/adf222_r061/P1222.2ADF_r0.6.1.releaseNote
	ERROR: required kit dir '1222.2/x1r0/FDK/PDK/pdk222_r061' has not been installed yet.
	ERROR: Skip install 'P1222.2ADF_r0.6.1' (dependency fail)

	------------------------------------------------------------------
	SUMMARY: Total 1/1 kits require check fail. (error)
	------------------------------------------------------------------
	==============================================================
	INFO: Please select the following packages to be installed :
	[ releaseNotes/1222.2/x1r0/FDK ]:
	  0) Go back to previous selection menu..
		1) P1222.2ADF_r0.6.1
		2) P1222.2CTK_r0.6.1
		3) P1222.2PDK_r0.6.1
		4) P1222.2PDK_r1.0.1
		5) P1222.2PDK_r1.0HF4
		6) P1222.2PDK_r1.0hf7
	  q) quit..
	INPUT: Select ? 3 2 1
	========================================================
	INFO: Install kit 'releaseNotes/1222.2/x1r0/FDK/./PDK/pdk222_r061/P1222.2PDK_r0.6.1.releaseNote' ..
	[1]: Reading releaseNotes/1222.2/x1r0/FDK/./PDK/pdk222_r061/P1222.2PDK_r0.6.1.releaseNote
	    : Package file - packages/P1222.2PDK_r0.6.1.tgz
	INFO: Unpacking file 'packages/P1222.2PDK_r0.6.1.tgz' ...
	pdk222_r061/
	pdk222_r061/README

	------------------------------------------------------------------
	SUMMARY: Total 1/1 kits are installed.
	------------------------------------------------------------------
	INFO: Install kit 'releaseNotes/1222.2/x1r0/FDK/./CTK/ctk222_r061/P1222.2CTK_r0.6.1.releaseNote' ..
	[1]: Reading releaseNotes/1222.2/x1r0/FDK/./CTK/ctk222_r061/P1222.2CTK_r0.6.1.releaseNote
	    : Package file - packages/P1222.2CTK_r0.6.1.tgz
	INFO: Unpacking file 'packages/P1222.2CTK_r0.6.1.tgz' ...
	ctk222_r061/
	ctk222_r061/README

	------------------------------------------------------------------
	SUMMARY: Total 1/1 kits are installed.
	------------------------------------------------------------------
	INFO: Install kit 'releaseNotes/1222.2/x1r0/FDK/./ADF/adf222_r061/P1222.2ADF_r0.6.1.releaseNote' ..
	[1]: Reading releaseNotes/1222.2/x1r0/FDK/./ADF/adf222_r061/P1222.2ADF_r0.6.1.releaseNote
	    : Package file - packages/P1222.2ADF_r0.6.1.tgz
	INFO: Unpacking file 'packages/P1222.2ADF_r0.6.1.tgz' ...
	adf222_r061/
	adf222_r061/README

	------------------------------------------------------------------
	SUMMARY: Total 1/1 kits are installed.
	------------------------------------------------------------------
	techLib
	└── 1222.2
	    └── x1r0
		└── FDK
		    ├── ADF
		    │   └── adf222_r061
		    ├── CTK
		    │   └── ctk222_r061
		    └── PDK
			└── pdk222_r061

	9 directories, 0 files
	==============================================================
	.....

	==============================================================
	INFO: Please select the following packages to be installed :
	[ releaseNotes/ ]:
	  0) Go back to previous selection menu..
		1) P1222.2ADF_r0.6.1
		2) P1222.2CTK_r0.6.1
		3) P1222.2PDK_r0.6.1
		4) P1222.2PDK_r1.0.1
		5) P1222.2PDK_r1.0HF4
		6) P1222.2PDK_r1.0hf7
		7) MEMORY_lib222_2PRF_e.0.6
		8) STDCELL_lib222_6t_base_e.1.0
		9) STDCELL_lib222_7t_base_e.2.0
		10) GPIO_lib222_e.0.6.1
	  q) quit..
	INPUT: Select ? 7 8 9 10
	.....
	==============================================================
	INFO: Please select the following packages to be installed :
	[ releaseNotes/ ]:
	  0) Go back to previous selection menu..
		.....
	  q) quit..
	INPUT: Select ? q
	========================================================
	techLib
	└── 1222.2
	    └── x1r0
		├── FDK
		│   ├── ADF
		│   │   └── adf222_r061
		│   ├── CTK
		│   │   └── ctk222_r061
		│   └── PDK
		│       └── pdk222_r061
		├── FIP
		│   ├── MEMORY
		│   │   └── mem222_2prf_r061
		│   └── STDCELL
		│       └── lib222_6t_base_e10
		└── HIP
		    └── GPIO
			└── ip222_gpio_r061

	17 directories, 0 files
	TIME: @20171109_024710 END   dcm_install
	========================================================

	% cat techLib/.dcm_install.log

	20171109024620 hungchun % dcm_install releaseNotes/1222.2/x1r0/FDK/./PDK/pdk222_r061/P1222.2PDK_r0.6.1.releaseNote
	20171109024622 hungchun % dcm_install releaseNotes/1222.2/x1r0/FDK/./CTK/ctk222_r061/P1222.2CTK_r0.6.1.releaseNote
	20171109024623 hungchun % dcm_install releaseNotes/1222.2/x1r0/FDK/./ADF/adf222_r061/P1222.2ADF_r0.6.1.releaseNote
	20171109024653 hungchun % dcm_install releaseNotes//./1222.2/x1r0/FIP/STDCELL/lib222_6t_base_e10/STDCELL_lib222_6t_base_e.1.0.releaseNote
	20171109024703 hungchun % dcm_install releaseNotes//./1222.2/x1r0/FIP/MEMORY/mem222_2prf_r061/MEMORY_lib222_2PRF_e.0.6.releaseNote
	20171109024706 hungchun % dcm_install releaseNotes//./1222.2/x1r0/HIP/GPIO/ip222_gpio_r061/GPIO_lib222_e.0.6.1.releaseNote

***
Step 3 - Create bundleLib from the bundle List:

	% make bundle

	  # cp techLib/1222.2/x1r0/.dcm_packages bundleFile.txt

	P1222.2PDK_r0.6.1
	P1222.2CTK_r0.6.1
	P1222.2ADF_r0.6.1
	STDCELL_lib222_6t_base_e.1.0
	MEMORY_lib222_2PRF_e.0.6
	GPIO_lib222_e.0.6.1

	  # dcm_install --targetLibDir bundleLib --bundleList bundleFile.txt

	% tree -d bundleLib

	bundleLib/
	└── 1222.2
	    └── x1r0
		├── FDK
		│   ├── ADF
		│   │   └── adf222_r061
		│   ├── CTK
		│   │   └── ctk222_r061
		│   └── PDK
		│       └── pdk222_r061
		├── FIP
		│   ├── MEMORY
		│   │   └── mem222_2prf_r061
		│   └── STDCELL
		│       └── lib222_6t_base_e10
		└── HIP
		    └── GPIO
			└── ip222_gpio_r061

	17 directories
