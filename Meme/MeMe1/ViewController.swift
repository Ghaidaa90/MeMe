//
//  ViewController.swift
//  MeMe1
//
//  Created by Ghaidaa Alfayez on 23/01/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var ButtomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var AlbumButton: UIBarButtonItem!
    @IBOutlet weak var ToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.contentMode = .scaleAspectFit
        ShareButton.isEnabled = false
        if !(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            cameraButton.isEnabled = false}
        configureTextField(TopTextField, text:"Top")
        configureTextField(ButtomTextField, text:"Buttom")
    }
    
    func configureTextField(_ textField: UITextField, text: String) {
        let paragraphStyle=NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black ,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -2 ,
            NSAttributedString.Key.paragraphStyle:paragraphStyle
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()}
    
    func pickAnImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)}
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image=info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image=image
            ShareButton.isEnabled=true}
        picker.dismiss(animated: true)
    }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField.text == "TOP" || textField.text == "BOTTOM"{textField.text = ""}}
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true}
        
        @objc func keyboardWillShow(_ notification:Notification) {
            if (ButtomTextField.isEditing){
                view.frame.origin.y = -getKeyboardHeight(notification)
            }}
        
        @objc func keyboardWillHide(_ notification:Notification) {
            if ButtomTextField.isFirstResponder {view.frame.origin.y = 0}}
        
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue 
            return keyboardSize.cgRectValue.height}
        
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object:nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object:nil)
        }
        
        func unsubscribeFromKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)}
    
    func save()
        {
            
            let meme = Meme(topText: TopTextField.text!, bottomText: ButtomTextField.text!, originalImage: imagePickerView.image!, memedImage:generateMemedImage())
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            
        }
    
        func generateMemedImage() -> UIImage {
            navigationController?.navigationBar.isHidden = true
            ToolBar.isHidden = true
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            navigationController?.navigationBar.isHidden = false
            ToolBar.isHidden = false
            return memedImage
        }
        @IBAction func Share(_ sender: Any) {
            let memeImage = generateMemedImage()
            let ActivController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            ActivController.completionWithItemsHandler = { activity, success, items, error in
                if success {self.save()}
                self.dismiss(animated: true, completion: nil)}
            present(ActivController, animated: true, completion: nil)}
    
        @IBAction func CancelButtonClicked () {
            navigationController?.dismiss(animated: true, completion: nil)
    }
}

