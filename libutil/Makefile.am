
INCLUDES = -I$(top_srcdir)/include

if BUILD_WITH_MSVC
noinst_LIBRARIES = util.lst
else
noinst_LTLIBRARIES = libutil.la
endif

libutil_la_SOURCES = \
	error.c \
	glue.c \
	gluint.h \
	mipmap.c \
	project.c \
	quad.c \
	registry.c

util_lst_SOURCES = \
	error.c \
	glue.c \
	gluint.h \
	mipmap.c \
	project.c \
	quad.c \
	registry.c

util.lst: $(util_lst_OBJECTS)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(util_lst_OBJECTS); do echo $$i >>$@; done

