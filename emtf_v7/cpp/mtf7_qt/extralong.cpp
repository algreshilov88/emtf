#include "extralong.h"

// constructor from uint32_t
void elong::assign(uint32_t v, int bits)
{
    clr();
    r[0] = v;
    l = bits;
}

// clears extended long variable
void elong::clr ()
{
	int i;
    for (i = 0; i < ELLENGTH; i++) r[i] = 0;
    l = 0;
}

// concatenates "bits" bits from "arg" ulong with extended long "el"
// these bits are added into MSBs of el
void elong::cat (uint32_t arg, int bits)
{
    int wl = l/32;
    int bl = l%32;
    int bitsleft = bl + bits - 32;
    uint32_t mask = (bits == 32) ? (uint32_t)(-1) : (((uint32_t)1 << bits) - 1);
	arg &= mask;
	
	if (wl < ELLENGTH)
        r[wl] |= (arg << bl);
	
	if (bitsleft > 0 && wl+1 < ELLENGTH)
        r[wl+1] |= (arg >> (bits - bitsleft));
	
    l += bits;
	
}


// splits "bits" bits out of MSBs of el. Reduces the length of el by "bits"
// returns the bits as unsigned long. "bits" cannot be more than 32
uint32_t elong::split (int bits)
{
    int wn = (l - bits) / 32; // word number
    int bn = (l - bits) % 32; // bit number
    int lpl = 32 - bn; // low part length
    if (lpl > bits) lpl = bits;
    unsigned int lmask = ((unsigned long)1 << lpl) - 1; // low part mask
    unsigned int pmask = ((unsigned long)1 << bits) - 1; //full part mask

    unsigned lp = (r[wn] >> bn) & lmask; // low part of the result
    unsigned hp = (r[wn+1] << lpl); // high part of the result (unmasked)

    unsigned ret = (lp | hp) & pmask;

    l -= bits;
    return ret;
}
