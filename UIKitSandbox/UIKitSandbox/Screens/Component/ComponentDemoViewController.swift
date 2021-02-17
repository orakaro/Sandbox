//
//  ComponentDemoViewController.swift
//  UIKitSandbox
//
//  Created by DTVD on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa
import ComponentKit

class ComponentDemoViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!

    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    private let dataSource = SectionedCollectionDataSource<ViewModel.SectionModel, ComponentHeaderViewController, ComponentCellViewController, ComponentDemoViewController>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSource()
        bind()
    }

    private func setUpDataSource() {
        CollectionViewCell<ComponentCellViewController, ComponentDemoViewController>.register(to: collectionView)
        CollectionReusableView<ComponentHeaderViewController, ComponentDemoViewController>.register(to: collectionView, for: .header)
        dataSource.config(parent: self)
    }

    private func bind() {
        viewModel.upstreamData
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ComponentDemoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.bounds.width
        let height: CGFloat = 30
        return CGSize(width: width, height: height)
    }
}

extension ComponentDemoViewController: EventAcceptable {
    typealias Event = Never
}

extension ComponentDemoViewController {
    class ViewModel {
        struct SectionModel: SectionModelType {
            let header: String
            let rows: [CellData]
        }

        let upstreamData: Driver<[SectionModel]> = Driver.just([
            SectionModel(header: "Section 1", rows: [
                CellData(title: "1", image: nil),
                CellData(title: "2", image: nil),
                CellData(title: "3", image: nil),
            ]),
            SectionModel(header: "Section 2", rows: [
                CellData(title: "1", image: nil),
                CellData(title: "2", image: nil),
                CellData(title: "3", image: nil),
                CellData(title: "4", image: nil),
            ]),
        ])
    }
}
