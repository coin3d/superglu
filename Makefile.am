
SUBDIRS = libspec include libnurbs libtess libutil .

if BUILD_WITH_MSVC
lib_LIBRARIES = GLU.lib
else
lib_LTLIBRARIES = libGLU.la
endif

libGLU_la_SOURCES =

libGLU_la_LIBADD = \
	libnurbs/interface/libinterface.la \
	libnurbs/internals/libinternals.la \
	libnurbs/nurbtess/libnurbtess.la \
	libtess/libtess.la \
	libutil/libutil.la

libGLU_la_LDFLAGS = \
	-no-undefined \
	-version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)

GLU_lib_SOURCES =
GLU_lib_LIBADD = \
	libnurbs/interface/interface.lst \
	libnurbs/internals/internals.lst \
	libnurbs/nurbtess/nurbtess.lst \
	libtess/tess.lst \
	libutil/util.lst

GLU.lib: Makefile \
  $(libGLU_lib_OBJECTS) \
  $(libGLU_lib_DEPENDENCIES)
	@basename="GLU"; \
	rm -f "$$basename.dll" "$$basename.lib"; \
	echo "Linking $$basename.lib..."; \
	echo $(CC) $(LDFLAGS) $(LIBFLAGS) \
	  $(GLU_lib_OBJECTS) \
	  $(GLU_lib_LIBADD) $(LIBS); \
	$(CC) $(LDFLAGS) $(LIBFLAGS) \
	  $(GLU_lib_OBJECTS) \
	  $(GLU_lib_LIBADD) $(LIBS);

# **************************************************************************

install-exec-local:
	@basename="GLU"; \
	for ext in dll pdb; do \
	  file="$$basename.$$ext"; \
	  if test -s "$$file"; then \
	    $(mkinstalldirs) "$(DESTDIR)$(bindir)"; \
	    echo $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(bindir)/$$file"; \
	    $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(bindir)/$$file"; \
	  fi \
	done

install-data-local:
	@basename="GLU"; \
	for ext in lib; do \
	  file="$$basename.$$ext"; \
	  if test -s "$$file"; then \
	    $(mkinstalldirs) "$(DESTDIR)$(libdir)"; \
	    echo $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(libdir)/$$file"; \
	    $(INSTALL_PROGRAM) "$$file" "$(DESTDIR)$(libdir)/$$file"; \
	  fi \
	done

uninstall-local:
	@basename="GLU"; \
	for file in \
	  "$(DESTDIR)$(bindir)/$$basename.dll" \
	  "$(DESTDIR)$(bindir)/$$basename.pdb" \
	  "$(DESTDIR)$(libdir)/$$basename.lib"; do \
	  if test -f "$$file"; then \
	    echo " rm -f" "$$file"; \
	    rm -f "$$file"; \
	  fi \
	done;

