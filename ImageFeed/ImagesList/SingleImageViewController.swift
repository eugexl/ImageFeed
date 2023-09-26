//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Eugene Dmitrichenko on 15.09.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
        
        present(activityController, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let minZoomScale = scrollView.minimumZoomScale
//        let maxZoomScale = scrollView.maximumZoomScale
        
        // На этапе выполнения задачи 9-го спринта, для растягивания мелких моковых картинок до ширины/высоты экрана устройства (согласно ТЗ) >>>
        var maxZoomScale: CGFloat
        if hScale > 0 && vScale > 0 {
            maxZoomScale = hScale > vScale ? hScale : vScale
            scrollView.maximumZoomScale = maxZoomScale
        } else {
            maxZoomScale = scrollView.maximumZoomScale
        }
        // <<<
        
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
       return imageView
    }
}
