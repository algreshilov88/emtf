#include "sp12_qtw.h"
#include <QApplication>
#include <QPlastiqueStyle>

sp12_qtw *f;

int main(int argc, char *argv[])
{
    QApplication::setStyle(new QPlastiqueStyle());
    QApplication a(argc, argv);
    sp12_qtw w;
    f = &w;
    w.show();
    
    return a.exec();
}
