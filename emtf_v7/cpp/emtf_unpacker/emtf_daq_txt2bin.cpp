

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int main (int argc, char* argv[]) 
{
	FILE * tfile;
	FILE * bfile;

	tfile = fopen ( argv[1] , "rt" );
	if (tfile==NULL) {fputs ("text file error\n",stderr); exit (1);}

	bfile = fopen ( argv[2] , "wb" );
	if (bfile==NULL) {fputs ("binary file error\n",stderr); exit (1);}

	union bw64_u
	{
	  uint64_t comb;
	  uint16_t w[4];
	} bw64;

	uint64_t bindata[10000];
	uint32_t rdv;
	
	int i, j = 0;
	int n;
	
	while (1)
	{
	  for (i = 0; i < 4; i++)
	  {
	    n = fscanf (tfile, "%x", &rdv);
	    if (n != 1) goto eject;
	    bw64.w[i] = (uint16_t)rdv;
	  }

	  bindata[j] = bw64.comb;
	  j++;
	}

 eject:	
	fwrite (bindata, 1, j*8, bfile);
	fclose (tfile);
	fclose (bfile);
	printf ("wrote %d 64-bit words\n", j);
}
