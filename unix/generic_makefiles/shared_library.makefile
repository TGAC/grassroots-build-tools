
TARGET_NAME = lib$(NAME).so

CFLAGS 	+= -fPIC
LDFLAGS += -shared -rdynamic 

CPPFLAGS += -DSHARED_LIBRARY 

include $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/general.makefile


.PHONY:	all 

all:: init $(DIR_OBJS)/$(TARGET_NAME)	
	@echo "current dir $(CURRENT_DIR)"
	@echo "Built $(DIR_OBJS)/$(TARGET_NAME)"
