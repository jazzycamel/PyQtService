TARGET=qtservice
TEMPLATE=lib

win32 {
	CONFIG+=staticlib
}

DEFINES+=QT_QTSERVICE_EXPORT
SOURCES+=qtservice.cpp qtservice_win.cpp
HEADERS+=qtservice.h qtservice_p.h