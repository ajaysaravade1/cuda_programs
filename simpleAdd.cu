#include<stdio.h>
#include<time.h>
__global__ void add_gpu(int *a, int *b,int *c)
{
 *c = *a + *b;
}

int main()
{
    int *h_a;
    int *h_b;
    int *h_c;

    clock_t begin,end;
    double time_spent;

    int *d_a,*d_b,*d_c;

    h_a = (int *)malloc(sizeof(int));
    h_b = (int *)malloc(sizeof(int));

    cudaMalloc((void **)&d_a,sizeof(int));
    cudaMalloc((void **)&d_b,sizeof(int));

    *h_a = 20;
    *h_b = 30;
    begin = clock();

    cudaMemcpy(d_a,h_a,sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_a,h_a,sizeof(int),cudaMemcpyHostToDevice);

    add_gpu<<<1,1>>>(d_a,d_b,d_c);
    cudaMemcpy(h_c,d_c,sizeof(int),cudaMemcpyDeviceToHost);       
    end = clock();

    time_spent = (double)(end-begin)/CLOCKS_PER_SEC;

    printf("\nTime spent simple Addition %f seconds",time_spent);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    
    
    return 0;
}