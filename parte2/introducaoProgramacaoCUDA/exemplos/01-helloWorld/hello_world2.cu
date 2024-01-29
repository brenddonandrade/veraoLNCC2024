// vai ser executado paralelamente na GPU
__global__ void mykernel (void) {
}

int main(void) {
	
	// lancando um bloco e uma thread na GPU
	mykerneli<<<1,1>>>();
	printf("Hello World!\n");
	return 0;
}
