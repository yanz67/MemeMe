//
//  MemeUIViewController.swift
//  MemeMe
//
//  Created by Yan Zverev on 6/23/16.
//  Copyright © 2016 Yan Zverev. All rights reserved.
//

import UIKit

class MemeUIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextView: UITextField!
    @IBOutlet weak var bottomTextView: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var blGuide: NSLayoutConstraint!
    @IBOutlet weak var tpGuide: NSLayoutConstraint!
    
    var delegate: CreateMemeDelegate? = nil
    
    var memeModel = MemeModel()
    
    var savedMemesModel: SavedMemesModel!
    
    //MARK: UpdateView
    
    func updateUI()
    {
        topTextView.text = memeModel.topText
        bottomTextView.text = memeModel.bottomText
        memeImageView.image = memeModel.backgroundImage
    }
    		
    
    //MARK: UIViewController Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        topTextView.defaultTextAttributes = memeTextAttributes
        topTextView.textAlignment = NSTextAlignment.Center
        bottomTextView.defaultTextAttributes = memeTextAttributes
        bottomTextView.textAlignment = NSTextAlignment.Center

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topTextView.delegate = self
        bottomTextView.delegate = self
        
        updateUI()
        
        //enable or disable camera if available/unavailable
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }


    //MARK: Action Events
    
    @IBAction func getImageFromCameraOrAlbum(sender: UIBarButtonItem)
    {
        let imagePicker = UIImagePickerController()
        if sender.title == "Album" {
            imagePicker.sourceType = .PhotoLibrary
        }else {
            imagePicker.sourceType = .Camera 
        }
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem)
    {
        updateUI()
        let memeImage = generateMemedImage()
        memeModel.memeImage = memeImage
        //saveMeme()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success,items,error) in
            // if shared the delegate method will be called and memeModel will be passed 
            if success == true {
                if let delegate = self.delegate {
                    delegate.memeDidCreate(self.memeModel) // might create a retain cycle
                }
            } else {
                if let delegate = self.delegate {
                    delegate.memeCancelCreate() // should handle error case better
                }
            }
            
        }
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem)
    {
        if let delegate = self.delegate {
            delegate.memeCancelCreate()
        }
    
    }
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        
        topToolBar.hidden = true
        bottomToolBar.hidden  = true
        // render view to an image
        UIGraphicsBeginImageContext(contentView.frame.size)
        contentView.drawViewHierarchyInRect(contentView.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topToolBar.hidden = false
        bottomToolBar.hidden  = false
        return memedImage
    }
    
    //MARK: UIIMagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            memeModel.backgroundImage = image
            updateUI()
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Keyboard functions
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    func unSubscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        
        if bottomTextView.editing {
            //only move up the conteview when bottom text is being edited
            blGuide.constant = getKeyboardHeight(notification)
            tpGuide.constant = -getKeyboardHeight(notification)
            view.layoutIfNeeded()
        }
        
    
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        blGuide.constant = 0
        tpGuide.constant = 0
        view.layoutIfNeeded()

    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: TextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField)
    {
        shareButton.enabled = true
        if textField == topTextView {
            if textField.text?.characters.count == 0 {
                textField.text = "TOP"
               
            }
            memeModel.topText = textField.text!
        } else if textField == bottomTextView {
            if textField.text?.characters.count == 0 {
                textField.text = "BOTTOM"
            }
            memeModel.bottomText = textField.text!
        }
        updateUI()
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        shareButton.enabled = false
        textField.text = ""
    }
    
}

