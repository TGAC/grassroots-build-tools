#
# Get the directory containing this makefile
#
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


# If it is not already set, get the path to where the Grassroots
# core repository is checked out to.
#
ifeq ($(DIR_CORE),)
export DIR_CORE := $(realpath $(DIR_BUILD_CONFIG)/../../core)
endif


#
# If it is not already set, get the path to where the Grassroots
# docs repository is checked out to.
#
ifeq ($(DIR_DOCS),)
export DIR_DOCS := $(realpath $(DIR_BUILD_CONFIG)/../../docs)
endif


#
# If it is not already set, get the path to where the Grassroots
# references repository is checked out to.
#
ifeq ($(DIR_REFERENCES),)
export DIR_REFERENCES := $(realpath $(DIR_BUILD_CONFIG)/../../references)
endif

#
# If it is not already set, get the path to where the Grassroots
# docs repository is checked out to.
#
ifeq ($(DIR_USER_DOCS),)
export DIR_USER_DOCS := $(realpath $(DIR_BUILD_CONFIG)/../../user-docs)
endif


#
# If it is not already set, get the path to where the Grassroots
# docs repository is checked out to.
#
ifeq ($(DIR_LUCENE),)
export DIR_LUCENE := $(realpath $(DIR_BUILD_CONFIG)/../../lucene)
endif

#
# If it is not already set, get the path to where the Grassroots
# docs repository is checked out to.
#
ifeq ($(DIR_LIBS),)
export DIR_LIBS := $(realpath $(DIR_BUILD_CONFIG)/../../libs)
endif


COPY	:= cp
DELETE := rm

# The name of the remote that we will use for our git operations
GIT_REMOTE := origin

# The name of the branch that we will use for our git operations
GIT_BRANCH := master

DOXYGEN := doxygen

#################################################################
##### Hopefully you should not need to edit below this line #####
#################################################################

#
# The prefix that we will use to manage the targets
# for all of the subdirectories
#
FAKE_TARGET_PREFIX := --

include $(DIR_BUILD_CONFIG)/project.properties

#
# Get all of the build files for each component
#
ifneq ($(DIR_SERVERS),)
	SERVERS_BUILD_DIRS := $(shell find $(DIR_SERVERS) -path '*/build/unix/$(PLATFORM)/makefile' -exec dirname {} \;)
else
	SERVERS_BUILD_DIRS :=
endif


ifneq ($(DIR_CLIENTS),)
	CLIENTS_BUILD_DIRS := $(shell find $(DIR_CLIENTS) -path '*/build/unix/$(PLATFORM)/makefile' -exec dirname {} \;)
	
	# Add any qt projects
	CLIENTS_BUILD_DIRS += $(shell find $(DIR_CLIENTS) -path '*/build/unix/$(PLATFORM)/*.pro' -exec dirname {} \;)
else
	CLIENTS_BUILD_DIRS :=
endif


ifneq ($(DIR_SERVICES),)
	SERVICES_BUILD_DIRS := $(shell find $(DIR_SERVICES) -path '*/build/unix/$(PLATFORM)/makefile' -exec dirname {} \;)
else
	SERVICES_BUILD_DIRS :=
endif


ifneq ($(DIR_HANDLERS),)
	HANDLERS_BUILD_DIRS := $(shell find $(DIR_HANDLERS) -path '*/build/unix/$(PLATFORM)/makefile' -exec dirname {} \;)
else
	HANDLERS_BUILD_DIRS :=
endif


ifneq ($(DIR_LIBS),)
	LIBS_BUILD_DIRS := $(shell find $(DIR_LIBS) -path '*/build/unix/$(PLATFORM)/makefile' -exec dirname {} \;)
else
	LIBS_BUILD_DIRS :=
endif


#
# Get all of the git repos
#
ifneq ($(DIR_SERVERS),)
	SERVERS_REPO_DIRS := $(shell find $(DIR_SERVERS) -path '*/.git' -exec dirname {} \;)
else
	SERVERS_REPO_DIRS :=
endif


ifneq ($(DIR_CLIENTS),)
	CLIENTS_REPO_DIRS := $(shell find $(DIR_CLIENTS) -path '*/.git' -exec dirname {} \;)
	else
	CLIENTS_REPO_DIRS :=
endif


ifneq ($(DIR_SERVICES),)
	SERVICES_REPO_DIRS := $(shell find $(DIR_SERVICES) -path '*/.git' -exec dirname {} \;)
else
	SERVICES_REPO_DIRS :=
endif


ifneq ($(DIR_HANDLERS),)
	HANDLERS_REPO_DIRS := $(shell find $(DIR_HANDLERS) -path '*/.git' -exec dirname {} \;)
else
	HANDLERS_REPO_DIRS :=
endif


ifneq ($(DIR_LIBS),)
	LIBS_REPO_DIRS := $(shell find $(DIR_LIBS) -path '*/.git' -exec dirname {} \;)
else
	LIBS_REPO_DIRS :=
endif


ifneq ($(DIR_DOCS),)
	DOCS_REPO_DIR := $(shell find $(DIR_DOCS) -path '.git' -exec dirname {} \;)
else
	DOCS_REPO_DIR :=
endif

ifneq ($(DIR_USER_DOCS),)
	USER_DOCS_REPO_DIR := $(shell find $(DIR_USER_DOCS) -path '.git' -exec dirname {} \;)
else
	USER_DOCS_REPO_DIR :=
endif

ifneq ($(DIR_LUCENE),)
	LUCENE_REPO_DIR := $(shell find $(DIR_LUCENE) -path '.git' -exec dirname {} \;)
else
	LUCENE_REPO_DIR :=
endif

#
# Make some phony targets to allow us to pass targets to the makefiles in each of subdirectories
#
ifneq ($(SERVICES_BUILD_DIRS),)
	SERVICES_ALL := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
	SERVICES_INSTALL := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
	SERVICES_CLEAN := $(SERVICES_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)
endif

ifneq ($(HANDLERS_BUILD_DIRS),)
	HANDLERS_ALL := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
	HANDLERS_INSTALL := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
	HANDLERS_CLEAN := $(HANDLERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)
endif

ifneq ($(SERVERS_BUILD_DIRS),)
	SERVERS_ALL := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
	SERVERS_INSTALL := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
	SERVERS_CLEAN := $(SERVERS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)
endif

ifneq ($(CLIENTS_BUILD_DIRS),)
	CLIENTS_ALL := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
	CLIENTS_INSTALL := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
	CLIENTS_CLEAN := $(CLIENTS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)
endif

ifneq ($(LIBS_BUILD_DIRS),)
	LIBS_ALL := $(LIBS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)all-%)
	LIBS_INSTALL := $(LIBS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)install-%)
	LIBS_CLEAN := $(LIBS_BUILD_DIRS:%=$(FAKE_TARGET_PREFIX)clean-%)
#	-include $(LIBS_BUILD_DIRS)/lib.properties
endif

#
# targets depends on the same target name in each of the directories
#
all: core-all $(LIBS_ALL) $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL)  $(CLIENTS_ALL) lucene-all
install: all core-install  $(LIBS_INSTALL) $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL)  $(CLIENTS_INSTALL) references-install lucene-install
clean: core-clean $(LIBS_CLEAN) $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN) lucene-clean

#
# Check any repositories to see if they are modified and need committing
#
git-check:
	@echo "Repositories that need committing:"
	@echo "==================================\n"
	@git diff-index --name-only --quiet HEAD -- || echo "$(DIR_BUILD_CONFIG)";
	@cd $(DIR_CORE) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_CORE)";
	@$(foreach SERVER_REPO_DIR,$(SERVERS_REPO_DIRS), \
   	 cd $(SERVER_REPO_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(SERVER_REPO_DIR)";)	
	@$(foreach SERVICE_REPO_DIR,$(SERVICES_REPO_DIRS), \
   	 cd $(SERVICE_REPO_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(SERVICE_REPO_DIR)";)
	@$(foreach HANDLER_REPO_DIR,$(HANDLERS_REPO_DIRS), \
   	 cd $(HANDLER_REPO_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(HANDLER_REPO_DIR)";)
	@$(foreach CLIENT_REPO_DIR,$(CLIENTS_REPO_DIRS), \
   	 cd $(CLIENT_REPO_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(CLIENT_REPO_DIR)";)	
	@$(foreach LIB_REPO_DIR,$(LIBS_REPO_DIRS), \
   	 cd $(LIB_REPO_DIR); git diff-index --name-only --quiet HEAD -- || echo "$(LIB_REPO_DIR)";)	
	@[ "${DIR_DOCS}" ] && cd $(DIR_DOCS) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_DOCS)";
	@[ "${DIR_REFERENCES}" ] && cd $(DIR_REFERENCES) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_REFERENCES)";
	@[ "${DIR_USER_DOCS}" ] && cd $(DIR_USER_DOCS) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_USER_DOCS)";
	@[ "${DIR_LUCENE}" ] && cd $(DIR_LUCENE) && git diff-index --name-only --quiet HEAD -- || echo "$(DIR_LUCENE)";

#
# Update any local copies of 
#


git-pull:
	@echo "Updating local copies:"
	@echo "======================\n"
	@echo ">>> Updating $(DIR_BUILD_CONFIG)"
	@git pull $(GIT_ARG)
	@echo ">>> Updating $(DIR_CORE)"
	@cd $(DIR_CORE) && git pull $(GIT_ARG);
	@[ "${DIR_DOCS}" ] && echo ">>> Updating \"$(DIR_DOCS)\"" && cd $(DIR_DOCS) && git pull $(GIT_ARG) || echo "";
	@[ "${DIR_REFERENCES}" ] && echo ">>> Updating \"$(DIR_REFERENCES)\"" && cd $(DIR_REFERENCES) && git pull $(GIT_ARG) || echo "";
	@[ "${DIR_USER_DOCS}" ] && echo ">>> Updating \"$(DIR_USER_DOCS)\"" && cd $(DIR_USER_DOCS) && git pull $(GIT_ARG) || echo "";
	@[ "${DIR_LUCENE}" ] && echo ">>> Updating \"$(DIR_LUCENE)\"" && cd $(DIR_LUCENE) && git pull $(GIT_ARG) || echo "";
	@$(foreach SERVER_REPO_DIR,$(SERVERS_REPO_DIRS), \
   	 echo ">>> Updating $(SERVER_REPO_DIR)"; cd $(SERVER_REPO_DIR); git pull $(GIT_ARG);)	
	@$(foreach SERVICE_REPO_DIR,$(SERVICES_REPO_DIRS), \
   	 echo ">>> Updating $(SERVICE_REPO_DIR)"; cd $(SERVICE_REPO_DIR); git pull $(GIT_ARG);)	
	@$(foreach HANDLER_REPO_DIR,$(HANDLERS_REPO_DIRS), \
   	 echo ">>> Updating $(HANDLER_REPO_DIR)"; cd $(HANDLER_REPO_DIR); git pull $(GIT_ARG);)	
	@$(foreach CLIENT_REPO_DIR,$(CLIENTS_REPO_DIRS), \
   	 echo ">>> Updating $(CLIENT_REPO_DIR)"; cd $(CLIENT_REPO_DIR); git pull $(GIT_ARG);)	
	@$(foreach LIB_REPO_DIR,$(LIBS_REPO_DIRS), \
   	 echo ">>> Updating $(LIB_REPO_DIR)"; cd $(LIB_REPO_DIR); git pull $(GIT_ARG);)	
   	 

git-pull-current:
	GIT_ARG=$(GIT_REMOTE) $(GIT_BRANCH)
	@$(MAKE) git-pull

git-pull-all:
	GIT_ARG=--all
	@$(MAKE) git-pull


#
# Update any local copies of 
#
git-fetch:
	@echo "Updating local copies:"
	@echo "======================\n"
	@echo ">>> Updating $(DIR_BUILD_CONFIG)"
	@git fetch $(GIT_REMOTE) $(GIT_BRANCH)
	@echo ">>> Updating $(DIR_CORE)"
	@cd $(DIR_CORE) && git fetch $(GIT_REMOTE) $(GIT_BRANCH);
	@[ "${DIR_DOCS}" ] && echo ">>> Updating \"$(DIR_DOCS)\"" && cd $(DIR_DOCS) && git fetch $(GIT_REMOTE) $(GIT_BRANCH); || echo "";
	@[ "${DIR_REFERENCES}" ] && echo ">>> Updating \"$(DIR_REFERENCES)\"" && cd $(DIR_REFERENCES) && git fetch $(GIT_REMOTE) $(GIT_BRANCH); || echo "";
	@[ "${DIR_USER_DOCS}" ] && echo ">>> Updating \"$(DIR_USER_DOCS)\"" && cd $(DIR_USER_DOCS) && git fetch $(GIT_REMOTE) $(GIT_BRANCH); || echo "";
	@[ "${DIR_LUCENE}" ] && echo ">>> Updating \"$(DIR_LUCENE)\"" && cd $(DIR_LUCENE) && git fetch $(GIT_REMOTE) $(GIT_BRANCH); || echo "";
	@$(foreach SERVER_REPO_DIR,$(SERVERS_REPO_DIRS), \
   	 echo ">>> Updating $(SERVER_REPO_DIR)"; cd $(SERVER_REPO_DIR); git fetch  $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach SERVICE_REPO_DIR,$(SERVICES_REPO_DIRS), \
   	 echo ">>> Updating $(SERVICE_REPO_DIR)"; cd $(SERVICE_REPO_DIR); git fetch $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach HANDLER_REPO_DIR,$(HANDLERS_REPO_DIRS), \
   	 echo ">>> Updating $(HANDLER_REPO_DIR)"; cd $(HANDLER_REPO_DIR); git fetch $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach CLIENT_REPO_DIR,$(CLIENTS_REPO_DIRS), \
   	 echo ">>> Updating $(CLIENT_REPO_DIR)"; cd $(CLIENT_REPO_DIR); git fetch $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach LIB_REPO_DIR,$(LIBS_REPO_DIRS), \
   	 echo ">>> Updating $(LIB_REPO_DIR)"; cd $(LIB_REPO_DIR); git fetch $(GIT_REMOTE) $(GIT_BRANCH);)	
   	 

#

#
# Push all changes to the repositories
#
git-push:
	@echo "Pushing local copies:"
	@echo "======================\n"
	@echo ">>> Pushing $(DIR_BUILD_CONFIG)"
	@git push $(GIT_REMOTE) $(GIT_BRANCH);
	@echo ">>> Pushing $(DIR_CORE)"
	@cd $(DIR_CORE) && git push $(GIT_REMOTE) $(GIT_BRANCH);
	@echo ">>> Pushing $(DIR_DOCS)"
	@cd $(DIR_DOCS) && git push $(GIT_REMOTE) $(GIT_BRANCH);	
	@echo ">>> Pushing $(DIR_REFERENCES)"
	@cd $(DIR_REFERENCES) && git push $(GIT_REMOTE) $(GIT_BRANCH);	
	@echo ">>> Pushing $(DIR_USER_DOCS)"
	@cd $(DIR_USER_DOCS) && git push $(GIT_REMOTE) $(GIT_BRANCH);	
	@echo ">>> Pushing $(DIR_LUCENE)"
	@cd $(DIR_LUCENE) && git push $(GIT_REMOTE) $(GIT_BRANCH);	
	@$(foreach SERVER_REPO_DIR,$(SERVERS_REPO_DIRS), \
   	 echo ">>> Pushing $(SERVER_REPO_DIR)"; cd $(SERVER_REPO_DIR); git push  $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach SERVICE_REPO_DIR,$(SERVICES_REPO_DIRS), \
   	 echo ">>> Pushing $(SERVICE_REPO_DIR)"; cd $(SERVICE_REPO_DIR); git push $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach HANDLER_REPO_DIR,$(HANDLERS_REPO_DIRS), \
   	 echo ">>> Pushing $(HANDLER_REPO_DIR)"; cd $(HANDLER_REPO_DIR); git push $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach CLIENT_REPO_DIR,$(CLIENTS_REPO_DIRS), \
   	 echo ">>> Pushing $(CLIENT_REPO_DIR)"; cd $(CLIENT_REPO_DIR); git push $(GIT_REMOTE) $(GIT_BRANCH);)	
	@$(foreach LIB_REPO_DIR,$(LIBS_REPO_DIRS), \
   	 echo ">>> Pushing $(LIB_REPO_DIR)"; cd $(LIB_REPO_DIR); git push $(GIT_REMOTE) $(GIT_BRANCH);)	


show-config: 
	@echo "DIR_SERVERS: $(DIR_SERVERS)"
	@echo "DIR_SERVICES: $(DIR_SERVICES)"
	@echo "DIR_HANDLERS: $(DIR_HANDLERS)"
	@echo "DIR_CLIENTS: $(DIR_CLIENTS)"
	@echo "DIR_CORE: $(DIR_CORE)"
	@echo "DIR_DOCS: $(DIR_DOCS)"
	@echo "DIR_USER_DOCS: $(DIR_USER_DOCS)"
	@echo "DIR_LUCENE: $(DIR_LUCENE)"
	@echo "DIR_APACHE: $(DIR_APACHE)"
	@echo "DIR_REFERENCES: \"$(DIR_REFERENCES)\""
	@echo "SERVERS_BUILD_DIRS: $(SERVERS_BUILD_DIRS)"
	@echo "SERVERS_ALL: $(SERVERS_ALL)"
	@echo "SERVICES_BUILD_DIRS: $(SERVICES_BUILD_DIRS)"
	@echo "SERVICES_ALL: $(SERVICES_ALL)"
	@echo "HANDLERS_BUILD_DIRS: $(HANDLERS_BUILD_DIRS)"
	@echo "CLIENTS_BUILD_DIRS: $(CLIENTS_BUILD_DIRS)"
	@echo "LIBS_BUILD_DIRS: $(LIBS_BUILD_DIRS)"
	@echo "LIBS_ALL: $(LIBS_ALL)"
	@echo "GRASSROOTS_GEOCODER_LIB_NAME: $(GRASSROOTS_GEOCODER_LIB_NAME)"
	@echo "DIR_GRASSROOTS_GEOCODER: $(DIR_GRASSROOTS_GEOCODER)"
	@echo "CURRENT_DIR: $(CURRENT_DIR)"
	@echo "DIR_JANSSON: $(DIR_JANSSON)"
	@echo "DIR_MONGOC: $(DIR_MONGODB)"
	@echo "BSON_HOME: $(BSON_HOME)"
	@echo "DIR_BSON: $(DIR_BSON)"
	@echo "DIR_SQLITE: $(DIR_SQLITE)"
	@echo "BSON_INC_SUBFOLDER: $(BSON_INC_SUBFOLDER)"
	@echo "DIR_BSON_INC: $(DIR_BSON_INC)"
	@echo "MONGOC_INC_SUBFOLDER: $(MONGOC_INC_SUBFOLDER)"
	@echo "DIR_MONGODB_INC: $(DIR_MONGODB_INC)"
	@echo "TEST: $(TEST)"


#
# Show all of the available targets, taken from
# http://stackoverflow.com/questions/4219255/how-do-you-get-the-list-of-targets-in-a-makefile
#
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(THIS_MAKEFILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
	  
# remove the fake prefixes and call the targets
$(SERVICES_ALL): core-all 
	@echo "calling: @$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all"
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



$(LIBS_ALL): core-all
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)all-%=%) all

$(LIBS_INSTALL): core-install
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)install-%=%) install

$(LIBS_CLEAN):
	@$(MAKE) $(MAKE_FLAGS) -C $(@:$(FAKE_TARGET_PREFIX)clean-%=%) clean


# declare the phony targets
.PHONY: subdirs $(LIBS_ALL) $(SERVICES_ALL) $(HANDLERS_ALL) $(SERVERS_ALL) $(CLIENTS_ALL) 
.PHONY: subdirs $(SERVICES_INSTALL) $(HANDLERS_INSTALL) $(SERVERS_INSTALL) $(CLIENTS_INSTALL) $(LIBS_INSTALL)
.PHONY: subdirs $(SERVICES_CLEAN) $(HANDLERS_CLEAN) $(SERVERS_CLEAN) $(CLIENTS_CLEAN) $(LIBS_CLEAN)
.PHONY: all install clean core-all core-clean
.PHONY: git-pull git-push git-check show-config create-dirs
.PHONY: services-all services-clean services-install
.PHONY: libs-all libs-clean libs-install

create-dirs:
	mkdir -p ../clients
	mkdir -p ../servers
	mkdir -p ../services


all: core-all $(SERVICES_ALL)

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


references-install:
ifneq ($(strip $(DIR_REFERENCES)),)
	@echo "****** BEGIN GRASSROOTS REFERENCES ******"
	@echo ">>> DIR_REFERENCES $(DIR_REFERENCES)"
	echo "****** CALLING $(MAKE) -C $(DIR_REFERENCES)/build/linux install ******";
	$(MAKE) -C $(DIR_REFERENCES)/build/linux install
	@echo "****** END GRASSROOTS REFERENCES ******"	
endif
	
lucene-all:	
ifneq ($(DIR_LUCENE),"")
	@echo "****** BEGIN GRASSROOTS LUCENE ******"
	@echo ">>> DIR_LUCENE $(DIR_LUCENE)"
	@echo "****** CALLING make C $(DIR_LUCENE) jars ******";
	make -C $(DIR_LUCENE) jars
	@echo "****** END GRASSROOTS LUCENE ******"	
endif

lucene-install:	
ifneq ($(DIR_LUCENE),"")
	@echo "****** BEGIN GRASSROOTS LUCENE ******"
	@echo ">>> DIR_LUCENE $(DIR_LUCENE)"
	@echo "****** CALLING make C $(DIR_LUCENE) install ******";
	make -C $(DIR_LUCENE) install
	@echo "****** END GRASSROOTS LUCENE ******"	
endif


lucene-clean:	
ifneq ($(DIR_LUCENE),"")
	@echo "****** BEGIN GRASSROOTS LUCENE ******"
	@echo ">>> DIR_LUCENE $(DIR_LUCENE)"
	@echo "****** CALLING make C $(DIR_LUCENE) clean ******";
	make -C $(DIR_LUCENE) clean
	@echo "****** END GRASSROOTS LUCENE ******"	
endif



libs-clean: $(LIBS_CLEAN)

libs-all: $(LIBS_ALL)

libs-install: libs-all $(LIBS_INSTALL)


services-clean: $(SERVICES_CLEAN)
	
services-all: $(SERVICES_ALL)

services-install: services-all $(SERVICES_INSTALL)


	
docs:
ifneq ($(DIR_DOCS),"")
	@cd $(DIR_DOCS) && $(DOXYGEN)
	zip -r $(DIR_DOCS)/api.zip $(DIR_DOCS)/api
endif

