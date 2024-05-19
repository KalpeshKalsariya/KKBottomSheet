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

# Custom Presentation Controller
For iOS versions earlier than 15, HalfScreenPresentationController is used to present the bottom sheet. It defines the frame for the presented view.

class HalfScreenPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: (containerView.bounds.height / 2) + 150.0, width: containerView.bounds.width, height: (containerView.bounds.height / 2) - 150.0)
    }
}

# Bottom Sheet ViewController
BottomSheetViewController contains the search bar, cancel button, and table view. It manages the search functionality and displays the list of items.

import UIKit

class BottomSheetViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    var noDataLabel: UILabel!
    var data: [String] = []
    var filteredData: [String] = []
    var timerSearch: Timer?
    var selectedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = ["Apple", "Banana", ...]
        filteredData = data
        selectedItem = "Papaya"
        
        setupUI()
        tableView.reloadData()
        
        if let defaultIndex = data.firstIndex(of: selectedItem ?? "") {
            let indexPath = IndexPath(row: defaultIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    private func setupUI() {
        // Initialize UI elements and constraints
        ...
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        timerSearch?.invalidate()
        timerSearch = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(performSearch), userInfo: nil, repeats: false)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            data = filteredData
            noDataLabel.isHidden = !data.isEmpty
            tableView.reloadData()
        }
    }
    
    @objc func performSearch() {
        guard let searchText = searchBar.text?.lowercased(), !searchText.isEmpty else {
            data = filteredData
            noDataLabel.isHidden = !data.isEmpty
            tableView.reloadData()
            return
        }
        
        selectedItem = ""
        data = filteredData.filter { $0.lowercased().contains(searchText) }
        noDataLabel.isHidden = !data.isEmpty
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = data[indexPath.row]
        cell.textLabel?.text = item
        
        if item == selectedItem {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
}

# Custom Transition Animations
BottomSheetTransitioningDelegate manages the custom presentation and dismissal animations.

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetPresentAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomSheetDismissAnimator()
    }
}

