
INCLUDES = \
	-I$(top_srcdir)/libnurbs/interface \
	-I$(top_srcdir)/libnurbs/internals \
	-I$(top_srcdir)/libnurbs/nurbtess

if BUILD_WITH_MSVC
noinst_LIBRARIES = interface.lst
else
noinst_LTLIBRARIES = libinterface.la
endif

libinterface_la_SOURCES = \
	bezierEval.cc bezierEval.h \
	bezierPatch.cc bezierPatch.h \
	bezierPatchMesh.cc bezierPatchMesh.h \
	glcurveval.cc glcurveval.h \
	glinterface.cc \
	glrenderer.cc glrenderer.h \
	glsurfeval.cc glsurfeval.h \
	incurveeval.cc insurfeval.cc

interface_lst_SOURCES = \
	bezierEval.cc bezierEval.h \
	bezierPatch.cc bezierPatch.h \
	bezierPatchMesh.cc bezierPatchMesh.h \
	glcurveval.cc glcurveval.h \
	glinterface.cc \
	glrenderer.cc glrenderer.h \
	glsurfeval.cc glsurfeval.h \
	incurveeval.cc insurfeval.cc

interface.lst: $(interface_lst_OBJECTS)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(interface_lst_OBJECTS); do echo $$i >>$@; done

