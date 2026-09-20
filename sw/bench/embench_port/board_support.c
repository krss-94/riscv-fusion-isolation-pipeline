static inline unsigned int rdcycle_u32(void) {
    unsigned int c;
    __asm__ volatile ("csrr %0, mcycle" : "=r"(c));
    return c;
}
unsigned int embench_start_cyc = 0, embench_stop_cyc = 0;

void initialise_board(void) {}
void start_trigger(void) { embench_start_cyc = rdcycle_u32(); }
void stop_trigger(void) { embench_stop_cyc = rdcycle_u32(); }
