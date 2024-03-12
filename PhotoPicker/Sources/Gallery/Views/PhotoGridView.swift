//
//  PhotoGridView.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import UIKit
import UIUtils
import GalleryUtils
import Selection
import AlbumEntity
import Photos


protocol PhotoGridViewDelegate: AnyObject{
    func photoDidTap(_ photo: Photo)
}

final class PhotoGridView: UIView{
    
    private var viewModel: PhotoGridViewModel?
    weak var delegate: PhotoGridViewDelegate?
    
    private let imageManager: PHAssetCacheManager = PHAssetCacheManager.shared()
    
            
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        collectionView.collectionViewLayout = getCollectionViewLayout()
        collectionView.register(cellType: PhotoGridCell.self)
                
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    deinit{
        imageManager.stopCachingImagesForAllAssets()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        addSubview(collectionView)

        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    func showPhotos(_ viewModel: PhotoGridViewModel){
        self.viewModel = viewModel
        collectionView.reloadData()
    }
    
    func albumChanged(_ change: AlbumChange){
        guard let fetchResult = viewModel?.fetchResult,
              let changeDetails = change.changeDetails(fetchResult) else { return }
        
        viewModel?.fetchResult = changeDetails.fetchResult()
                        
        
        if let insertedIndex = changeDetails.insertedIndex{
            collectionView.insertItems(at: insertedIndex)
        }
        
        if let removedIndexes = changeDetails.removedIndexes{
            collectionView.deleteItems(at: removedIndexes)
        }
                
        
        if let changedIndex = changeDetails.changedIndex{
            collectionView.reloadItems(at: changedIndex)
        }
    }
    
    func limitedAlbumChanged(_ change: AlbumChange){
        guard let fetchResult = viewModel?.fetchResult,
              let changeDetails = change.changeDetails(fetchResult) else { return }                                
        viewModel?.fetchResult = changeDetails.fetchResult()
        collectionView.reloadData()
    }
    
    private func getCollectionViewLayout() -> UICollectionViewLayout{
        let section = getListTypeSection()
        let compositional = UICollectionViewCompositionalLayout(section: section)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        compositional.configuration = config
        return compositional
    }
    
    private func getListTypeSection() -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1 / 5
        let inset: CGFloat = 1.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(0.0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init()
        section.interGroupSpacing = 0.0
                       
        return section
    }
}


extension PhotoGridView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoGridCell.self)                
        let viewModel = PhotoGridCellViewModel(
            photo: viewModel!.photo(indexPath.row),
            isSelect: viewModel!.isSelect(indexPath.row),
            selectNum: viewModel!.selectNum(indexPath.row)
        )
        cell.bindPhoto(viewModel)
        return cell
    }
}

extension PhotoGridView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel!.photo(indexPath.row)
        delegate?.photoDidTap(photo)
        
        UIView.performWithoutAnimation {
            collectionView.reloadData()
        }
    }
}

extension PhotoGridView: UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let assets = indexPaths
            .compactMap { viewModel!.photo($0.row) }
            .map { $0.asset }
        imageManager.startCachingImages(for: assets)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let assets = indexPaths
            .compactMap { viewModel!.photo($0.row) }
            .map { $0.asset }
        imageManager.stopCachingImages(for: assets)
    }
}
