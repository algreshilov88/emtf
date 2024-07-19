#ifndef __EXTRALONG_H_FILE__
#define __EXTRALONG_H_FILE__

#define ELLENGTH 2

#include <inttypes.h>
#include <stdint.h>

class elong
{
public:
    uint32_t r[ELLENGTH]; // value holder
	int l;               // current length
    void assign(uint32_t, int bits);
    void clr ();
    void cat (uint32_t arg, int bits);
    uint32_t split (int bits);
};



#endif
