package main;
import "fmt";

func plus(a1 int, b1 int) int {
    return a1 + b1;
    
};

func plusPlus(a2 int, b2 int, c2 int) int {
	var temp int := plus(a2,b2);
    	return temp + c2;
};

func foo(a3 int,b3 int,c3 int){
	var bar1,bar2,bar3,bar int;
	bar1 := plus(a3,b3);
	bar2 := plus(b3,c3);
	bar3 := plus(c3,a3);
	bar := plusPlus(bar1,bar2,bar3);
	return bar;
};


func foo2(a4 int,b4 int,c4 int){
	var bar11,bar21,bar31,bar_n int;
	bar11 = a4*2;
	bar21 = b4*5;
	bar31 = c4*10;
	bar_n := plusPlus(bar11,bar21,bar31);
	return bar_n;
};
//new
func new_1(a_1 int,b_1 int) int{
	var temp_f int;
	temp_f := foo2(a_1,b_1,10);
	return 2*a_1 + 3*b_1 + temp_f;
};

func main() {

    var res int := plus(1, 2);
    fmt.Println("1 + 2 = ",res,"\n");
    res := plusPlus(1, 2, 3);
    fmt.Println("1 + 2 + 3 = ",res,"\n");
    res := foo(1, 2, 3);
    fmt.Println("foo = ",res,"\n");
    res := foo2(1, 2, 3);
    fmt.Println("foo2 = ",res,"\n");
    var z1,z2,z3 int;
    fmt.Scanln(z1,z2,z3);
    res := plusPlus(z1, z2, z3);
    fmt.Println(z1," + ",z2," + ",z3," = ",res,"\n");
    //new
    res := new_1(3, 4);
    fmt.Println("res = ",res,"\n");
}
