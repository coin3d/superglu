
specdir = $(top_srcdir)/specs
genheader = $(top_srcdir)/cfg/genheader.pl

BUILT_SOURCES = \
	glu.h

gluincdir = $(includedir)/GL
gluinc_HEADERS = \
	glu.h

glu.h: $(specdir)/enumglu.spec $(specdir)/glu.spec $(genheader)
	$(genheader) $(specdir)/enumglu.spec $(specdir)/glu.spec >$@

