#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <iostream>
using namespace std;


typedef double (*double_method_type) (void *);
typedef void (*void_method_type) (void *);

typedef union {
	double_method_type double_method;
	void_method_type void_method;
} VirtualTableEntry;

typedef VirtualTableEntry * VTableType;

#define AREA_INDEX 0
#define PRINT_INDEX 1
#define DRAW_INDEX 2

#define PI 3.14159


struct Shape {
	VTableType VPointer;
	std::string name;
};

// double Shape_area (Shape * _this) {
// 	return 0.0;
// }

// void Shape_print (Shape * _this) {

// }

// void Shape_draw (Shape * _this) {
	
// }

// VirtualTableEntry Shape_VTable [] = {
// 	{.double_method = (double_method_type)Shape_area},
// 	{.void_method = (void_method_type)Shape_print},
// 	{.void_method = (void_method_type)Shape_draw}
// }

Shape * Shape_Shape (Shape * _this, std::string nam) {
	// _this->Vpointer = Shape_VTable;
	_this->name = nam;
	return _this;
}


struct Circle {
	VTableType VPointer;
	std::string name;
	double radius;
};

double Circle_area(Circle * _this) {
	return PI * _this->radius * _this->radius;
}

void Circle_print (Circle * _this) {
	std::cout << _this->name << "(" << _this->radius << ") : " << (_this->VPointer[AREA_INDEX]).double_method(_this) << std::endl;
}

void Circle_draw (Circle * _this) {
	std::cout <<
		"  ***  \n" <<
		" *   * \n" <<
		"*     *\n" <<
		"*     *\n" <<
		"*     *\n" <<
		" *   * \n" <<
		"  ***  \n";
}

VirtualTableEntry Circle_VTable [] = {
	{.double_method = (double_method_type)Circle_area},
	{.void_method = (void_method_type)Circle_print},
	{.void_method = (void_method_type)Circle_draw}
};

Circle * Circle_Circle (Circle * _this, std::string nam, double rad) {
	Shape_Shape((Shape *)_this, nam);
	_this->VPointer = Circle_VTable;
	_this->radius = rad;
	return _this;
}


struct Square {
	VTableType VPointer;
	std::string name;
	int base;
	int height;
};

double Square_area(Square * _this) {
	return 1.0 * _this->base * _this->height;
}

void Square_print (Square * _this) {
	std::cout << _this->name << "(" << _this->base << ") : " << (_this->VPointer[AREA_INDEX]).double_method(_this) << std::endl;
}

void Square_draw (Square * _this) {
	std::cout <<
		"*****\n" <<
		"*   *\n" <<
		"*   *\n" <<
		"*****\n";
}

VirtualTableEntry Square_VTable [] = {
	{.double_method = (double_method_type)Square_area},
	{.void_method = (void_method_type)Square_print},
	{.void_method = (void_method_type)Square_draw}
};

Square * Square_Square (Square * _this, std::string nam, int bas) {
	Shape_Shape((Shape *)_this, nam);
	_this->VPointer = Square_VTable;
	_this->base = bas;
	_this->height = bas;
	return _this;
}


struct Rectangle {
	VTableType VPointer;
	std::string name;
	int base;
	int height;
};

void Rectangle_print (Rectangle * _this) {
	std::cout << _this->name << "(" << _this->base << ", " << _this->height << ") : " << (_this->VPointer[AREA_INDEX]).double_method(_this) << std::endl;
}

void Rectangle_draw (Rectangle * _this) {
	std::cout <<
		"*******\n" <<
		"*     *\n" <<
		"*******\n";
}

VirtualTableEntry Rectangle_VTable [] = {
	{.double_method = (double_method_type)Square_area},
	{.void_method = (void_method_type)Rectangle_print},
	{.void_method = (void_method_type)Rectangle_draw}
};

Rectangle * Rectangle_Rectangle (Rectangle * _this, std::string nam, int bas, int hei) {
	Square_Square((Square *)_this, nam, bas);
	_this->VPointer = Rectangle_VTable;
	_this->height = hei;
	return _this;
}


struct Triangle {
	VTableType VPointer;
	std::string name;
	int base;
	int height;
};

double Triangle_area(Triangle * _this) {
	return 0.5 * _this->base * _this->height;
}

void Triangle_print (Triangle * _this) {
	std::cout << _this->name << "(" << _this->base << ", " << _this->height << ") : " << (_this->VPointer[AREA_INDEX]).double_method(_this) << std::endl;
}

void Triangle_draw (Triangle * _this) {
	std::cout <<
		"   *   \n" <<
		"  * *  \n" <<
		" *   * \n" <<
		"*******\n";
}

VirtualTableEntry Triangle_VTable [] = {
	{.double_method = (double_method_type)Triangle_area},
	{.void_method = (void_method_type)Triangle_print},
	{.void_method = (void_method_type)Triangle_draw}
};

Triangle * Triangle_Triangle (Triangle * _this, std::string nam, int bas, int hei) {
	Shape_Shape((Shape *)_this, nam);
	_this->VPointer = Triangle_VTable;
	_this->base = bas;
	_this->height = hei;
	return _this;
}


void printAll (Shape * shapes [], int size) {
	for (int i = 0; i < size; i++) {
		(shapes[i]->VPointer[PRINT_INDEX]).double_method(shapes[i]);
	}
}

void drawAll (Shape * shapes [], int size) {
	for (int i = 0; i < size; i++) {
		(shapes[i]->VPointer[DRAW_INDEX]).double_method(shapes[i]);
	}
}

double totalArea (Shape * shapes [], int size) {
	double sum = 0;
	for (int i = 0; i < size; i++) {
		sum += (shapes[i]->VPointer[AREA_INDEX]).double_method(shapes[i]);
	}
	return sum;
}


int main(int argc, char *argv[]) {
	int x, y, z;
	if (argc == 3) {
		x = atoi(argv[1]);
		y = atoi(argv[2]);
		z = 8;
	} else {
		std::cout << "Not enough arguments\n";
		return 0;
	}
	Shape * shapes [] = {
		(Shape *)Triangle_Triangle((Triangle *)malloc(sizeof(Triangle)), "FirstTriangle", x, y),
		(Shape *)Triangle_Triangle((Triangle *)malloc(sizeof(Triangle)), "SecondTriangle", x-1, y-1),
		(Shape *)Circle_Circle((Circle *)malloc(sizeof(Circle)), "FirstCircle", x),
		(Shape *)Circle_Circle((Circle *)malloc(sizeof(Circle)), "SecondCircle", x-1),
		(Shape *)Square_Square((Square *)malloc(sizeof(Square)), "FirstSquare", x),
		(Shape *)Square_Square((Square *)malloc(sizeof(Square)), "SecondSquare", x-1),
		(Shape *)Rectangle_Rectangle((Rectangle *)malloc(sizeof(Rectangle)), "FirstRectangle", x, y),
		(Shape *)Rectangle_Rectangle((Rectangle *)malloc(sizeof(Rectangle)), "SecondRectangle", x-1, y-1)
	};
    std::cout << "Total: " << totalArea(shapes, z) << std::endl;
	printAll(shapes, z);
	drawAll(shapes, z);
    return 0;
}

