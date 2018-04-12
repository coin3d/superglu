# source files
set(COIN_SUPERGLU_LIBNURBS_NURBTESS_FILES
	directedLine.cc
	gridWrap.cc
	monoChain.cc
	monoPolyPart.cc
	monoTriangulation.cc
	partitionX.cc
	partitionY.cc
	polyDBG.cc
	polyUtil.cc
	primitiveStream.cc
	quicksort.cc
	rectBlock.cc
	sampleComp.cc
	sampleCompBot.cc
	sampleCompRight.cc
	sampleCompTop.cc
	sampleMonoPoly.cc
	sampledLine.cc
	searchTree.cc
)

foreach(SRCFILE ${COIN_SUPERGLU_LIBNURBS_NURBTESS_FILES})
	set(SUPERGLU_SOURCE ${SUPERGLU_SOURCE} libnurbs/nurbtess/${SRCFILE} CACHE INTERNAL "SUPERGLU_SOURCE")
endforeach(SRCFILE)
