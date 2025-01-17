//
//  AskQuestion.swift
//  Hoot
//
//  Created by Zack Cuomo on 1/15/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.

import Foundation

class ClassAskQuestion: NSObject {
    
    var userTopic: String?
    var userText: String?
    var answerCount: Int?
    var hasPic: Bool?
//    let alert = UIAlertController()
    
    init(topic: String, text: String){
        self.userTopic = topic
        self.userText = text
        self.answerCount = 0
        self.hasPic = false
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userTopic!.isEmpty && !userText!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func topicSufficientLength() -> Bool{
        if userTopic!.characters.count < 4{
            return false
        }else{
            return true
        }
    }
    
    func questionSufficientLenght() -> Bool{
        if userText!.characters.count > 200{
            return false
        }else{
            return true
        }
    }

    
    func classAskQuestionAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard topicSufficientLength() else{
            throw Error.InsufficientTopicLength
        }
        guard questionSufficientLenght() else{
            throw Error.InsufficientQuestionLength
        }
    }
}