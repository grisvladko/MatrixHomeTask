//
//  ViewController.swift
//  MatrixHomeTask
//
//  Created by hyperactive hi-tech ltd on 11/08/2021.
//  Copyright © 2021 hyperactive. All rights reserved.
//

import UIKit

class SmoothOrPaggedViewController: UIViewController {
    
    private let service = Service()
    private let parser = JSONParser()
    private let errorHandler = ErrorHandler()
    
    private var tableView: UITableView! = nil
    private var categories: [CategoryModel] = []
    private var cardModels: [CardModel] = []
    
    private var currentState: Constants.TabCase = .allBenefits // default when program starts
    private var cellHeight: CGFloat?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nav = navigationController as? TabNavigationController {
            nav.setTabHidden(false)
            navigationItem.hidesBackButton = true
        }
        
        #if DEBUG
        setupForTesting()
        #endif
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        Cache.shared.clear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.reloadData()
    }
    

    func setCurrentState(_ newState: Constants.TabCase) {
        currentState = newState
    }
    
    private func setup() {
        getServiceData()
        setTableView()
    }
    
    private func setupForTesting() {
        tableView.accessibilityIdentifier = "MainTableView"
        tableView.isAccessibilityElement = true
    }
    
    private func getServiceData() {
        if cacheHasData() {
            setupDataForDataSource()
            return 
        }
        
        service.getData { [weak self] (result) in
            do {
                let res = self?.parser.parse(json: try result.get())
                self?.handleParserResult(result: res!)
            } catch {
                self?.errorHandler.handleError(type: .service, error: error)
            }
        }
    }
    
    private func cacheHasData() -> Bool {
        var didCacheCards = false
        var didCacheCategories = false
        
        if let cachedCards = Cache.shared.get(Constants.JSONFields.DataListObject.rawValue as AnyObject) as? [CardModel] {
            didCacheCards = true
            self.cardModels = cachedCards
        }
        
        if let cachedCategories = Cache.shared.get(Constants.JSONFields.DataListCat.rawValue as AnyObject) as? [CategoryModel] {
            didCacheCategories = true
            self.categories = cachedCategories
        }
        
        return didCacheCategories && didCacheCards
    }
    
    private func handleParserResult(result: Result<(dataListCat : [CategoryModel], dataListObject: [CardModel]), Error>) {
        do {
            let data = try result.get()
            categories = data.dataListCat
            cardModels = data.dataListObject
            setupDataForDataSource()
        } catch {
            errorHandler.handleError(type: .service, error: error)
        }
    }
    
    private func setupDataForDataSource() {
        categories.sort()
        for card in cardModels {
            let i : Int = Int(card.CatId - 1)
            categories[i].cardModels.append(card)
        }
        
        callWhenFinishedDataFetching()
    }
    
    private func callWhenFinishedDataFetching() {
        guard tableView != nil else { return }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setTableView() {
        tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.register(CollectionContainingCell.self, forCellReuseIdentifier: Constants.CellIds.category.rawValue)
        tableView.insetsContentViewsToSafeArea = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.pin(tableView, insets: .zero)
        
        #if DEBUG
        setupForTesting()
        #endif
    }
}

extension SmoothOrPaggedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.category.rawValue, for: indexPath) as! CollectionContainingCell
        
        let layoutStyle: Constants.LayoutStyle = currentState == .allBenefits ? .smooth : .pagged
        cell.setup(layoutStyle, category: categories[indexPath.section], navigationDelegate: self)
        
        #if DEBUG
        cell.setupForDebbuging(indexPath)
        #endif
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].CTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .white
        header.textLabel?.textAlignment = .right
        if traitCollection.horizontalSizeClass != .compact  && traitCollection.verticalSizeClass != .compact {
            header.textLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        }
        header.layoutSubviews()
    }
}

extension SmoothOrPaggedViewController: NavigationDelegate {
    
    internal func navigate(to card: CardModel, categoryName: String) {
        let vc = CardDetailsViewController()
        vc.card = card
        vc.categoryName = categoryName
        let backBtn = UIBarButtonItem(title: categoryName, style: .plain, target: nil, action: nil)
        backBtn.tintColor = .tabButtonSelected
        navigationItem.backBarButtonItem = backBtn
        show(vc, sender: nil)
    }
}

extension SmoothOrPaggedViewController: ErrorHandlerDelegate {
    func handleConnectionFix() {
        guard tableView != nil else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


