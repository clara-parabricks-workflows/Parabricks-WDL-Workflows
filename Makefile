WORKFLOWS_DIR := workflows
UTILS_DIR := utils
SUBDIRS := $(shell find $(WORKFLOWS_DIR) -mindepth 1 -maxdepth 1 -type d)
SUBDIR_NAMES := $(notdir $(SUBDIRS))
DOWNLOAD_SCRIPT := download_data.sh

.PHONY: all download-all $(SUBDIR_NAMES) ref 

all: download-all ref

download-all: $(SUBDIR_NAMES) ref

$(SUBDIR_NAMES):
	@echo "Running download script in $@..."
	@cd $(WORKFLOWS_DIR)/$@ && bash $(DOWNLOAD_SCRIPT)

ifneq ($(MAKECMDGOALS),)
  SUBDIR_NAMES := $(filter $(MAKECMDGOALS), $(SUBDIR_NAMES))
endif

ref:
	@echo "Running reference download script..."
	@cd $(UTILS_DIR) && bash download_reference.sh