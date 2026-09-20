#include <stdarg.h>

extern int _write(int fd, const char *buf, int len);

static void putc_uart(char c) { _write(1, &c, 1); }

static void print_str(const char *s) { while (*s) putc_uart(*s++); }

static void print_uint(unsigned long v, int base) {
    char buf[32]; int i = 0;
    if (v == 0) { putc_uart('0'); return; }
    while (v) { int d = v % base; buf[i++] = d < 10 ? '0'+d : 'a'+d-10; v /= base; }
    while (i--) putc_uart(buf[i]);
}

static void print_int(long v) {
    if (v < 0) { putc_uart('-'); print_uint((unsigned long)(-v), 10); }
    else print_uint((unsigned long)v, 10);
}

int printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int n = 0;
    for (const char *p = fmt; *p; p++) {
        if (*p != '%') { putc_uart(*p); n++; continue; }
        p++;
        int is_long = 0;
        if (*p == 'l') { is_long = 1; p++; }
        switch (*p) {
            case 'd': if (is_long) print_int(va_arg(ap, long)); else print_int(va_arg(ap, int)); break;
            case 'u': if (is_long) print_uint(va_arg(ap, unsigned long), 10); else print_uint(va_arg(ap, unsigned int), 10); break;
            case 's': print_str(va_arg(ap, const char*)); break;
            case 'c': putc_uart((char)va_arg(ap, int)); break;
            case '%': putc_uart('%'); break;
            default: putc_uart('%'); putc_uart(*p); break;
        }
    }
    va_end(ap);
    return n;
}
