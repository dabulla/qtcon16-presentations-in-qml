TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp

#QMAKE_CXXFLAGS -= -Zm200
#QMAKE_CXXFLAGS += -Zm2000

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
