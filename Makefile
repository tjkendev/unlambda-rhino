SRCDIR := src
SRCCF := $(SRCDIR)/unlambda.coffee $(SRCDIR)/main.coffee
DESTDIR := js
DESTJS := $(DESTDIR)/main.js $(DESTDIR)/unlambda.js

COFFEE := coffee
COFFEE_OPT := -pc

all: $(DESTJS)

$(DESTDIR)/%.js: $(SRCDIR)/%.coffee
	@[ -d $(DESTDIR) ] || mkdir $(DESTDIR)
	$(COFFEE) $(COFFEE_OPT) $< > $@

clean:
	rm $(DESTJS)
