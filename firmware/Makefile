BUILD ?= SOLUM_AUTODETECT

ifeq ($(BUILD),SOLUM_AUTODETECT)
  FULL_BASE_NAME=SOLUM_AUTODETECT_FULL
  OTA_BASE_NAME=upgrade_OEPL_UNI
endif


COMMANDER=~/.local/bin/commander/commander

DEVICE=EFR32BG22C222F352GM40


BUILD_DIR=firmware
FW_SLPC_FILE=$(BUILD_DIR)/EFR32xG22_OEPL.slcp
BL_SLPC_FILE=bootloader/EFR32_SPIF_SingleSlot_BTL.slcp
FW_OUT_DIR=$(BUILD_DIR)/out
BOOTLOADER_DIR=bootloader
BL_OUT_DIR=$(BOOTLOADER_DIR)/out
BASE_BIN_DIR=$(BOOTLOADER_DIR)/base_binaries
VARIANT_BIN_DIR=$(BOOTLOADER_DIR)/variant_binaries

APP_S37=$(FW_OUT_DIR)/build/debug/EFR32xG22_OEPL.s37
BL_S37=$(BL_OUT_DIR)/build/debug/EFR32_SPIF_SingleSlot_BTL.s37
PATCHED_BL_S37=$(VARIANT_BIN_DIR)/$(BUILD).s37

GIT_VERSION := $(shell git describe --abbrev=4 --dirty --always --tags --all --match releases/*)
THIS_VER := $(shell cat ../$(FW_SLPC_FILE) | sed 's/\r$$//' | awk '/SL_APPLICATION_VERSION/ {gsub(/'"'"'|"|\}|\s/, "", $$5);print $$5}')
GSDK_PATH="/gecko_sdk/"
FW_SLC_GEN_CMD=slc generate -v DEBUG -s $(GSDK_PATH) -p $(FW_SLPC_FILE) -o makefile -d $(FW_OUT_DIR) -cp
BL_BULD_CMD=sh -c "cd $(BOOTLOADER_DIR);bash build_bootloaders.sh"
BUILD_FW_CMD=env C_DEFS=-DGIT_COMMIT_ID=\\\"$(GIT_VERSION)\\\" make -C $(FW_OUT_DIR) -f EFR32xG22_OEPL.Makefile -j8

BUILD_FULL_CMD=commander convert -o $(FULL_S37) $(PATCHED_BL_S37) $(APP_S37)
BUILD_OTA_CMD=commander gbl create $(OTA_GBL) --app $(APP_S37) --compress lzma --metadata firmware/fwid.bin

FULL_S37=$(FULL_BINARIES_DIR)/$(FULL_BASE_NAME)_v$(THIS_VER).s37
OTA_GBL=$(OTA_DIR)/$(OTA_BASE_NAME)_v$(THIS_VER).ota.bin


FULL_BINARIES_DIR=full_binaries/v$(THIS_VER)
OTA_DIR=ota_files

DOCKER_ARGS=run --rm -it --user builder -v $(CURDIR)/..:/build -v ~/.gitconfig:/home/builder/.gitconfig silabs-builder

.PHONY: build clean veryclean bootloader firmware reset flash version help debug

build: ../$(FULL_BINARIES_DIR) ../$(OTA_DIR) ../$(FULL_S37) ../$(OTA_GBL)

../$(FULL_S37): ../$(BL_S37) ../$(APP_S37)
	docker $(DOCKER_ARGS) $(BUILD_FULL_CMD)

../$(OTA_GBL):
	docker $(DOCKER_ARGS) $(BUILD_OTA_CMD)

clean:
	rm -rf ../$(FW_OUT_DIR) ../$(FULL_S37) ../$(OTA_GBL)

veryclean: clean
	rm -rf ../$(BL_OUT_DIR) ../$(BASE_BIN_DIR)

../$(OTA_DIR) ../$(FULL_BINARIES_DIR) ../$(BASE_BIN_DIR) ../$(BL_OUT_DIR):
	mkdir -p $@

../$(BL_S37): ../$(BL_OUT_DIR)
	@echo "Building bootloader..."
	docker $(DOCKER_ARGS) $(BL_BULD_CMD)
	@echo "Bootloader built successfully"


../$(APP_S37):
	@echo "Building firmware..."
	rm -rf ../$(FW_OUT_DIR)
	docker $(DOCKER_ARGS) $(FW_SLC_GEN_CMD)
	sed -i 's/C_DEFS   =/C_DEFS ?=/' ../${FW_OUT_DIR}/EFR32xG22_OEPL.Makefile
	sed -i 's/, LFXO/, LFRCO/' ../${FW_OUT_DIR}/autogen/sl_device_init_clocks.c
	sed -i 's/ sl_device_init_lfxo/\/\/ sl_device_init_lfxo/' ../${FW_OUT_DIR}/autogen/sl_event_handler.c
	docker $(DOCKER_ARGS) $(BUILD_FW_CMD)
	@echo "Firmware built successfully"

bootloader: ../$(BL_S37) 

firmware: ../$(APP_S37)

reset:
	$(COMMANDER) device reset

flash:
	$(COMMANDER) flash -d $(DEVICE) ../$(FULL_S37)

erase:
	$(COMMANDER) device masserase -d $(DEVICE)

help:	
	@echo "Usage:"
	@echo "  make            - build entire image"
	@echo "  make reset      - reset board"
	@echo "  make flash      - flash image"
	@echo "  make clean      - clean only app build, leaving bootloader"
	@echo "  make veryclean  - clean bootloader and app builds"
	@echo "  make bootloader - build bootloader (only)"
	@echo "  make firmware   - build app (only)"
	@echo "  make help       - help (you're looking at it)"

debug:
	@echo "FULL_S37: $(FULL_S37)"
	@echo "OTA_GBL: $(OTA_GBL)"
	@echo "GIT_VERSION: $(GIT_VERSION)"
	@echo "THIS_VER: $(THIS_VER)"
	@echo "BUILD: $(BUILD)"
	@echo "FW_OUT_DIR: $(FW_OUT_DIR)"
	@echo "BL_OUT_DIR: $(BL_OUT_DIR)"
	@echo "BOOTLOADER_DIR: $(BOOTLOADER_DIR)"
	@echo "FW_SLPC_FILE $(FW_SLPC_FILE)"
	@echo "APP_S37 $(APP_S37)"
	@echo "BL_S37: $(BL_S37)"
	@echo "FULL_BINARIES_DIR: $(FULL_BINARIES_DIR)"
	@echo "DEVICE: $(DEVICE)"



