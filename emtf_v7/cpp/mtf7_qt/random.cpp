#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main ()
{
  FILE *out = fopen ("random.bin", "wb");

  uint16_t arr[0x100000];
  for (uint32_t i = 0; i < 0x100000UL; i++)
    arr[i] = (uint16_t)i; //random();

  fwrite(arr, 2, 0x100000, out);
  fclose(out);
}
