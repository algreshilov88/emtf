#ifndef SP12_MACROS_H
#define SP12_MACROS_H

#include <unistd.h>

extern int device_d; // device file descriptor
extern int devices_d[13]; // multiple devices

extern "C" void log_printf(const char *pszFormat, ...);
extern "C" void set_progress(int pcent);

#define mwrite(a,b,c,d) if (pwrite (a,b,c,d) != c) log_printf ("pwrite error: w: %d file: %s line: %d\n", c, __FILE__, __LINE__);
#define mread(a,b,c,d) if (pread (a,b,c,d) != c) log_printf ("pread error: w: %d file: %s line: %d\n", c, __FILE__, __LINE__);
#define check_ret(ret)\
{\
 switch (ret)\
 {\
case cvSuccess   : break;\
case cvBusError  : log_printf("File: %s Line: %d  Bus Error !!!\n", __FILE__, __LINE__);\
        break ;\
case cvCommError : log_printf("File: %s Line: %d  Communication Error !!!\n", __FILE__, __LINE__);\
    break ;\
case -10 : log_printf("File: %s Line: %d  Error writing socket\n", __FILE__, __LINE__);\
    break ;\
case -11 : log_printf("File: %s Line: %d  Error reading socket\n", __FILE__, __LINE__);\
    break ;\
case -12 : log_printf("File: %s Line: %d  Wrong byte count returned\n", __FILE__, __LINE__);\
    break ;\
default          : log_printf("File: %s Line: %d  Unknown Error !!!\n", __FILE__, __LINE__);\
    break ;\
}\
}


#endif // SP12_MACROS_H
