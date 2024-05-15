//
//  ControlButton.swift
//  Neobis_iOS_StopWatch
//
//  Created by Ai Hawok on 14/05/2024.
//

import UIKit

@IBDesignable
class ControlButton: UIButton {
    
    var actionHandler: (() -> Void)?
    
    @IBInspectable var imageName: String? {
        didSet {
            setImageFromName()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setImageFromName()
    }
    
    private func setImageFromName(){
        guard let imageName = imageName else { return }
        // Set dark background color
        backgroundColor = AppColors.secondaryColor
        layer.cornerRadius = 15
        
        // Create UIImageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        
        // Set image
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            imageView.image = image
        }
        imageView.setImageColor(color: AppColors.primaryColor)
        
        // Set image view constraints to center it inside the button
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.4)
        ])
    }
    
    @objc private func buttonTapped() {
        actionHandler?()
    }
}
