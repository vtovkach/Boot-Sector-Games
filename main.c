#include <stdio.h>

void print_primes(int);

int main(void)
{

    print_primes(20);

    return 0;
}

void print_primes(int n)
{
    // 0 - false
    // 1 - true
    int table[n];
    int test_num;
    int i;
    // set table
    for(i = 0; i < n; i++)
    {
        if(i == 0 || i == 1)
        {
            table[i] = 0;
        }
        else
        {
            table[i] = 1;
        }
    }

    i = 0;
    while(table[i] != 1)
    {
        i++;
    }

    test_num = table[i];

    for(i = test_num; i < n; )
    {
        for(int j = 0; j < n; ++j)
        {
            if(i <= test_num)
            {
                continue;
            }
            else
            {
                if((i % test_num) == 0)
                {   
                    table[i] = 0;
                }
            }
        }

        int o = 1;
        while(table[0] != 1 && o < n)
        {
            o++;
        }
        if(o >= n)
        {
            i = n + 1;
        }
        else
        {
            i = o;
        }
    }

    for(int j = 0; j < n; ++j)
    {
        if(table[j] == 1)
        {
            printf("%d ", j);
        }
    }

}