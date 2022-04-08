#include<stdio.h>
#include<time.h>
int n;

__global__ void vector_add_gpu(int *a,int *b,int *c)
{
    int index  = (blockIdx.x * blockDim.x) + threadIdx.x;
    c[index] = a[index] +b[index];

}
void vector_add_cpu(int *a,int *b,int *c)
{
    for(int i=0;i<n;i++)
    {
        c[i] = a[i] +b[i];
    }
}
int main()
{
    int *h_a,*h_b,*h_c;
    int *d_a,*d_b,*d_c;


    clock_t begin,end;
    double time_spent;

    printf("Enter size of vector ");
    scanf("%d",&n);
    
    begin = clock();
    h_a = (int *)malloc(sizeof(int)*n);
    h_b = (int *)malloc(sizeof(int)*n);
    h_c = (int *)malloc(sizeof(int)*n);

    cudaMalloc((void **)&d_a,sizeof(int)*n);
    cudaMalloc((void **)&d_b,sizeof(int)*n);
    cudaMalloc((void **)&d_c,sizeof(int)*n);

    for(int i=0;i<n;i++)
    {
        h_a[i] =rand()%100;
        h_b[i] =rand()%100;
    }


    
    vector_add_cpu(h_a,h_b,h_c);
    end = clock();
    time_spent = (double)(end-begin)/CLOCKS_PER_SEC;
    printf("\nTime spent for Serial Vector Addition %f seconds",time_spent);

    begin = clock();
    cudaMemcpy(d_a,h_a,sizeof(int)*n,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,h_b,sizeof(int)*n,cudaMemcpyHostToDevice);
    
    vector_add_gpu<<<1,n>>>(d_a,d_b,d_c);
    
    cudaMemcpy(h_c,d_c,sizeof(int)*n,cudaMemcpyDeviceToHost);
    end = clock();

    

    time_spent = (double)(end-begin)/CLOCKS_PER_SEC;

    printf("\nTime spent for Parrellel Vector Addition %f seconds",time_spent);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);
    return 0;
}