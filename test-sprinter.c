#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

//typedef unsigned char uchar;

extern int sprinter (char *res, char *format, ...);

void add_int (char **sp, int v)
{
  if (v >= 10) {
    add_int(sp, v/10);
  }
  **sp = v%10 + '0';  (*sp)++;
}

void my_ftoa (char *s, double f)
{
  int n, i;

  if (f < 0.0) {
    *s = '-';  s++;  f = -f;
  }
  f += 0.0000005;

  n = (int)f;  f -= n;  add_int(&s, n);
  *s = '.';  s++;
  for (i = 1;  i <= 6;  i++) {
    f *= 10.0;  n = (int)f;  f -= n;
    *s = n + '0';  s++;
  }

  *s = 0;
}


void check (int n, int ret1, int ret2, char *buf1, char *buf2)
{
    if (ret1==ret2 && strcmp(buf1,buf2)==0) {
        printf("Test %2d OK.\n", n);  
                return;
    }
    if (strcmp(buf1,buf2) != 0) {
        printf("Test %2d: Teksten er \"%s\" og ikke \"%s\".\n",
               n, buf1, buf2);
    }
    if (ret1 != ret2) {
        printf("Test %2d: Returverdi er %d og ikke %d.\n",
               n, ret1, ret2);
    }

}


char *s;
int main (void){
    char t1[2000];
    char t2[2000];
    int r2, r1;
	
    r1 = sprinter(t1, "");
    r2 = sprintf (t2, "");
    check(1, r1, r2, t1, t2); 
    
     r1 = sprinter(t1, "En lang tekst uten %%-tegn.");
     r2 = sprintf (t2, "En lang tekst uten %%-tegn.");
    
     check(2, r1, r2, t1, t2);
    
     r1 = sprinter(t1, "Ett tegn: '%c'.", 'w');
     r2 = sprintf (t2, "Ett tegn: '%c'.", 'w');
     check(3, r1, r2, t1, t2);

    
     r1 = sprinter(t1, "To tegn: '%c' og '%c'.", 'x', 'y');
     r2 = sprintf (t2, "To tegn: '%c' og '%c'.", 'x', 'y');
     check(4, r1, r2, t1, t2);
    
     r1 = sprinter(t1, "Tre tegn: '%c', '%c' og '%c'.", 'x', 'y', 'z');
     r2 = sprintf (t2, "Tre tegn: '%c', '%c' og '%c'.", 'x', 'y', 'z');
     check(5, r1, r2, t1, t2);
    
    
    
     r1 = sprinter(t1, "Lovlige %s er '%%%%', '%cc', '%%d', '%c%c', '%%s' og '%%x'.",
                   "%-spesifikasjoner", '%', '%', 'f');
     r2 = sprintf (t2, "Lovlige %s er '%%%%', '%cc', '%%d', '%c%c', '%%s' og '%%x'.",
                   "%-spesifikasjoner", '%', '%', 'f');
     check(6, r1, r2, t1, t2);
    
    
     r1 = sprinter(t1, "Tre tekster: '%s', '%s' og '%s'.",
                   "abc...xyz", "alfa -> omega", "");
     r2 = sprintf (t2, "Tre tekster: '%s', '%s' og '%s'.",
                   "abc...xyz", "alfa -> omega", "");
     check(7, r1, r2, t1, t2);
    
    r1 = sprinter(t1, "En oekning paa %d%% er bedre enn en paa %d%%!", 27, 8);
    r2 = sprintf (t2, "En oekning paa %d%% er bedre enn en paa %d%%!", 27, 8);
    check(8, r1, r2, t1, t2);
    
    r1 = sprinter(t1, "Tallet %d ligger i intervallet %d-%d.", -2230, -10000, -1000);
    r2 = sprintf (t2, "Tallet %d ligger i intervallet %d-%d.", -2230, -10000, -1000);
    check(9, r1, r2, t1, t2);
    
    
    r1 = sprinter(t1, "Tallene er %d, %d og %d.", 0, 1000, 1000000000);
    r2 = sprintf (t2, "Tallene er %d, %d og %d.", 0, 1000, 1000000000);
    check(10, r1, r2, t1, t2);

    
    
    
      r1 = sprinter(t1, "Det %s tallet med fortegn er %d.", 
         "stoerste positive", 2147483647);
     r2 = sprintf (t2, "Det %s tallet med fortegn er %d.", 
            "stoerste positive", 2147483647);
     check(11, r1, r2, t1, t2);

     r1 = sprinter(t1, "Det nest %s tallet er %d (-%d).", "stoerste negative", 
           -2147483647, 1);
     r2 = sprintf (t2, "Det nest %s tallet er %d (-%d).", "stoerste negative", 
           -2147483647, 1);
     check(12, r1, r2, t1, t2);

     r1 = sprinter(t1, "Det aller %s tallet er %d.", "stoerste negative", 
           -2147483647-1);
     r2 = sprintf (t2, "Det aller %s tallet er %d.", "stoerste negative", 
           -2147483647-1);
     check(13, r1, r2, t1, t2);

     r1 = sprinter(t1, "%d = 0x%x", 0, 0);
     r2 = sprintf (t2, "%d = 0x%x", 0, 0);
     check(14, r1, r2, t1, t2);

     r1 = sprinter(t1, "%d = 0x%x", 1234, 1234);
     r2 = sprintf (t2, "%d = 0x%x", 1234, 1234);
     check(15, r1, r2, t1, t2);

     r1 = sprinter(t1, "Adressen til %s er 0x%x.", "r1", &r1);
     r2 = sprintf (t2, "Adressen til %s er 0x%x.", "r1", &r1);
     check(16, r1, r2, t1, t2);

   r1 = sprinter(t1, "Et flyt-tall: %f", 3.14);
   r2 = sprintf (t2, "Et flyt-tall: %f", 3.14);
   check(17, r1, r2, t1, t2);

  r1 = sprinter(t1, "Tre flyt-tall: %f, %f og %f", -1.05, 1234.567, -0.001);
  r2 = sprintf (t2, "Tre flyt-tall: %f, %f og %f", -1.05, 1234.567, -0.001);
  check(18, r1, r2, t1, t2);


    
    
    
	exit(0);
}