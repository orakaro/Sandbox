//
//  CollectionViewCell.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import UIKit
import RxCocoa
import RxSwift

public class CollectionViewCell<C: UIViewController & EventEmittable & CellType, P: UIViewController & EventAcceptable>: UICollectionViewCell, UIComponent where C.Event == P.Event {
    var content: C?
    weak var parent: P?

    static var reuseIdentifier: String {
        return C.className
    }

    public static func register(to collectionView: UICollectionView) {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        content?.disposeBag = DisposeBag()
        content?.prepareForReuse()
        content?.rebind()
    }
}

public extension CollectionViewCell {
    static func dequeue(from collectionView: UICollectionView, for indexPath: IndexPath, parent: P?) -> CollectionViewCell {
        guard let parent = parent else {
            fatalError("Parent is not set")
        }
        // Fall warning from Swift Compilter
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
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

public enum CollectionViewSupplementaryKind {
    case header
    case footer

    var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

public class CollectionReusableView<C: UIViewController & EventEmittable, P: UIViewController & EventAcceptable>: UICollectionReusableView, UIComponent where C.Event == P.Event {
    var content: C?
    weak var parent: P?
    var contentView: UIView {
        return self
    }

    static var reuseIdentifier: String {
        return C.className
    }

    public static func register(to collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind) {
        collectionView.register(CollectionReusableView.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: reuseIdentifier)
    }
}

public extension CollectionReusableView {
    static func dequeue(from collectionView: UICollectionView, of kind: CollectionViewSupplementaryKind, for indexPath: IndexPath, parent: P?) -> CollectionReusableView {
        guard let parent = parent else {
            fatalError("Parent is not set")
        }
        // Fall warning from Swift Compilter
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionReusableView
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
