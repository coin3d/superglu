#!/usr/bin/perl
############################################################################
# quick hack to generate glu.h from spec files without having to set up
# the immense libspec system...

if ( @ARGV != 2 ) {
  print STDERR "usage: $0 <const-spec> <api-spec>\n";
  exit -1;
}

open( CONSTS, $ARGV[0] ) || die "couldn't open $ARGV[0]";
chomp(@consts = <CONSTS>);
close( CONSTS );

open( API, $ARGV[1] ) || die "couldn't open $ARGV[1]";
chomp(@api = <API>);
close( API );

############################################################################

$defprefix = "GLU_";
$apiprefix = "glu";

%typetranslations = (
  'void', 'void ',
  'void in reference', 'const void *',
  'VoidPointer in value', 'GLvoid* ',
  'VoidPointer out value', 'GLvoid* ',
  'Boolean', 'GLboolean ',
  'Boolean in value', 'GLboolean ',
  'Int32', 'GLint ',
  'Int32 in value', 'GLint ',
  'Int32 in array [4]', 'const GLint *',
  'Int32 out array [4]', 'GLint *',
  'String', 'const GLubyte * ',
  'StringName in value', 'GLenum ',
  'NurbsObj', 'GLUnurbs* ',
  'NurbsObj in value', 'GLUnurbs* ',
  'TesselatorObj', 'GLUtesselator* ',
  'TesselatorObj in value', 'GLUtesselator* ',
  'ErrorCode in value', 'GLenum ',
  'UInt8 in array [COMPSIZE()]', 'const GLubyte *',
  'Float64 in value', 'GLdouble ',
  'Float64 in array [16]', 'const GLdouble *',
  'Float64 out array [3]', 'GLdouble *',
  'Float64Pointer in value', 'GLdouble* ',
  'Float64Pointer out value', 'GLdouble* ',
  'TextureTarget in value', 'GLenum ',
  'PixelFormat in value', 'GLenum ',
  'PixelType in value', 'GLenum ',
  'NurbsProperty in value', 'GLenum ',
  'NurbsCallback in value', 'GLenum ',
  'SizeI in value', 'GLsizei ',
  'FunctionPointer in value', '_GLUfuncptr ',
  'Float32Pointer in value', 'GLfloat* ',
  'Float32Pointer out value', 'GLfloat* ',
  'Float32 in array [16]', 'const GLfloat *',
  'Float32 in value', 'GLfloat ',
  'Float32 out reference', 'GLfloat *',
  'QuadricObj', 'GLUquadric* ',
  'QuadricObj in value', 'GLUquadric* ',
  'QuadricNormal in value', 'GLenum ',
  'QuadricCallback in value', 'GLenum ',
  'QuadricDrawStyle in value', 'GLenum ',
  'QuadricOrientation in value', 'GLenum ',
  'TessProperty in value', 'GLenum ',
  'TessContour in value', 'GLenum ',
  'TessCallback in value', 'GLenum ',
  'MapTarget in value', 'GLenum ',
  'NurbsTrim in value', 'GLenum ',
);

%ignore = (
  'Filter4TypeSGIS', 1,
  'gluTexFilterFuncSGI', 1,
);

############################################################################
# print SGI header

print <<"END";
/*
** License Applicability. Except to the extent portions of this file are
** made subject to an alternative license as permitted in the SGI Free
** Software License B, Version 1.1 (the "License"), the contents of this
** file are subject only to the provisions of the License. You may not use
** this file except in compliance with the License. You may obtain a copy
** of the License at Silicon Graphics, Inc., attn: Legal Services, 1600
** Amphitheatre Parkway, Mountain View, CA 94043-1351, or at:
** 
** http://oss.sgi.com/projects/FreeB
** 
** Note that, as provided in the License, the Software is distributed on an
** "AS IS" basis, with ALL EXPRESS AND IMPLIED WARRANTIES AND CONDITIONS
** DISCLAIMED, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES AND
** CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A
** PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
** 
** Original Code. The Original Code is: OpenGL Sample Implementation,
** Version 1.2.1, released January 26, 2000, developed by Silicon Graphics,
** Inc. The Original Code is Copyright (c) 1991-2000 Silicon Graphics, Inc.
** Copyright in any portions created by third parties is as indicated
** elsewhere herein. All Rights Reserved.
** 
** Additional Notice Provisions: This software was created using the
** OpenGL(R) version 1.2.1 Sample Implementation published by SGI, but has
** not been independently verified as being compliant with the OpenGL(R)
** version 1.2.1 Specification.
*/
END

############################################################################

print <<"END";

#ifndef __glu_h__
#define __glu_h__

#include <GL/gl.h>

#ifdef __cplusplus
extern "C" {
#endif

/* This define is used to tag all functions with the default
   Win32 calling convention. If we are not under Win32, we make
   it empty to avoid compilation errors. */
#ifndef APIENTRY
#define APIENTRY
#endif /* APIENTRY */

/*************************************************************/
END

%defines = ();

for ( $i = 0; $i < @consts; $i++ ) {
  if ( $consts[$i] =~ m/^# / ) {
    next;
  }
  if ( $consts[$i] =~ m/^([^ \t].*) (define|enum):$/ ) {
    $section = $1;
    next if ( defined $ignore{$section} );
    print "\n";
    print "/* $1 */\n";
    next;
  }
  if ( $consts[$i] =~ m/^\tuse ([A-Za-z0-9_]+)[\t ]*([A-Za-z0-9_]+)$/ ) {
    next if ( defined $ignore{$section} );
    print "/*      $defprefix$2 */\n";
    next;
  }
  if ( $consts[$i] =~ m/^\t([A-Za-z0-9_]+)[\t ]*=[\t ]*([0-9]*)/ ) {
    next if ( defined $ignore{$section} );
    $define = $defprefix . $1;
    next if ( defined $defines{$define} );
    $defines{$define} = 1;
    $value = $2;
    $define =~ s/_TEXTURE_(.*)_EXT/_TEX_$1_EXT/o;
    $string = "#define $define                                     ";
    print substr($string, 0, 42), " ", $value, "\n";
    next;
  }
}

print <<"END";

/*************************************************************/


#ifdef __cplusplus
class GLUnurbs;
class GLUquadric;
class GLUtesselator;
#else
typedef struct GLUnurbs GLUnurbs;
typedef struct GLUquadric GLUquadric;
typedef struct GLUtesselator GLUtesselator;
#endif

typedef struct GLUnurbs GLUnurbsObj;
typedef struct GLUquadric GLUquadricObj;
typedef struct GLUtesselator GLUtesselatorObj;
typedef struct GLUtesselator GLUtriangulatorObj;

#define GLU_TESS_MAX_COORD 1.0e150

/* Internal convenience typedefs */
typedef void (APIENTRY * _GLUfuncptr)();

END

if ( 0 ) {
print <<"END";

#ifdef GLU_API
# error Leave the internal GLU_API define alone.
#endif /* GLU_API */

/*
  On MSWindows platforms, one of these defines must always be set when
  building application programs:

   - "GLU_DLL", when the application programmer is using the library
     in the form of a dynamic link library (DLL)

   - "GLU_NOT_DLL", when the application programmer is using the
     library in the form of a static object library (LIB)

  Note that either GLU_DLL or GLU_NOT_DLL _must_ be defined by the
  application programmer on MSWindows platforms, or else the #error
  statement will hit. Set up one or the other of these two defines in
  your compiler environment according to how the library was built --
  as a DLL (use "GLU_DLL") or as a static LIB (use "GLU_NOT_DLL").
  Chances are you are using a DLL and need to define GLU_DLL.

  (Setting up defines for the compiler is typically done by either
  adding something like "/DGLU_DLL" to the compiler's argument line
  (for command-line build processes), or by adding the define to the
  list of preprocessor symbols in your IDE GUI (in the MSVC IDE, this
  is done from the "Project"->"Settings" menu, choose the "C/C++" tab,
  then "Preprocessor" from the dropdown box and add the appropriate
  define)).

  It is extremely important that the application programmer uses the
  correct define, as using "GLU_NOT_DLL" when "GLU_DLL" is correct
  will cause mysterious crashes.
 */

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
# ifdef GLU_INTERNAL
#  ifdef GLU_MAKE_DLL
#   define GLU_API __declspec(dllexport)
#  endif /* GLU_MAKE_DLL */
# else /* !GLU_INTERNAL */
#  ifdef GLU_DLL
#   define GLU_API __declspec(dllimport)
#  else /* !GLU_DLL */
#   ifndef GLU_NOT_DLL
#    error Define either GLU_DLL or GLU_NOT_DLL as appropriate for your linkage! See GL/glu.h for further instructions.
#   endif /* GLU_NOT_DLL */
#  endif /* !GLU_DLL */
# endif /* !GLU_INTERNAL */
#endif /* Microsoft Windows */

#ifndef GLU_API
# define GLU_API
#endif /* !GLU_API */

END
}

%decls = ();
for ( $i = 0; $i < scalar(@api); $i++ ) {
  if ( $api[$i] =~ /^# / ) {
    next;
  }
  if ( $api[$i] =~ /^([A-Z][A-Za-z0-9_]*)\((.*)\);?$/ ) {
    $j = $i + 1;
    $return = "";
    %types = ();
    $function = $apiprefix . $1;
    if ( defined $ignore{$function} ) {
      while ( $api[$j] !~ /^$/ ) {
        $j++;
      }
      $i = $j;
      next;
    }
    while ( $api[$j] !~ /^$/ ) {
      if ( $api[$j] =~ m/^[ \t]*return[ \t]*(.*)/ ) {
        if ( defined $typetranslations{$1} ) {
          $return = $typetranslations{$1};
        } else {
          printf STDERR "unknown type: $1\n";
          $return = $1;
        }
      } elsif ( $api[$j] =~ m/^[ \t]*param[ \t]*([^ \t]*)[ \t]*(.*)/ ) {
        $param = $1;
        $type = $2;
        if ( defined $typetranslations{$type} ) {
          $types{$param} = $typetranslations{$type};
        } else {
          printf STDERR "unknown type: $type\n";
          $types{$param} = $type;
        }
      }
      $j++;
    }
    $arguments = $2;
    @arglist = split(/, ?/, $arguments);
    for ( $c = 0; $c < scalar(@arglist); $c++ ) {
      if ( defined $types{$arglist[$c]} ) {
        $arglist[$c] = $types{$arglist[$c]} . $arglist[$c];
      }
    }
    $arglist = join(", ", @arglist);
    if ( $arglist =~ /^$/ ) {
      $arglist = "void";
    }
    $decls{$function} = "${return}APIENTRY $function ($arglist);";
    $i = $j;
    next;
  }
}

foreach $func (sort(keys(%decls))) {
  print $decls{$func}, "\n";
}

print <<"END";

#ifdef __cplusplus
}
#endif

#endif /* __glu_h__ */
END
