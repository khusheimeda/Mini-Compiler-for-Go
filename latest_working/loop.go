package main;
import "fmt";

func main() {
	  var i,j,k,res int;
	  
	  res = 0;
	  for i=0 ;i<10; i++ {
		
		for j=0;j<10; j++ {
			
			for k=0;k<10; k++ {
				res= res+1;
			};	 
		}; 
        
		
    	 };
	
	fmt.Println("res =", res);
}

