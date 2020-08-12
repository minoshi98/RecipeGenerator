//
//  recipeDictionary.swift
//  classProject
//
//  Created by Minoshi K on 11/1/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import Foundation
class recipeDictionary {
    

var recipes:[recipeRecord?] = []





init () {}


func getCount(_ recipe: recipeRecord) -> Int
    
{
    
}


func severityScore(_ game:symptomRecord) -> Int {
    var countSevere:Int = 0
    if game.headache! >= 5 {
        countSevere += game.headache!
    }
    if game.balance_problem! >= 5{
        countSevere += game.headache!
    }
    if game.blurred_vision! >= 5 {
        countSevere += game.headache!
    }
    if game.dizziness! >= 5 {
        countSevere += game.headache!
    }
    if game.nausea_vomiting! >= 5 {
        countSevere += game.headache!
    }
    if game.neck_pain! >= 5 {
        countSevere += game.headache!
    }
    if game.pressure_in_head! >= 5 {
        countSevere += game.headache!
    }
    if game.sensitivity_light! >= 5 {
        countSevere += game.headache!
    }
    if game.sensitivity_noise! >= 5 {
        countSevere += game.headache!
    }
    if game.slowed_down! >= 5 {
        countSevere += game.headache!
    }
    
    
    return countSevere
}



func getSymptomDifference(_ first_game:symptomRecord, _ second_game:symptomRecord) -> String {
    var message:String = ""
    
    if ( getCount(second_game) - getCount(first_game) < 3 ) && ( severityScore(second_game) < 10 ) {
        
        message = "No difference"
        
    }
        
    else if ( getCount(second_game) - getCount(first_game) < 3 ) && ( severityScore(second_game) >= 10 ) {
        
        message = "Unsure"
        
    }
        
    else if ( getCount(second_game) - getCount(first_game) >= 3 ) || ( severityScore(second_game) >= 15 ) {
        
        message = "Very Different"
        
    }
    
    
    
    
    return message
}

}
