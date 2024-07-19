#-------------------------------------------------
#
# Project created by QtCreator 2012-12-06T16:26:38
#
#-------------------------------------------------

DEFINES  += "REG_BANK_CH=54"

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = mtf7_qt
TEMPLATE = app


SOURCES += main.cpp\
        sp12_qtw.cpp \
    flash.cpp \
    loopback_dma.cpp \
    prbs_enable.cpp \
    prbs_errors.cpp \
    resets.cpp \
    core_link.cpp \
    gtx_bitrate.cpp \
    write_verify_pc_luts.cpp \
    read_dat_file.cpp \
    core_logic.cpp \
    extralong.cpp \
    mpc.cpp \
    mtf7_daq.cpp \
    input_links.cpp

HEADERS  += sp12_qtw.h \
    sp12_macros.h \
    core_link.h \
    extralong.h \
    vme_client.h

#    CAENVMElib.h \
#    CAENVMEoslib.h \
#    CAENVMEtypes.h

FORMS    += sp12_qtw.ui

QMAKE_CFLAGS += -DLINUX
QMAKE_CXXFLAGS += -DLINUX
# QMAKE_LIBS += -lCAENVME
# QMAKE_LFLAGS += -L/opt/xdaq/lib
