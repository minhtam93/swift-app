//
//  CreateUserViewController.swift
//  userManagement
//
//  Created by USER on 2022/10/29.
//

import UIKit

class NewUserViewController: UIViewController {

    @IBOutlet weak var photoImageVIew: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var insertButton: UIButton!
    //databseに接続
    let db = DBService.shared
    var imageUrl = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(getImage))
        photoImageVIew.isUserInteractionEnabled = true
        photoImageVIew.addGestureRecognizer(gesture)
        print("hi")
    }
    
    @IBAction func dismissClick(_ sender: UIButton) {
        let name = nameTextField.text ?? ""
        let age = Int(ageTextField.text ?? "") ?? 0
//        print(urlString)
        let directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let urlString: NSURL = directoryPath.appendingPathComponent(imageName) as NSURL
        db.insertData(name: name, age: age, media: imageName)
    dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewUserViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBAction func getImage(_ sender: UITapGestureRecognizer) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        //画像の取得先はフォトライブライ
        photoPicker.sourceType = .photoLibrary
        photoPicker.allowsEditing = false
        present(photoPicker, animated: true, completion: nil)
    }
    // 画像が選択された時に呼ばれる.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //選択された画像を取得.
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           
            let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            imageName = imageURL.path!
            saveImageToDocumentsDirectory(imageName: imageName, image: selectedImage!)
           photoImageVIew.image = selectedImage
           dismiss(animated: true, completion: nil)
        }
        //画像選択がキャンセルされた時に呼ばれる.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // モーダルビューを閉じる
           dismiss(animated: true, completion: nil)
        }
    
        func saveImageToDocumentsDirectory(imageName: String, image: UIImage) {
            let directoryPath =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let urlString: NSURL = directoryPath.appendingPathComponent(imageName) as NSURL
                print("画像パース : \(urlString)")
            if !FileManager.default.fileExists(atPath: urlString.path!) {
                do {
                    try image.jpegData(compressionQuality: 1.0)!.write(to: urlString as URL)
                    print ("画像が追加できた。")
                } catch {
                    print ("画像が追加できない。")
                }
            }
        }
}
