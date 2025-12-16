WORKFLOWS_DIR := .
SUBDIRS := $(shell find $(WORKFLOWS_DIR) -mindepth 1 -maxdepth 1 -type d)
SUBDIR_NAMES := $(notdir $(SUBDIRS))
DOWNLOAD_DATA_SCRIPT := download_data.sh

.PHONY: all download-all $(SUBDIR_NAMES)  

all: download-all

download-all: $(SUBDIR_NAMES)

$(SUBDIR_NAMES):
	@echo "Downloading sample files for $@..."
	@if [ -f $(WORKFLOWS_DIR)/$@/tests/$(DOWNLOAD_DATA_SCRIPT) ]; then \
		cd $(WORKFLOWS_DIR)/$@/tests && \
		bash $(DOWNLOAD_DATA_SCRIPT); \
	fi

ifneq ($(MAKECMDGOALS),)
  SUBDIR_NAMES := $(filter $(MAKECMDGOALS), $(SUBDIR_NAMES))
endif