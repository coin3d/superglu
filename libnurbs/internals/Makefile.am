
INCLUDES = \
	-I$(top_srcdir)/include \
	-I$(top_srcdir)/libnurbs/interface \
	-I$(top_srcdir)/libnurbs/nurbtess

if BUILD_WITH_MSVC
noinst_LIBRARIES = internals.lst
else
noinst_LTLIBRARIES = libinternals.la
endif

libinternals_la_SOURCES = \
	arc.cc arc.h \
	arcsorter.cc \
	arcsorter.h \
	arctess.cc \
	arctess.h \
	backend.cc \
	backend.h \
	basiccrveval.cc \
	basiccrveval.h \
	basicsurfeval.cc \
	basicsurfeval.h \
	bezierarc.h \
	bin.cc \
	bin.h \
	bufpool.cc \
	bufpool.h \
	cachingeval.cc \
	cachingeval.h \
	ccw.cc \
	coveandtiler.cc \
	coveandtiler.h \
	curve.cc \
	curve.h \
	curvelist.cc \
	curvelist.h \
	curvesub.cc \
	dataTransform.cc \
	dataTransform.h \
	defines.h \
	displaylist.cc \
	displaylist.h \
	displaymode.h \
	flist.cc \
	flist.h \
	flistsorter.cc \
	flistsorter.h \
	gridline.h \
	gridtrimvertex.h \
	gridvertex.h \
	hull.cc \
	hull.h \
	intersect.cc \
	jarcloc.h \
	knotvector.cc \
	knotvector.h \
	mapdesc.cc \
	mapdesc.h \
	mapdescv.cc \
	maplist.cc \
	maplist.h \
	mesher.cc \
	mesher.h \
	monoTriangulationBackend.cc \
	monotonizer.cc \
	monotonizer.h \
	myassert.h \
	mycode.cc \
	mymath.h \
	mysetjmp.h \
	mystring.h \
	nurbsconsts.h \
	nurbsinterfac.cc \
	nurbstess.cc \
	nurbstess.h \
	patch.cc \
	patch.h \
	patchlist.cc \
	patchlist.h \
	pwlarc.h \
	quilt.cc \
	quilt.h \
	reader.cc \
	reader.h \
	renderhints.cc \
	renderhints.h \
	simplemath.h \
	slicer.cc \
	slicer.h \
	sorter.cc \
	sorter.h \
	splitarcs.cc \
	subdivider.cc \
	subdivider.h \
	tobezier.cc \
	trimline.cc \
	trimline.h \
	trimregion.cc \
	trimregion.h \
	trimvertex.h \
	trimvertpool.cc \
	trimvertpool.h \
	types.h \
	uarray.cc \
	uarray.h \
	varray.cc \
	varray.h

internals_lst_SOURCES = \
	arc.cc arc.h \
	arcsorter.cc \
	arcsorter.h \
	arctess.cc \
	arctess.h \
	backend.cc \
	backend.h \
	basiccrveval.cc \
	basiccrveval.h \
	basicsurfeval.cc \
	basicsurfeval.h \
	bezierarc.h \
	bin.cc \
	bin.h \
	bufpool.cc \
	bufpool.h \
	cachingeval.cc \
	cachingeval.h \
	ccw.cc \
	coveandtiler.cc \
	coveandtiler.h \
	curve.cc \
	curve.h \
	curvelist.cc \
	curvelist.h \
	curvesub.cc \
	dataTransform.cc \
	dataTransform.h \
	defines.h \
	displaylist.cc \
	displaylist.h \
	displaymode.h \
	flist.cc \
	flist.h \
	flistsorter.cc \
	flistsorter.h \
	gridline.h \
	gridtrimvertex.h \
	gridvertex.h \
	hull.cc \
	hull.h \
	intersect.cc \
	jarcloc.h \
	knotvector.cc \
	knotvector.h \
	mapdesc.cc \
	mapdesc.h \
	mapdescv.cc \
	maplist.cc \
	maplist.h \
	mesher.cc \
	mesher.h \
	monoTriangulationBackend.cc \
	monotonizer.cc \
	monotonizer.h \
	myassert.h \
	mycode.cc \
	mymath.h \
	mysetjmp.h \
	mystring.h \
	nurbsconsts.h \
	nurbsinterfac.cc \
	nurbstess.cc \
	nurbstess.h \
	patch.cc \
	patch.h \
	patchlist.cc \
	patchlist.h \
	pwlarc.h \
	quilt.cc \
	quilt.h \
	reader.cc \
	reader.h \
	renderhints.cc \
	renderhints.h \
	simplemath.h \
	slicer.cc \
	slicer.h \
	sorter.cc \
	sorter.h \
	splitarcs.cc \
	subdivider.cc \
	subdivider.h \
	tobezier.cc \
	trimline.cc \
	trimline.h \
	trimregion.cc \
	trimregion.h \
	trimvertex.h \
	trimvertpool.cc \
	trimvertpool.h \
	types.h \
	uarray.cc \
	uarray.h \
	varray.cc \
	varray.h

internals.lst: $(internals_lst_OBJECTS)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(internals_lst_OBJECTS); do echo $$i >>$@; done

