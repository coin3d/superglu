
m4_define([GLU_MAJOR_VERSION], [1])
m4_define([GLU_MINOR_VERSION], [3])
m4_define([GLU_MICRO_VERSION], [2])
m4_define([GLU_VERSION],
  [GLU_MAJOR_VERSION.GLU_MINOR_VERSION.GLU_MICRO_VERSION])

AC_INIT([GLU], [GLU_VERSION])

AC_CONFIG_AUX_DIR(cfg)
AC_CONFIG_SRCDIR(libutil/gluint.h)

AC_CANONICAL_SYSTEM

# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it and to generate an MSWindows .dll file.

SIM_AC_SETUP_MSVCPP_IFELSE

AM_CONDITIONAL(BUILD_WITH_MSVC, $BUILD_WITH_MSVC)

AC_SUBST([BUILD_MAJOR_VERSION], [GLU_MAJOR_VERSION])
AC_SUBST([BUILD_MINOR_VERSION], [GLU_MINOR_VERSION])
AC_SUBST([BUILD_MICRO_VERSION], [GLU_MICRO_VERSION])
AC_SUBST([BUILD_VERSION], [GLU_VERSION])

VERSION=GLU_VERSION

# Libtool versioning
LT_CURRENT=0
LT_REVISION=2
LT_AGE=0

AC_SUBST([LT_CURRENT])
AC_SUBST([LT_REVISION])
AC_SUBST([LT_AGE])

AC_DEFINE_UNQUOTED([BUILD_MAJOR_VERSION], [$BUILD_MAJOR_VERSION],
  [define this to the libGLU major version number])
AC_DEFINE_UNQUOTED([BUILD_MINOR_VERSION], [$BUILD_MINOR_VERSION],
  [define this to the libGLU minor version number])
AC_DEFINE_UNQUOTED([BUILD_MICRO_VERSION], [$BUILD_MICRO_VERSION],
  [define this to the libGLU release version number])
AC_DEFINE_UNQUOTED([BUILD_VERSION], ["$BUILD_VERSION"],
  [define this to the full libGLU major.minor.micro version number])

# *******************************************************************
# Miscellaneous options and initializations.

glu_build_dir=`pwd`

# *******************************************************************
# Library name prefix.

AC_ARG_WITH(
  [libname-prefix],
  [AC_HELP_STRING([--with-libname-prefix=string],
                  [specify library name prefix])],
  [LIBPREFIX=$withval],
  [LIBPREFIX=$SUPERGLUPREFIX])

AC_SUBST([LIBPREFIX])
AC_SUBST([libprefix], [`echo $LIBPREFIX | tr [A-Z] [a-z]`])

# **************************************************************************
#  Locate C++ compiler and set C++ as the default language to use
#  in tests. The configure script will automatically terminate if
#  it doesn't find a C++ compiler.
AC_PROG_CC
AC_PROG_CPP
AC_PROG_CXX
AC_LANG_CPLUSPLUS

# **************************************************************************
# NOTE: if we touch CFLAGS/CXXFLAGS before AC_PROG_CC is invoked, the -g
# flag will be lost  20020104 larsa

if $BUILD_WITH_MSVC; then
  SIM_AC_SETUP_MSVCRT([
    CPPFLAGS="$CPPFLAGS $sim_ac_msvcrt_CPPFLAGS"
    CFLAGS="$CFLAGS $sim_ac_msvcrt_CFLAGS"
    CXXFLAGS="$CXXFLAGS $sim_ac_msvcrt_CXXFLAGS"
    LDFLAGS="$LDFLAGS $sim_ac_msvcrt_LDFLAGS"
    LIBS="$LIBS $sim_ac_msvcrt_LIBS"
  ])

  SIM_AC_CONFIGURATION_SETTING([C library version], [$sim_ac_msvcrt])
fi

# **************************************************************************

AC_CHECK_HEADERS([windows.h unistd.h ctype.h])

AM_INIT_AUTOMAKE(GLU, $VERSION)

#  Files to cram results from the configure tests into.
AM_CONFIG_HEADER([include/config.h])

#  Default to not building a shared library.
#  Can be overridden by the user with --enable-shared.
AM_DISABLE_SHARED

#  Turn off default maintainer make-rules -- use ./bootstrap instead.
AM_MAINTAINER_MODE

# Initialize libtool
if $BUILD_WITH_MSVC; then
  RANLIB=:
else
  AC_PROG_LIBTOOL
fi

SIM_AC_DEBUGSYMBOLS
SIM_AC_RTTI_SUPPORT
SIM_AC_EXCEPTION_HANDLING
SIM_AC_PROFILING_SUPPORT
SIM_AC_COMPILER_WARNINGS

# don't try to use the static/shared configure options for windows
# builds. Only static .lib is supported so if the user tries to
# explicitly --enable-shared for Coin, superglu configure will fail.
if $BUILD_WITH_MSVC; then
  GLU_STATIC=true;
else
  case $enable_static in
  yes | true)  GLU_STATIC=true;;
  *)           GLU_STATIC=false;;
  esac

  case $enable_shared in
  yes | true)  GLU_STATIC=false;;
  *)           GLU_STATIC=true;;
  esac
fi

if $GLU_STATIC; then
  SIM_AC_CONFIGURATION_SETTING([Install as], [static library])
else
  SIM_AC_CONFIGURATION_SETTING([Install as], [shared library])
  if $BUILD_WITH_MSVC; then
    AC_MSG_ERROR([GLU as DLL is not supported just yet])
  fi
fi

SIM_AC_COMPILE_DEBUG([
#  CPPFLAGS="$CPPFLAGS"
], [
#  CPPFLAGS="$CPPFLAGS -DNDEBUG"
])

# GLU debug messages are not cool...
CPPFLAGS="$CPPFLAGS -DNDEBUG"

# huh?  What is this?
# case $enable_debug in
# yes | true)  GLU_SHARED=true;;
# *)           GLU_SHARED=false;;
# esac

CPPFLAGS="-DLIBRARYBUILD -DGLU_INTERNAL $CPPFLAGS"

LIBFLAGS=
AC_SUBST(LIBFLAGS)

if $BUILD_WITH_MSVC; then
  rm -f vc60.pdb
  LIBFLAGS="$LIBFLAGS $sim_ac_msvcrt_LIBLDFLAGS"
  LIBS="$LIBS $sim_ac_msvcrt_LIBLIBS"
  if $GLU_STATIC; then
    :
  else
    CPPFLAGS="-DGLU_MAKE_DLL $CPPFLAGS"
  fi
  debugfile="`pwd`/${LIBPREFIX}GLU.pdb"
  debugfile=`cygpath -w "$debugfile" | sed 's,\\\\,\\\\\\\\,g'`
  if $GLU_STATIC; then
    LIBFLAGS="-LIB $LIBFLAGS"
    LIBFLAGS="$LIBFLAGS /OUT:${LIBPREFIX}GLU.lib"
    SIM_AC_CONFIGURATION_SETTING([GLU build type], [static .lib])
  else
    LIBFLAGS="-DLL /INCREMENTAL:NO $LIBFLAGS"
    case $enable_symbols in
    no | false)
      LIBFLAGS="$LIBFLAGS /RELEASE"
      SIM_AC_CONFIGURATION_SETTING([GLU build type], [dynamic .dll])
      ;;
    *)
      CFLAGS="/Fd$debugfile $CFLAGS"
      CXXFLAGS="/Fd$debugfile $CXXFLAGS"
      LIBFLAGS="$LIBFLAGS /DEBUG /PDB:${LIBPREFIX}GLU.pdb"
      SIM_AC_CONFIGURATION_SETTING([GLU build type], [dynamic .dll + .pdb])
      ;;
    esac

    LIBFLAGS="$LIBFLAGS /OUT:${LIBPREFIX}GLU.dll"
  fi
fi


SIM_AC_UNIQIFY_LIST(CPPFLAGS, $CPPFLAGS)
SIM_AC_UNIQIFY_LIST(LDFLAGS, $LDFLAGS)
SIM_AC_UNIQIFY_LIST(LIBS, $LIBS)

AC_OUTPUT([
  Makefile
  include/Makefile
  libnurbs/Makefile
  libnurbs/interface/Makefile
  libnurbs/internals/Makefile
  libnurbs/nurbtess/Makefile
  libtess/Makefile
  libutil/Makefile
])

SIM_AC_CONFIGURATION_SETTING([Install path prefix], [$prefix])
if $BUILD_WITH_MSVC; then
  SIM_AC_CONFIGURATION_SETTING([Library installation], [$libdir/${LIBPREFIX}GLU.dll])
else
  SIM_AC_CONFIGURATION_SETTING([Library installation], [$libdir/lib${LIBPREFIX}GLU])
fi
SIM_AC_CONFIGURATION_SETTING([Header installation], [$includedir/GL/${libprefix}glu.h])

SIM_AC_CONFIGURATION_SUMMARY

if test x"$libprefix" = x""; then
  cat <<EOF

Warning:
   You are now installing the GLU library and include header file with
   no prefix to their names.  This means they could clash with the
   GLU-library and GL/glu.h files from some other installation, which
   could cause mysterious bugs and crashes in your application
   programs.  You can add a library prefix by re-running configure with
   the --with-libname-prefix=PREFIX option.

EOF
else
  echo ""
fi


echo ""
echo "Now, run 'make' and 'make install' to install $PACKAGE"
echo ""
