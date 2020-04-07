// RUN: %clang_cc1 -verify -fopenmp -ferror-limit 100 %s -Wno-openmp-mapping -Wuninitialized

// RUN: %clang_cc1 -verify -fopenmp-simd -ferror-limit 100 %s -Wno-openmp-mapping -Wuninitialized

void foo() {
}

bool foobool(int argc) {
  return argc;
}

void xxx(int argc) {
  int map; // expected-note {{initialize the variable 'map' to silence this warning}}
#pragma omp target teams distribute map(map) // expected-warning {{variable 'map' is uninitialized when used here}}
  for (int i = 0; i < 10; ++i)
    ;
}

struct S1; // expected-note 2 {{declared here}}
extern S1 a;
class S2 {
  mutable int a;
public:
  S2():a(0) { }
  S2(S2 &s2):a(s2.a) { }
  static float S2s;
  static const float S2sc;
};
const float S2::S2sc = 0;
const S2 b;
const S2 ba[5];
class S3 {
  int a;
public:
  S3():a(0) { }
  S3(S3 &s3):a(s3.a) { }
};
const S3 c;
const S3 ca[5];
extern const int f;
class S4 {
  int a;
  S4();
  S4(const S4 &s4);
public:
  S4(int v):a(v) { }
};
class S5 {
  int a;
  S5():a(0) {}
  S5(const S5 &s5):a(s5.a) { }
public:
  S5(int v):a(v) { }
};

S3 h;
#pragma omp threadprivate(h) // expected-note 2 {{defined as threadprivate or thread local}}

typedef int from;

template <typename T, int I> // expected-note {{declared here}}
T tmain(T argc) {
  const T d = 5;
  const T da[5] = { 0 };
  S4 e(4);
  S5 g(5);
  T i, t[20];
  T &j = i;
  T *k = &j;
  T x;
  T y;
  T to, tofrom, always;
  const T (&l)[5] = da;


#pragma omp target teams distribute map // expected-error {{expected '(' after 'map'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map( // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map() // expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(alloc) // expected-error {{use of undeclared identifier 'alloc'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to argc // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to:) // expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(from: argc, // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(x: y) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[-1:]) // expected-error 2 {{array section must be a subset of the original array}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[:-1]) // expected-error 2 {{section length is evaluated to a negative value -1}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[true:true])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom: t[:I])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(T: a) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}} expected-error {{incomplete type 'S1' where a complete type is required}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(T) // expected-error {{'T' does not refer to a value}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(I) // expected-error 2 {{expected expression containing only member accesses and/or array sections based on named variables}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2s)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2sc)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to: x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to: to)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to, x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to x) // expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom: argc > 0 ? x : y) // expected-error 2 {{expected expression containing only member accesses and/or array sections based on named variables}} 
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(argc)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S1) // expected-error {{'S1' does not refer to a value}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(a, b, c, d, f) // expected-error {{incomplete type 'S1' where a complete type is required}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(ba)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(ca)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2s)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2sc)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(e, g)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(h) // expected-error {{threadprivate variables are not allowed in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(k), map(k) // expected-error 2 {{variable already marked as mapped in current construct}} expected-note 2 {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(k), map(k[:5]) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}} expected-note 2 {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da[:4])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target data map(k, j, l) // expected-note 2 {{used here}}
#pragma omp target teams distribute map(k[:4]) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(j)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l) map(l[:5]) // expected-error 2 {{variable already marked as mapped in current construct}} expected-note 2 {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target data map(k[:4], j, l[:5]) // expected-note 2 {{used here}}
{
#pragma omp target teams distribute map(k) // expected-error 2 {{pointer cannot be mapped along with a section derived from itself}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(j)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l)
  for (i = 0; i < argc; ++i) foo();
}

#pragma omp target teams distribute map(always, tofrom: x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(always: x) // expected-error {{missing map type}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom, always: x) // expected-error {{incorrect map type modifier, expected 'always', 'close', or 'mapper'}} expected-error {{missing map type}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(always, tofrom: always, tofrom, x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom j) // expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();

  return 0;
}

int main(int argc, char **argv) {
  const int d = 5;
  const int da[5] = { 0 };
  S4 e(4);
  S5 g(5);
  int i;
  int &j = i;
  int *k = &j;
  int x;
  int y;
  int to, tofrom, always;
  const int (&l)[5] = da;

#pragma omp target teams distribute map // expected-error {{expected '(' after 'map'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map( // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map() // expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(alloc) // expected-error {{use of undeclared identifier 'alloc'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to argc // expected-error {{expected ')'}} expected-note {{to match this '('}} expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to:) // expected-error {{expected expression}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(from: argc, // expected-error {{expected expression}} expected-error {{expected ')'}} expected-note {{to match this '('}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(x: y) // expected-error {{incorrect map type, expected one of 'to', 'from', 'tofrom', 'alloc', 'release', or 'delete'}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[-1:]) // expected-error {{array section must be a subset of the original array}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[:-1]) // expected-error {{section length is evaluated to a negative value -1}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l[true:true])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to: x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to: to)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to, x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(to x) // expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom: argc > 0 ? argv[1] : argv[2]) // expected-error {{expected expression containing only member accesses and/or array sections based on named variables}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(argc)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S1) // expected-error {{'S1' does not refer to a value}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(a, b, c, d, f) // expected-error {{incomplete type 'S1' where a complete type is required}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(argv[1])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(ba)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(ca)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2s)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(S2::S2sc)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(e, g)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(h) // expected-error {{threadprivate variables are not allowed in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(k), map(k) // expected-error {{variable already marked as mapped in current construct}} expected-note {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(k), map(k[:5]) // expected-error {{pointer cannot be mapped along with a section derived from itself}} expected-note {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(da[:4])
  for (i = 0; i < argc; ++i) foo();
#pragma omp target data map(k, j, l) // expected-note {{used here}}
#pragma omp target teams distribute map(k[:4]) // expected-error {{pointer cannot be mapped along with a section derived from itself}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(j)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l) map(l[:5]) // expected-error 1 {{variable already marked as mapped in current construct}} expected-note 1 {{used here}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target data map(k[:4], j, l[:5]) // expected-note {{used here}}
{
#pragma omp target teams distribute map(k) // expected-error {{pointer cannot be mapped along with a section derived from itself}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(j)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(l)
  for (i = 0; i < argc; ++i) foo();
}

#pragma omp target teams distribute map(always, tofrom: x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(always: x) // expected-error {{missing map type}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom, always: x) // expected-error {{incorrect map type modifier, expected 'always', 'close', or 'mapper'}} expected-error {{missing map type}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(always, tofrom: always, tofrom, x)
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(tofrom j) // expected-error {{expected ',' or ')' in 'map' clause}}
  for (i = 0; i < argc; ++i) foo();
#pragma omp target teams distribute map(delete: j) // expected-error {{map type 'delete' is not allowed for '#pragma omp target teams distribute'}}
  for (i = 0; i < argc; ++i)
    foo();
#pragma omp target teams distribute map(release: j) // expected-error {{map type 'release' is not allowed for '#pragma omp target teams distribute'}}
  for (i = 0; i < argc; ++i)
    foo();

  return tmain<int, 3>(argc)+tmain<from, 4>(argc); // expected-note {{in instantiation of function template specialization 'tmain<int, 3>' requested here}} expected-note {{in instantiation of function template specialization 'tmain<int, 4>' requested here}}
}

