//
//  PhotoGridView.swift
//
//
//  Created by 한현규 on 3/3/24.
//

import UIKit
import UIUtils


final class PhotoGridView: UIView{
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.collectionViewLayout = getCollectionViewLayout()

        collectionView.register(cellType: PhotoCell.self)
        
        return collectionView
    }()
    
    private var viewModel: AlbumViewModel?
    
    init(){
        super.init(frame: .zero)
        
        setView()
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
    
    
    func showPhotos(_ viewModel: AlbumViewModel){
        self.viewModel = viewModel
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
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCell.self)
        let viewModel = PhotoViewModel(viewModel!.photo(indexPath.row)) 
        cell.bindPhoto(viewModel)
        return cell
    }
}
