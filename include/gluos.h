/*
** gluos.h - operating system dependencies for GLU
**
*/

#ifdef _WIN32

#define WIN32_LEAN_AND_MEAN
#define NOGDI
#define NOIME
#include <windows.h>

/* Disable warnings */
#pragma warning(disable : 4101)
#pragma warning(disable : 4244)
#pragma warning(disable : 4761)

#define GLAPIENTRY APIENTRY

#else

/* Disable Microsoft-specific keyword for calling convention */
#define GLAPIENTRY

#endif
