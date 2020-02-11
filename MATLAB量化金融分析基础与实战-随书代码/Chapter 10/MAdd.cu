definition __global__ void MAdd(float X[M][N], float Y[M][N], float Z[M][N]) {
int i = blockIdx.x * blockDim.x + threadIdx.x;
int j = blockIdx.y * blockDim.y + threadIdx.y;
if (i < M && j < N) C[i][j] = A[i][j] + B[i][j];
 }
int main() { 
	dim3 threadsPerBlock(16, 16);
	dim3 numBlocks(M / threadsPerBlock.x, N / threadsPerBlock.y); 
	MAdd<<<numBlocks, threadsPerBlock>>>(A, B, C); 
	return 0;
}