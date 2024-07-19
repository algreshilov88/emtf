

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int main (int argc, char* argv[]) 
{
  FILE * pFile;
  long lSize;
  uint64_t * buffer;
  size_t result;

  
  pFile = fopen ( argv[1] , "rb" );
  if (pFile==NULL) {fputs ("File error\n",stderr); exit (1);}

  // obtain file size:
  fseek (pFile , 0 , SEEK_END);
  lSize = ftell (pFile);
  rewind (pFile);

  // allocate memory to contain the whole file:
  buffer = (uint64_t*) malloc (sizeof(char)*lSize);
  if (buffer == NULL) {fputs ("Memory error\n",stderr); exit (2);}

  // copy the file into the buffer:
  result = fread (buffer,1,lSize,pFile);
  if (result != lSize) {fputs ("Reading error\n",stderr); exit (3);}

  /* the whole file is now loaded in the memory buffer. */

  int twc = lSize / 8;
  printf ("file size in bytes: %d, in int64: %d\n", lSize, twc);

  int i = 0;

#define w(s,m) (((buffer[i]) >> s) & ((1ULL << m) - 1ULL))
#define b(m) (buffer[i] & m)

  for (i = 0; i < twc;)
    {

      
      i+=3; //  CDF header word 1
      uint64_t amc13_bx_id  = w(20,12);
      uint64_t amc13_lv1_id = w(32,24);

      i++; // CDF header word 2
      uint64_t amc13_orn = w(4,32); 
      uint64_t amc13_namc = w(52,4);

      printf ("AMC13 header: bx: %04d lv1: %06x orn: %08x namc: %d\n", 
	      amc13_bx_id, amc13_lv1_id, amc13_orn, amc13_namc);

      // read AMC sizes
      uint64_t amc_size[12];
      uint64_t board_id[12], amc_bx_id[12], amc_lv1_id[12], amc_orn[12], amc_board_id[12];
      uint64_t amc_data_lng[12], amc_lv1_id_8b[12];
      uint64_t amc_l1a, amc_l1a_bxn, amc_sp_ts, amc_me_en[5];
      for (int j = 0; j < amc13_namc; j++) // amc loop
	{
	  i++;
	  amc_size[j] = w(32, 24);
	  board_id[j] = w(0, 16);
	  //	  if (amc_size[j] != 3ULL)
	    printf ("amc %d size: %06x id: %04x\n", j, amc_size[j], board_id[j]);
	}
      
      // read AMC payloads
      for (int j = 0; j < amc13_namc; j++) // amc loop
	{
	  i++; // at amc header word 1
	  amc_bx_id[j] = w(20, 12);
	  amc_lv1_id[j] = w(32, 24);

	  i++; // at amc header word 2
	  amc_board_id[j] = w(0, 16);
	  amc_orn[j] = w(16, 16);

	  int payload_start = i; // remember where payload started for this AMC
	  if (amc_size[j] > 3ULL) // payload not empty
	    {
	      i++; // first payload header word
	      if (b(0xf000f000f000f000ULL) == 0x9000900090009000ULL)
		{
		  amc_l1a = w(0,12) | (w(16,12) << 12);
		  amc_l1a_bxn = w(48, 12);
		  printf ("EMUTF head: L1A: %06x L1A_BXN: %03x\n", amc_l1a, amc_l1a_bxn);
		}
	      else
		printf ("ERROR: EMUTF head 1 does not match: %016x %016x\n", buffer[i], 0x9000900090009000ULL);

	      i++; // second payload header word
	      if (b(0xf000f000f000f000ULL) == 0xA000A000A000A000ULL)
		{
		  amc_sp_ts = w(24, 4);
		  amc_me_en[0] = w(48,8);
		  printf ("EMUTF head: Sector: %d\n", amc_sp_ts);
		}
	      else
		printf ("ERROR: EMUTF head 2 does not match: %016x %016x\n", buffer[i], 0xA000A000A000A000ULL);

	      i++; // third payload header word
	      if (b(0x8000800080008000ULL) == 0x0000000000008000ULL)
		{
		  amc_me_en[1] = w(0,8);
		  amc_me_en[2] = w(16,8);
		  amc_me_en[3] = w(32,8);
		  amc_me_en[4] = w(48,8);
		  printf ("EMUTF head: ME en: %02x %02x %02x %02x %02x\n", 
			  amc_me_en[0], amc_me_en[1], amc_me_en[2], amc_me_en[3], amc_me_en[4]);
		}
	      else
		printf ("ERROR: EMUTF head 3 does not match: %016x %016x\n", buffer[i], 0x0000000000008000ULL);
	      
	      i++; // block of counters
	      if (b(0x8000800080008000ULL) == 0x0000000080000000ULL)
		{
		  // not implemented in fw so far
		}
	      else
		printf ("ERROR: EMUTF block of counters does not match: %016x %016x\n", buffer[i], 0x0000000080000000ULL);
	      
	      uint64_t me_q, me_wg, me_hs, me_cscid, me_bxn, me_tbin, me_station;
	      uint64_t trk_tbin, trk_phi_inner, trk_phi_outer, trk_eta, trk_pt, trk_q;
	      uint64_t trk_me_id[4], trk_me_tbin[4], trk_pt_lut_address;
	      i++; // data records
	      //	      while (b(0xf000f000f000f000ULL) != 0xf000f000f000f000ULL) // scan data until we see the trailer
	      while (b(0xf000f000f000f000ULL) != 0xf000e000f000f000ULL) // scan data until we see the trailer (this line is for defective fw)
		{
		  if (b(0x8000800080008000ULL) == 0x0000000080008000ULL) // ME data
		    {
		      me_q = w(4, 4);
		      me_wg = w(8, 7);
		      me_hs = w(16, 8);
		      me_cscid = w(24, 4);
		      me_bxn = w(32, 12);
		      me_tbin = w(48, 3);
		      me_station = w(52, 3);
		      printf ("EMUTF stub: q: %d wg: %03d hs: %03d cscid: %d bxn: %03x tbin: %d station: %d\n",
			      me_q, me_wg, me_hs, me_cscid, me_bxn, me_tbin, me_station);
		      if (me_wg > 111) printf ("ERROR: me_wg out of range: %d\n", me_wg);
		      if (me_hs > 160) printf ("ERROR: me_hs out of range: %d\n", me_hs);
		    }

		  if (b(0x8000800080008000ULL) == 0x0000800000008000ULL) // SP output word 1
		    {
		      trk_phi_inner = w(0,12);
		      trk_phi_outer = w(16,12);
		      trk_eta = w(32,9);
		      trk_pt = w(48,9);
		      trk_q = w(41,4);
		      trk_me_id[0] = w(57,6);
		      printf ("EMUTF trk1: ph_in: %03x ph_out: %03x eta: %03x pt: %03x q: %x\n",
			      trk_phi_inner, trk_phi_outer, trk_eta, trk_pt, trk_q);

		    }
		  if (b(0x8000800080008000ULL) == 0x0000800080000000ULL) // SP output word 2
		    {
		      trk_me_id[1] = w(0,5);
		      trk_me_id[2] = w(5,5);
		      trk_me_id[3] = w(10,5);
		      trk_me_tbin[0] = w(16,3);
		      trk_me_tbin[1] = w(19,3);
		      trk_me_tbin[2] = w(22,3);
		      trk_me_tbin[3] = w(25,3);
		      trk_tbin = w(28,3);
		      trk_pt_lut_address = w(32,15) | (w(48,15) << 15);

		      printf ("EMUTF trk2: tbin: %d me_id: %d %d %d %d\n", 
			      trk_tbin, trk_me_id[0], trk_me_id[1], trk_me_id[2], trk_me_id[3]);
		      printf ("EMUTF trk2: me_tbin: %d %d %d %d ptlut_addr: %08x\n", 
			      trk_me_tbin[0], trk_me_tbin[1], trk_me_tbin[2], trk_me_tbin[3], trk_pt_lut_address);
		      
		    }
		  
		  i++;
		}

	      // at the payload trailer word 1
	      uint64_t amc_day, amc_month, amc_year;
	      amc_month = w(32,4);
	      amc_year = w(36,4) + 2000;

	      i++; // payload trailer word 2
	      amc_day = w(0,5);
	      printf ("EMUTF trlr: date: %04d-%02d-%02d\n", amc_year, amc_month, amc_day);

	    } // if payload is not empty

	  // check that index is where it's supposed to be after payload unpacking
	  if (i != payload_start + (amc_size[j] - 3ULL))
	    printf ("payload length mismatch: i: %d should be: %d\n", i, payload_start + (amc_size[j] - 3ULL));

	  i = payload_start + (amc_size[j] - 3ULL); // jump at the end of payload (in case index did not end up there as it should)
	  i++;
	  // amc trailer
	  amc_data_lng[j] = w(0,20);
	  amc_lv1_id_8b[j] = w(24,8);

	  printf ("AMC: %d bx: %04d lv1: %06x id: %04x orn: %04x lng: %05x lv1_match: %d\n",
		  j, amc_bx_id[j], amc_lv1_id[j], amc_board_id[j], amc_orn[j],
		  amc_data_lng[j], (amc_lv1_id[j] & 0xffULL) == amc_lv1_id_8b[j]);
	  if (amc_bx_id[j] == amc13_bx_id)
	    {
	      printf ("BX    match: amc13: %04d amc: %04d\n", amc13_bx_id, amc_bx_id[j]);
	    }
	  else
	    {
	      printf ("BX mismatch: amc13: %04d amc: %04d\n", amc13_bx_id, amc_bx_id[j]);
	    }
	} // amc loop
      i++;
      // at event trailer word

      i++;
      // at cdf trailer

      i++;
      // at first word of next event
      
    }

 eject:
  // terminate
  fclose (pFile);
  free (buffer);
  return 0;
}

  
