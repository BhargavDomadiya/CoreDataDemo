//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by R93 on 11/02/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!

    var arrStudent: [StudentDetails] = []
    private func insertUser() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      
        let viewContext = appDelegate.persistentContainer.viewContext
        guard let studentEntity = NSEntityDescription.entity(forEntityName: "Student", in: viewContext) else { return }
        let studentManagedObject = NSManagedObject(entity: studentEntity, insertInto: viewContext)
        studentManagedObject.setValue(nameTextField.text, forKey: "name")
        studentManagedObject.setValue(addressTextField.text, forKey: "address")
        studentManagedObject.setValue(salaryTextField.text, forKey: "salary")
        do {
            try viewContext.save()
            print("data saved successfully")
            messageLabel.text = "data saved succesfully"
            nameTextField.text = ""
            addressTextField.text = ""
            salaryTextField.text = ""
            
        }catch let error as NSError{
            print(error.localizedDescription)
            messageLabel.text = error.localizedDescription
        }
        
    }
    private func getStudents() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Student")
        
        do {
            let students = try viewContext.fetch(fetchRequest)
            arrStudent = []
            for student in students as! [NSManagedObject] {
                
                let name = student.value(forKey: "name") ?? ""
                let address = student.value(forKey: "address") ?? ""
                let salary = student.value(forKey: "salary") ?? 0.0
                let studentObject = StudentDetails(name: name as! String, address: address as! String, salary: salary as! Double)
                arrStudent.append(studentObject)
                print("student name is \(name)")
                print("student address is \(address)")
                print("student salary is \(salary)")
            }
            print(arrStudent)
            if arrStudent.count > 0 {
                
            }
            else {
                print("no data found")
            }
        } catch let error as NSError {
            
        }
    }
    
    
    private func deleteUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "salary = %f", Float(salaryTextField.text ?? "0.0") ?? 0.0)
        do {
            let students = try viewContext.fetch(fetchRequest)
            for student in students as! [NSManagedObject]{
                viewContext.delete(student)
                try viewContext.save()
                print("Data deleted successFully.")
                messageLabel.text = "data deleted successfully."
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                getStudents()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            messageLabel.text = error.localizedDescription
        }
        
    }
    private func updateUsers() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let viewContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Student")
        
        do {
            let students = try viewContext.fetch(fetchRequest)
            for student in students as! [NSManagedObject] {
                let tempStudent = student
                tempStudent.setValue(Double(salaryTextField.text ?? "0"), forKey: "salary")
                try viewContext.save()
                print("Data Updated SuccessFully.")
                messageLabel.text = "Data Updated SuccessFully."
                nameTextField.text = ""
                addressTextField.text = ""
                salaryTextField.text = ""
                getStudents()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            messageLabel.text = error.localizedDescription
            
        }
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
          //Insert Meet
          if nameTextField.text?.count == 0 || addressTextField.text?.count == 0 || salaryTextField.text?.count == 0 {
              print("Please enter missing details")
              return
          }
        insertUser()
    }
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        getStudents()
       }
    @IBAction func updateButtonClicked(_ sender: UIButton) {
   
           //Insert Meet
           if nameTextField.text?.count == 0 || addressTextField.text?.count == 0 || salaryTextField.text?.count == 0 {
               print("Please enter missing details")
               return
           }
        updateUsers()
        
    }
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        deleteUsers()
    }
}

    
    
struct StudentDetails {
    var name: String
    var address: String
    var salary: Double
}




