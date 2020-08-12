//
//  foodDisplayViewController.swift
//  classProject
//
//  Created by Minoshi K on 11/3/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import UIKit

class foodDisplayViewController: UIViewController  {
    
   
    @IBOutlet weak var ingredientField: UITextField!
    
   
    
    
    var selectedIngredients:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ingredientButton(_ sender: Any) {
    
    
        selectedIngredients.append(ingredientField.text!)
        
    }
        
    
    
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
