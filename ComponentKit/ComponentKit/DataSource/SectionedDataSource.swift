//
//  SectionedDataSource.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import RxCocoa
import RxSwift
import UIKit

public protocol SectionModelType {
    associatedtype RowType
    var header: String { get }
    var rows: [RowType] { get }
}

// A CollectionView DataSource that supports sections
public final class SectionedCollectionDataSource<SectionModel: SectionModelType, Cell: UIViewController & CellType & EventEmittable, Parent: UIViewController & EventAcceptable>: NSObject, RxCollectionViewDataSourceType, UICollectionViewDataSource where SectionModel.RowType: Convertible, SectionModel.RowType.Target == Cell.Input, Cell.Event == Parent.Event {
    public typealias Element = [SectionModel]

    public private(set) var sections: [SectionModel] = []
    private weak var parent: Parent?

    public func config(parent: Parent) {
        self.parent = parent
    }

    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        if case let .next(element) = observedEvent {
            self.sections = element
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    public func numberOfSections(in _: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[safe: section]?.rows.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewCell<Cell, Parent>.dequeue(from: collectionView, for: indexPath, parent: parent)
        if let input = item(at: indexPath)?.convert() {
            cell.content?.apply(input: input)
        }
        return cell
    }

    public func item(at indexPath: IndexPath) -> SectionModel.RowType? {
        sections[safe: indexPath.section]?.rows[safe: indexPath.row]
    }
}

// A TableView DataSource that supports sections
public final class SectionedTableDataSource<SectionModel: SectionModelType, Cell: UIViewController & CellType & EventEmittable, Parent: UIViewController & EventAcceptable>: NSObject, RxTableViewDataSourceType, UITableViewDataSource where SectionModel.RowType: Convertible, SectionModel.RowType.Target == Cell.Input, Cell.Event == Parent.Event {
    public typealias Element = [SectionModel]

    public private(set) var sections: [SectionModel] = []
    private weak var parent: Parent?

    public func config(parent: Parent) {
        self.parent = parent
    }

    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        if case let .next(element) = observedEvent {
            self.sections = element
            tableView.reloadData()
        }
    }

    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.rows.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell<Cell, Parent>.dequeue(from: tableView, for: indexPath, parent: parent)
        if let input = item(at: indexPath)?.convert() {
            cell.content?.apply(input: input)
        }
        return cell
    }

    public func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[safe: section]?.header
    }

    public func item(at indexPath: IndexPath) -> SectionModel.RowType? {
        sections[safe: indexPath.section]?.rows[safe: indexPath.row]
    }
}
