TARGET_NAME = $(NAME)

include $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/general.makefile

.PHONY: exe

exe: $(DIR_OBJS)/$(TARGET_NAME)	
	@echo "Built $(DIR_OBJS)/$(TARGET_NAME)"

