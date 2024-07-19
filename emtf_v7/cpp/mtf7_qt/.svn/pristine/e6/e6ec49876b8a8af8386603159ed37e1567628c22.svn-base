#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>



int main (int argc, char* argv[])
{
  FILE *fin = fopen("mpc_data.dat", "rb");
  if (fin == NULL) 
    {
      printf ("file not found\n");
      exit (0);
    }

  int fsizeb = 131072; // fixed file size in bytes
  int fsizew = fsizeb / 2; // file size in words 16
  int framew = 64; // frame size in words16
  int mpc_words = 40; // count of MPC words in one frame
  int ch0_words = 5; // count of chambers with ID = 0
  int frame_cnt = fsizew / framew; // frame count in file

  uint16_t quality[mpc_words][2], wiregroup[mpc_words][2], 
    half_strip[mpc_words][2], cpattern[mpc_words][2],
    lr[mpc_words][2], valid[mpc_words][2];

  uint16_t quality0[ch0_words][2], wiregroup0[ch0_words][2], 
    half_strip0[ch0_words][2], cpattern0[ch0_words][2],
    lr0[ch0_words][2], valid0[ch0_words][2];


  uint16_t rbuf[fsizew];
  bool frame0_found = false;

  fread(rbuf, 1, fsizeb, fin);

  // find frame 0 first
  int fr;
  for (fr = 0; fr < frame_cnt; fr++)
    {
      if ((rbuf[fr*framew] & 0x8000) == 0x8000)
	{
	  printf ("found frame 0, frame: %d\n", fr);
	  frame0_found = true;
	  break;
	}
    }

  if (!frame0_found)
    {
      printf ("frame0 not found\n");
      exit (0);
    }

  // check frame syncronization for all links
  for (int wd = 0; wd < mpc_words; wd++)
    {
      if ((rbuf[fr*framew + wd] & 0x8000) != 0x8000)
	{
	  printf ("unsynchronized MPC: %d\n", wd);
	  exit (0);
	}
    }

  int fr_word = 0; // frame word index
  uint16_t abst = 0, abst_old = 0;

  for (; fr < frame_cnt; fr++) // frame loop
    {


      if (fr_word == 0)
	{
	  abst_old = abst;
	  // read absolute time counter
	  //abst = rbuf[fr*framew + 50];
	  //abst <<= 16;
	  abst = rbuf[fr*framew + 49];
	  
	  if ((abst_old+4) != abst) // new event
	    {
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	      printf ("12345\n");
	    }
	  // reset decoded arrays
	  for (int i = 0; i < mpc_words; i++)
	    for (int j = 0; j < 2; j++)
	      {
		quality[i][j] = 0; 
		wiregroup[i][j] = 0; 
		half_strip[i][j] = 0; 
		cpattern[i][j] = 0;
		lr[i][j] = 0; 
		valid[i][j] = 0;
	      }

	  for (int i = 0; i < ch0_words; i++)
	    for (int j = 0; j < 2; j++)
	      {
		quality0[i][j] = 0; 
		wiregroup0[i][j] = 0; 
		half_strip0[i][j] = 0; 
		cpattern0[i][j] = 0;
		lr0[i][j] = 0; 
		valid0[i][j] = 0;
	      }

	}
      

      for (int mpc = 0; mpc < mpc_words; mpc++) // mpc word loop
	{
	  uint16_t fword = rbuf[fr*framew + mpc];

	  switch (fr_word)
	    {
	    case 0:
	      half_strip[mpc][0] = fword & 0xff;
	      wiregroup[mpc][0] = (fword >> 8) & 0x7f;
	      if ((fword & 0x8000) != 0x8000)
		{
		  printf("frame: %d mpcw = %d bad frame0\n",
			 fr, mpc);
		  //bad_alignment |= (1ULL << fiber_abs); // mark this fiber as bad
		}
	      break;

	    case 1:
	      half_strip[mpc][1] = fword & 0xff;
	      wiregroup[mpc][1] = (fword >> 8) & 0x7f;
	      break;

	    case 2:
	      quality[mpc][0] = fword & 0xf;
	      cpattern[mpc][0] = (fword >> 4) & 0xf;
	      lr[mpc][0] = (fword >> 8) & 1;
	      lr[mpc][1] = (fword >> 9) & 1;
	      valid[mpc][0] = (fword >> 10) & 1;
	      valid[mpc][1] = (fword >> 11) & 1;
	      break;

	    case 3:
	      quality[mpc][1] = fword & 0xf;
	      cpattern[mpc][1] = (fword >> 4) & 0xf;
	      // decode chamber 0 spread over all fibers in fword 3
	      int ch0 = mpc/8; // index of chamber with ID=0
	      switch (mpc % 8)
		{
		case 0:
		  wiregroup0[ch0][0] = (fword >> 8) & 0x7f;
		  break;
		case 1:
		  wiregroup0[ch0][1] = (fword >> 8) & 0x7f;
		  break;
		case 2:
		  half_strip0[ch0][0] = (fword >> 8) & 0x7f;
		  break;
		case 3:
		  half_strip0[ch0][1] = (fword >> 8) & 0x7f;
		  break;
		case 4:
		  quality0[ch0][0] = (fword >> 8) & 0xf;
		  lr0[ch0][0] = (fword >> 12) & 1;
		  valid0[ch0][0] = (fword >> 13) & 1;
		  half_strip0[ch0][0] |= (fword >> 7) & 0x80;
		  break;
		case 5:
		  quality0[ch0][1] = (fword >> 8) & 0xf;
		  lr0[ch0][1] = (fword >> 12) & 1;
		  valid0[ch0][1] = (fword >> 13) & 1;
		  half_strip0[ch0][1] |= (fword >> 7) & 0x80;
		  break;
		case 6:
		  cpattern0[ch0][0] = (fword >> 8) & 0xf;
		  break;
		case 7:
		  cpattern0[ch0][1] = (fword >> 8) & 0xf;
		  break;
		}
	      break;
	    }
	}
      
      if (fr_word == 3)
	{
	  // last frame word decoded, print
	  for (int station = 0; station < 5; station++)
	    {
	      for (int seg = 0; seg < 2; seg ++)
		{
		  if (valid0[station][seg])
		    {
		      printf ("1\t1\t1\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
			      station == 0 ? 1 : station == 1 ? 2 : 0, // subsector
			      station == 0 ? 1 : station,
			      valid0[station][seg],
			      quality0[station][seg],
			      cpattern0[station][seg],
			      wiregroup0[station][seg],
			      1,
			      1,
			      half_strip0[station][seg]
			      );
		    }
		}
	      for (int chamber = 0; chamber < 8; chamber++)
		{
		  int ind = station * 8 + chamber;
		  for (int seg = 0; seg < 2; seg ++)
		    {
		      if (valid[ind][seg])
			{
			  printf ("1\t1\t1\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n",
				  station == 0 ? 1 : station == 1 ? 2 : 0, // subsector
				  station == 0 ? 1 : station,
				  valid[ind][seg],
				  quality[ind][seg],
				  cpattern[ind][seg],
				  wiregroup[ind][seg],
				  chamber + 2,
				  1,
				  half_strip[ind][seg]
				  );
			}
		    }
		}
	    } 
	}

      fr_word = (fr_word + 1) & 3; 
    }



  fclose (fin);
}
