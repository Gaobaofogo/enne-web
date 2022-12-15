#include <stdio.h>
#include "zhash.h"
#include "data.h"

int main (int argc, char *argv[])
{
  struct ZHashTable *symbol_table = zcreate_hash_table();
  Data d1,d2,d3;
  d1.name = "x";
  d2.name = "y";
  d3.name = "z";
  zhash_set(symbol_table, "x", (void*)&d1);
  zhash_set(symbol_table, "y", (void*)&d2);
  zhash_set(symbol_table, "z", (void*)&d3);
  Data *d1_hash = (Data*)zhash_get(symbol_table, "x");
  Data *d2_hash = (Data*)zhash_get(symbol_table, "y");
  Data *d3_hash = (Data*)zhash_get(symbol_table, "z");

  printf("%s\n", d1_hash->name);
  printf("%s\n", d2_hash->name);
  printf("%s\n", d3_hash->name);


  zfree_hash_table(symbol_table); 
  
  return 0;
}
