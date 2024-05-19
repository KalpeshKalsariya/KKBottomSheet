# KKBottomSheet

KKBottomSheet is an iOS application that demonstrates how to implement a bottom sheet using UISheetPresentationController for iOS 15 and later, and a custom presentation controller for earlier versions. This example includes a search bar, a cancel button, and a table view that displays a list of fruits.

# Features
- Bottom sheet presentation for both iOS 15+ and earlier versions
- Search bar to filter items in the table view
- Cancel button to dismiss the bottom sheet
- Highlighting of the selected item
- Smooth animations for presenting and dismissing the bottom sheet

# Requirements
- iOS 13.0+ 
- Swift 5
- Xcode 12.0+

# Usage
# Main ViewController
ViewController is the main view controller that presents the bottom sheet. It includes a button that triggers the presentation of BottomSheetViewController.

import UIKit

class ViewController: UIViewController {
    
    private var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTapToOpenBottom_Action(_ sender: UIButton) {
        self.presentBottomSheet()
    }
    
    func presentBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        
        if #available(iOS 15.0, *) {
            if let presentationController = bottomSheetVC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
        } else {
            let transitioningDelegate = BottomSheetTransitioningDelegate()
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = transitioningDelegate
            self.bottomSheetTransitioningDelegate = transitioningDelegate // Hold a strong reference
        }
        
        present(bottomSheetVC, animated: true, completion: nil)
    }
}
