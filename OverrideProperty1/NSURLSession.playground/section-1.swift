// Playground - noun: a place where people can play
import Foundation
import XCPlayground

func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
    var session = NSURLSession.sharedSession()
    var task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
        if error != nil {
            callback(String(), error.localizedDescription)
        } else {
            var result = NSString(data: data, encoding:
                NSASCIIStringEncoding)!
            callback(result, nil)
        }
    }
    task.resume()
}
let url = NSURL(string: "http://www.stackoverflow.com")
let url1 = NSURL(string: "http://www.google.com")
var request = NSURLRequest(URL:url1!)

    httpGet(request){
        (data, error) -> Void in
        if error != nil {
            println(error)
        } else {
            println(data.debugDescription)
        }
    }
    XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)