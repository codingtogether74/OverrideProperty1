// Playground - noun: a place where people can play

import Foundation
import UIKit

//~~~~~~~~~~~~~~~~ Error handling with enum Result<A> ~~~~~~~

enum Result<A> {
    case Error(NSError)
    case Value(Box<A>)
    
    init(_ error: NSError?, _ value: A) {
        if let err = error {
            self = .Error(err)
        } else {
            self = .Value(Box(value))
        }
    }
}

final class Box<A> {
    let value: A
    
    init(_ value: A) {
        self.value = value
    }
}
//--------------- for Result <A> ---

func stringResult<A:Printable>(result: Result<A> ) -> String {
    switch result {
    case let .Error(err):
        return "\(err.localizedDescription)"
    case let .Value(box):
        return "\(box.value.description)"
    }
}

//-------- convenience initializer for  NSError class -----

extension NSError {
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}
//-------------------------------------
class MyFunClass {
    
    func doSomething(activity: String, callback:(Result <[String]>) -> () )
    {
        var stringArray:[String] = ["White"]
        var err: NSError?
        
        switch activity {
             case "Red": stringArray.append("Red")
             case "Green":stringArray.append("Green")
        default: err = NSError(localizedDescription: "Wrong Color")
            
        }
        return callback(Result (err,stringArray))
    }
}
//--------------  Test  1 ------------------

let myFunClass = MyFunClass()

myFunClass.doSomething("Red"){ strings in
    println(stringResult(strings))
    return // Playground issue one line closure
}
//--------------  Test  2 ------------------

myFunClass.doSomething("Blue"){ strings in
    println(stringResult(strings))
    return // Playground issue one line closure
}

