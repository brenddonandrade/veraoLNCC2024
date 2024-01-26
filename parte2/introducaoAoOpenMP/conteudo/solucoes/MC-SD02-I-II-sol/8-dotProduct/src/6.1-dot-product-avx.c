double dot_product(double *a, int *b, long long int N){
	long long int i;
	double dot = 0.0, partial[4];
	__m256d ac, va, vb, mul;

	ac = _mm256_set_pd(0.0, 0.0, 0.0, 0.0);
	for(i = 0; i < N; i += 4){
		va = _mm256_load_pd(&a[i]);
		vb = _mm256_load_pd(&b[i]);
		
		mul = _mm256_mul_pd(va, vb);
		
		ac = _mm256_add_pd(ac, mul);
	}

	_mm256_storeu_pd(partial, ac);

	dot = partial[0] + partial[1] + partial[2] + partial[3];

	return dot;
}