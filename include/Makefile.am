specdir = $(top_srcdir)/specs
genheader = $(top_srcdir)/cfg/genheader.pl

BUILT_SOURCES = superglu.h

gluincdir = $(includedir)/GL
gluinc_HEADERS = superglu.h

superglu.h: $(specdir)/enumglu.spec $(specdir)/glu.spec $(genheader)
	$(genheader) $(specdir)/enumglu.spec $(specdir)/glu.spec >$@

install-gluincHEADERS: $(gluinc_HEADERS)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(gluincdir)
	@list='$(gluinc_HEADERS)'; for p in $$list; do \
	  if test -f "$$p"; then d=; else d="$(srcdir)/"; fi; \
	  f="`echo $$p | sed -e 's|^.*/||'`"; \
	  src="$$d$$p"; dst="$(DESTDIR)$(gluincdir)/@libprefix@`echo $$f | sed 's|superglu.h|glu.h|'`"; \
	  if cmp -s "$$src" "$$dst"; then :; else \
	    echo " $(INSTALL_HEADER) $$src $$dst"; \
	    $(INSTALL_HEADER) "$$src" "$$dst"; \
	  fi \
	done

## FIXME: must overload uninstall aswell? 20011019 <mortene@coin3d.org>.
