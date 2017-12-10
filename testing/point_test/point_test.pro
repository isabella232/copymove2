QT       += testlib

TARGET = point_test
CONFIG -= app_bundle
CONFIG += x86_64
TEMPLATE = app
DESTDIR = bin

macx: PLATFORM=mac
win32: PLATFORM=win
unix: !macx: PLATFORM=linux

MAIN_DIR=../..

PRI_DIR  = $${MAIN_DIR}/qmake/include
SRC_DIR  = $${MAIN_DIR}/src

include( $${PRI_DIR}/setup.pri )
include( $${PRI_DIR}/log.pri )
macx: include( $${PRI_DIR}/mac.pri )
unix: !macx: include( $${PRI_DIR}/linux.pri )

HEADERS += $${SRC_DIR}/point.hpp
SOURCES += $${SRC_DIR}/point.cpp

SOURCES += point_test.cpp

