//
//  DisplayViewController.swift
//  classProject
//
//  Created by Minoshi K on 11/2/19.
//  Copyright © 2019 Minoshi K. All rights reserved.
//

import UIKit
import CoreData

class DisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    
    var myrecipeList:recipes =  recipes() //create a recipes object
    var counter = 1

    @IBOutlet weak var ingredientField: UITextField!
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - Recipe
    struct Recipe: Decodable {
        let title: String
        let version: Double
        let href: String
        let results: [Result]
    }
    
    // MARK: - Result
    struct Result: Decodable {
        let title: String
        let href: String
        let ingredients, thumbnail: String
    }
    //get this date for the segue --------
    var cellname:String = ""
    var cellIngredient:String = ""
    //------------------------------------
    
    @IBOutlet var clear: UIButton!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    //this is the array to store recipe entities from the coredata
    var fetchResults = [Recipes]()
   
    
    
    override func viewDidLoad() {
       initCounter()
       
        super.viewDidLoad()
    // Do any additional setup after loading the view.
    }
    
    
    func fetchRecord() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
       
        var x = 0
        // Execute the fetch request, and cast the results to an array of recipe objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Recipes])!
        
        print("\(fetchResults)") //for debugging
       
        x = fetchResults.count
        
      
        
        // return howmany entities in the coreData
        return x
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return myrecipeList.recipeArray.count
        return fetchRecord()
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! recipeTableViewCell
        cell.layer.borderWidth = 1.0
     
        cell.textLabel?.text = fetchResults[indexPath.row].recipeName
        cell.detailTextLabel?.text = fetchResults[indexPath.row].ingredient
        if let picture = fetchResults[indexPath.row].image {
            cell.imageView?.image =  UIImage(data: picture  as Data)
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
        
     
    }
   
    
    // delete table entry
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        
        
        if editingStyle == .delete
        {
            
            // delete the selected object from the managed
            // object context
            managedObjectContext.delete(fetchResults[indexPath.row])
            // remove it from the fetch results array
            fetchResults.remove(at:indexPath.row)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
            } catch {
                
            }
            // reload the table after deleting a row
            recipeTableView.reloadData()
        }
       
        
    }
    
    
    @IBAction func addAction(_ sender: Any) {
        
        let ent = NSEntityDescription.entity(forEntityName: "Recipes", in: self.managedObjectContext)
      
        
       
        
        if myrecipeList.addToRecipeArray(value: ingredientField.text!, dictionary: myrecipeList.recipes) == false {
            if myrecipeList.getKey(value: ingredientField.text!, dictionary: myrecipeList.recipes) != "" {
                //add to the manege object context
                let newItem = Recipes(entity: ent!, insertInto: self.managedObjectContext)
                
            
                newItem.recipeName = myrecipeList.getKey(value: ingredientField.text!, dictionary: myrecipeList.recipes)
                newItem.ingredient = ingredientField.text

                newItem.image = nil
                updateCounter()
                
                var photoPicker = UIImagePickerController ()
            
                let alert = UIAlertController(title: "Select from Photo Library or Camera", message: "", preferredStyle: .alert)
                
                let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (aciton) in
                    // load image
                  
                    photoPicker.delegate = self
                    photoPicker.sourceType = .photoLibrary
                    // display image selection view
                    self.present(photoPicker, animated: true, completion: nil)
                    
                }
                let cameraAction = UIAlertAction(title: "Camera", style: .default) {
                    (action) in
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    photoPicker.delegate = self
                    photoPicker.sourceType = .camera
                    self.present(photoPicker, animated: true, completion: nil)
                    }
                    else {
                        print("Camera not available")
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                
                alert.addAction(photoAction)
                alert.addAction(cameraAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            
        
           
            // save the updated context
            do {
                try self.managedObjectContext.save()
            } catch _ {
            }
    
            recipeTableView.reloadData()
            print(fetchResults.count) //for debugging
            }
        }
            //user did not enter an ingredient in the database
        else {
             let noRecipeAlert = UIAlertController(title: "No recipe exists", message: "", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            }
            noRecipeAlert.addAction(okAction)
            self.present(noRecipeAlert, animated: true, completion: nil)
         
            print(fetchResults.count) //for debugging
            // save the updated context
            
            
            
        }//end of else
        
 
        
      //else, don't do anything
 
    }
    func updateLastRow() {
        let indexPath = IndexPath(row: fetchResults.count-1, section: 0)
        recipeTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        
        // fetch resultset has the recently added row without the image
        // this code ad the image to the row
        if let recipe = fetchResults.last,
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipe.image = image.pngData()! as NSData
            
            //update the row with image
            updateLastRow()
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Error while saving the new image")
            }
            recipeTableView.reloadData() //just added this, check if not ok

        }
        
    }
   
    
    func initCounter() {
        counter = UserDefaults.init().integer(forKey: "counter")
    }
    
    func updateCounter() {
        counter += 1
        UserDefaults.init().set(counter, forKey: "counter")
        UserDefaults.init().synchronize()
    }
  
    
    @IBAction func clearAction(_ sender: Any) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            
            
        }
        catch let _ as NSError {
            // Handle error
        }
        
        recipeTableView.reloadData()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        var recipeAndIngredients:[String:String] = [:]
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        
       
        
        
        if(segue.identifier == "toRecipe"){
            if let detailviewController: recipeDetailViewController = segue.destination as? recipeDetailViewController {
                let selectedIndex: IndexPath = self.recipeTableView.indexPath(for: sender as! UITableViewCell)!
                var recipe = fetchResults[selectedIndex.row]
                cellIngredient = recipe.ingredient!
                cellname = recipe.recipeName!
                
                
               
                detailviewController.getRecipeName = cellname
                var i:Int = 0
                let urlAsString = "http://www.recipepuppy.com/api/?i="+cellIngredient+"&q="+cellname+"&p=2"
                
                let url = URL(string: urlAsString)!
                let urlSession = URLSession.shared
                
                let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                    var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                   
                    let jsonObjects = jsonResult as? [String:Any]
                    print("\(jsonObjects)")
                    let recipeArray = jsonObjects!["results"] as? NSArray
                  
                    //make sure executed on main thread
                    DispatchQueue.main.async {
                        //want to add all recipe names into an array
                        
                     
                       while i < recipeArray!.count {
                            let thisResults = recipeArray![i] as? [String:Any]
                            var title = thisResults!["title"] as! String
                            var ingredients = thisResults!["ingredients"] as! String
                            print("INGREDIENTS: \(ingredients)")
                            print("\(title)")
                            self.myrecipeList.titleArray.append(title)
                            self.myrecipeList.ingredientArray.append(ingredients)
                            i = i+1
                        }
 
                        
                        
                       
                        detailviewController.recipeTextView.text =  self.myrecipeList.displayRecipes()
                        
                        
                        
                        
                        
                    }
                    
                })
                
                jsonQuery.resume()
            }
                
                
            }
        }
    
    
 
    
}//EOF
    
    
    


