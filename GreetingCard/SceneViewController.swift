//
//  SceneViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {
	@IBOutlet weak var canvas: UIView!
	@IBOutlet weak var caption: UILabel!
	var scene: Scene?
	var index: Int = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.render()
	}
	
	private func render()
	{
		caption.text = scene?.caption
		for layer in scene!.layers {
			let image = UIImage(contentsOfFile: layer.image)
			let container = UIImageView(image: image)
			
			// The layer should maintain the image's aspect ratio
			container.contentMode = UIViewContentMode.ScaleAspectFit
			
			// Image Size
			container.frame = CGRect(origin: position(layer), size: scale(image, percentage: layer.scale))
			
			// Rotation
			container.transform = rotation(layer)
			
			// Opacity
			container.alpha = opacity(layer)
			
			canvas.addSubview(container)
		}
	}
	
	private func opacity(layer: Layer) -> CGFloat
	{
		return CGFloat(layer.opacity)
	}
	
	private func rotation(layer: Layer) -> CGAffineTransform
	{
		let degrees = layer.rotation
		let radians = CGFloat(degrees) * CGFloat(1/57.2957795)
		
		return CGAffineTransformMakeRotation(radians)
	}
	
	private func position(layer: Layer) -> CGPoint
	{
		return CGPoint(x: Int(layer.left), y: Int(layer.top))
	}
	
	private func scale(image: UIImage, percentage: Float) -> CGSize
	{
		let w = Float(image.size.width) * percentage
		let h = Float(image.size.height) * percentage
		
		return CGSize(width: CGFloat(w), height: CGFloat(h))
	}
}
