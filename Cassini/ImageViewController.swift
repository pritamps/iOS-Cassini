//
//  ImageViewController.swift
//  Cassini
//
//  Created by Pritam Sukumar on 31/07/17.
//  Copyright © 2017 Pritam Sukumar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Fetch Image from URL
    private func fetchImage() {
        // Do this on another thread
        // We use 'weak' to only maintain a weak reference here. If the class
        // is destroyed, 'self' will now become 'nil'. Yay!
        if let url = imageURL {
            
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                // Make sure url == self.imageURL to make sure the returned image
                // corresponds to the correct list
                if let imageData = urlContents, url == self?.imageURL {
                    // DO UI CHANGES ON MAIN THREAD
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    // Add imageView to the superView
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // Set test image URL
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    // Initialize ImageView
    fileprivate var imageView = UIImageView()
    
    // Set image of imageView
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            
            // Stop animating spinner
            spinner?.stopAnimating()
        }
    }
    
}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
