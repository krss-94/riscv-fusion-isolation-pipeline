#include "support.h"
extern unsigned int embench_start_cyc, embench_stop_cyc;
extern int printf(const char *fmt, ...);

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    volatile int result;
    int correct;
    initialise_board();
    initialise_benchmark();
    warm_caches(0);
    start_trigger();
    result = benchmark();
    stop_trigger();
    correct = verify_benchmark(result);
    printf("EMBENCH cycles=%ld correct=%d\n",
           (long)(embench_stop_cyc - embench_start_cyc), correct);
    return !correct;
}
