//
//  AlbumsViewController.swift
//  Picker
//
//  Created by 한현규 on 3/5/24.
//

import ModernRIBs
import UIKit

protocol AlbumsPresentableListener: AnyObject {
    func albumDidTap(_ viewModel: AlbumViewModel)
}

final class AlbumsViewController: UIViewController, AlbumsPresentable, AlbumsViewControllable {

    weak var listener: AlbumsPresentableListener?
        
    private var viewModels: [AlbumViewModel]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: AlbumCell.self)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    init(){
        viewModels = []
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        viewModels = []
        super.init(coder: coder)
        
        setLayout()
    }

    
    private func setLayout(){
        self.view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    
    func showAlbums(_ viewModels: [AlbumViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
        
    
}


extension AlbumsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AlbumCell.self)
        cell.bindView(viewModels[indexPath.row])
        return cell
    }
}

extension AlbumsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
        listener?.albumDidTap(viewModels[indexPath.row])
    }
}
