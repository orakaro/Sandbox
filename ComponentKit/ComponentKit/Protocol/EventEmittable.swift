//
//  EventEmittable.swift
//  ComponentKit
//
//  Created by DTVD on 2021/02/08.
//

import RxRelay
import RxSwift
import UIKit

public protocol EventEmittable {
    associatedtype Event
    var disposeBag: DisposeBag { get set }
    var eventEmitter: PublishRelay<Event> { get }
    func rebind()
}

public extension EventEmittable {
    func rebind() {}
}

public protocol EventAcceptable {
    associatedtype Event
    var eventAcceptor: PublishRelay<Event> { get }
}

public extension EventEmittable where Event == Never {
    var eventEmitter: PublishRelay<Event> {
        return PublishRelay<Event>()
    }
}

public extension EventAcceptable where Event == Never {
    var eventAcceptor: PublishRelay<Event> {
        return PublishRelay<Event>()
    }
}
