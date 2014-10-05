//
//  RenderingAgent.swift
//  GreetingCard
//
//  Created by David Bazile on 10/4/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

///
/// Provides some common services to any view controller that renders a scene
/// onto a canvas UIView.
///
class RenderingAgent
{
	let DEFAULT_CONTENT_MODE = UIViewContentMode.ScaleAspectFit
	
	///
	/// Sets some default configuration for a given canvas
	///
	func normalize(canvas:UIView) -> RenderingAgent
	{
		canvas.clipsToBounds = true
		canvas.frame.size = CGSize(width:320, height:400)
		return self
	}
	
	///
	/// Wipes all layers from the canvas
	///
	func purge(canvas:UIView) -> RenderingAgent
	{
		for renderedLayer in canvas.subviews {
			renderedLayer.removeFromSuperview()
		}
		
		return self
	}
	
	///
	/// Renders all layers in a given scene to the canvas
	///
	func render(scene:Scene, onto:UIView) -> RenderingAgent
	{
		return render(scene, onto:onto, highlighting:nil)
	}
	
	///
	/// Renders all layers in a given scene to the canvas with highlighting
	/// of a specific layer index
	///
	func render(scene:Scene, onto canvas:UIView, highlighting highlightIndex:Int?) -> RenderingAgent
	{
		// Always start with a blank slate
		purge(canvas)
		
		var currentIndex = 0
		for layer in scene.layers {
			let image = UIImage(contentsOfFile: layer.image)
			
			let renderedLayer = UIImageView()
			
			renderedLayer.image = image
			renderedLayer.contentMode = DEFAULT_CONTENT_MODE
			renderedLayer.clipsToBounds = true
			renderedLayer.frame = calculateImageSize(layer, image:image)
			renderedLayer.alpha = calculateOpacity(layer)
			
			
			if (currentIndex == highlightIndex) {
				decorateWithBorder(renderedLayer)
			}
			
			// Once transform begins, all bets are off
			renderedLayer.transform = calculateRotation(layer)
			
			canvas.addSubview(renderedLayer)
			currentIndex += 1
		}
		
		return self
	}

	///
	/// Renders a single layer to the canvas
	///
	func render(layerAsIcon layer:Layer, onto canvas:UIView) -> RenderingAgent
	{
		// Always start with a blank slate
		purge(canvas)
		
		let image = UIImage(contentsOfFile:layer.image)
		let renderedLayer = UIImageView()
		
		renderedLayer.image = image
		renderedLayer.contentMode = DEFAULT_CONTENT_MODE
		renderedLayer.clipsToBounds = true
		renderedLayer.frame = canvas.bounds.rectByInsetting(dx: 5, dy: 5)
		renderedLayer.alpha = calculateOpacity(layer)
		
		// Once transform begins, all bets are off
		renderedLayer.transform = calculateRotation(layer)
		
		canvas.addSubview(renderedLayer)
		
		return self
	}
	

	
	
	
	

	
	func render(fromPath path:String, onto canvas:UIView) -> RenderingAgent
	{
		// Always start with a blank slate
		purge(canvas)
		
		let image = UIImage(contentsOfFile:path)
		let renderedLayer = UIImageView()
		
		renderedLayer.image = image
		renderedLayer.contentMode = DEFAULT_CONTENT_MODE
		renderedLayer.clipsToBounds = true
		renderedLayer.frame = canvas.bounds.rectByInsetting(dx: 5, dy: 5)
		
		canvas.addSubview(renderedLayer)
		
		return self
	}
	
	func decorate(element:UIView, borderSize:Int, borderColor:UIColor, dashed:Bool)
	{
		let segmentSize = borderSize * 2
		let border = CAShapeLayer()
		border.strokeColor = borderColor.CGColor
		border.fillColor = nil
		border.lineWidth = CGFloat(borderSize)
		
		if (dashed) {
			border.lineDashPattern = [segmentSize, segmentSize]
		}
		
		border.path = UIBezierPath(rect:element.bounds).CGPath
		border.frame = element.bounds
		
		element.layer.addSublayer(border)
	}
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	///
	/// Calculates the size for a given layer
	///
	private func calculateImageSize(layer:Layer, image:UIImage) -> CGRect
	{
		// Calculate the (x,y)
		let origin = CGPoint(x:Int(layer.left), y:Int(layer.top))
		
		// Calculate the height and width
		let w = Float(image.size.width) * layer.scale
		let h = Float(image.size.height) * layer.scale
		
		let size = CGSize(width: CGFloat(w),
			              height:CGFloat(h))

		return CGRect(origin:origin, size:size)
	}

	///
	/// Calculates the opacity for a given layer
	///
	private func calculateOpacity(layer:Layer) -> CGFloat
	{
		return CGFloat(layer.opacity)
	}
	
	///
	/// Calculates the rotation for a given layer
	///
	private func calculateRotation(layer:Layer) -> CGAffineTransform
	{
		let RADIAN_RATIO = CGFloat(1/57.2957795)
		let degrees = layer.rotation
		let radians = CGFloat(degrees) * RADIAN_RATIO
		
		return CGAffineTransformMakeRotation(radians)
	}
	
	///
	/// Caculates the (x,y) position for a given layer
	///
	private func calculatePosition(layer:Layer) -> CGPoint
	{
		return CGPoint(x: Int(layer.left),
			           y: Int(layer.top))
	}
	
	///
	/// Adds the highlight border around a given layer
	///
	private func decorateWithBorder(renderedLayer:UIImageView)
	{
//		let border = CAShapeLayer()
//		border.strokeColor = UIColor.blackColor().CGColor
//		border.fillColor = nil
//		border.lineDashPattern = [10, 10]
//		border.lineWidth = 5
//		border.path = UIBezierPath(rect:renderedLayer.bounds).CGPath
//		border.frame = renderedLayer.bounds
//		
//		renderedLayer.layer.addSublayer(border)
		
		self.decorate(renderedLayer, borderSize: 5, borderColor: UIColor.blackColor(), dashed: true)
	}
}