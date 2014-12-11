// Playground - noun: a place where people can play

import Foundation

//class representing card.

class Card{
    var contents: String
    var isChosen: Bool = false
    var isMatched:Bool = false
    
    init(contents:String) {
        self.contents = contents
    }
    
    func match(otherCards: [Card]) -> Int {
        var score = 0
        for card in otherCards {
            if self.contents == card.contents {
                score = 1
            }
        }
        return score
    }
}

// A class representing Playing card.
class PlayingCard: Card {
    
    var suit: String = "?" {
        didSet {
            if  !contains(PlayingCard.validSuits(), suit) {
                suit = "?"
            }
            //        super.contents = PlayingCard.rankStrings()[self.rank]+self.suit
        }
    }
    
    var rank: Int = 0 {
        didSet {
            if rank > PlayingCard.maxRank() || rank < 0 {
                rank = 0
            }
            //        super.contents = PlayingCard.rankStrings()[self.rank]+self.suit
        }
    }
    
    override var contents:String {
        get {
            return PlayingCard.rankStrings()[self.rank]+self.suit
        }
        set{
            super.contents = newValue
        }
    }
    
    init(suit s:String, rank r:Int) {
        self.rank = 0
        if r <=  PlayingCard.maxRank() && r >= 0 {
            self.rank = r
        }
        self.suit = "?"
        
        if  contains(PlayingCard.validSuits(), s) {
            self.suit = s
        }
        super.init(contents: PlayingCard.rankStrings()[self.rank]+self.suit)
        
    }
    
    class func rankStrings() -> [String] {
        
        return  ["?", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
        
    }
    
    class func validSuits() -> [String] {
        return ["♥️", "♦️", "♠️", "♣️"]
    }
    
    class func maxRank() -> Int {
        
        return PlayingCard.rankStrings().count-1;
    }
    
    
    override func match(otherCards: [Card]) -> Int {
        var score = 0
        var numMatches = 0
        
        if otherCards.count > 0
        {
            for var i = 0; i < otherCards.count; i++ {
                var card1:PlayingCard? = otherCards[i] as? PlayingCard
                if card1 != nil
                {
                    for var  j = i+1; j < otherCards.count; j++ {
                        var card2:PlayingCard? = otherCards[j] as? PlayingCard
                        if card2 != nil
                        {
                            // check for the same suit
                            if card1!.suit == card2!.suit {
                                score += 1;
                                numMatches++;
                            }
                            // check for the same rank
                            if card1!.rank == card2!.rank {
                                score += 4;
                                numMatches++;
                            }
                        }
                    }
                }
            }
            
            if numMatches < (otherCards.count - 1)
            {score = 0}
        }
        return score;
    }
}

var card1:Card = Card(contents: "One")
var card2:Card = Card(contents: "Two")
var pcard1:PlayingCard = PlayingCard (suit: "♠️",rank: 8)
var pcard2:PlayingCard = PlayingCard (suit: "♥️",rank: 8)
print (pcard2.contents)

pcard2.rank = 10
print (pcard2.contents)
pcard1.contents
pcard2.contents

infix operator |-  { associativity left precedence 150 }
func |-<T, U>(opt:T?, f: T -> U?) -> U? {
    switch opt {
    case .Some(let x):
        return f(x)
    case .None:
        return .None
    }
}


public class Demo {
    public let subDemo:SubDemo?
    init(subDemo sDemo:SubDemo? = nil) {
        self.subDemo = sDemo
    }
}

public class SubDemo {
    public let count:Int = 1
    public func two() ->Int {return 2}
}

let aDemo:Demo? = nil
let bDemo:Demo? = Demo()
let cDemo:Demo? = Demo(subDemo: SubDemo())

let aCount = aDemo |- { $0.subDemo } |- { $0.count } // {None}
let bCount = bDemo |- { $0.subDemo } |- { $0.count } // {None}
let cCount = cDemo |- { $0.subDemo } |- { $0.count } // {Some 1}
let dCount = cDemo |- { $0.subDemo } |- { $0.two() } // {Some 2}
println("\(aCount) \(bCount) \(cCount) \(dCount)")

extension Optional {
    func flatMap<Z>(f:T->Z?) -> Z? {
        switch self {
        case .Some(let a):
            return f(a)
        case .None:
            return .None
        }
    }
}
let a:Int? = 9 // some optional

if let a = a {
    println("\(a)")
}

a.flatMap { println("\($0)") }
//
// Version 1 of pagesFromData from Flat All The Things
// http://robnapier.net/flat-all-the-things
//

import Foundation

func pagesFromData(data: NSData) -> Result<[Page]> {
    return asJSON(data)
        .flatMap(asJSONArray)
        .flatMap({indexElement($0)(index: 1)})  //.flatMap(secondElement)
        .flatMap(asStringList)
        .flatMap(asPages)
}

func asJSON(data: NSData) -> Result<JSON> {
    var error: NSError?
    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
    
    switch (json, error) {
    case (_, .Some(let error)): return .Failure(error)
        
    case (.Some(let json), _): return .Success(Box(json))
        
    default:
        fatalError("Received neither JSON nor an error")
        return .Failure(NSError())
    }
}

func asJSONArray(json: JSON) -> Result<JSONArray> {
    if let array = json as? JSONArray {
        return .Success(Box(array))
    } else {
        return .Failure(NSError(localizedDescription: "Expected array. Got: \(json)"))
    }
}

func secondElement(array: JSONArray) -> Result<JSON> {
    if array.count < 2 {
        return .Failure(NSError(localizedDescription:"Could not get second element. Array too short: \(array.count)"))
    }
    return .Success(Box(array[1]))
}

func indexElement(array: JSONArray)(index:Int) -> Result<JSON> {
    if array.count < index {
        return .Failure(NSError(localizedDescription:"Could not get second element. Array too short: \(array.count)"))
    }
    return .Success(Box(array[index]))
    
}


func asStringList(array: JSON) -> Result<[String]> {
    if let string = array as? [String] {
        return .Success(Box(string))
    } else {
        return .Failure(NSError(localizedDescription: "Unexpected string list: \(array)"))
    }
}

func asPages(titles: [String]) -> Result<[Page]> {
    return .Success(Box(titles.map { Page(title: $0) }))
}

enum Result<A> {
    case Success(Box<A>)
    case Failure(NSError)
    
    func flatMap<B>(f:A -> Result<B>) -> Result<B> {
        switch self {
        case Success(let value): return f(value.unbox)
        case Failure(let error): return .Failure(error)
        }
    }
}
final class Box<T> {
    let unbox: T
    init(_ value: T) { self.unbox = value }
}

extension Result: Printable {
    var description: String {
        switch self {
        case .Success(let box):
            return "Success: \(box.unbox)"
        case .Failure(let error):
            return "Failure: \(error.localizedDescription)"
        }
    }
}

struct Page {
    let title: String
}

extension Page: Printable {
    var description: String {
        return title
    }
}

typealias JSON = AnyObject
typealias JSONArray = [JSON]

extension NSError {
    convenience init(localizedDescription: String) {
        self.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

func asJSONData(string: NSString) -> NSData {
    return string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
}
//========

let goodPagesJson = asJSONData("[\"a\",[\"Animal\",\"Association football\",\"Arthropod\",\"Australia\",\"AllMusic\",\"African American (U.S. Census)\",\"Album\",\"Angiosperms\",\"Actor\",\"American football\",\"Austria\",\"Argentina\",\"American Civil War\",\"Administrative divisions of Iran\",\"Alternative rock\"]]")

let pages = pagesFromData(goodPagesJson).description



let corruptJson = asJSONData("a\",[\"Animal\",\"Association football\",\"Arthropod\",\"Australia\",\"AllMusic\",\"African American (U.S. Census)\",\"Album\",\"Angiosperms\",\"Actor\",\"American football\",\"Austria\",\"Argentina\",\"American Civil War\",\"Administrative divisions of Iran\",\"Alternative rock\"]]")

pagesFromData(corruptJson).description

//==============================
//Хранилище для closures
// https://devforums.apple.com/message/1036183#1036183
//ClosureMap below acts like a dictionary where the keys are classes
//and the values are closures that take instances of the keys as parameters. 
//The trick was to cast a box class, ClosureHolder<T>, instead the closures themselves.

private struct ClosureHolder<T> {
    let closure: T -> Void
    init(_ closure: T -> Void) {
        self.closure = closure
    }
}

public struct ClosureMap {
    private var storage: [ObjectIdentifier:Any] = [:]
    
    public mutating func put<T: AnyObject>(type: T.Type, value: (T -> Void)?) {
        put(value)
    }
    
    public mutating func put<T: AnyObject>(value: (T -> Void)?) {
        if let value = value {
            storage[ObjectIdentifier(T)] = ClosureHolder(value)
        } else {
            storage[ObjectIdentifier(T)] = nil
        }
    }
    
    public func get<T: AnyObject>(i: T.Type) -> (T -> Void)? {
        return get()
    }
    
    public func get<T: AnyObject>() -> (T -> Void)? {
        return (storage[ObjectIdentifier(T)] as? ClosureHolder<T>)?.closure
    }
}

func closureTest() {
    var closures = ClosureMap()
    
    class Email {
        var Subject:String = "email subject"
    }
    class SMS {
        var Message:String = "sms message"
    }
    
    closures.put(Email.self, {item in println("\(item.Subject)")})
    closures.put(SMS.self, {item in println("\(item.Message)")})
    
    closures.get(Email.self)?(Email())  // "email subject"
    closures.get(SMS.self)?(SMS())      // "sms message"
    
    closures.get()?(Email())    // "email subject"
    closures.get()?(SMS())      // "sms message
}
closureTest()
//====
struct Loan {
    let number: String
    let status: String
}
let loan1 = Loan (number: "123ABC", status: "open")
let loan2 = Loan (number: "456DEF", status: "closed")
let loan3 = Loan (number: "123XYZ", status: "open")
let loan4 = Loan (number: "483DDD", status: "closed")

let loans = [loan1, loan2, loan3, loan4]
let results = loans.filter({loan in loan.number.hasPrefix("123") && loan.status == "open"}).count
println("\(results)")

let r = 1..<6
contains (r,3)

let integer_interval: ClosedInterval = 1...5
integer_interval.contains(3)

extension Int {
    func times(block: () -> Void) {
        for _ in 0 ..< self { block() }
    }
}

10.times {
    println("Hello")
    return
}
//======
enum Suit {
    case Clubs, Diamonds, Hearts, Spades
}

enum Rank {
    case Jack, Queen, King, Ace
    case Num(Int)
}

struct Card1 {
    let suit: Suit
    let rank: Rank
}


/*
- Generate an array of tuples of 2 card subsequences by zipping the hand array with itself (minus the first element)
- Map over the array examining each pair for value-contributing combinations in a switch statement
- Sum all resulting values
*/
func countHand(hand: [Card1]) -> Int {
    return Array(Zip2(hand, dropFirst(hand))).map{(card1: Card1, card2: Card1)->Int in
        switch (card1.suit, card1.rank, card2.rank) {
        case (.Hearts, _, .Num(let numRank)) where numRank % 2 == 1:
            return 2 * numRank
        case (.Diamonds, .Num(5), .Ace):
            return 100
        default:
            return 0
        }}.reduce(0, +)
}


countHand([
    Card1(suit:.Hearts, rank:.Num(10)),
    Card1(suit:.Hearts, rank:.Num(6)),
    Card1(suit:.Diamonds, rank:.Num(5)),
    Card1(suit:.Clubs, rank:.Ace),
    Card1(suit:.Diamonds, rank:.Jack)
    ])
//-------------

extension String {
    func toEnum<Enum: RawRepresentable where Enum.RawValue == String>() -> Enum? {
        return Enum(rawValue: self)
    }
}

enum Segue: String {
    case Foo = "Foo"
    case Bar = "Bar"
}

let x: String? = "Foo"

let y: Segue? = x?.toEnum()

let ww = stride(from: 1, through: 10, by: 5)

for i in lazy(0...5).reverse() {
    println(i)// 5, 4, 3, 2, 1, 0
}
let vv = Range(start: 5, end: 1)

func helloWithNames(names: String...) {
    for name in names {
        println("Hello, \(name)")
    }
}

// 2 names
helloWithNames("Mr. Robot", "Mr. Potato")

func findRangeFromNumbers(numbers: Int...) -> (min: Int, max: Int) {
    
    var min = numbers[0]
    var max = numbers[0]
    
    for number in numbers {
        if number > max {
            max = number
        }
        
        if number < min {
            min = number
        }
    }
    
    return (min, max)
}

let range = findRangeFromNumbers(1, 234, 555, 345, 423)
println("From numbers: 1, 234, 555, 345, 423. The min is \(range.min). The max is \(range.max).")
// From numbers: 1, 234, 555, 345, 423. The min is 1. The max is 555.

let (min, max) = findRangeFromNumbers(236, 8, 38, 937, 328)
println("From numbers: 236, 8, 38, 937, 328. The min is \(min). The max is \(max)")
// From numbers: 236, 8, 38, 937, 328. The min is 8. The max is 937

func add (a1:Int, a2:Int) ->Int {return (a1 + a2)}
func multiply (a1:Int, a2:Int) ->Int {return (a1 * a2)}

func funcReturnFunc (funcOperation: (Int,Int) -> Int) -> (Int, Int) ->Int {
   
    return  funcOperation
}

func funcReturnFunc2 (funcOperation: (Int,Int) -> Int) -> (Int, Int) ->Int {
    return funcReturnFunc(funcOperation)
}

let returnedFunction = funcReturnFunc2 (multiply)
let returnedFunction1 = funcReturnFunc2 (add)


returnedFunction(5,6)
returnedFunction1(5,6)

func chained (i:Int) -> Int-> Int -> Int {
    return { j in
        return { k in
            return i + j + k;
        }
    }
}
chained(5)(6)(7)

func add1 (a:Int) -> Int-> Int {
    return {b in
        return a + b
    }
}

add1(3)(4)

let add3 = add1(3)
add3(4)
//======
// Использовались материалы http://habrahabr.ru/post/241303/#first_unread

func performOperation(op1: Double, op2: Double, operation: (Double, Double) -> Double) -> Double {
    return operation(op1, op2)
}


let operationDictionary: Dictionary<String, (Double, Double) -> Double > = [ "+": {$0 + $1} , "x": {$0 * $1}, "-": {$0 - $1}]
var symbolOperation:String = "-"

if let operation = operationDictionary[symbolOperation] {
    performOperation(3.0, 2.0, operation)}
