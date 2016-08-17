//
//  PageController.swift
//  InteractiveStory
//
//  Created by Gareth Fuller on 16/08/16.
//  Copyright © 2016 Gareth Fuller. All rights reserved.
//

import UIKit

class PageController: UIViewController {
  
  var page: Page?
  
  // we cant change the instance as let but can mutate the properties
  let artwork = UIImageView()
  let storyLabel = UILabel()
  let firstChoiceBtn = UIButton(type: .System)
  let secondChoiceBtn = UIButton(type: .System)
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(page: Page) {
    self.page = page
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = .whiteColor()
    
    if let page = page {
      
      let attributaedString = NSMutableAttributedString(string: page.story.text)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 10
      
      attributaedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributaedString.length))
      
      
      artwork.image = page.story.artwork
      storyLabel.attributedText = attributaedString
      
      if let firstChoice = page.firstChoice {
        firstChoiceBtn.setTitle(firstChoice.title, forState: UIControlState.Normal)
        firstChoiceBtn.addTarget(self, action: #selector(PageController.loadFirstChoice), forControlEvents: .TouchUpInside)
      } else {
        // must be the end
        firstChoiceBtn.setTitle("Play again?", forState: .Normal)
        firstChoiceBtn.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: .TouchUpInside)
      }
      
      // add the second button if it is there as it is an optional
      if let secondChoice = page.secondChoice {
        secondChoiceBtn.setTitle(secondChoice.title, forState: .Normal)
        secondChoiceBtn.addTarget(self, action: #selector(PageController.loadSecondChoice), forControlEvents: .TouchUpInside)
      }
    }
    
  }
  
  // here we can set up the sub views of the view controller
  override func viewWillLayoutSubviews() {
    // this is like dragging to the story board
    view.addSubview(artwork)
    // remove parent view constraints!
    artwork.translatesAutoresizingMaskIntoConstraints = false
    // provide the set of constraints
    NSLayoutConstraint.activateConstraints([
      artwork.topAnchor.constraintEqualToAnchor(view.topAnchor),
      artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
      artwork.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
      artwork.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
    ])
    
    view.addSubview(storyLabel)
    storyLabel.translatesAutoresizingMaskIntoConstraints = false
    // allow multilline
    storyLabel.numberOfLines = 0
    
    NSLayoutConstraint.activateConstraints([
      storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16.0),
      storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -16.0),
      storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -48.0)
    ])
    
    view.addSubview(firstChoiceBtn)
    firstChoiceBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      firstChoiceBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      firstChoiceBtn.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80.0)
    ])
    
    view.addSubview(secondChoiceBtn)
    secondChoiceBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activateConstraints([
      secondChoiceBtn.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
      secondChoiceBtn.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -32)
    ])
    
  }
  
  func loadFirstChoice() {
    // get page instance in first choice and init a new page controller
    if let page = page, firstChoice = page.firstChoice {
      // get the page
      let nextPage = firstChoice.page
      let pageController = PageController(page: nextPage)
      
      // all view controllers have navigation controller
      // can ask the controller to push another controller to the stack, works like the suegue
      // here we call and pass the view controller
      navigationController?.pushViewController(pageController, animated: true)
    }
  }
  
  func loadSecondChoice() {
    if let page = page, secondChoice = page.secondChoice {
      let nextPage = secondChoice.page
      let pageController = PageController(page: nextPage)
      
      navigationController?.pushViewController(pageController, animated: true)
    }
  }
  
  // unwind stack
  func playAgain() {
    navigationController?.popToRootViewControllerAnimated(true)
  }
  
}
