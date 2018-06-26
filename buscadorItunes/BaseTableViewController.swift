//
//  BaseTableViewController.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 25/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: UITableViewController {
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    var alertView: UIView!
    var acceptButton: UIButton!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    fileprivate var spinnerView: UIView!
    
    fileprivate func initDialogViews() {
        alertView = {
            let alertView = UIView()
            alertView.backgroundColor = .white
            alertView.layer.cornerRadius = 5
            alertView.translatesAutoresizingMaskIntoConstraints = false
            alertView.center = view.center
            return alertView
        }()
        
        acceptButton = {
            let acceptButton = CustomButton()
            acceptButton.translatesAutoresizingMaskIntoConstraints = false
            acceptButton.setTitle("Got it!", for: .normal)
            acceptButton.addTarget(self, action: #selector(dismissBlurMessage), for: .touchUpInside)
            return acceptButton
        }()
        
        titleLabel = {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
            titleLabel.sizeToFit()
            titleLabel.textColor = UIColor.primaryDarkColor
            return titleLabel
        }()
        
        descriptionLabel = {
            let descriptionLabel = UILabel()
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.numberOfLines = 0
            descriptionLabel.lineBreakMode = .byWordWrapping
            descriptionLabel.textAlignment = .center
            descriptionLabel.font = UIFont.systemFont(ofSize: 18.0)
            descriptionLabel.sizeToFit()
            descriptionLabel.textColor = UIColor.darkGray
            return descriptionLabel
        }()
    }
    
    fileprivate func setUpDialogConstraints() {
        
        self.navigationController?.view.addSubview(visualEffect)
        self.navigationController?.view.addSubview(alertView)
        
        self.alertView.addSubview(titleLabel)
        self.alertView.addSubview(descriptionLabel)
        self.alertView.addSubview(acceptButton)
        
        
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[superview]-(<=1)-[v0]", options: .alignAllCenterY, metrics: nil, views: ["superview":(navigationController?.view)!, "v0":alertView]))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": alertView]))
        
        self.alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[superview]-(<=1)-[v0]", options: .alignAllCenterX, metrics: nil, views: ["superview":alertView, "v0":acceptButton]))
        
        self.alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        self.alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": descriptionLabel]))
        
        self.alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v1]-16-[v2]-32-[v3]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": titleLabel, "v2": descriptionLabel, "v3": acceptButton]))
    }
    
    func showDialogBlurMessage(title: String, description: String) {
        initDialogViews()
        setUpDialogConstraints()
        
        visualEffect.frame = CGRect(x: 0, y: 0, width: (self.navigationController?.view.bounds.width)!, height: (self.navigationController?.view.bounds.height)!)
        
        alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0
        
        titleLabel.text = title
        descriptionLabel.text = description
        
        UIView.animate(withDuration: 0.4, animations: {
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        })
        
    }
    
    @objc func dismissBlurMessage(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alertView.alpha = 0
        }, completion: { (succes: Bool) in
            self.alertView.removeFromSuperview()
            self.visualEffect.removeFromSuperview()
        })
    }
    
    func startLoading() {
        spinnerView = UIView(frame: (self.navigationController?.view.bounds)!)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            self.spinnerView.addSubview(activityIndicator)
            self.navigationController?.view.addSubview(self.spinnerView)
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.spinnerView.removeFromSuperview()
        }
    }
}
