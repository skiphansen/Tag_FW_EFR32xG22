#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "logging.h"

#if 1
// Debugging version
void DumpHex(void *AdrIn,int Len)
{
   unsigned char *Adr = (unsigned char *) AdrIn;
   int i = 0;
   int j;

   while(i < Len) {
      for(j = 0; j < 16; j++) {
         if((i + j) == Len) {
            break;
         }
         _LOG("%02x ",Adr[i+j]);
      }

      _LOG(" ");
      for(j = 0; j < 16; j++) {
         if((i + j) == Len) {
            break;
         }
         if(isprint(Adr[i+j])) {
            _LOG("%c",Adr[i+j]);
         }
         else {
            _LOG(".");
         }
      }
      i += 16;
      _LOG("\n");
   }
}
#else
// version to allow hex dumps to be copied to source files easily
void DumpHex(void *AdrIn,int Len)
{
   unsigned char *Adr = (unsigned char *) AdrIn;
   int i = 0;
   int j;

   while(i < Len) {
      for(j = 0; j < 16; j++) {
         if((i + j) == Len) {
            break;
         }
         LOG_RAW("0x%02x,",Adr[i+j]);
      }
      i += 16;
      LOG_RAW("\n");
   }
}
#endif


