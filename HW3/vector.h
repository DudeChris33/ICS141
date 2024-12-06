#ifndef VECTOR_H
#define VECTOR_H
#include <iostream>
using namespace std;

/* ADVISED ORDER OF IMPLEMENTATION
* 1. Constructors
* 2. Inserter (<<) -> allows you to print & see what is in the vector throughout development
* 3. Write test cases that use some of the constructors and print those vectors out
* 4. Write a test case for a function
* 5. Implement the function and test until you are confident on its correctness
* 6. Repeat from 4 until all methods are implemented and tested
* 7. Implement the destructor last; if there are still errors, then you know it is due to memory management
*/

template <typename T>
class Vector {
	private:
		size_t sz;
		T* buf;

	public:
		Vector(size_t sz) {
			this->sz = sz;
			this->buf = new T[sz];

			// if (this->buf == NULL) {
			// 	std::cout << "Memory not allocated by size\n";
			// } else {
			// 	std::cout << "Memory successfully allocated by size\n";
			// }
		}
		/*
		* Constructs a vector of size sz
		*
		* ex: Vector v(10); -> constructs a 10 elem Vector
		* @param sz size of vector
		*/
		
		Vector(initializer_list<T> L) {
			this->sz = L.size();
			this->buf = new T[L.size()];
			int index = 0;
			for (T i : L) {
				buf[index] = i;
				index++;
			}
			// for (int i = 0; i < L.size(); ++i) {
			// 	this->buf[i] = L.data()[i];
			// }
			
			// if (this->buf == NULL) {
			// 	std::cout << "Memory not allocated by list\n";
			// } else {
			// 	std::cout << "Memory successfully allocated by list\n";
			// }
		}
		/*
		* Constructs a vector from a list of elements
		*
		* ex: Vector v1{1, 2, 3}; -> creates a vector with values 1, 2, 3 and size 3
		* @param L a list of values to initialize our vector
		*   - L.size() gives the list's size
		*   - You can iterate through it using an iterator
		*/
		
		~Vector() {
			delete[] this->buf;
			// std::cout << "Successfully deconstructed\n";
		}
		/*
		* Destructs the object at the end of the object's lifecycle
		*  - Automatically called
		* Deallocate the array here.
		* Some versions of valgrind report 72704 bytes in one still-reachable block.  
		* You can ignore that.
		*/
		
		Vector(const Vector & v) {
			this->sz = v.size();
			this->buf = new T[v.size()];
			for (int i = 0; i < v.size(); ++i) {
				this->buf[i] = v[i];
			}
			
			// if (this->buf == NULL) {
			// 	std::cout << "Memory not allocated by copy\n";
			// } else {
			// 	std::cout << "Memory successfully allocated by copy\n";
			// }
		}
		/*
		* Copy constructor; makes a new Vector by deep copying the vector passed to it
		* ex: Vector v2{v1};
		*/

		size_t size() const {
			// std::cout << "size()\n";
			return this->sz;
		}
		/*
		* Returns the size of the vector
		* ex: Vector v1(10); v1.size(); -> will return 10
		* @return size of vector
		*/
		
		T & operator [] (const int i) {
			// std::cout << "&[]\n";
			return this->buf[i];
		}
		/*
		* Overloads the [] operator and returns a reference to the value at index i in the
		* dynamically allocated array. This would be used to change the value at that index.
		* Throws an error when accessing index out of bounds
		* ex: v1[2] = 3;
		* @param i index of elem in buf that will be accessed
		*/
		
		T operator [] (const int i) const {
			// std::cout << "[]\n";
			return this->buf[i];
		}
		/*
		* Overloads the [] operator and returns the value of the elem at index i in the
		* dynamically allocated array. This would be used to access the value at that index
		* without modifying it.
		* Throws an error when accessing index out of bounds
		* ex: T elemAtInd3 = v1[3];
		* @param i index of elem in buf that will be accessed
		*/

		T operator * (const Vector & v) const {
			// std::cout << "* operator\n";
			// std::cout << this << "\n";
			// std::cout << v << "\n";
			// std::cout << this->size() << v.size() << "\n";
			T product = 0;
			for (int i = 0; i < this->size() + v.size(); ++i) {
				if (i < this->size() and i < v.size()) {
					product += this->buf[i] * v[i];
				} else {
					break;
				}
			}
			return product;
		}
		/*
		* Dot products the current vector with the passed vector.
		* The dot product of two vectors is the sum of the products
		* of the corresponding entries of two sequences of numbers.
		* ex: T x = V1 * V2;
		* dot product: [1, 2] * [3, 4, 5] = 1 * 3 + 2 * 4 + 0 = 11
		* Assume an empty Vector will cause the product to be 0.
		* @param v Vector on the right to dot product with
		* @return a scalar value with type T (not a vector!) that is the dot product of the two vectors
		*/

		Vector operator + (const Vector & v) const {
			// std::cout << "+ operator\n";
			Vector<T> temp(this->size());
			for (int i = 0; i < temp.size()+v.size(); ++i) {
				if (i < this->size() and i < v.size()) {
					temp[i] = this->buf[i] + v[i];
				} else if (i < this->size()) {
					temp[i] = this->buf[i];
				} else if (i < v.size()) {
					temp[i] = v[i];
				} else {
					break;
				}
			}
			return temp;
		}
		/*
		* Adds the current vector with the passed vector and returns a new vector.
		* ex: V3 = V1 + V2;
		* addition: [1, 2, 3] + [4, 5, 6, 7] = [5, 7, 9, 7]
		* @param v Vector on the right to perform addition with
		* @return new vector where index i is the result of this->buf[i] + v[i]
		*/

		const Vector & operator = (const Vector & v) {
			// std::cout << "= operator\n";
			delete[] this->buf;
			this->buf = new T[v.size()];
			this->sz = v.size();
			for (int i = 0; i < v.size(); ++i) {
				this->buf[i] = v[i];
			}
			return *this;
		}
		/*
		* Destructs the current vector and deep copies the passed vector
		* ex: V1 = V2;
		* V1 could be an already existing vector, be sure to clean it up before the deep copy
		* @param v Vector on the right to deep copy
		* @return reference to the current object
		*/

		bool operator == (const Vector & v) const {
			// std::cout << "== operator\n";
			if (this->size() != v.size()) {
				return false;
			}
			for (int i = 0; i < this->size(); ++i) {
				if (this->buf[i] != v[i]) {
					return false;
				}
			}
			return true;
		}
		/*
		* Determines whether the current vector is equivalent to the passed vector
		* ex: bool isV1AndV2Same = V1 == V2;
		* @param v Vector on the right to compare current with
		* @return true if both vectors are deeply equivalent (elem by elem comparison)
		* and false otherwise
		*/

		bool operator != (const Vector & v) const {
			// std::cout << "!= operator\n";
			if (this->size() != v.size()) {
				return true;
			}
			for (int i = 0; i < this->size(); ++i) {
				if (this->buf[i] != v[i]) {
					return true;
				}
			}
			return false;
		}
		/*
		* Determines whether the current vector is not equivalent to the passed vector
		* ex: bool isV1AndV2Different = V1 != V2;
		* @param v Vector on the right to compare current with
		* @return false if both vectors are deeply equivalent (elem by elem comparison)
		* and true otherwise
		*/

		inline friend Vector operator * (const int scale, const Vector & v) {
			// std::cout << "scalar * operator\n";
			Vector<T> temp(v.size());
			for (int i = 0; i < v.size(); ++i) {
				temp[i] = scale * v[i];
			}
			return temp;
		}
		/*
		* Multiplies each element in current vector with the passed integer and returns a new vector.
		* ex: V1 = 20 * V2; it is important that 20 is on the left!
		* 20 * [1, 2, 3] = [20, 40, 60]
		* @param scale integer to multiple each element of vector v
		* @param v Vector on the right to perform multiplication on
		* @return new vector where index i is the result of v[i] * scale
		*/

		inline friend Vector operator + (const int adder, const Vector & v) {
			// std::cout << "scalar + operator\n";
			Vector<T> temp(v.size());
			for (int i = 0; i < v.size(); ++i) {
				temp[i] = adder + v[i];
			}
			return temp;
		}
		/*
		* Adds each element in the current vector with the passed integer and returns a new vector.
		* ex: V1 = 20 + V2; it is important that 20 is on the left!
		* 20 + [1, 2, 3] = [21, 22, 23]
		* @param adder integer to add to each element of vector v
		* @param v Vector on the right to perform addition on
		* @return new vector where index i is the result of v[i] + adder
		*/

		inline friend ostream& operator << (ostream & o, const Vector & v) {
			// std::cout << "<< operator\n";
			o << "(";
			for (int i = 0; i < v.size(); ++i) {
				o << v[i];
				if (i < v.size()-1) {
					o << ", ";
				} else {
					o << ")";
				}
			}
			return o;
		}
		/*
		* Allows the << operator to correctly print out the vector.
		* ex: cout << V2; -> (v[0], v[1], v[2], ... v[sz-1])
		* @param o ostream to print the elems of the array, usage is o << thingToPrint;
		* @param v vector that will be printed out
		* @return the ostream passed in
		*/
};

#endif