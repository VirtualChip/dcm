BIN_PATH := bin
CSH_PATH := ../csh

bin: csh/* csh/
	mkdir -p $(BIN_PATH)
	rm -fr $(BIN_PATH)/dcm_*
	ln -f -s $(CSH_PATH)/dcm_help.csh			$(BIN_PATH)/dcm_help
	ln -f -s $(CSH_PATH)/dcm_pack.csh			$(BIN_PATH)/dcm_pack
	ln -f -s $(CSH_PATH)/dcm_import.csh			$(BIN_PATH)/dcm_import
	ln -f -s $(CSH_PATH)/dcm_install.csh			$(BIN_PATH)/dcm_install
	ln -f -s $(CSH_PATH)/dcm_check.csh			$(BIN_PATH)/dcm_check
