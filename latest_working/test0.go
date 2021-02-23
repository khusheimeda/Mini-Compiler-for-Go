package main;
import "fmt";
import "math";

const s string = "constant";

func boo(){;};

type point struct {
    y,x int "hey";
};

 	

type person struct {
    name string;
    age  int;
};

func (r *rect) area() int {
    return r.width * r.height;
};

func main( ) {
    Println(s);
    foo();
    a := foo(b,c);
    const n int ;
    var fgh int;
    const d int = 320 + 3 + 4 * 3 - a*5/3 ;
    fmt.Println(d);
    fmt.Println(x[5][3]);
    var x [5] int := getvall("f",c[3]);
    fmt.Println(math.Sin(n));
    fmt.Println("emp:", a);
    var a [5]int;
    
    for i = 0; i < 2; i++ {
		for j = 0; j < 3; j++ {
			if(a<0){
				twoD[i][j] = i + j;
			}else if(a==0){
				;
			}else{boo();};	
		};
	};
	a[4] = 100;
	//var b   [5] int = {1, 2, 3, 4, 5};	
	var twoD [2][3]int;
	var ptr int ;	
	return 5.4+ 4;
	continue;
	break;
	x++;
	//x+ 6;
	//fmt.Println(person{name:"Bob",age:20});
	person.name = "hey";
	fmt.Println("area: ", r.area());
	b = person{name:"Bob",age:20};
	b.name = "kf";
	fmt.Println(person{name:"Bob",age:20},a);
	
	
}
