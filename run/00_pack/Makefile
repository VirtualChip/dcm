TECH_NODE   := 1222.2/x1r0

ICFDK_HOME  := techLib
ICFDK_PKGS  := packages
ICFDK_RELN  := releaseNotes
BUNDLE_LIB  := bundleLib

DCM_BIN     := $(DCM_HOME)/bin
DCM_PACK    := $(DCM_BIN)/dcm_pack
DCM_IMPORT  := $(DCM_BIN)/dcm_import
DCM_INSTALL := $(DCM_BIN)/dcm_install
DCM_CHECK   := $(DCM_BIN)/dcm_check

COLLATERAL_CSV = collateral_r061.csv collateral_r101.csv
BUNDLE_LIST    = collateral_r061.bundle collateral_r101.bundle


DCM_OPTIONS  = --info --packageSrcDir $(ICFDK_PKGS) --releaseNoteDir $(ICFDK_RELN) --targetLibDir $(ICFDK_HOME)


help:
	@echo "Usage:"
	@echo "  make clean         ; clean up previouse data"
	@echo "  make pack          ; pack collater tar ball"
	@echo ""

run:	pack bundle diff

pack:
	$(DCM_PACK) $(DCM_OPTIONS) $(COLLATERAL_CSV)

import:
	$(DCM_IMPORT) $(DCM_OPTIONS)

install:
	$(DCM_INSTALL) $(DCM_OPTIONS)

bundle:
	@for file in $(BUNDLE_LIST); do \
	$(DCM_INSTALL) $(DCM_OPTIONS)  --targetLibDir $(BUNDLE_LIB) --bundleList $$file; \
	done;

diff:
	diff -r $(BUNDLE_LIB) $(ICFDK_HOME)

clean:
	rm -fr $(ICFDK_HOME)
	rm -fr $(ICFDK_PKGS)
	rm -fr $(ICFDK_RELN)
	rm -fr $(BUNDLE_LIB)
	rm -fr *.log *.bundle

