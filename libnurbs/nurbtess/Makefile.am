
INCLUDES = \
	-I$(top_srcdir)/include

if BUILD_WITH_MSVC
noinst_LIBRARIES = nurbtess.lst
else
noinst_LTLIBRARIES = libnurbtess.la
endif

libnurbtess_la_SOURCES = \
	definitions.h \
	directedLine.cc \
	directedLine.h \
	glimports.h \
	gridWrap.cc \
	gridWrap.h \
	monoChain.cc \
	monoChain.h \
	monoPolyPart.cc \
	monoPolyPart.h \
	monoTriangulation.cc \
	monoTriangulation.h \
	mystdio.h \
	mystdlib.h \
	partitionX.cc \
	partitionX.h \
	partitionY.cc \
	partitionY.h \
	polyDBG.cc \
	polyDBG.h \
	polyUtil.cc \
	polyUtil.h \
	primitiveStream.cc \
	primitiveStream.h \
	quicksort.cc \
	quicksort.h \
	rectBlock.cc \
	rectBlock.h \
	sampleComp.cc \
	sampleComp.h \
	sampleCompBot.cc \
	sampleCompBot.h \
	sampleCompRight.cc \
	sampleCompRight.h \
	sampleCompTop.cc \
	sampleCompTop.h \
	sampleMonoPoly.cc \
	sampleMonoPoly.h \
	sampledLine.cc \
	sampledLine.h \
	searchTree.cc \
	searchTree.h \
	zlassert.h

nurbtess_lst_SOURCES = \
	definitions.h \
	directedLine.cc \
	directedLine.h \
	glimports.h \
	gridWrap.cc \
	gridWrap.h \
	monoChain.cc \
	monoChain.h \
	monoPolyPart.cc \
	monoPolyPart.h \
	monoTriangulation.cc \
	monoTriangulation.h \
	mystdio.h \
	mystdlib.h \
	partitionX.cc \
	partitionX.h \
	partitionY.cc \
	partitionY.h \
	polyDBG.cc \
	polyDBG.h \
	polyUtil.cc \
	polyUtil.h \
	primitiveStream.cc \
	primitiveStream.h \
	quicksort.cc \
	quicksort.h \
	rectBlock.cc \
	rectBlock.h \
	sampleComp.cc \
	sampleComp.h \
	sampleCompBot.cc \
	sampleCompBot.h \
	sampleCompRight.cc \
	sampleCompRight.h \
	sampleCompTop.cc \
	sampleCompTop.h \
	sampleMonoPoly.cc \
	sampleMonoPoly.h \
	sampledLine.cc \
	sampledLine.h \
	searchTree.cc \
	searchTree.h \
	zlassert.h

nurbtess.lst: $(nurbtess_lst_OBJECTS)
	@echo "Linking $@..."; \
	rm -f $@; \
	for i in $(nurbtess_lst_OBJECTS); do echo $$i >>$@; done

