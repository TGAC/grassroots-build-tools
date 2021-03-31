.DEFAULT_GOAL = all

MAKEDEPEND 	:= gcc -MM -MF

ifeq ($(CC),)
CC := gcc
endif

ifeq ($(CXX),)
CXX := g++
endif

ifeq ($(DIR_BUILD),)
export DIR_BUILD = $(realpath .)
endif

DIR_OBJS = $(DIR_BUILD)/$(BUILD)


CFLAGS 	+=  -Wall -Wshadow -Wextra 

CPPFLAGS += $(INCLUDES) -DUNIX

.SUFFIXES: .c .cpp

.PHONY: clean init

# Build a list of the object files to create, based on the source we find
C_SRCS = $(filter %.c, $(SRCS))
CXX_SRCS = $(filter %.cpp, $(SRCS))

OBJS = $(patsubst %.c, $(DIR_OBJS)/%.o, $(C_SRCS))
OBJS += $(patsubst %.cpp, $(DIR_OBJS)/%.o, $(CXX_SRCS))
  
# Pull in dependency info for our objects
ifneq ($(MAKECMDGOALS), clean)
-include $(OBJS:.o=.d)
endif


ifeq ($(BUILD),release)
	CFLAGS 	+= -O3 -s -Wshadow
 	LDFLAGS += -s
else
	CFLAGS 	+= -g -O0 -pg -ggdb  -Wshadow
	LDFLAGS +=  -g -pg
	CPPFLAGS += -D_DEBUG
endif




$(DIR_OBJS)/$(TARGET_NAME): init  $(OBJS) 
	$(CXX) -o $(DIR_OBJS)/$(TARGET_NAME) $(OBJS) $(STATIC_LIBS) $(LDFLAGS)


install:: all
	@echo "ROOT DIR $(DIR_ROOT)"
	@echo "THIS DIR $(THIS_DIR)"
	@echo "Installing $(TARGET_NAME) to $(DIR_INSTALL)"
	mkdir -p $(DIR_INSTALL)
	cp $(DIR_OBJS)/$(TARGET_NAME) $(DIR_INSTALL)/  
	git -C $(DIR_OBJS) log -1 > $(DIR_INSTALL)/$(TARGET_NAME).log
	
init:
	@mkdir -p $(DIR_OBJS)
	@echo "-----------------------------------------------" 
	@echo "DIR_OBJS: $(DIR_OBJS)"
	@echo "OBJS: $(OBJS)"
	@echo "c: $(C_SRCS)"	
	@echo "c++: $(CXX_SRCS)"	
	@echo "VPATH: $(VPATH)" 
	@echo "DIR_CORE: $(DIR_CORE)"
	@echo "DIR_GRASSROOTS_UTIL: $(DIR_GRASSROOTS_UTIL)"
	@echo "DIR_GRASSROOTS_NETWORK: $(DIR_GRASSROOTS_NETWORK)"
	@echo "-----------------------------------------------" 
	
clean::
	rm -fr $(DIR_OBJS)/

 
# Compile and generate dependency info
# 1. Compile the .c file
# 2. Generate dependency information, explicitly specifying the target name
$(DIR_OBJS)/%.o : %.c
	@echo ">>> c build for $@"
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<
	@$(MAKEDEPEND) $(basename $@).d -MT $(basename $@).o $(CPPFLAGS) $(CFLAGS) $<  
	@mv -f $(basename $@).d $(basename $@).d.tmp
	@sed -e 's|.*:|$*.o:|' < $(basename $@).d.tmp > $(basename $@).d
	@sed -e 's/.*://' -e 's/\\$$//' < $(basename $@).d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> $(basename $@).d
	@rm -f $(basename $@).d.tmp   	

# Compile and generate dependency info
# 1. Compile the .cpp file
# 2. Generate dependency information, explicitly specifying the target name
$(DIR_OBJS)/%.o : %.cpp 
	@echo ">>> c++ build for $@"
	$(CXX) $(CFLAGS) $(CPPFLAGS) -o $@ -c $< 
	@$(MAKEDEPEND) $(basename $@).d -MT $(basename $@).o $(CPPFLAGS) $(CFLAGS) $<  
	@mv -f $(basename $@).d $(basename $@).d.tmp
	@sed -e 's|.*:|$*.o:|' < $(basename $@).d.tmp > $(basename $@).d
	@sed -e 's/.*://' -e 's/\\$$//' < $(basename $@).d.tmp | fmt -1 | \
		sed -e 's/^ *//' -e 's/$$/:/' >> $(basename $@).d
	@rm -f $(basename $@).d.tmp  
