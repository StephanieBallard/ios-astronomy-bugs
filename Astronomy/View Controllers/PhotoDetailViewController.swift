//
//  PhotoDetailViewController.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            savePhoto(photo: image)
        } else if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { granted in
                if granted == .authorized {
                    self.savePhoto(photo: image)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func savePhoto(photo: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: photo)
        }, completionHandler: { (success, error) in
            if let error = error {
                NSLog("Error saving photo: \(error)")
                return
            }
        })
    }
    
    private func updateViews() {
        guard let photo = photo, isViewLoaded else { return }
//        do {
            if let data = imageData {
//            let data = try Data(contentsOf: photo.imageURL.usingHTTPS!)
                imageView.image = UIImage(data: data)
            }
            let dateString = dateFormatter.string(from: photo.earthDate)
            detailLabel.text = "Taken by \(photo.camera.roverId) on \(dateString) (Sol \(photo.sol))"
            cameraLabel.text = photo.camera.fullName
//        } catch {
//            NSLog("Error setting up views on detail view controller: \(error)")
//        }
    }
    
    // MARK: - Properties
    
    var imageData: Data?
    var photo: MarsPhotoReference? {
        didSet {
            updateViews()
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
}
