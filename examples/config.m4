include(javaglue.m4)dnl
dnl
dnl Optional classpath setzen. Per default: .
dnl JG_SET_CLASSPATH([pfad/...])
dnl
dnl Oder an bestehenden anhängen:
dnl JG_APPEND_CLASSPATH([pfad])
dnl
dnl
dnl JG_SET_SRC_DIR([src])
dnl
dnl Ausgabe verzeichnis festlegen: Default: bin
dnl JG_SET_DEST_DIR([...])
dnl
dnl Sucht alle Java dateien und erstellt rules.
JG_AUTO_DETECT
dnl
dnl Kann auch manuell angegeben werden:
dnl JG_TARGETS([Quelle.java], [Abhaengigkeit1 Abhaengigkeit2 ...])
dnl
dnl Dateien angeben, die mit ins Archiv gepackt werden
JG_SET_DIST_FILES([myfile.txt mynext$strangefile.txt])
dnl
dnl Generiert das all target.
JG_ALL
dnl
dnl Erstellt rule um Quelldistribution zu erstellen.
JG_SRC_DIST
