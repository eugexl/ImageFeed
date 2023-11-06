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
    
    private let buttonBack: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: NamedImages.buttonBack), for: .normal)
        
        return button
    }()
    
    private let buttonShare: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: NamedImages.buttonShare), for: .normal)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        
        return iView
    }()
    
    private let scrollView: UIScrollView = {
        
        let sView = UIScrollView()
        sView.minimumZoomScale = 0.1
        sView.maximumZoomScale = 1.25
        sView.contentMode = .scaleToFill
        sView.backgroundColor = UIColor(named: ColorNames.ypBlack)
        
        return sView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        setUpUI()
        
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @objc
    private func didTapBackButton(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @objc
    private func didTapShareButton(_ sender: Any) {
        
        let activityController = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    private func setUpUI(){
        
        scrollView.addSubview(imageView)
        
        [scrollView,buttonBack,buttonShare].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            
            buttonBack.heightAnchor.constraint(equalToConstant: 48.0),
            buttonBack.widthAnchor.constraint(equalToConstant: 48.0),
            buttonBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            buttonBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            
            buttonShare.heightAnchor.constraint(equalToConstant: 50.0),
            buttonShare.widthAnchor.constraint(equalToConstant: 50.0),
            buttonShare.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonShare.topAnchor.constraint(equalTo: view.topAnchor, constant: 711)
        ])
        
        buttonBack.addTarget(self, action: #selector(didTapBackButton) , for: .touchUpInside)
        buttonShare.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
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
