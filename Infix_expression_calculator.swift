import Foundation
import Glibc

print("Press 1 For Infix expression")
print("Press 2 For Post expression")

let read1 = readLine()
let input1 = Int(read1!)

if input1 == 1 {
    print("Enter the infix expression")
    let read2 = readLine()
    evaluate(tokens:(read2!))
    
}
else{
	print("Enter the post expression")  
}


//Infix evaluation

 
func Precedence (op: Character)-> Int{
    if op == "+" || op == "-"{
        return 1
    }
    if op == "*" || op == "/"{
        return 2
    }
    
    return 0
        
}

func applyOp(a: Int, b: Int, op:Character)-> Int{
    if op == "+" {
        return a+b
    }
            
    if op == "-" {
        return a-b
    }
            
    if op == "*" {
        return a*b
    }
            
    if op == "/" {
        return a/b
    }
    
    return 0
}        
        
        
func evaluate (tokens: String) -> Void {
    
    var values = [Int]()
    var ops = [Character]()
    
    for i in tokens {
        if i == " " {
            continue
        }
        else if i == "(" {
            ops.append(i)
        }
        else if i.isWholeNumber{
            if let add = Int(String(i)) {
                values.append(add)
            }
        }
        else if i==")" {
            while ops.last != "(" {
                let operators: Character = ops.removeLast()
                let v2: Int = values.removeLast()
                let v1: Int = values.removeLast()
                let opv: Int = applyOp(a: v1, b: v2, op: operators)
                values.append(opv)
            }
            ops.removeLast()
        }
        else if i == "+" || i == "-" || i  == "*" || i  == "/" {
                while ops.count > 0 && (ops.last!) != "(" && Precedence(op: i) <= Precedence(op: ops.last!){
                    let operators: Character = ops.removeLast()
                    let v2: Int = values.removeLast()
                    let v1: Int = values.removeLast()
                    let opv: Int = applyOp(a: v1, b: v2, op: operators)
                    values.append(opv)
                }
            ops.append(i)
        }
    }
    while ops.count != 0 {
        let operators: Character = ops.removeLast()
        let v2: Int = values.removeLast()
        let v1: Int = values.removeLast()
        let opv: Int = applyOp(a: v1, b: v2, op: operators)
        values.append(opv)
    }
    
    print(values.last!)
}    

   
        
        
        
        
        