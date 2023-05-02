#
# hcxselect - A CSS selector engine for htmlcxx
#

LEX = flex
CXXFLAGS += -Wall -Wno-unused-function -g
CXXFLAGS += -I$(DIR_HTMLCXX)/include -fPIC
LFLAGS += --reentrant

all: lib

.cpp.o: lexer.h
	$(CXX) $(CXXFLAGS) -c -o $@ $<

lexer.h: lexer.l
	$(LEX) $(LFLAGS) -o $@ $^

libhcxselect.a: hcxselect.o
	$(AR) rcs libhcxselect.a hcxselect.o

lib: lexer.h libhcxselect.a

shared: lexer.h hcxselect.o 
	$(CXX) -shared hcxselect.o -o libhcxselect.so

clean:
	$(RM) *.o *.a lexer.h
