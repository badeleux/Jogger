//
//  ResourceBasedViewController.swift
//  EDK
//
//  Created by Kamil Badyla on 04.03.2017.
//  Copyright © 2017 Peony Media. All rights reserved.
//

import Foundation
import StatefulViewController
import ReactiveSwift
import EasyPeasy
import Result

protocol LoadingView { }
protocol ErrorView { }
protocol EmptyView { }

protocol ViewControllerProtocol {
    var view: UIView! { get }
}

protocol TableViewControllerProtocol {
    var tableView: UITableView! { get set }
}

extension TableViewControllerProtocol where Self: ViewControllerProtocol & UITableViewDataSource & UITableViewDelegate {
    func setupTableView() -> UITableView {
        let tableView = UITableView(frame: UIScreen.main.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView <- Edges(0)
        return tableView
    }
}

extension UIViewController: ViewControllerProtocol {}

protocol ResourceBasedViewController: StatefulViewController, ViewControllerProtocol {
    associatedtype E: Swift.Error
    associatedtype VM: ResourceViewModelOutput
    var viewModel: VM { get }
    var dataSource: MutableProperty<VM.D?> { get }
}


extension ResourceBasedViewController {
    func setUpEmptyState(content: EmptyStateContent) {
        self.loadingView = EmptyStateLoadingView(frame: view.bounds)
        let errorView = EmptyStateErrorView(frame: view.bounds)
        self.errorView = errorView
        let noContentView = EmptyStateNoContentView(frame: view.bounds)
        noContentView.customize(content: content.noDataContent)
        self.emptyView = noContentView
        
        self.viewModel
            .resourceStatus
            .observe(on: QueueScheduler.main)
            .observeValues { (status: ActionStatus<Self.VM.E>) in
                if status.isLoading {
                    self.startLoading(animated: true, completion: nil)
                }
                else if let e = status.error {
                    errorView.mainLabel.text = e.localizedDescription
                    self.endLoading(animated: true, error: e, completion: nil)
                }
                else {
                    self.endLoading(animated: true, error: nil, completion: nil)
                }
        }
    }
    
    func hasContent() -> Bool {
        if let a = self.dataSource.value as? [Any] {
            return a.count > 0
        }
        return self.dataSource.value != nil
    }
}

protocol ListResourceBasedViewController: TableViewControllerProtocol, ResourceBasedViewController {

}

extension ListResourceBasedViewController where VM: ResourceViewModelInput & ResourceViewModelOutput {
    func setUp(content: EmptyStateContent = .general) {
        self.setUpEmptyState(content: content)
        self.tableView.tableFooterView = UIView()
        self.dataSource.signal.observe(on: QueueScheduler.main).observeValues { [weak self] _ in
            self?.tableView.reloadData()
        }
        self.setUpRefreshControl()
        self.dataSource <~ self.viewModel.resourceData
    }
    
    func setUpRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.reactive.controlEvents(.valueChanged).observeValues { _ in self.viewModel.refresh() }
        refreshControl.reactive.isRefreshing <~ viewModel.resourceStatus.map { $0.isLoading }
        self.tableView.addSubview(refreshControl)
        
    }
}
