#include "vector.h"
using namespace std;

int main() {
	Vector<int> intVec{1,3,5,7,9};
	Vector<double> doubleVec{1.5,2.5,3.5,4.5};
	Vector<int> iv{intVec};
	Vector<double> dv{doubleVec};
	cout << "intVec" << intVec << endl;
	// "intVec(1, 3, 5, 7, 9)"
	cout << "iv" << iv << endl;
	// "iv(1, 3, 5, 7, 9)"
	cout << "doubleVec" << doubleVec << endl;
	// "doubleVec(1.5, 2.5, 3.5, 4.5)"
	cout << "dv" << dv << endl;
	// "dv(1.5, 2.5, 3.5, 4.5)"
	cout << "intVec.size() = 5 " << intVec.size() << "\n";
	intVec[3] = 5;
	cout << "intVec[3] = 5 " << intVec[3] << "\n";
	int test1 = intVec*iv;
	cout << "mult test: 151 " << test1 << "\n";
	Vector<int> test2 = test1+intVec;
	cout << "scalar add test: " << test1 << " + " << intVec << " = " << test2 << "\n";
	test2 = intVec;
	cout << "= test: " << test2 << " " << intVec << "\n";
	Vector<double> test3{8.3, 62, -9.21, 451.2, 62};
	dv = doubleVec + test3;
	cout << "+ test: " << dv << " = " << doubleVec << " + " << test3 << "\n";
	dv = -1 * test3;
	cout << "scalar * test: " << dv << " * -1 = " << test3 << "\n";
	cout << "!= test: " << dv << " != " << test3 << "? " << (dv != test3) << "\n";
	cout << "== test: " << test2 << " == " << intVec << "? " << (test2 == intVec) << "\n";
	return 0;
}