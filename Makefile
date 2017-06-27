DESTDIR          =
PREFIX           = /usr
VERSION          = 1.90.1
POD_CMD         := pod2man --utf8 --center=func --release=$(VERSION) 

SRC_MAN1        := $(wildcard src/*.1.pod)
SRC_MAN8        := $(wildcard src/*.8.pod)
SRC_BIN         := $(filter-out $(SRC_MAN1) $(SRC_MAN8),$(wildcard src/*))

DEST_BASE       := $(DESTDIR)$(PREFIX)
DEST_BIN        := $(DEST_BASE)/bin
DEST_MAN1       := $(DEST_BASE)/share/man/man1
DEST_MAN8       := $(DEST_BASE)/share/man/man8

DEST_BIN_FILES  := $(addprefix $(DEST_BIN)/,$(notdir $(SRC_BIN)))
DEST_MAN1_FILES := $(addprefix $(DEST_MAN1)/,$(basename $(notdir $(SRC_MAN1))))
DEST_MAN8_FILES := $(addprefix $(DEST_MAN8)/,$(basename $(notdir $(SRC_MAN8))))

.PHONY           = all install

all:     $(patsubst src/%.pod,build/%,$(SRC_MAN1) $(SRC_MAN8))

install: $(DEST_BIN_FILES) $(DEST_MAN1_FILES) $(DEST_MAN8_FILES)

$(DEST_BIN)/%:  src/%   ; install -Dm755 $< $@

$(DEST_MAN1)/%: build/% ; install -Dm644 $< $@

$(DEST_MAN8)/%: build/% ; install -Dm644 $< $@

build/%.1: src/%.1.pod  ; $(POD_CMD) --section=1 $< $@

build/%.8: src/%.8.pod  ; $(POD_CMD) --section=8 $< $@

$(DEST_BIN_FILES):  $(DEST_BIN)
$(DEST_MAN1_FILES): $(DEST_MAN1) build
$(DEST_MAN8_FILES): $(DEST_MAN8) build

$(DEST_BIN) $(DEST_MAN1) $(DEST_MAN8): $(DEST_BASE) build
	install -d $@

$(DEST_BASE) build:
	install -d $@
