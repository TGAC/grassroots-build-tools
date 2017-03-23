THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))
export DIR_BUILD_CONFIG :=  $(realpath $(dir $(THIS_MAKEFILE)))


#
# If it is not already set, get the path to where all
# of the separate server instances are stored
#
ifeq ($(DIR_SERVERS),)
export DIR_SERVERS := $(realpath $(DIR_BUILD_CONFIG)/../../servers)
endif

#
# If it is not already set, get the path to where all
# of the separate service instances are stored
#
ifeq ($(DIR_SERVICES),)
export DIR_SERVICES := $(realpath $(DIR_BUILD_CONFIG)/../../services)
endif

#
# If it is not already set, get the path to where all
# of the separate handler instances are stored
#
ifeq ($(DIR_HANDLERS),)
export DIR_HANDLERS := $(realpath $(DIR_BUILD_CONFIG)/../../handlers)
endif

#
# If it is not already set, get the path to where all
# of the separate client instances are stored
#
ifeq ($(DIR_CLIENTS),)
export DIR_CLIENTS := $(realpath $(DIR_BUILD_CONFIG)/../../clients)
endif

#
# If it is not already set, get the path to where the Grassroots
# core repository is checked out to.
#
ifeq ($(DIR_CORE),)
export DIR_CORE := $(realpath $(DIR_BUILD_CONFIG)/../../core)
endif


COPY	:= cp 
DELETE := rm

#################################################################
##### Hopefully you should not need to edit below this line #####
#################################################################

#
# Get the directory containing this makefile
#
FAKE_TARGET_PREFIX := --

include $(DIR_BUILD_CONFIG)/project.properties

#
# Get all of the build files for each component
#
SERVERS_BUILD_DIRS := $(shell find $(DIR_SERVERS) -path '*/build/$(PLATFORM)/makefile' | xargs -n 1 dirname)
SERVICES_BUILD_DIRS := $(shell find $(DIR_SERVICES) -path '*/build/$(PLATFORM)/makefile' | xargs -n 1 dirname)
HANDLERS_BUILD_DIRS := $(shell find $(DIR_HANDLERS) -path '*/build/$(PLATFORM)/makefile' | xargs -n 1 dirname)
CLIENTS_BUILD_DIRS := $(shell find $(DIR_CLIENTS) -path '*/build/$(PLATFORM)/makefile' | xargs -n 1 dirname)

#
# Make some phony targets to allow us to pass targets to the makefiles in each of subdirectories
#
SERVICES_ALL := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
SERVICES_INSTALL := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
SERVICES_CLEAN := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)

HANDLERS_ALL := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
HANDLERS_INSTALL := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
HANDLERS_CLEAN := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)

SERVERS_ALL := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
SERVERS_INSTALL := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
SERVERS_CLEAN := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)

CLIENTS_ALL := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
CLIENTS_INSTALL := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
CLIENTS_CLEAN := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)

#
# targets depends on the same target name in each of the directories 
#
all: core-all $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL) $(CLIENTS_ALL)
install: all core-install $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL) $(CLIENTS_INSTALL)
clean: core-clean $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN)

#
# Check any repositories to see if they are modified and need committing
#
git-check:
	@echo "Repositories that need committing:"
	@echo "==================================\n"
	@git diff-index --name-only --quiet HEAD -- || echo "$(DIR_BUILD_CONFIG)";
	@cd $(DIR_CORE) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_CORE)";
	@$(foreach SERVER_BUILD_DIR,$(SERVERS_BUILD_DIRS), \
		cd $(SERVER_BUILD_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(SERVER_BUILD_DIR)";)	
	@$(foreach SERVICE_BUILD_DIR,$(SERVICES_BUILD_DIRS), \
		cd $(SERVICE_BUILD_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(SERVICE_BUILD_DIR)";)	
	@$(foreach HANDLER_BUILD_DIR,$(HANDLERS_BUILD_DIRS), \
		cd $(HANDLER_BUILD_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(HANDLER_BUILD_DIR)";)	
	@$(foreach CLIENT_BUILD_DIR,$(CLIENTS_BUILD_DIRS), \
		cd $(CLIENT_BUILD_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(CLIENT_BUILD_DIR)";)	

#
# Update any local copies of repositories
#
git-pull:
	@echo "Updating local copies:"
	@echo "======================\n"
	@echo ">>> Updating $(DIR_BUILD_CONFIG)" 
	@git pull
	@echo ">>> Updating $(DIR_CORE)" 
	@cd $(DIR_CORE) && git pull;
	@$(foreach SERVER_BUILD_DIR,$(SERVERS_BUILD_DIRS), \
		echo ">>> Updating $(SERVER_BUILD_DIR)"; cd $(SERVER_BUILD_DIR); git pull;)	
	@$(foreach SERVICE_BUILD_DIR,$(SERVICES_BUILD_DIRS), \
		echo ">>> Updating $(SERVICE_BUILD_DIR)"; cd $(SERVICE_BUILD_DIR); git pull;)	
	@$(foreach HANDLER_BUILD_DIR,$(HANDLERS_BUILD_DIRS), \
		echo ">>> Updating $(HANDLER_BUILD_DIR)"; cd $(HANDLER_BUILD_DIR); git pull;)	
	@$(foreach CLIENT_BUILD_DIR,$(CLIENTS_BUILD_DIRS), \
		echo ">>> Updating $(CLIENT_BUILD_DIR)"; cd $(CLIENT_BUILD_DIR); git pull;)	
		

show-config:
	@echo "DIR_SERVERS: $(DIR_SERVERS)"
	@echo "DIR_SERVICES: $(DIR_SERVICES)"
	@echo "DIR_HANDLERS: $(DIR_HANDLERS)"
	@echo "DIR_CLIENTS: $(DIR_CLIENTS)"
	@echo "DIR_CORE: $(DIR_CORE)"
	@echo "SERVERS_BUILD_DIRS: $(SERVERS_BUILD_DIRS)"
	@echo "SERVICES_BUILD_DIRS: $(SERVICES_BUILD_DIRS)"
	@echo "HANDLERS_BUILD_DIRS: $(HANDLERS_BUILD_DIRS)"
	@echo "CLIENTS_BUILD_DIRS: $(CLIENTS_BUILD_DIRS)"

#
# Show all of the avialable targets, taken from 
# http://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
#
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(THIS_MAKEFILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
	  
# remove the fake prefixes and call the targets
$(SERVICES_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all

$(SERVICES_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)install-%=%) install

$(SERVICES_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)clean-%=%) clean

$(HANDLERS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all

$(HANDLERS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)install-%=%) install

$(HANDLERS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)clean-%=%) clean

$(SERVERS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all

$(SERVERS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)install-%=%) install

$(SERVERS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)clean-%=%) clean

$(CLIENTS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all

$(CLIENTS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)install-%=%) install

$(CLIENTS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)clean-%=%) clean

# declare the phony targets
.PHONY: subdirs $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL) $(CLIENTS_ALL)
.PHONY: subdirs $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL) $(CLIENTS_INSTALL)
.PHONY: subdirs $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN)
.PHONY: all install clean core-all core-clean 
.PHONY: git-pull git-check show-config

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
