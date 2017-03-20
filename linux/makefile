export DIR_BUILD_CONFIG :=  $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

COPY	:= cp 
DELETE := rm



ifeq ($(DIR_SERVERS),)
export DIR_SERVERS := $(realpath ../../servers)
endif

ifeq ($(DIR_SERVICES),)
export DIR_SERVICES := $(realpath ../../services)
endif

ifeq ($(DIR_HANDLERS),)
export DIR_HANDLERS := $(realpath ../../handlers)
endif

ifeq ($(DIR_CLIENTS),)
export DIR_CLIENTS := $(realpath ../../clients)
endif


ifeq ($(DIR_CORE),)
export DIR_CORE := $(realpath ../../core)
endif


include $(DIR_BUILD_CONFIG)/project.properties

#
# Get all of the build files for each component
SERVERS_BUILD_DIRS := $(shell find $(DIR_SERVERS) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)
SERVICES_BUILD_DIRS := $(shell find $(DIR_SERVICES) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)
HANDLERS_BUILD_DIRS := $(shell find $(DIR_HANDLERS) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)
CLIENTS_BUILD_DIRS := $(shell find $(DIR_CLIENTS) -path '*/build/$(PLATFORM)/makefile' | xargs dirname)

#
# Make some phony targets to allow us to pass targets to the makefiles in each of subdirectories
#
SERVICES_ALL := $(SERVICES_BUILD_DIRS:%=all-%)
SERVICES_INSTALL := $(SERVICES_BUILD_DIRS:%=install-%)
SERVICES_CLEAN := $(SERVICES_BUILD_DIRS:%=clean-%)

HANDLERS_ALL := $(HANDLERS_BUILD_DIRS:%=all-%)
HANDLERS_INSTALL := $(HANDLERS_BUILD_DIRS:%=install-%)
HANDLERS_CLEAN := $(HANDLERS_BUILD_DIRS:%=clean-%)

SERVERS_ALL := $(SERVERS_BUILD_DIRS:%=all-%)
SERVERS_INSTALL := $(SERVERS_BUILD_DIRS:%=install-%)
SERVERS_CLEAN := $(SERVERS_BUILD_DIRS:%=clean-%)

CLIENTS_ALL := $(CLIENTS_BUILD_DIRS:%=all-%)
CLIENTS_INSTALL := $(CLIENTS_BUILD_DIRS:%=install-%)
CLIENTS_CLEAN := $(CLIENTS_BUILD_DIRS:%=clean-%)

# targets depends on the same target name in each of the directories 
all: core-all $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL) $(CLIENTS_ALL)
install: all core-install $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL) $(CLIENTS_INSTALL)
clean: core-clean $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN)

#
# Check any repositoiries to see if they are modified and need committing
check-git:
	@echo "Repositories that need committing:"
	@echo "==================================\n"
	@git diff-index --name-only --quiet HEAD -- || echo "$(DIR_BUILD_CONFIG)";
	@cd $(DIR_CORE) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_CORE)";
	@$(foreach SERVER_BUILD_DIR,$(SERVERS_BUILD_DIRS), \
		cd $(SERVER_BUILD_DIR) && git diff-index --name-only --quiet HEAD -- || echo "$(SERVER_BUILD_DIR)";)	
	@$(foreach SERVICE_BUILD_DIR,$(SERVICES_BUILD_DIRS), \
		cd $(SERVICE_BUILD_DIR) && git diff-index --name-only --quiet HEAD -- || echo "$(SERVICE_BUILD_DIR)";)	
	@$(foreach HANDLER_BUILD_DIR,$(HANDLERS_BUILD_DIRS), \
		cd $(HANDLER_BUILD_DIR) && git diff-index --name-only --quiet HEAD -- || echo "$(HANDLER_BUILD_DIR)";)	
	@$(foreach CLIENT_BUILD_DIR,$(CLIENTS_BUILD_DIRS), \
		cd $(CLIENT_BUILD_DIR) && git diff-index --name-only --quiet HEAD -- || echo "$(CLIENT_BUILD_DIR)";)	
		

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

$(SERVERS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:all-%=%) all

$(SERVERS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:install-%=%) install

$(SERVERS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:clean-%=%) clean

$(CLIENTS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:all-%=%) all

$(CLIENTS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:install-%=%) install

$(CLIENTS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:clean-%=%) clean

# declare the phony targets
.PHONY: subdirs $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL) $(CLIENTS_ALL)
.PHONY: subdirs $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL) $(CLIENTS_INSTALL)
.PHONY: subdirs $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN)
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
