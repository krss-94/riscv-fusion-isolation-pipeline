#ifndef STRING_H
#define STRING_H
#include <stddef.h>
int strcmp(const char *a, const char *b);
char *strcpy(char *dst, const char *src);
void *memset(void *s, int c, size_t n);
void *memcpy(void *d, const void *s, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
char *strchr(const char *s, int c);
size_t strlen(const char *s);
void *memmove(void *dest, const void *src, size_t n);
#endif
