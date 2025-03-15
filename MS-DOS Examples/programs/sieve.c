#include <stdio.h>
#include <math.h>

void prime_finder(int);

int main(void)
{
    int prime_n = 100;

    printf("Here are the primes up to %d.\n", prime_n);

    prime_finder(prime_n);

    return 0;
}


void prime_finder(int n)
{
    // 0 - false
    // 1 - true

    int table[n];

    // false by default
    table[0] = 0;
    table[1] = 0;

    int lim = sqrt(n);

    // Set the table
    for(int i = 2; i < n; i++)
    {
        table[i] = 1;
    }

    for(int i = 2; i < lim; )
    {
    
        for(int j = i + 1; j < n; ++j)
        {
            if(((j) % i) == 0)
            {
                table[j] = 0;
            }
        }

        // set next i prime
        for(int k = i + 1; k < n; k++)
        {
            if(table[k] != 0)
            {
                i = k;
                break;
            }
        }
    }

    // print prime numbers 
    for(int i = 0; i < n; i++)
    {
        if(table[i] != 0)
        {
            printf("%d ", i);
        }
    }
    putchar('\n');
}