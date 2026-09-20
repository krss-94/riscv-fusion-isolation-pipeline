#include <sys/stat.h>
#include <errno.h>

#define UART_TXDATA (*(volatile unsigned int*)0x80000000)

int _write(int fd, const char *buf, int len) {
    (void)fd;
    for (int i = 0; i < len; i++) UART_TXDATA = (unsigned int)buf[i];
    return len;
}
int _close(int fd) { (void)fd; return -1; }
int _fstat(int fd, struct stat *st) { (void)fd; st->st_mode = S_IFCHR; return 0; }
int _isatty(int fd) { (void)fd; return 1; }
int _lseek(int fd, int ofs, int whence) { (void)fd; (void)ofs; (void)whence; return 0; }
int _read(int fd, char *buf, int len) { (void)fd; (void)buf; (void)len; return 0; }
void _exit(int code) { (void)code; while (1) { asm volatile("nop"); } }
int _kill(int pid, int sig) { (void)pid; (void)sig; errno = EINVAL; return -1; }
int _getpid(void) { return 1; }

extern char __heap_start;
extern char __heap_end;
static char *heap_ptr = 0;
void *_sbrk(int incr) {
    if (heap_ptr == 0) heap_ptr = &__heap_start;
    char *base = heap_ptr;
    if (heap_ptr + incr > &__heap_end) return (void*)-1;
    heap_ptr += incr;
    return base;
}
