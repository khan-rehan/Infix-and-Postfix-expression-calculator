import Foundation
import Glibc

print("Type 1 for Infix expression and Enter the expression")
print("Type 2 for Postfix expression and Enter the expression")

enum expressionError : Error {
    case inValidExpression
}

if let input = readLine() {
    if input == "1" {
        if let read_infix = readLine(){
            do{
                // Validating infix expression
                var counter: Int = 0
                for check in read_infix {
                    if check == "(" { counter += 1}
                    else if check == ")" { counter -= 1}
                }
                if counter == 0 {
                try evaluateInfix(tokens: read_infix)
                }
                else {
                    print("Invalid expression! Error occured because of an open paranthesis")
                }
            }
            catch expressionError.inValidExpression {
                debugPrint("Error occured because of an incorrect expression!")
            }
           
        }
    }
    else if input == "2" {
        if let read_postfix = readLine(){
            do{
                try evaluatePostfix(expression: read_postfix)
            }
            catch expressionError.inValidExpression {
                debugPrint("Error occured because of an incorrect expression!")
            }
        }
    }
    /* else {
        print("Incorrect input")
    }*/
}

extension StringProtocol {
    subscript(i: Int) -> Character {
            self[index(startIndex, offsetBy: i)]
    }
}

func isNumber(num: Character)-> Bool {
    if num >= "0" && num <= "9" {
        return true
    }
    return false
}

//Infix evaluation

func precedenceOp (op: Character)-> Int{
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
   
    if op == "^" {
        let power = Int(pow(Double(a), Double(b)))
        return power
    }
   
    return 0
}        
       
       
func evaluateInfix (tokens: String) throws -> Void {
   
    var values = [Int]()
    var ops = [Character]()
    var i: Int = 0
 
    while i < (tokens.count) {
        if tokens[i] >= "A" && tokens[i] <= "Z" || tokens[i] >= "a" && tokens[i] <= "z" || tokens[i] == "{" || tokens[i] == "}" || tokens[i] == "[" || tokens[i] == "]" || tokens[i] == "." {
            throw expressionError.inValidExpression
        }
        else if tokens[i] == " " {
            i += 1
            continue
        }
        else if tokens[i] == "(" {
            ops.append(tokens[i])
        }
        else if isNumber(num: tokens[i]) {
            var num: Int = 0
            while i < tokens.count && isNumber(num: tokens[i]) {
                num = num * 10 + tokens[i].wholeNumberValue!
                i += 1
            }
            i -= 1
            values.append(num)
        }
        else if tokens[i] == ")" {
            while ops.last != "(" {
                let operators: Character = ops.removeLast()
                let val2: Int = values.removeLast()
                let val1: Int = values.removeLast()
                let opv: Int = applyOp(a: val1, b: val2, op: operators)
                values.append(opv)
            }
            ops.removeLast()
        }
        else if  tokens[i] == "+" || tokens[i] == "-" || tokens[i]  == "*" || tokens[i]  == "/" {
                while ops.count > 0 && (ops.last!) != "(" && precedenceOp(op: tokens[i]) <= precedenceOp(op: ops.last!){
                    let operators: Character = ops.removeLast()
                    let val2: Int = values.removeLast()
                    let val1: Int = values.removeLast()
                    let opv: Int = applyOp(a: val1, b: val2, op: operators)
                    values.append(opv)
                }
            ops.append(tokens[i])
        }
       
        i += 1
    }
   
    while ops.count != 0 {
        let operators: Character = ops.removeLast()
        let val2: Int = values.removeLast()
        let val1: Int = values.removeLast()
        let opv: Int = applyOp(a: val1, b: val2, op: operators)
        values.append(opv)
    }
   
    if let printInfix = values.last{
        print("Result of Infix:",printInfix)
    }
    else{
        print("Error occured! Incorrect/No expression")
    }
   

}
//postfix evaluation
   
       
func evaluatePostfix(expression: String) throws -> Void{

    var operands = [Int]()
    var count: Int = 0
    var index: Int = 0
   
    while index < (expression.count) {
   
        if expression[index] >= "A" && expression[index] <= "Z" || expression[index] >= "a" && expression[index] <= "z" || expression[index] == "{" || expression[index] == "}" || expression[index] == "[" || expression[index] == "]" || expression[index] == "." || expression[index] == "(" || expression[index] == ")"{
            throw expressionError.inValidExpression
        }
       
        else if expression[index] == " " {
            index += 1
            continue
        }
       
        else if isNumber(num: expression[index]) {
            var temp: Int = 0
            while index < expression.count && isNumber(num: expression[index]) {
                temp = temp * 10 + expression[index].wholeNumberValue!
                index += 1
            }
            index -= 1
            operands.append(temp)
            count += 1
        }
       
        else{
            count -= 1
            var opr1: Int = 0
            let op2:Int = operands.last!
            operands.removeLast()
            if let op1 = operands.last{
                opr1 = op1
                operands.removeLast()
            }
            else{
                print("Please use spaces in the expression for differentiation")
            }
            let push_oprs = applyOp(a: opr1, b:op2, op:expression[index])
            operands.append(push_oprs)
        }
       
        index += 1
    }
   
    if count == 1 { // validating postfix expression
        print("Result of Postfix:", operands.last!)  
    }
    else {
        print("Invalid postfix expresion!")
    }
}
     
// 46+2/5*7+ --> sample postfix expression
