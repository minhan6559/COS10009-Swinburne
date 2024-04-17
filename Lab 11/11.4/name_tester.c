#include <stdio.h>
#include <string.h>
#include "terminal_user_input.h"

#define LOOP_COUNT 60

int main()
{
  my_string name;
  int index;
 
  name = read_string("What is your name? ");

  printf("\nYour name ", name.str);

  // Move the following code into a procedure
  // ie:  void print_silly_name(my_string name)
  if (strcmp(name.str, "YOUR_TUTOR_NAME") == 0)
  {
    printf(" is an AWESOME name!");
  }
  else
  {
    print_silly_name(name);
  }

  return 0;
}
