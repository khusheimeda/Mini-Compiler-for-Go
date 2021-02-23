package main;
import "fmt";

type T struct {
    a byte;
    b  int;
    c byte;
    d float32;
    name[10] byte;
    f byte;
};

func f(T x) void {
  x.a = 'a';
  x.b = 47114711;
  x.c = 'c';
  x.d = 1234;
  x.e = 3.141592897932;
  x.f = '*';
  x.name = "abc\"";
};

func main(){
  var k T;
  f(k);
}
