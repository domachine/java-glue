changequote([,])dnl
divert(2)dnl
dnl
dnl Quotes a shell command.
dnl
dnl
define([JG_Q],
  [patsubst([$1], [\([`'"$\\\#&!
 *]\)], \\\1)])dnl
dnl
dnl
dnl Indent the code line to match make's requirements.
dnl
define([JG_INDENT],
  [ifelse([$1], [], [], [	$1
JG_INDENT(shift($@))])])dnl
dnl
dnl Create a make rule
dnl
define([JG_RULE],
  [$1: $2
JG_INDENT(shift(shift($@)))])dnl
dnl
dnl Set the javac executable
dnl
define([JG_SET_JAVAC], [define([JG_JAVAC], [JG_Q([$1])])])dnl
JG_SET_JAVAC([javac])dnl
dnl
dnl
dnl
define([JG_SET_JAVAC], [define([JG_JAVAC], [JG_Q([$1])])])dnl
JG_SET_JAVAC([javac])dnl
dnl
dnl Source directory.
dnl
define([JG_SET_SRC_DIR], [define([JG_SRC_DIR], [JG_Q([$1])])])dnl
JG_SET_SRC_DIR([src])dnl
dnl
dnl Set dist zip name.
dnl
define([JG_SET_DIST_NAME], [define([JG_DIST_NAME], [JG_Q([$1])])])dnl
JG_SET_DIST_NAME([project])dnl
dnl
dnl Distfiles.
dnl
define([JG_DIST_FILES], [])dnl
define([JG_SET_DIST_FILES], [define([JG_DIST_FILES], [$1])])dnl
dnl
dnl Set destination for class files
dnl
define([JG_SET_DEST_DIR], [define([JG_DEST_DIR], [JG_Q([$1])])])dnl
JG_SET_DEST_DIR([bin])dnl
dnl
dnl Set the classpath.
dnl
define([JG_SET_CLASSPATH], [define([JG_CLASSPATH], [JG_Q([$1])])])dnl
JG_SET_CLASSPATH([src])dnl
dnl
dnl Appends a classpath. Attention: Classpaths cannot contain ,
dnl
define([JG_APPEND_CLASSPATH], [define([JG_CLASSPATH], JG_CLASSPATH:[JG_Q([$1])])])dnl
dnl
dnl Generate targets for java objects
dnl
define([JG_TARGET],
  [JG_RULE([JG_Q([JG_DEST_DIR/$1.class])], [JG_Q([JG_SRC_DIR/$1.java]) $2],
           [JG_JAVAC JG_Q([JG_SRC_DIR/$1.java]) -d JG_DEST_DIR -cp JG_CLASSPATH])])dnl
dnl
dnl Default constants
dnl
define([JG_SOURCES], [])dnl
define([JG_CLASSES], [])dnl
dnl
dnl Generate targets of the given argument list. But in most
dnl cases the JG_AUTO_DETECT should do all the job.
dnl
define([JG_TARGETS],
  [ifelse([$1], [], [],
          [JG_TARGET([$1], [$2])
JG_TARGETS(shift(shift($@)))define([JG_CLASSES], JG_CLASSES [JG_DEST_DIR/$1.class])])])dnl
dnl
dnl Cuts the source directory prefix of a path
dnl
define([_JG_FILE_NAME],
  [substr([$1], len(JG_SRC_DIR/))])dnl
dnl
dnl Used by auto detection.
dnl
define([_JG_TARGETS],
  [ifelse([$1], [], [],
          [JG_TARGET([_JG_FILE_NAME([$1])], [])
_JG_TARGETS(shift($@))dnl
define([JG_CLASSES], JG_CLASSES [JG_DEST_DIR/_JG_FILE_NAME([$1.class])])dnl
define([JG_SOURCES], JG_SOURCES [$1.java])])])dnl
define([JG_PROJECT_DIR], [esyscmd([echo -n $(basename $PWD)])])dnl
dnl
dnl Autodetect java files
dnl
define([JG_AUTO_DETECT],
  [_JG_TARGETS(esyscmd([find -name \*.java|sed -e s/.java\$//g -e s,^\\./,,g|tr \\n ,]))])dnl
dnl
dnl Generates the all target
dnl
define([JG_ALL],
  [divert(0)JG_RULE([all], [JG_CLASSES],)divert(2)])dnl
dnl
dnl Convenience macro to trim trailing whitespace
dnl
define([_JG_TRIM],
  [patsubst([patsubst([$1], [^ *], [])], [  *$], [])])dnl
dnl
dnl Rewrite a path list by appending the project directory
dnl to each
dnl
define([__JG_REWRITE_PATHS],
  [ifelse([$1], [], [],
          [JG_Q([JG_PROJECT_DIR/$1]) __JG_REWRITE_PATHS(shift($@))])])dnl
define([_JG_REWRITE_PATHS],
  [__JG_REWRITE_PATHS(patsubst(_JG_TRIM([$1]), [  *], [,]))])dnl
dnl
dnl Generate a source distribution include all specified dist files.
dnl
define([JG_SRC_DIST], [divert(1)JG_RULE([dist], [],
                           [cd ..; pwd; echo _JG_REWRITE_PATHS(JG_DIST_FILES)dnl
_JG_REWRITE_PATHS(JG_SOURCES) | tr \  \\n | zip JG_DIST_NAME.zip -@])divert(2)])dnl
