#
#
#
TECH_NODE   := 1222.2/x1r0

ICFDK_HOME  := techLib
ICFDK_CFGS  := configs
ICFDK_PKGS  := packages
ICFDK_RELN  := releaseNotes
BUNDLE_LIB  := bundleLib

DCM_BIN     := $(DCM_HOME)/bin
DCM_PACK    := $(DCM_BIN)/dcm_pack
DCM_IMPORT  := $(DCM_BIN)/dcm_import
DCM_INSTALL := $(DCM_BIN)/dcm_install
DCM_CHECK   := $(DCM_BIN)/dcm_check

DCM_PACK_TEMP  = tempLib

COLLATERAL_CSV = collateral_r061.csv collateral_r101.csv
PATCH_CSV      = patch_pdk222_r101.csv
BUNDLE_LIST    = collateral_r061.bundle collateral_r101.bundle


DCM_OPTIONS  = --info --selectCategory $(TECH_NODE)
DCM_OPTIONS += --packageCfgDir $(ICFDK_CFGS) --releaseNoteDir $(ICFDK_RELN) 
DCM_OPTIONS += --packageSrcDir $(ICFDK_PKGS) --targetLibDir $(ICFDK_HOME)

DCM_PACK_OPT = --packCfgsDir $(ICFDK_CFGS) --packDestDir $(ICFDK_PKGS) --packTempDir $(DCM_PACK_TEMP) 


help:
	@echo "Usage:"
	@echo "  make clean         ; clean up previouse data"
	@echo "  make pack          ; pack collateral dcm and tar ball"
	@echo "  make bundle        ; create bundle lib"
	@echo ""

run:	pack bundle 

pack:
	$(DCM_PACK) $(DCM_PACK_OPT) $(COLLATERAL_CSV)

patch:
	$(DCM_PACK) $(DCM_PACK_OPT) $(PATCH_CSV)

import:
	$(DCM_IMPORT) $(DCM_OPTIONS)

install: $(ICFDK_RELN)
	$(DCM_INSTALL) $(DCM_OPTIONS)

bundle: $(BUNDLE_LIST)
	@for file in $(BUNDLE_LIST); do \
	$(DCM_INSTALL) $(DCM_OPTIONS)  --targetLibDir $(BUNDLE_LIB) --bundleList $$file; \
	done;

diff:
	diff -r $(BUNDLE_LIB) $(ICFDK_HOME)

$(ICFDK_RELN): import

$(ICFDK_HOME): install

$(BUNDLE_LIST): pack

clean:
	rm -fr $(ICFDK_HOME)
	rm -fr $(ICFDK_CFGS)
	rm -fr $(ICFDK_PKGS)
	rm -fr $(ICFDK_RELN)
	rm -fr $(ICFDK_TEMP)
	rm -fr $(DCM_PACK_TEMP)
	rm -fr $(BUNDLE_LIB)
	rm -fr *.log *.bundle *.log.*

