export DIR_BUILD_CONFIG :=  $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

COPY	:= cp 
DELETE := rm


ifeq ($(DIR_SERVICES),)
export DIR_SERVICES := $(realpath ../../services)
endif

ifeq ($(DIR_HANDLERS),)
export DIR_HANDLERS := $(realpath ../../handlers)
endif

ifeq ($(DIR_CORE),)
export DIR_CORE := $(realpath ../../core)
endif


include $(DIR_BUILD_CONFIG)/project.properties


SERVICES_BUILD_DIRS := $(shell find $(DIR_SERVICES) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)
HANDLERS_BUILD_DIRS := $(shell find $(DIR_HANDLERS) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)

#
# Make some phony targets to allow us to pass targets to the makefiles in each of subdirectories
#
SERVICES_ALL := $(SERVICES_BUILD_DIRS:%=all-%)
SERVICES_INSTALL := $(SERVICES_BUILD_DIRS:%=install-%)
SERVICES_CLEAN := $(SERVICES_BUILD_DIRS:%=clean-%)

HANDLERS_ALL := $(HANDLERS_BUILD_DIRS:%=all-%)
HANDLERS_INSTALL := $(HANDLERS_BUILD_DIRS:%=install-%)
HANDLERS_CLEAN := $(HANDLERS_BUILD_DIRS:%=clean-%)

# targets depends on the same target name in each of the directories 
all: core-all $(SERVICES_ALL) $(HANDLERS_ALL)
install: core-install $(SERVICES_INSTALL) $(HANDLERS_INSTALL)
clean: core-clean $(SERVICES_CLEAN) $(HANDLERS_CLEAN)


# remove the fake prefixes and call the targets
$(SERVICES_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:all-%=%) all

$(SERVICES_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:install-%=%) install

$(SERVICES_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:clean-%=%) clean

$(HANDLERS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:all-%=%) all

$(HANDLERS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:install-%=%) install

$(HANDLERS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:clean-%=%) clean



.PHONY: subdirs $(SERVICES_ALL) $(HANDLERS_ALL)
.PHONY: subdirs $(SERVICES_INSTALL) $(HANDLERS_INSTALL)
.PHONY: subdirs $(SERVICES_CLEAN) $(HANDLERS_CLEAN)
.PHONY: all install clean core-all core-clean 



core-all:
	@echo "****** BEGIN GRASSROOTS CORE ******"
	@echo ">>> DIR_CORE $(DIR_CORE)"
	echo "****** CALLING $(MAKE) -C $(DIR_CORE) all ******"; 
	$(MAKE) -C $(DIR_CORE) all 
	@echo "****** END GRASSROOTS CORE ******"	


core-clean:
	@echo "****** BEGIN GRASSROOTS CORE ******"
	@echo ">>> DIR_CORE $(DIR_CORE)"
	echo "****** CALLING $(MAKE) -C $(DIR_CORE) clean ******"; 
	$(MAKE) -C $(DIR_CORE) clean 
	@echo "****** END GRASSROOTS CORE ******"	
	
core-install:
	@echo "****** BEGIN GRASSROOTS CORE ******"
	@echo ">>> DIR_CORE $(DIR_CORE)"
	echo "****** CALLING $(MAKE) -C $(DIR_CORE) install ******"; 
	$(MAKE) -C $(DIR_CORE) install 
	@echo "****** END GRASSROOTS CORE ******"	

services-all: core-all
	@echo "****** BEGIN INDIVIDUAL SERVICES ******"
	@echo ">>> SERVICES_DIR $(DIR_SERVICES)"
	@echo ">>> SERVICES_BUILD_DIRS: $(SERVICES_BUILD_DIRS)"
	$(foreach SERVICE_BUILD_DIR,$(SERVICES_BUILD_DIRS), \
		echo "****** CALLING $(MAKE) -C $(SERVICE_BUILD_DIR) all ******"; \
		$(MAKE) -C $(SERVICE_BUILD_DIR) all; \
		echo "****** END $(SERVICE_BUILD_DIR) ******\n";)	
	@echo "****** END INDIVIDUAL SERVICES ******"	
	

services-clean:
	@echo "****** BEGIN INDIVIDUAL SERVICES ******"
	@echo ">>> SERVICES_DIR $(DIR_SERVICES)"
	@echo ">>> SERVICES_BUILD_DIRS: $(SERVICES_BUILD_DIRS)"
	@$(foreach SERVICE_BUILD_DIR,$(SERVICES_BUILD_DIRS), \
		echo "****** CALLING $(MAKE) -C $(SERVICE_BUILD_DIR) clean ******"; \
		$(MAKE) -C $(SERVICE_BUILD_DIR) clean; \
		echo "****** END $(SERVICE_BUILD_DIR) ******\n";)	
	@echo "****** END INDIVIDUAL SERVICES ******"		