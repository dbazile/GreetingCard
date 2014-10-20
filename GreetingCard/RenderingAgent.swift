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
	private let DEFAULT_CONTENT_MODE = UIViewContentMode.ScaleAspectFit

	///
	/// Draws a border around a given UIView
	///
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
	/// Renders a single image based on its identifier onto the canvas
	///
	func render(fromIdentifier identifier:String, onto canvas:UIView) -> RenderingAgent
	{
		// Always start with a blank slate
		purge(canvas)
		
		let image = png(identifier)
		let renderedLayer = UIImageView()
		
		renderedLayer.image = image
		renderedLayer.contentMode = DEFAULT_CONTENT_MODE
		renderedLayer.clipsToBounds = true
		renderedLayer.frame = canvas.bounds.rectByInsetting(dx: 5, dy: 5)
		
		canvas.addSubview(renderedLayer)
		
		return self
	}
	
	///
	/// Renders a glyphicon onto the canvas
	///
	func render(glyph text:String, onto canvas:UIView) -> RenderingAgent
	{
		let glyph = UILabel()
		glyph.frame = canvas.bounds.rectByOffsetting(dx: 0, dy: -5)
		glyph.text = text
		glyph.font = UIFont.boldSystemFontOfSize(60)
		glyph.textColor = UIColor(white: 1, alpha: 1)
		glyph.textAlignment = NSTextAlignment.Center
		glyph.baselineAdjustment = UIBaselineAdjustment.AlignCenters
		canvas.addSubview(glyph)
		canvas.backgroundColor = UIColor(white: 0, alpha: 0.15)
		
		return self
	}
	
	///
	/// Renders a single layer to the canvas
	///
	func render(layerAsIcon layer:Layer, onto canvas:UIView) -> RenderingAgent
	{
		// Always start with a blank slate
		purge(canvas)
		
		let image = png(layer.image)
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
			let image = png(layer.image)

			let renderedLayer = UIImageView()

			renderedLayer.image = image
			renderedLayer.contentMode = DEFAULT_CONTENT_MODE
			renderedLayer.clipsToBounds = true
			renderedLayer.frame = calculateImageSize(layer, image:image)
			renderedLayer.alpha = calculateOpacity(layer)


			if (currentIndex == highlightIndex) {
				formatHighlightedLayer(renderedLayer)
			}

			// Once transform begins, all bets are off
			renderedLayer.transform = calculateRotation(layer)

			canvas.addSubview(renderedLayer)
			currentIndex += 1
		}

		return self
	}


	// MARK: HELPER METHODS ////////////////////////////////////////////////////

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
	/// Caculates the (x,y) position for a given layer
	///
	private func calculatePosition(layer:Layer) -> CGPoint
	{
		return CGPoint(x: Int(layer.left),
			y: Int(layer.top))
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
	/// Adds the highlight border around a given layer
	///
	private func formatHighlightedLayer(renderedLayer:UIImageView)
	{
		self.decorate(renderedLayer, borderSize: 5, borderColor: UIColor.blackColor(), dashed: true)
	}

	///
	/// Factory method for loading images from identifiers
	///
	private func png(identifier:String) -> UIImage
	{
		if let path = DataUtility.Resolve(identifier) {
			return UIImage(contentsOfFile:path)
		} else {
			return UIImage(named:"QuestionMark")
		}
	}
}
