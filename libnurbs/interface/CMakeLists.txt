# source files
set(COIN_SUPERGLU_LIBNURBS_INTERFACE_FILES
	bezierEval.cc
	bezierPatch.cc
	bezierPatchMesh.cc
	glcurveval.cc
	glinterface.cc
	glrenderer.cc
	glsurfeval.cc
	incurveeval.cc
	insurfeval.cc
)

foreach(SRCFILE ${COIN_SUPERGLU_LIBNURBS_INTERFACE_FILES})
	set(SUPERGLU_SOURCE ${SUPERGLU_SOURCE} libnurbs/interface/${SRCFILE} CACHE INTERNAL "SUPERGLU_SOURCE")
endforeach(SRCFILE)
