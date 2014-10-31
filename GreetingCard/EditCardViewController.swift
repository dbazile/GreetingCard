//
//  EditCardViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditCardViewController : UIViewController,
                               UICollectionViewDataSource,
                               UICollectionViewDelegate,
	                           UIGestureRecognizerDelegate
{
	private let CONFIRM_CANCEL_MESSAGE    = "If you go back now, you will lose your changes to this card.  Is this okay?"
	private let CONFIRM_CANCEL_TITLE      = "Cancel Edit"
	private let LOSE_CHANGES              = "Lose my changes"
	private let SAVE_CHANGES              = "Save my changes"
	private let CONTINUE_EDITING          = "Keep editing!"
	private let EDIT_SCENE_SEGUE          = "EditSceneSegue"
	private let SCENE_CELL                = "SceneCell"
	private let TAG_LABEL                 = 1
	private let TAG_ICON                  = 2
	private let SCENE_CELL_ALPHA          = 1.0
	private let SCENE_CELL_BGCOLOR        = UIColor(white: 1, alpha: 0.1)
	private let SCENE_ICON_ALPHA          = 0.3
	private let CREATE_SCENE_CELL_ALPHA   = 0.5
	private let CREATE_SCENE_CELL_BGCOLOR = UIColor(white: 0, alpha: 0.5)
	private let LONGPRESS_DURATION        = 0.3
	
	private var dirty = false
	private let agent = RenderingAgent()
	private var _card: Card?
	private var workingCopyCard : Card?

	///
	/// Card property
	///   Automatically makes a working copy of the card
	///
	var card : Card? {
		get { return _card }
		set {
			_card = newValue
			workingCopyCard = DataUtility.Clone(card: _card!)
		}
	}
	
	// MARK: -
	
	///
	/// One-time controller setup
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Decorator.applyBackButton(on:self, onClickInvoke:"didClickBackButton")
		Decorator.applySaveButton(on:self, onClickInvoke:"didClickSaveButton")
		
		activateLongPressGesture()
	}
	
	///
	/// Refreshes all fields before coming into focus
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		collectionView.reloadData()

		// Since this controller is the front-door for editing, flip the switch here
		Decorator.usingEditContext(navigationController)
		
		inputTitle.text = workingCopyCard?.title
		
		// Fix the placeholder color
		inputTitle.attributedPlaceholder = NSAttributedString(
			    string:inputTitle.placeholder ?? "Title",
			attributes:[NSForegroundColorAttributeName:UIColor(white:1, alpha:0.1)])
	}

	///
	/// Intercepts the segue to configure the next view controller
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = collectionView.indexPathForCell(sender as UICollectionViewCell)!.item
		
		// Let's just assume that the user modifies something out here because it's easier to code :)
		dirty = true

		if (index < workingCopyCard?.scenes.count) {
			destinationController.scene = workingCopyCard!.scenes[index]
		} else {
			destinationController.scene = generateScene()
		}
		destinationController.sceneNumber = index + 1
	}
	
	///
	/// Executes when the user presses the 'Back' button in the navbar.  Prompts to abandon or save changes.
	///
	func didClickBackButton()
	{
		if (dirty) {
			let actionSheet = UIAlertController(title:CONFIRM_CANCEL_TITLE, message:CONFIRM_CANCEL_MESSAGE, preferredStyle: .ActionSheet)
			actionSheet.addAction(UIAlertAction(title:LOSE_CHANGES, style:.Destructive, handler:didSelectLoseChangesAction))
			actionSheet.addAction(UIAlertAction(title:SAVE_CHANGES, style:.Default, handler:didSelectSaveAction))
			actionSheet.addAction(UIAlertAction(title:CONTINUE_EDITING, style:.Default, handler:nil))
			
			presentViewController(actionSheet, animated:true, completion:nil)
		} else {
			// Clean up if this was a new card
			if (card!.isNew) {
				DataUtility.Delete(card!)
			}
			navigationController?.popViewControllerAnimated(true)
		}
	}
	
	///
	/// Executes when the user presses the 'Save' button in the navbar
	///
	func didClickSaveButton()
	{
		card!.title = ("" != workingCopyCard!.title) ? workingCopyCard!.title : "Untitled"
		card!.isNew = false
		card!.scenes = workingCopyCard!.scenes

		// Queue an alert on the nav controller
		let alert = UIAlertController(title:"Card Saved", message:"Your changes to \"\(card!.title)\" have been saved!", preferredStyle:.Alert)
		alert.addAction(UIAlertAction(title:"OK", style:.Default, handler:nil))
		
		/*
		 * Swift doesn't appear to like seeing the navcontroller operation in a callback, so
		 * I wrapped it in a function here.
		 */
		func _returnToInbox() { navigationController?.popToRootViewControllerAnimated(true) }
		navigationController?.presentViewController(alert, animated:false, completion:_returnToInbox)
	}
	
	///
	/// Executes whenever a cell is long-pressed
	///
	func didLongPressCell(gesture: UILongPressGestureRecognizer)
	{
		func _bind(index: Int, operation:(Int) -> Void) -> (UIAlertAction!) -> Void
		{
			return {action in operation(index)}
		}
		
		if (.Began == gesture.state) {
			let touchPoint = gesture.locationInView(collectionView)
			let index = collectionView.indexPathForItemAtPoint(touchPoint)!.item
			
			// Only show the context menu for the actual scenes, not the "Create New" one
			if (index < workingCopyCard?.scenes.count) {
				
				let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: .ActionSheet)
				actionSheet.addAction(UIAlertAction(title:"Delete this Scene", style:.Destructive, handler: _bind(index, deleteScene)))
				actionSheet.addAction(UIAlertAction(title:"Copy this Scene", style:.Default, handler: _bind(index, copyScene)))
				if (index > 0 && index < workingCopyCard?.scenes.count ) {
					actionSheet.addAction(UIAlertAction(title:"Move left", style:.Default, handler: _bind(index, moveSceneLeft)))
				}
				if (index + 1 < workingCopyCard?.scenes.count) {
					actionSheet.addAction(UIAlertAction(title:"Move right", style:.Default, handler: _bind(index, moveSceneRight)))
				}
				actionSheet.addAction(UIAlertAction(title:"Cancel", style:.Default, handler:nil))
				
				presentViewController(actionSheet, animated:true, completion:nil)
			}
		}
	}
	
	///
	/// Discards the changes to the card and returns to whichever controller sent us to edit mode
	///
	func didSelectLoseChangesAction(action:UIAlertAction!)
	{
		// Clean up if this was a new card
		if (card!.isNew) {
			DataUtility.Delete(card!)
		}
		
		navigationController!.popViewControllerAnimated(true)
	}
	
	///
	/// Triggers the save operation from the navbar
	///
	func didSelectSaveAction(action:UIAlertAction!)
	{
		didClickSaveButton()
	}
	

	// MARK: - INTERFACE BUILDER /////////////////////////////////////////////////

	@IBOutlet weak var inputTitle : UITextField!
	@IBOutlet weak var collectionView : UICollectionView!

	///
	/// EventHandler: Scene title was changed
	///
	@IBAction func didChangeTitle(sender: UITextField)
	{
		dirty = true
		workingCopyCard!.title = sender.text
	}


	// MARK: - COLLECTIONVIEW DATASOURCE/DELEGATE ////////////////////////////////

	///
	/// Sets the number of sections
	///
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}

	///
	/// Sets the number of scenes
	///
	func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		// Return an extra cell to account for the 'New Scene' button
		return workingCopyCard!.scenes.count + 1
	}

	///
	/// Configures a specific scene cell
	///
	func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SCENE_CELL, forIndexPath: indexPath) as UICollectionViewCell
		let index = indexPath.item

		// Configure the cell
		let label = cell.viewWithTag(TAG_LABEL)! as UILabel
		let canvas = cell.viewWithTag(TAG_ICON)! as UIView
		
		agent.purge(canvas)
		
		if (index < self.workingCopyCard!.scenes.count) {
			label.text = "\(index + 1)"
			
			agent.render(workingCopyCard!.scenes[index], onto:canvas)
			canvas.alpha = CGFloat(SCENE_ICON_ALPHA)
			cell.backgroundColor = SCENE_CELL_BGCOLOR
			cell.alpha = CGFloat(SCENE_CELL_ALPHA)
		} else {
			label.text = "+"
			cell.backgroundColor = CREATE_SCENE_CELL_BGCOLOR
			cell.alpha = CGFloat(CREATE_SCENE_CELL_ALPHA)
		}

		return cell
	}
	

	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Activates the long-press gesture recognizer that provides the action sheet for each cell
	///
	private func activateLongPressGesture()
	{
		let longpressGesture = UILongPressGestureRecognizer(target:self, action:"didLongPressCell:")
		longpressGesture.minimumPressDuration = LONGPRESS_DURATION
		longpressGesture.delegate = self
		collectionView.addGestureRecognizer(longpressGesture)
	}
	
	///
	/// Places a duplicate of a scene to its right
	///
	private func copyScene(index: Int)
	{
		let oldScene = workingCopyCard!.scenes[index]
		let copiedScene = DataUtility.Clone(scene:oldScene)
		workingCopyCard!.scenes.insert(copiedScene, atIndex:index+1)
		collectionView.reloadData()
	}
	
	///
	/// Deletes a scene at a given index
	///
	private func deleteScene(index: Int)
	{
		workingCopyCard!.scenes.remove(index)
		collectionView.reloadData()
	}
	
	///
	/// Creates a new Scene to be edited
	///
	private func generateScene() -> Scene
	{
		let scene = DataUtility.CreateScene()
		workingCopyCard!.scenes.append(scene)
		return scene
	}
	
	///
	/// Reorders a scene by moving it one index to the right
	///
	private func moveSceneRight(index: Int)
	{
		if (index + 1 < workingCopyCard?.scenes.count ) {
			workingCopyCard!.scenes.swap(index, index+1)
			collectionView.reloadData()
		}
	}
	
	///
	/// Reorders a scene by moving it one index to the left
	///
	private func moveSceneLeft(index: Int)
	{
		if (index > 0 && index < workingCopyCard?.scenes.count ) {
			workingCopyCard!.scenes.swap(index, index-1)
			collectionView.reloadData()
		}
	}
}
