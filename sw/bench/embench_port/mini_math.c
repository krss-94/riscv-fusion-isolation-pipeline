double sqrt(double x)
{
    if (x <= 0.0) return 0.0;
    double guess = x;
    double prev;
    do {
        prev = guess;
        guess = 0.5 * (guess + x / guess);
    } while (guess < prev - 1e-9 || guess > prev + 1e-9);
    return guess;
}
