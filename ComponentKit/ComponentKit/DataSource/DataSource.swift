//
//  DataSource.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import RxCocoa
import RxSwift
import UIKit

// CollectionView can have many different Cell types. Each can have different Input type.
// If T of DataSource can convert to each of those Input type then we allow to dequeReusable
public final class CollectionDataSource<T: Convertible, Cell: UIViewController & CellType & EventEmittable, Parent: UIViewController & EventAcceptable>: NSObject, RxCollectionViewDataSourceType, UICollectionViewDataSource where T.Target == Cell.Input, Cell.Event == Parent.Event {
    public typealias Element = [T]

    public private(set) var element: Element = []
    private weak var parent: Parent?

    public func config(parent: Parent) {
        self.parent = parent
    }

    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        if case let .next(element) = observedEvent {
            self.element = element
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    public func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return element.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewCell<Cell, Parent>.dequeue(from: collectionView, for: indexPath, parent: parent)
        let input = element[indexPath.row].convert()
        cell.content?.apply(input: input)
        return cell
    }
}

// TableView can have many different Cell types. Each can have different Input type.
// If T of DataSource can convert to each of those Input type then we allow to dequeReusable
public final class TableDataSource<T: Convertible, Cell: UIViewController & CellType & EventEmittable, Parent: UIViewController & EventAcceptable>: NSObject, RxTableViewDataSourceType, UITableViewDataSource where T.Target == Cell.Input, Cell.Event == Parent.Event {
    public typealias Element = [T]

    public private(set) var element: Element = []
    private weak var parent: Parent?
    private var sectionTitles: [String] = []

    public func config(parent: Parent, sectionTitles: [String] = []) {
        self.parent = parent
        self.sectionTitles = sectionTitles
    }

    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        if case let .next(element) = observedEvent {
            self.element = element
            tableView.reloadData()
        }
    }

    public func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return element.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell<Cell, Parent>.dequeue(from: tableView, for: indexPath, parent: parent)
        let input = element[indexPath.row].convert()
        cell.content?.apply(input: input)
        return cell
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[safe: section]
    }
}
