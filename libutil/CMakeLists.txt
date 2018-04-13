# source files
set(COIN_SUPERGLU_LIBUTIL_FILES
	error.c
	glue.c
	mipmap.c
	project.c
	quad.c
	registry.c
)

foreach(SRCFILE ${COIN_SUPERGLU_LIBUTIL_FILES})
	set(SUPERGLU_SOURCE ${SUPERGLU_SOURCE} libutil/${SRCFILE} CACHE INTERNAL "SUPERGLU_SOURCE")
endforeach(SRCFILE)
