# source files
set(COIN_SUPERGLU_LIBTESS_FILES
	dict.c
	geom.c
	memalloc.c
	mesh.c
	normal.c
	priorityq.c
	render.c
	sweep.c
	tess.c
	tessmono.c
)

foreach(SRCFILE ${COIN_SUPERGLU_LIBTESS_FILES})
	set(SUPERGLU_SOURCE ${SUPERGLU_SOURCE} libtess/${SRCFILE} CACHE INTERNAL "SUPERGLU_SOURCE")
endforeach(SRCFILE)
