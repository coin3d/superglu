SUBDIRS = include libnurbs libtess libutil .

if BUILD_WITH_MSVC
lib_LIBRARIES = @LIBPREFIX@GLU.lib
else
lib_LTLIBRARIES = lib@LIBPREFIX@GLU.la
endif

lib@LIBPREFIX@GLU_la_SOURCES = 

lib@LIBPREFIX@GLU_la_LIBADD = \
	libnurbs/interface/libinterface.la \
	libnurbs/internals/libinternals.la \
	libnurbs/nurbtess/libnurbtess.la \
	libtess/libtess.la \
	libutil/libutil.la

lib@LIBPREFIX@GLU_la_LDFLAGS = \
	-no-undefined \
	-version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)

@LIBPREFIX@GLU_lib_SOURCES =
@LIBPREFIX@GLU_lib_LIBADD = \
	libnurbs/interface/interface.lst \
	libnurbs/internals/internals.lst \
	libnurbs/nurbtess/nurbtess.lst \
	libtess/tess.lst \
	libutil/util.lst

@LIBPREFIX@GLU.lib: Makefile \
  $(lib@LIBPREFIX@GLU_lib_OBJECTS) \
  $(lib@LIBPREFIX@GLU_lib_DEPENDENCIES) \
  @LIBPREFIX@GLU.lst
	@basename="@LIBPREFIX@GLU"; \
	rm -f "$$basename.dll" "$$basename.lib"; \
	echo "Linking $$basename.lib..."; \
	echo $(CC) $(LDFLAGS) $(LIBFLAGS) \
	  $(@LIBPREFIX@GLU_lib_OBJECTS) \
	  $(@LIBPREFIX@GLU_lib_LIBADD) $(LIBS); \
	$(CC) $(LDFLAGS) $(LIBFLAGS) \
	  $(@LIBPREFIX@GLU_lib_OBJECTS) \
	  $(@LIBPREFIX@GLU_lib_LIBADD) $(LIBS);

# This file is need when superglu is used from Coin.
@LIBPREFIX@GLU.lst: $(@LIBPREFIX@GLU_lib_LIBADD)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(@LIBPREFIX@GLU_lib_LIBADD); do \
	  LSTDIRCAT=`dirname $$i`; \
	  cat $$i | sed s%^%$$LSTDIRCAT/% >> $@; \
	done


# **************************************************************************

install-exec-local:
	@basename="@LIBPREFIX@GLU"; \
	for ext in dll pdb; do \
	  file="$$basename.$$ext"; \
	  if test -s "$$file"; then \
	    $(mkinstalldirs) "$(DESTDIR)$(bindir)"; \
	    echo $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(bindir)/$$file"; \
	    $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(bindir)/$$file"; \
	  fi \
	done

install-data-local:
	@basename="@LIBPREFIX@GLU"; \
	for ext in lib; do \
	  file="$$basename.$$ext"; \
	  if test -s "$$file"; then \
	    $(mkinstalldirs) "$(DESTDIR)$(libdir)"; \
	    echo $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(libdir)/$$file"; \
	    $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(libdir)/$$file"; \
	  fi \
	done

uninstall-local:
	@basename="@LIBPREFIX@GLU"; \
	for file in \
	  "$(DESTDIR)$(bindir)/$$basename.dll" \
	  "$(DESTDIR)$(bindir)/$$basename.pdb" \
	  "$(DESTDIR)$(libdir)/$$basename.lib"; do \
	  if test -f "$$file"; then \
	    echo " rm -f" "$$file"; \
	    rm -f "$$file"; \
	  fi \
	done;

