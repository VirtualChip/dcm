DCM_BIN  = $(DCM_HOME)/bin

ICFDK_PKGS  = packages
ICFDK_RELN  = releaseNotes
ICFDK_HOME  = techLib

DCM_OPTIONS  = --info --packageSrcDir $(ICFDK_PKGS) --releaseNoteDir $(ICFDK_RELN) --targetLibDir $(ICFDK_HOME)

DCM_CATEGORY = 1222.2/x1r0
BUNDLE_FILE  = bundleFile.txt
BUNDLE_LIB   = bundleLib

DCM_IMPORT  = $(DCM_BIN)/dcm_import
DCM_INSTALL = $(DCM_BIN)/dcm_install
DCM_CHECK   = $(DCM_BIN)/dcm_check

help:
	@echo "Usage:"
	@echo "  make clean         ; clean up previouse data"
	@echo "  make import        ; import *.dcm to releaseNotes"
	@echo "  make install       ; install collateral pacakge to $(ICFDK_HOME)"
	@echo "  make category      ; filter pacakge with $(DCM_CATEGORY)/"
	@echo ""
	@echo "  make bundle        ; create bundleLib at $(BUNDLE_LIB)"
	@echo "  make diff          ; compare $(ICFDK_HOME)/ with $(BUNDLE_LIB)/"

import:
	$(DCM_IMPORT) $(DCM_OPTIONS)

install:
	$(DCM_INSTALL) $(DCM_OPTIONS)

category:
	$(DCM_INSTALL) $(DCM_OPTIONS) --selectCategory $(DCM_CATEGORY)
	
bundle:
	cp $(ICFDK_HOME)/$(DCM_CATEGORY)/.dcm_packages $(BUNDLE_FILE)
	$(DCM_INSTALL) --targetLibDir $(BUNDLE_LIB) --bundleList $(BUNDLE_FILE)

diff:
	diff -r $(BUNDLE_LIB) $(ICFDK_HOME)

clean:
	rm -fr $(ICFDK_RELN)
	rm -fr $(ICFDK_HOME)
	rm -fr $(BUNDLE_LIB)
	rm -fr *.log *.txt

