# Qt config
QT += core gui widgets

TARGET = CopyMove2
TEMPLATE = app

macx:       PLATFORM=mac
win32:      PLATFORM=win
unix:!macx: PLATFORM=linux
unix:!macx: CONFIG += linux

MAIN_DIR = ../..
PRI_DIR  = $${MAIN_DIR}/build/qmake
SRC_DIR  = $${MAIN_DIR}/src

include( $${PRI_DIR}/setup.pri )
DESTDIR  = $${MAIN_DIR}/bin/$${COMPILE_MODE}

include( $${PRI_DIR}/ui.pri )
include( $${PRI_DIR}/log.pri )
include( $${PRI_DIR}/common.pri )
include( $${PRI_DIR}/version.pri )
mac:   include( $${PRI_DIR}/mac.pri )
linux: include( $${PRI_DIR}/linux.pri )

RESOURCES += $${MAIN_DIR}/resources/resources.qrc

mac {
    ICON = $${MAIN_DIR}/resources/icons/logo.icns
    QMAKE_POST_LINK += macdeployqt $${DESTDIR}/$${TARGET}.$${TEMPLATE};
    QMAKE_POST_LINK += $${MAIN_DIR}/scripts/fix_qt_frameworks_mac.sh $${DESTDIR}/$${TARGET}.$${TEMPLATE};
}

win32 {
    RC_FILE = $${MAIN_DIR}/resources/win/copymove2.rc
    CRLF = $$escape_expand(\n\t)
    DESTDIR_WIN = $${DESTDIR}
    DESTDIR_WIN ~= s,/,\\,g
    FULL_TARGET = $${DESTDIR_WIN}\\$${TARGET}.exe

    # copy Qt libs and plugins
    QMAKE_POST_LINK += $$quote( echo \"Deploy...\" & windeployqt \"$${FULL_TARGET}\" $$CRLF )

    # delete redistributable installer (from windeployqt...)
    QMAKE_POST_LINK += $$quote( echo \"Delete...\" & del \"$${DESTDIR_WIN}\\vcredist_x64.exe\" $$CRLF )

    # copy redistributables to dest (http://stackoverflow.com/a/3984180)
    EXTRA_BINFILES = $$(SYSTEMROOT)\System32\msvcp140.dll \
                     $$(SYSTEMROOT)\System32\vcruntime140.dll
    EXTRA_BINFILES ~= s,/,\\,g

    for( FILE, EXTRA_BINFILES ) {
        QMAKE_POST_LINK += $$quote( echo \"Copy...\" & copy /y \"$${FILE}\" \"$${DESTDIR_WIN}\" $$CRLF )
    }
}

linux {
    QMAKE_POST_LINK += strip --strip-all $${DESTDIR}/$${TARGET};
    QMAKE_LFLAGS += -Wl,--rpath=\\\$\$ORIGIN/lib
    RESOURCES += $${MAIN_DIR}/resources/qtconf.qrc
}
