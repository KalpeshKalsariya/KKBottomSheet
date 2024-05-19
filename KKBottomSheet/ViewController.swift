//
//  ViewController.swift
//  KKBottomSheet
//
//  Created by  Kalpesh on 19/05/24.
//

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
                presentationController.detents = [.medium()/*, .large()*/]
            }
        } else {
            // Custom presentation for earlier versions
            let transitioningDelegate = BottomSheetTransitioningDelegate()
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = transitioningDelegate
            self.bottomSheetTransitioningDelegate = transitioningDelegate // Hold a strong reference
        }
        
        present(bottomSheetVC, animated: true, completion: nil)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfScreenPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: (containerView.bounds.height / 2)+150.0, width: containerView.bounds.width, height: (containerView.bounds.height / 2)-150.0)
    }
}
