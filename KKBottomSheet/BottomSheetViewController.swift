//
//  BottomSheetViewController.swift
//  KKBottomSheet
//
//  Created by  Kalpesh on 19/05/24.
//

import Foundation
import UIKit

class BottomSheetViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    var noDataLabel: UILabel!
    var data: [String] = [] // Your data array
    var filteredData: [String] = [] // Filtered data array
    var timerSearch: Timer?
    var selectedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add data to the array
        data = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape",
                "Honeydew", "Indian Fig", "Jackfruit", "Kiwi", "Lemon", "Mango",
                "Nectarine", "Orange", "Papaya", "Quince", "Raspberry", "Strawberry",
                "Tangerine", "Ugli Fruit", "Vanilla Bean", "Watermelon", "Xigua",
                "Yellow Passion Fruit", "Zucchini"]
        filteredData = data // Initially, filteredData should be the same as data
        
        // Set default selected item
        selectedItem = "Papaya"
        
        setupUI()
        tableView.reloadData() // Reload data to update the selection
        
        // Scroll to the selected item
        if let defaultIndex = data.firstIndex(of: selectedItem ?? "") {
            let indexPath = IndexPath(row: defaultIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    private func setupUI() {
        // Initialize Search Bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage() // To make the search bar background clear
        searchBar.backgroundColor = .white

        // Initialize Cancel Button
        cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize Stack View
        let stackView = UIStackView(arrangedSubviews: [searchBar, cancelButton])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize Container View for Stack View
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        view.addSubview(containerView)
        
        // Initialize Table View
        tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Initialize No Data Label
        noDataLabel = UILabel()
        noDataLabel.text = "No data available"
        noDataLabel.textAlignment = .center
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataLabel)
        
        noDataLabel.isHidden = !data.isEmpty
        
        // Set up constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noDataLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate
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
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = data[indexPath.row]
        cell.textLabel?.text = item
        
        // Highlight the selected item
        if item == selectedItem {
            cell.backgroundColor = UIColor.lightGray // Change this color as needed
        } else {
            cell.backgroundColor = UIColor.white // Default color
        }
        
        return cell
    }
}

class BottomSheetPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        dimmingView.alpha = 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        
        let size = CGSize(width: containerView.bounds.width, height: containerView.bounds.height * 0.5)
        let origin = CGPoint(x: 0, y: containerView.bounds.height - size.height)
        return CGRect(origin: origin, size: size)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        
        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    @objc private func dimmingViewTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

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

class BottomSheetPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        let initialFrame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        toViewController.view.frame = initialFrame
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

class BottomSheetDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        let finalFrame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
