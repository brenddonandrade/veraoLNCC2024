#include <stdlib.h>
#include <stdio.h>


//real	0m14.905s
//real	0m5.621s



void matfree( double **X, int n) {
	for (int i = 0; i< n ; i++)
		free(X[i]);
	free( X ) ;
}

double **matnew(int n) {
	double ** X = (double **) malloc(sizeof(double *) *n);
	for(int i=0 ; i<n ; i++)
		X[i] = (double*) malloc(sizeof(double)*n);
	return X;
}

void matmul(double **X, double **A, double **B, int n){
	for(int i=0; i<n ; i++){
                for (int j =0 ; j<n ; j++) {
                        double s = 0.0;
                        for(int k=0 ; k<n ; k++)
                                s+= A[i][k] * B[j][k];
                        X[i][j] = s;
                }
        }
}


void matmul2(double **X, double **A, double **B, int n){

	// otimizacao de cache -> organizando o acesso de dados pelo principio da localidade (usa melhora cache assim)
	double **Bt = matnew(n);
	for(int i=0; i<n ; i++){
                for (int j =0 ; j<n ; j++) {
                        Bt[i][j] = B[j][i];
                }
        }
	
	
	for(int i=0; i<n ; i++){
		for (int j =0 ; j<n ; j++) {
			double s = 0.0;
			for(int k=0 ; k<n ; k++)
				s+= A[i][k] * Bt[j][k];
			X[i][j] = s;
		}
	}
}

int main(int argc, char **argv){
	int n = atoi(argv[1]);
	
	double ** X = matnew(n);
	double ** A = matnew(n);
	double ** B = matnew(n);
	
	for (int i=0; i<n ; i++)
		for (int j=0; j<n ; j++)
			A[i][j] = B[i][j] = 1.0;
	
	//matmul(X, A, B, n);
	matmul2(X, A, B, n);

	//for(int i=0; i<n ; i++){
	//	for(int j=0 ; j<n ; j++)
	//		printf("%.2lf", X[i][j]);
	//	puts("");	
	//}

	
	
	matfree(X, n);
	matfree(A, n);
	matfree(B, n);
	return 0;
}
		
