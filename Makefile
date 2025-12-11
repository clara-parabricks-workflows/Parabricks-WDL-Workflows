WORKFLOWS_DIR := workflows
UTILS_DIR := utils
SUBDIRS := $(shell find $(WORKFLOWS_DIR) -mindepth 1 -maxdepth 1 -type d)
SUBDIR_NAMES := $(notdir $(SUBDIRS))
DOWNLOAD_DATA_SCRIPT := download_data.sh
DOWNLOAD_REF_SCRIPT := download_reference.sh

.PHONY: all download-all $(SUBDIR_NAMES) ref 

all: download-all ref

download-all: $(SUBDIR_NAMES) ref

$(SUBDIR_NAMES):
	@echo "Downloading sample files for $@..."
	@cd $(WORKFLOWS_DIR)/$@ && bash $(DOWNLOAD_DATA_SCRIPT)

ifneq ($(MAKECMDGOALS),)
  SUBDIR_NAMES := $(filter $(MAKECMDGOALS), $(SUBDIR_NAMES))
endif

ref:
	@echo "Downloading references..."
	@cd $(UTILS_DIR) && bash $(DOWNLOAD_REF_SCRIPT)