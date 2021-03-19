//
//  Created by Michele Restuccia on 13/3/21.
//

import UIKit
import EssentialKit

extension BeerListViewController {
    
    class CollectionView: UICollectionView, ViewModelConfigurable {
        
        private typealias Constants = BeerListViewController.Constants
        
        struct VM {
            let bannerVM: [BannerCell.VM]
            let featureVM: [FeatureCell.VM]
            let blocksVM: BlocksVM
            let inlineVM: InlineVM
            
            struct BlocksVM {
                let title: String?
                let contents: [BlockCell.VM]
                
                static func empty() -> BlocksVM {
                    return .init(title: nil, contents: [])
                }
            }
            
            struct InlineVM {
                let title: String?
                let contents: [InlineCell.VM]
                
                static func empty() -> InlineVM {
                    return .init(title: nil, contents: [])
                }
            }
            
            static func empty() -> VM {
                return .init(bannerVM: [], featureVM: [], blocksVM: .empty(), inlineVM: .empty())
            }
        }
        private var viewModel: VM = .empty() {
            didSet {
                reloadData()
            }
        }
        
        private let customLayout: UICollectionViewCompositionalLayout = {
            return UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                guard let tableSection = TableSection(rawValue: section) else { return nil }
                switch tableSection {
                case .banner:   return .bannerSectionLayout()
                case .feature:  return .featureSectionLayout()
                case .block:    return .blockSectionLayout()
                case .inline:   return .inlineSectionLayout()
                }
            }
        }()
        
        init() {
            super.init(frame: .zero, collectionViewLayout: customLayout)
            dataSource = self
            delegate = self
            registerReusableCell(BannerCell.self)
            registerReusableCell(FeatureCell.self)
            registerReusableCell(BlockCell.self)
            registerReusableCell(InlineCell.self)
            registerSupplementaryView(HeaderView.self, kind: .header)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: ViewModelConfigurable
        
        func configureFor(viewModel: VM) {
            self.viewModel = viewModel
        }
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate

extension BeerListViewController.CollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    private enum TableSection: Int, CaseIterable {
        case banner = 0, feature, block, inline
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return TableSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tableSection = TableSection(rawValue: section) else { return 0 }
        switch tableSection {
        case .banner:   return viewModel.bannerVM.count
        case .feature:  return viewModel.featureVM.count
        case .block:    return viewModel.blocksVM.contents.count
        case .inline:   return viewModel.inlineVM.contents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tableSection = TableSection(rawValue: indexPath.section) else { fatalError() }
        switch tableSection {
        case .banner:
            let cell: BannerCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureFor(viewModel: viewModel.bannerVM[indexPath.row])
            return cell
        case .feature:
            let cell: FeatureCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureFor(viewModel: viewModel.featureVM[indexPath.row])
            return cell
        case .block:
            let cell: BlockCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureFor(viewModel: viewModel.blocksVM.contents[indexPath.row])
            return cell
        case .inline:
            let cell: InlineCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureFor(viewModel: viewModel.inlineVM.contents[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { fatalError() }
        let v: HeaderView = collectionView.dequeueSupplementaryView(indexPath: indexPath, kind: .header)
        if let tableSection = TableSection(rawValue: indexPath.section) {
            if case .block = tableSection {
                v.configureFor(viewModel: .init(title: viewModel.blocksVM.title))
            }
            if case .inline = tableSection {
                v.configureFor(viewModel: .init(title: viewModel.inlineVM.title))
            }
        }
        return v
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.HeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tableSection = TableSection(rawValue: indexPath.section) else { fatalError() }
        guard let nextResponder = self.next() as BeerListViewController? else { return }
        
        switch tableSection {
        case .banner:
            nextResponder.showTodoAlert()

        case .feature:
            nextResponder.showTodoAlert()

        case .block:
            let ID = viewModel.blocksVM.contents[indexPath.row].ID
            nextResponder.navigateToBeer(ID: ID)

        case .inline:
            let ID = viewModel.inlineVM.contents[indexPath.row].ID
            nextResponder.navigateToBeer(ID: ID)
        }
    }
}

//MARK: NSCollectionLayoutSection

private extension NSCollectionLayoutSection {
    
    private typealias Constants = BeerListViewController.Constants
    
    static func bannerSectionLayout() -> NSCollectionLayoutSection {
        let heightSize: CGFloat = 170
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(heightSize)))
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .absolute(heightSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    static func featureSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: Constants.SmallSpacing, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: Constants.Spacing, leading: Constants.NormalSpacing, bottom: Constants.Spacing, trailing: Constants.NormalSpacing)
        return section
    }
    
    static func blockSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.33)))
        item.contentInsets = .init(top: Constants.NormalSpacing, leading: Constants.NormalSpacing, bottom: Constants.NormalSpacing, trailing: Constants.NormalSpacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: Constants.SmallSpacing, leading: Constants.NormalSpacing, bottom: Constants.Spacing, trailing: Constants.NormalSpacing)
        section.addHeaderElement()
        return section
    }
    
    static func inlineSectionLayout() -> NSCollectionLayoutSection {
        let heightSize: CGFloat = 150
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(heightSize)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: Constants.NormalSpacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),  heightDimension: .absolute(heightSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .init(top: Constants.NormalSpacing, leading: Constants.NormalSpacing, bottom: Constants.Spacing, trailing: Constants.NormalSpacing)
        section.orthogonalScrollingBehavior = .continuous
        section.addHeaderElement()
        return section
    }
    
    private func addHeaderElement() {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(Constants.HeaderHeight))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        boundarySupplementaryItems = [headerElement]
    }
}
