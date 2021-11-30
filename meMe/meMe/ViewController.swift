//
//  ViewController.swift
//  meMe
//
//  Created by Jack McCabe on 11/18/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {


    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var midScreenImage: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareMeme: UIButton!
    
    
    struct Meme{
        var topText:String
        var bottomText:String
        var originalImage:UIImage?
        var memedImage:UIImage
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextAttributes()
        shareMeme.isEnabled = false
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("yes")
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
     
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.black,
        NSAttributedString.Key.backgroundColor:UIColor.clear,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:1.01 ]
    
    func setTextAttributes() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.borderStyle = .none
        bottomTextField.borderStyle = .none
        topTextField.backgroundColor = .clear
        bottomTextField.backgroundColor = .clear
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
     
    }
    @objc func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField)-> Bool{
        textField.resignFirstResponder()
        return true
    }
    

    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector:   #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
   @objc func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification)->CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
   @objc func keyboardWillShow(_ notification:Notification){
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    
    @IBAction func settingImage(_ sender: Any) {
        var pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
       
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        var pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.sourceType = .camera
        
        present(pickerController, animated:true, completion:nil)
        
    }
    

    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
         
         if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             midScreenImage.image = selectedImage
             shareMeme.isEnabled = true
                }
         
         if let im = info[UIImagePickerController.InfoKey.imageURL]{
             print("\(im)")
         }
         
         dismiss(animated: true, completion:nil)
         
     }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion:nil)
    }

    
    func generatedMemedImage() ->UIImage {
        
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates:true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func shareMemeMethod(_ sender: Any) {
        let memeImage = generatedMemedImage()
        
        let savedMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: midScreenImage.image!, memedImage: memeImage)
        
        
        let UIViewCont = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        UIViewCont.popoverPresentationController?.sourceView = self.view
        //Playing with this functionality
        UIViewCont.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        
        present(UIViewCont, animated: true, completion: nil)
        
    }
    
    func save(_ memedImage: UIImage) {
            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: midScreenImage.image!, memedImage: memedImage)
    }
    

    
}

