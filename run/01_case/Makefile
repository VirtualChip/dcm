ICFDK_HOME  := techLib
ICFDK_PKGS  := packages
ICFDK_RELN  := releaseNotes

DCM_BIN     := $(DCM_HOME)/bin
DCM_IMPORT  := $(DCM_BIN)/dcm_import
DCM_INSTALL := $(DCM_BIN)/dcm_install
DCM_CHECK   := $(DCM_BIN)/dcm_check

TECH_NODE    = 1222.2/x1r0
BUNDLE_FILE  = bundleFile.txt
BUNDLE_LIB   = bundleLib

DCM_OPTIONS  = --info --packageSrcDir $(ICFDK_PKGS) --releaseNoteDir $(ICFDK_RELN) --targetLibDir $(ICFDK_HOME)


help:
	@echo "Usage:"
	@echo "  make clean         ; clean up previouse run log and data"
	@echo "  make env           ; show all environment variables"
	@echo "  make import        ; import *.dcm to releaseNotes"
	@echo "  make install       ; install collateral pacakge to $(ICFDK_HOME)"
	@echo ""
	@echo "  make bundle        ; create bundleLib at $(BUNDLE_LIB)"
	@echo "  make diff          ; compare $(ICFDK_HOME)/ with $(BUNDLE_LIB)/"
	@echo ""

run: import install_test bundle diff

env:
	@echo "=========================================="
	@echo "ICFDK_HOME = $(ICFDK_HOME)"
	@echo "ICFDK_PKGS = $(ICFDK_PKGS)"
	@echo "ICFDK_RELN = $(ICFDK_RELN)"
	@echo "=========================================="
	
pdk:
	$(DCM_IMPORT) $(DCM_OPTIONS) $(ICFDK_PKGS)/P1222.2PDK_r0.6.1.dcm
	
import:
	$(DCM_IMPORT) $(DCM_OPTIONS)

install:
	$(DCM_INSTALL) $(DCM_OPTIONS)
	cat $(ICFDK_HOME)/.dcm_install.summary

install_category:
	$(DCM_INSTALL) $(DCM_OPTIONS) --selectByCategory $(TECH_NODE)
	

install_test:
	$(DCM_INSTALL) --log install_test.log $(DCM_OPTIONS) < golden/install_test.cmd

bundle: $(BUNDLE_FILE)
	$(DCM_INSTALL) --log dcm_bundle.log --targetLibDir $(BUNDLE_LIB) --bundleList $(BUNDLE_FILE)

$(BUNDLE_FILE): $(ICFDK_HOME)/$(TECH_NODE)/.dcm_packages
	@echo
	cp -f $(ICFDK_HOME)/$(TECH_NODE)/.dcm_packages $(BUNDLE_FILE)
	@echo
	@echo "=========================================="
	cat $(BUNDLE_FILE)
	@echo "=========================================="
	@echo

diff:
	diff -r $(BUNDLE_LIB) $(ICFDK_HOME)

clean:
	rm -fr $(ICFDK_RELN)
	rm -fr $(ICFDK_HOME)
	rm -fr $(BUNDLE_LIB)
	rm -fr *.txt *.log *.log.*

