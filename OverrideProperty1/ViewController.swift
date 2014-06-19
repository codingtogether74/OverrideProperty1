//
//  ViewController.swift
//  OverrideProperty1
//
//  Created by Tatiana Kornilova on 6/19/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

import UIKit

class Card{
    var contents: String
    var isChosen: Bool = false
    var isMatched:Bool = false
    
    init(contents:String) {
        self.contents = contents
    }
    
    func description() ->String
    {
        return self.contents;
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
    
    class func rankStrings() -> String[] {
        
        return  ["?", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
        
    }
    
    class func validSuits() -> String[] {
        return ["♥️", "♦️", "♠️", "♣️"]
    }
    
    class func maxRank() -> Int {
        
        return PlayingCard.rankStrings().count-1;
    }
    
    
}
class ViewController: UIViewController {
                            
    @IBOutlet var contentsLabel: UILabel
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var pcard2:PlayingCard = PlayingCard (suit: "♥️",rank: 8)
        var card2Befor = pcard2.contents
        pcard2.rank = 10
        contentsLabel.text = card2Befor + " " + pcard2.contents

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

