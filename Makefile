
CC     ?= cc
PREFIX ?= /usr/local

ifeq ($(OS),Windows_NT)
BINS = clib.exe clib-install.exe clib-search.exe
LDFLAGS = -lcurldll
CP_F    = copy /Y
RM_F    = del /Q /S
MKDIR_P = mkdir
else
BINS = clib clib-install clib-search
LDFLAGS = -lcurl
CP_F    = cp -f
RM_F    = rm -f
MKDIR_P = mkdir -p
endif

SRC  = $(wildcard src/*.c)
DEPS = $(wildcard deps/*/*.c)
OBJS = $(DEPS:.c=.o)

CFLAGS  = -std=c99 -Ideps -Wall -Wno-unused-function -U__STRICT_ANSI__

all: $(BINS)

$(BINS): $(SRC) $(OBJS)
	$(CC) $(CFLAGS) -o $@ src/$@.c $(OBJS) $(LDFLAGS)

%.o: %.c
	$(CC) $< -c -o $@ $(CFLAGS)

clean:
	$(foreach c, $(BINS), $(RM_F) $(c);)
	$(RM_F) $(OBJS)

install: $(BINS)
	$(MKDIR_P) $(PREFIX)/bin
	$(foreach c, $(BINS), $(CP_F) $(c) $(PREFIX)/bin/$(c);)

uninstall:
	$(foreach c, $(BINS), $(RM_F) $(PREFIX)/bin/$(c);)

test:
	@./test.sh

.PHONY: test all clean install uninstall