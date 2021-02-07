//
//  TableViewCell.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import RxCocoa
import RxSwift
import UIKit

public class TableViewCell<C: UIViewController & EventEmittable & CellType, P: UIViewController & EventAcceptable>: UITableViewCell, UIComponent where C.Event == P.Event {
    var content: C?
    weak var parent: P?

    static var reuseIdentifier: String {
        return C.className
    }

    public static func register(to tableView: UITableView) {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        content?.disposeBag = DisposeBag()
        content?.prepareForReuse()
        content?.rebind()
    }
}

public extension TableViewCell {
    static func dequeue(from tableView: UITableView, for indexPath: IndexPath, parent: P?) -> TableViewCell {
        guard let parent = parent else {
            fatalError("Parent is not set")
        }
        // Fall warning from Swift Compilter
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! TableViewCell
        if cell.content == nil {
            let contentVC = C(nibName: C.className, bundle: C.bundle)
            cell.embed(content: contentVC, parent: parent)
        }
        if let child = cell.content {
            child.eventEmitter.asSignal()
                .emit(to: parent.eventAcceptor)
                .disposed(by: child.disposeBag)
        }
        return cell
    }
}

public class TableViewHeaderFooterView<C: UIViewController & EventEmittable, P: UIViewController & EventAcceptable>: UITableViewHeaderFooterView, UIComponent where C.Event == P.Event {
    var content: C?
    weak var parent: P?
    override public var contentView: UIView {
        return self
    }

    static var reuseIdentifier: String {
        return C.className
    }

    public static func register(to tableView: UITableView) {
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
}

public extension TableViewHeaderFooterView {
    static func dequeue(from tableView: UITableView, for _: IndexPath, parent: P?) -> TableViewHeaderFooterView {
        guard let parent = parent else {
            fatalError("Parent is not set")
        }
        // Fall warning from Swift Compilter
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as! TableViewHeaderFooterView
        if cell.content == nil {
            let contentVC = C(nibName: C.className, bundle: C.bundle)
            cell.embed(content: contentVC, parent: parent)
        }
        if let child = cell.content {
            child.eventEmitter.asSignal()
                .emit(to: parent.eventAcceptor)
                .disposed(by: child.disposeBag)
        }
        return cell
    }
}
