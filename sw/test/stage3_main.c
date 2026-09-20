#define UART_TXDATA (*(volatile unsigned int*)0x80000000)
void uart_puts(const char *s) { while (*s) { UART_TXDATA = (unsigned int)(unsigned char)*s; s++; } }
int main(void) {
    uart_puts("hello2\n");
    for (;;);
    return 0;
}
