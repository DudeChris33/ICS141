class Shape {
	String name;

	Shape(String name) {
		this.name = name;
	}

	void print() {
		
	}

	void draw() {
	}

	double area() {
		return 0.0;
	}
}

class Circle extends Shape {
	double radius;
	static double pi = 3.14;
	// static double pi = Math.PI;

	Circle(String name, int radius) {
		super(name);
		this.radius = 1.0*radius;
	}

	void print() {
		System.out.println(name + "(" + radius + ") : " + area());
	}

	void draw() {
		System.out.println(
			"  ***  \n" +
			" *   * \n" +
			"*     *\n" +
			"*     *\n" +
			"*     *\n" +
			" *   * \n" +
			"  ***  "
		);
	}

	double area() {
		return pi*radius*radius;
	}
}

class Square extends Shape {
	int base;
	int height;

	Square (String name, int base) {
		super(name);
		this.base = base;
		this.height = base;
	}

	void print() {
		// double areaDouble = area();
		// if (areaDouble % 1 == 0) {
		// 	int areaInt = (int) areaDouble;
		// 	System.out.println(name + "(" + base + ", " + height + ") : " + areaInt);
		// } else {
		// 	System.out.println(name + "(" + base + ", " + height + ") : " + areaDouble);
		// }
		// System.out.println(String.format("%s (%d, %d) : %32.2f", name, base, height, area()));
			// name + "(" + base + ", " + height + ") : " + area()));
		System.out.println(name + "(" + base + ", " + height + ") : " + area());
	}

	void draw() {
		System.out.println(
			"*****\n" +
			"*   *\n" +
			"*   *\n" +
			"*****"
		);
	}

	double area() {
		return 1.0*base*height;
	}
}

class Rectangle extends Square {
	Rectangle(String name, int base, int height) {
		super(name, base);
		this.height = height;
	}

	// void print() {
	// 	System.out.println(name + "(" + base + ", " + height + ") : " + area());
	// }

	void draw() {
		System.out.println(
			"*******\n" +
			"*     *\n" +
			"*******"
		);
	}

	// double area() {
	// 	return 1.0*base*height;
	// }
}

class Triangle extends Shape {
	int base;
	int height;

	Triangle(String name, int base, int height) {
		super(name);
		this.base = base;
		this.height = height;
	}

	void print() {
		System.out.println(name + "(" + base + ", " + height + ") : " + area());
	}

	void draw() {
		System.out.println(
			"   *   \n" +
			"  * *  \n" +
			" *   * \n" +
			"*******"
		);
	}

	double area() {
		return 1.0*base*height*0.5;
	}
}

class ListNode {
	ListNode next;
	Shape shape;

	ListNode(Shape shape) {
		this.shape = shape;
	}
}

class Picture {
	ListNode head;

	Picture() {
		head = null;
	}

	void add(Shape shape) {
		if (head != null) {
			ListNode temp = new ListNode(shape);
			temp.next = head;
			head = temp;
		} else {
			head = new ListNode(shape);
		}
	}

	void printAll() {
		ListNode temp = head;
		// while (temp.next != null) {
		// 	temp.shape.print();
		// 	temp = temp.next;
		// }
		for (int i = 0; i < 10000; ++i) {
			temp.shape.print();
			if (temp.next != null) {
				temp = temp.next;
			} else {
				break;
			}
		}
	}

	void drawAll() {
		ListNode temp = head;
		for (int i = 0; i < 10000; ++i) {
			temp.shape.draw();
			if (temp.next != null) {
				temp = temp.next;
			} else {
				break;
			}
		}
	}

	double totalArea() {
		double sum = 0;
		ListNode temp = head;
		for (int i = 0; i < 10000; ++i) {
			sum += temp.shape.area();
			if (temp.next != null) {
				temp = temp.next;
			} else {
				break;
			}
		}
		return sum;
	}
}

public class mainClass {
	public static void main(String[] args) {
		// A main() method, which creates a Picture object, fills it with different Shapes,
		// prints the Shapes, and prints the total area of all the Shapes in the Picture
		Picture p = new Picture();
		p.add(new Triangle("FirstTriangle", Integer.decode(args[0]), Integer.decode(args[1])));
		p.add(new Triangle("SecondTriangle", Integer.decode(args[0])-1, Integer.decode(args[1])-1));
		p.add(new Circle("FirstCircle", Integer.decode(args[0])));
		p.add(new Circle("SecondCircle", Integer.decode(args[0])-1));
		p.add(new Square("FirstSquare", Integer.decode(args[0])));
		p.add(new Square("SecondSquare", Integer.decode(args[0])-1));
		p.add(new Rectangle("FirstRectangle", Integer.decode(args[0]), Integer.decode(args[1])));
		p.add(new Rectangle("SecondRectangle", Integer.decode(args[0])-1, Integer.decode(args[1])-1));
		p.printAll();
		p.drawAll();
		System.out.println("Total : " + p.totalArea());
	}
}