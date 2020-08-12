//
//  jsonData.swift
//  classProject
//
//  Created by Minoshi K on 11/25/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import Foundation




class jsonData {
    
    func getjsonData(urlasString:String) {
    
    var titleArray:[String] = []
    
   // let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
    
    
    
   
   
    var i:Int = 0
    //let urlAsString = "http://www.recipepuppy.com/api/?i="+cellIngredient+"&q="+cellname+"&p=2"
    
    let url = URL(string: urlasString)!
    let urlSession = URLSession.shared
    
    let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
    if (error != nil) {
    print(error!.localizedDescription)
    }
    var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
    
    
    let jsonObjects = jsonResult as? [String:Any]
    let recipeArray = jsonObjects!["results"] as? NSArray
    
    //make sure executed on main thread
    DispatchQueue.main.async {
    //want to add all recipe names into an array
    while i < recipeArray!.count {
    let thisResults = recipeArray![i] as? [String:Any]
    var title = thisResults!["title"] as! String
    print("\(title)")
    titleArray.append(title)
    
    i = i+1
    }
    
    //display the recipe names as a list
    var string: String?
    for element in titleArray {
    if string == nil {
        string = element
    }
    else {
        string = string! + "\n\n" + element
        detailviewController.recipeTextView.text = string
        }
    }
        
    print(string!)
    
    
    
    }
    
    })
    
    jsonQuery.resume()
    }
    
    
    
}

