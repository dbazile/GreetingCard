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
                               UICollectionViewDelegate
{
	private let EDIT_SCENE_SEGUE          = "EditSceneSegue"
	private let SCENE_CELL                = "SceneCell"
	private let TAG_LABEL                 = 1
	private let TAG_ICON                  = 2
	private let SCENE_CELL_ALPHA          = 1.0
	private let SCENE_CELL_BGCOLOR        = UIColor(white: 1, alpha: 0.1)
	private let SCENE_ICON_ALPHA          = 0.3
	private let CREATE_SCENE_CELL_ALPHA   = 0.5
	private let CREATE_SCENE_CELL_BGCOLOR = UIColor(white: 0, alpha: 0.5)
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
			workingCopyCard = DataUtility.Clone(_card!)
		}
	}
	
	///
	/// One-time controller setup
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Decorator.applyBackButton(on:self)
		Decorator.applySaveButton(on:self, onClickInvoke:"didClickSaveButton")
	}
	
	func didClickSaveButton()
	{
		card!.title = workingCopyCard!.title
		card!.isNew = false
		card!.scenes = workingCopyCard!.scenes
		
		UIAlertView(title:"Saved", message:"Your card has been saved", delegate: nil, cancelButtonTitle: "OK").show()
		
		// Return to the inbox
		navigationController?.popToRootViewControllerAnimated(true)
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
			attributes:[NSForegroundColorAttributeName:UIColor(white:1, alpha:0.2)])
	}

	///
	/// Intercepts the segue to configure the next view controller
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = collectionView.indexPathForCell(sender as UICollectionViewCell)!.item

		if (index < workingCopyCard?.scenes.count) {
			destinationController.scene = workingCopyCard!.scenes[index]
			destinationController.sceneNumber = index + 1
		} else {
			destinationController.scene = generateScene()
			destinationController.sceneNumber = index
		}
	}


	// MARK: INTERFACE BUILDER /////////////////////////////////////////////////

	@IBOutlet weak var inputTitle : UITextField!
	@IBOutlet weak var collectionView : UICollectionView!

	///
	/// EventHandler: Scene title was changed
	///
	@IBAction func didChangeTitle(sender: UITextField)
	{
		workingCopyCard!.title = sender.text
	}


	// MARK: COLLECTIONVIEW DATASOURCE/DELEGATE ////////////////////////////////

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
	

	// MARK: HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Creates a new Scene to be edited
	///
	private func generateScene() -> Scene
	{
		let scene = DataUtility.CreateScene()
		workingCopyCard!.scenes.append(scene)
		return scene
	}
}
