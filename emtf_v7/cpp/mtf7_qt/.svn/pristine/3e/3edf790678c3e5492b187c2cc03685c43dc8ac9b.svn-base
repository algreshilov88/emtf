#ifndef __VME_SERVER_H__
#define __VME_SERVER_H__


#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include "CAENVMEtypes.h"


/*
 *
 * sockfd is the socket number
 */

int32_t sockfd;

int32_t CAENVME_Init(CVBoardTypes BdType, short Link, short BdNum, int32_t *Handle){
	int32_t storage[6], info[2], n;

    char *argv[3] =
    {
        (char*)"",
          (char*)"cosmic1.phys.ufl.edu", // computer name
//        (char*)"168.7.16.5",
//        (char*)"bonner-daq.rice.edu",
        (char*)"36754" // port name
    };

    // create and open socket here
    int portno;
    struct sockaddr_in serv_addr;
    struct hostent *server;

    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
    {
        perror("ERROR opening socket");
        return -10;
    }
    server = gethostbyname(argv[1]);
    if (server == NULL)
    {
        perror("ERROR, no such host\n");
        return -10;
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr,
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0)
    {
        perror("ERROR connecting");
        return -10;
    }

    // now call init function

    storage[0] = 1;    // function identifier
	storage[1] = BdType;
	storage[2] = Link;
	storage[3] = BdNum;
	storage[4] = *Handle;
	storage[5] = 0;
	n = write(sockfd, storage, sizeof(storage));
    if (n < 0) return -10;
    n = read(sockfd,info,sizeof(info));
    if (n < 0) return -11;
	*Handle = info[1];
	return info[0]; 
}

int32_t CAENVME_End(int32_t Handle){
	int32_t storage[6], info[2], n;
	storage[0] = 2;
	storage[1] = Handle;
	storage[2] = 0;
	storage[3] = 0;
	storage[4] = 0;
	storage[5] = 0;
	n = write(sockfd, storage, sizeof(storage));
    if (n < 0) return -10;
    n = read(sockfd,info,sizeof(info));
    if (n < 0) return -11;

    usleep (20000);
    // close socket
    close(sockfd);

	return info[0];
}

int32_t CAENVME_WriteCycle(int32_t Handle, uint32_t Address, void *Data, CVAddressModifier AM, CVDataWidth DW){
	int32_t storage[6], info[2], n;
	storage[0] = 3;
	storage[1] = Handle;
	storage[2] = Address;
	storage[3] = *((int32_t*)Data);
	storage[4] = AM;
	storage[5] = DW;
	n = write(sockfd, storage, sizeof(storage));
    if (n < 0) return -10;
    n = read(sockfd,info,sizeof(info));
    if (n < 0) return -11;
    return info[0];
}

int32_t CAENVME_ReadCycle(int32_t Handle, uint32_t Address, void *Data, CVAddressModifier AM, CVDataWidth DW){
	int32_t storage[6], info[2], n;
	storage[0] = 4;
	storage[1] = Handle;
	storage[2] = Address;
	storage[3] = *((int32_t*)Data);
	storage[4] = AM;
	storage[5] = DW;
	n = write(sockfd, storage, sizeof(storage));
    if (n < 0) return -10;
    n = read(sockfd,info,sizeof(info));
    if (n < 0) return -11;
    *((int32_t*)Data) = info[1];
	return info[0];
}

uint64_t write_dfr_data[16384];
int wr_dfr_i = 0;

// deferred write
int32_t CAENVME_WriteCycleDfr(int32_t Handle, uint32_t Address, void *Data, CVAddressModifier AM, CVDataWidth DW){
    // store write data for later transmission
    uint64_t addr64;
    write_dfr_data[wr_dfr_i] = (*((int32_t*)Data)) & 0xffffffff;
    addr64 = Address & 0xffffff;
    addr64 = addr64 << 32;
    write_dfr_data[wr_dfr_i] |= addr64;
    wr_dfr_i++; // move pointer

    Handle = AM + DW; // to avoid "unused parameter" warning

    return cvSuccess + Handle - Handle;
}

// execute all deferred writes now
int32_t CAENVME_WriteCycleExec (int32_t Handle, CVAddressModifier AM, CVDataWidth DW)
{
    int32_t storage[6], info[2], n;
    storage[0] = 5;
    storage[1] = Handle;
    storage[2] = 0;
    storage[3] = wr_dfr_i * 8; // length of dfr data in bytes
    storage[4] = AM;
    storage[5] = DW;
    n = write(sockfd, storage, sizeof(storage)); // send header
    if (n < 0) return -10;
    n = write(sockfd, write_dfr_data, storage[3]); // send data
    if (n < 0) return -10;
    n = read(sockfd,info,sizeof(info));
    if (n < 0) return -11;

    // reset dfr array counter
    wr_dfr_i = 0;
    return info[0];

}

uint32_t read_dfr_data[16384];
uint16_t* read_ptr[16384];
uint16_t read_data[16384];
int rd_dfr_i = 0;

int32_t CAENVME_ReadCycleDfr(int32_t Handle, uint32_t Address, void *Data, CVAddressModifier AM, CVDataWidth DW){
    // store read address for later execution
    read_dfr_data[rd_dfr_i] = Address;
    // store data pointer separately
    read_ptr[rd_dfr_i] = (uint16_t *)Data;
    rd_dfr_i++; // move pointer

    Handle = AM + DW; // to avoid "unused parameter" warning

    return cvSuccess + Handle - Handle;
}

int32_t CAENVME_ReadCycleExec(int32_t Handle, CVAddressModifier AM, CVDataWidth DW){
    int32_t storage[6], info[2], n;
    storage[0] = 6;
    storage[1] = Handle;
    storage[2] = 0;
    storage[3] = rd_dfr_i * 4; // length of dfr addresses in bytes
    storage[4] = AM;
    storage[5] = DW;
    n = write(sockfd, storage, sizeof(storage)); // write header
    if (n < 0) return -10;

    // write addresses
    n = write(sockfd, read_dfr_data, storage[3]); // send data
    if (n < 0) return -10;

    // read back the data returned by server
    n = read(sockfd,info,sizeof(info)); // return code and data length
    if (n < 0) return -11;
    int data_lng = info[1];

    if (data_lng != rd_dfr_i * 4) // wrong byte count returned
        return -12;

    // now read data
    n = 0;
    int terminal_n = rd_dfr_i * 2;
    while (1) // word count *2 because data is 16-bit
    {
        if (n >= terminal_n) break;
        n += read(sockfd, ((uint8_t*)read_data) + n, rd_dfr_i*2 - n);
    }

    // now place data into pointers as requested
    for (int i = 0; i < rd_dfr_i; i++)
    {
        *(read_ptr[i]) = read_data[i];
    }
    rd_dfr_i = 0; // reset dfr array counter
    return info[0];
}


#endif
