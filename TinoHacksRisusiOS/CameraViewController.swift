//
//  CameraViewController.swift
//  TinoHacksRisusiOS
//
//  Created by Sanjay Nighojkar on 4/15/17.
//  Copyright © 2017 Kartik Nighojkar. All rights reserved.
//

import UIKit
import CoreImage

class CameraViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    // Code for taking pictures and updating UIImageView
    let picker = UIImagePickerController()

    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shootPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
            self.detectFace()
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFit //3
        myImageView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        self.detectFace()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.detectFace()
    }
    //Code for facial detection
    func detectFace() {
        //print("Detecting")
        if (myImageView.image != nil) {
            let imageOptions =  NSDictionary(object: NSNumber(value: 5) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
            let personImage = CIImage(cgImage: myImageView.image!.cgImage!)
            let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
            let faces = faceDetector?.features(in: personImage, options: imageOptions as? [String : AnyObject])
            
            if let face = faces?.first as? CIFaceFeature {
                print("found bounds are \(face.bounds)")
                
                let alert = UIAlertController(title: "Say Cheese!", message: "We detected a face!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                print(String(describing: faces?.count));
                
                if face.hasSmile {
                    print("face is smiling");
                }else{
                    print("no smile");
                }
                
                if face.hasLeftEyePosition {
                    print("Left eye bounds are \(face.leftEyePosition)")
                }
                
                if face.hasRightEyePosition {
                    print("Right eye bounds are \(face.rightEyePosition)")
                }
            } else {
                let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
//            let faceImage = CIImage(image: myImageView.image!)
//            let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
//            let faces = faceDetector?.features(in: faceImage!) as! [CIFaceFeature]
//            print("Number of faces: \(faces.count)")
//            
//            let transformScale = CGAffineTransform(scaleX: 1, y: -1)
//            let transform = transformScale.translatedBy(x: 0, y: -faceImage!.extent.height)
//            
//            for face in faces {
//                var faceBounds = face.bounds.applying(transform)
//                let imageViewSize = myImageView.bounds.size
//                let scale = min(imageViewSize.width / faceImage!.extent.width,
//                                imageViewSize.height / faceImage!.extent.height)
//                
//                let dx = (imageViewSize.width - faceImage!.extent.width * scale) / 2
//                let dy = (imageViewSize.height - faceImage!.extent.height * scale) / 2
//                
//                faceBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
//                faceBounds.origin.x += dx
//                faceBounds.origin.y += dy
//                
//                let box = UIView(frame: faceBounds)
//                box.layer.borderColor = UIColor.red.cgColor
//                box.layer.borderWidth = 2
//                box.backgroundColor = UIColor.clear
//                myImageView.addSubview(box)
//            }
        
    }
}
