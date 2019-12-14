//
//  PracticeViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 14/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
import FirebaseDatabase

@available(iOS 11.0, *)
class PracticeViewController: UIViewController {

    let quote = "your technology your your your your hello recording your subtitle while recording your."
    
    let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    var language = String()
    var finalString = [String]()

    var wordCount = [[String: Int]]()
    
    var wordCounter = 0
    var vocabularyCount = 0
    var ref : DatabaseReference!
    @IBOutlet weak var final: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.tokenizeText(for: quote)
        self.lemmatization(for: quote)
        self.partsOfSpeech(for: quote)
        
        
        for subString in finalString {
            let temp = repetitionOfWordCheck(for: subString)
            wordCount.append(temp)
            
        }
        for repetition in wordCount {
            for(_, value) in repetition {
//                print(key+" : \(value)")
                if value > 1 {
//                    print(key+": \(value) : counter = \(wordCounter)")
                    wordCounter = wordCounter + 1
                }
            }
        }
        
        print("Total Words: \(finalString.count) \nNumber of Vocabulary: \(vocabularyCount) \nNumber of Repetition of Words: \(wordCounter)\nRepetition of Words: \(wordCount)")
        
        
        
        ref = FirebaseInitialization.databaseReference()
    }
    
    
    @available(iOS 11.0, *)
    func tokenizeText(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            finalString.append(word)
        }
    }
    
    @available(iOS 11.0, *)
    func lemmatization(for text: String) {
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
//                print(lemma)
            }
        }
    }
    
    @available(iOS 11.0, *)
    func partsOfSpeech(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                if tag.rawValue == "Noun" || tag.rawValue == "Verb" || tag.rawValue == "Pronoun" || tag.rawValue == "Adverb" || tag.rawValue == "Adjective" {
//                    print("\(word): \(tag.rawValue)")
                    vocabularyCount = vocabularyCount + 1
                }
            }
        }
    }
    
    func repetitionOfWordCheck(for text:String) -> [String: Int] {
        var count = 0
        var temp = [String: Int]()
        quote.enumerateSubstrings(in: quote.startIndex..<quote.endIndex, options: .byWords) { (subString, subStringRange, enclosingRange, stop) in
            
            if case let s? = subString{
                if s.caseInsensitiveCompare(text) == .orderedSame{
                    count = count + 1
                    temp = [text : count]
                }
            }
        }
        return temp
    }
}

//let options = NSLinguisticTagger.Options.omitWhitespace.rawValue | NSLinguisticTagger.Options.joinNames.rawValue

//let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"), options: Int(options))
//let inputString = "This is a very long test for you to try"
//tagger.string = inputString
//
//let range = NSRange(location: 0, length: inputString.utf16.count)
//tagger.enumerateTags(in: range, scheme: .nameTypeOrLexicalClass, options: NSLinguisticTagger.Options(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
//    guard let range = Range(tokenRange, in: inputString) else { return }
//    let token = inputString[range]
//
//    if  tag?.rawValue == "Noun" ||
//        tag?.rawValue == "Verb" ||
//        tag?.rawValue == "Adverb" ||
//        tag?.rawValue == "Pronoun" ||
//        tag?.rawValue == "Adjective" {
//        finalString.append("\(token): \((tag?.rawValue)!)")
//    }
//    finalString.append("\(token): \((tag?.rawValue)!)")
//}
//for index in finalString {
//    if final.text == "" {
//        final.text = index
//    } else {
//        final.text = final.text! + "\n\(index)"
//    }
//}

