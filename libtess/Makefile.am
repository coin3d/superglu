
INCLUDES = -I$(top_srcdir)/include

if BUILD_WITH_MSVC
noinst_LIBRARIES = tess.lst
else
noinst_LTLIBRARIES = libtess.la
endif

libtess_la_SOURCES = \
	dict-list.h \
	dict.c \
	dict.h \
	geom.c \
	geom.h \
	memalloc.c \
	memalloc.h \
	mesh.c \
	mesh.h \
	normal.c \
	normal.h \
	priorityq-heap.h \
	priorityq-sort.h \
	priorityq.c \
	priorityq.h \
	render.c \
	render.h \
	sweep.c \
	sweep.h \
	tess.c \
	tess.h \
	tessmono.c \
	tessmono.h

tess_lst_SOURCES = \
	dict-list.h \
	dict.c \
	dict.h \
	geom.c \
	geom.h \
	memalloc.c \
	memalloc.h \
	mesh.c \
	mesh.h \
	normal.c \
	normal.h \
	priorityq-heap.h \
	priorityq-sort.h \
	priorityq.c \
	priorityq.h \
	render.c \
	render.h \
	sweep.c \
	sweep.h \
	tess.c \
	tess.h \
	tessmono.c \
	tessmono.h

# priorityq-heap.c is included from priorityq.c and shouldn't be compiled

EXTRA_libtess_la_SOURCES = \
	priorityq-heap.c

EXTRA_tess_lst_SOURCES = \
	priorityq-heap.c

tess.lst: $(tess_lst_OBJECTS)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(tess_lst_OBJECTS); do echo $$i >>$@; done

