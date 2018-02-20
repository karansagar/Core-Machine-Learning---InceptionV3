//
//  ViewController.swift
//  SeaFood
//
//  Created by Karan Sagar on 20/02/18.
//  Copyright © 2018 Karan Sagar. All rights reserved.
//

import UIKit
import CoreML
//1 help us to process images more easily
import Vision


// 1.1
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //3
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLable: UILabel!
    
    
    //4 new image picker object
    let imagePicker = UIImagePickerController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //5. to set it's delegant as it's current class
        imagePicker.delegate = self
        
        //Source type and allow edditing
        //6. Source type
        imagePicker.sourceType = .camera
        
        //7. Edditing
        imagePicker.allowsEditing = false
        
    }
    
    //9. in order to address that point ... once the image is clicked then
    // image picker controller did finished
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        // user has picked image and done and do you want to do something with this image
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //10. change the clicked image as UIImage ...
            imageView.image = userPickedImage
            
            //11. convert UI Image .to CIImage .. to use vision framework and coreML framework
            
            guard let ciImage = CIImage(image: userPickedImage) else {fatalError("could not conver to ciImage")}
            
            detect(image: ciImage)
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        

    }
    // 12. created a modle
    func detect(image: CIImage)  {
        
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("loading core ML model Fail")}
     
        //13. create a vision coreML request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("model failed to process image)")}
    
            
            if let firstResult = results.first {
                
                let confidence = String(format: "%.2f", (firstResult.confidence)*100)
                self.navigationItem.title = String(confidence) + "% - " + (firstResult.identifier)
                
//                if firstResult.identifier.contains("hotdog"){
//                    self.navigationItem.title = "HotDog!"
//                } else {
//                    self.navigationItem.title = "Not Hotdog!"
//                }
            }
        }
        
        //14. create a handler which
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        
    }
    
    //2.
    @IBAction func cameraTap(_ sender: UIBarButtonItem) {
        
        //8. when we want image picker to apper ... when camera button tap
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    


}

