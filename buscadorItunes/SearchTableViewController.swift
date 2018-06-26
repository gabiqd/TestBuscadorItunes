//
//  SearchTableViewController.swift
//  buscadorItunes
//
//  Created by Gabriel Quispe Delgadillo on 21/6/18.
//  Copyright © 2018 Gabriel Quispe Delgadillo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import AVFoundation
import AVKit

class SearchTableViewController: BaseTableViewController {
    let headerCellID = "headerCellID"
    let musicCellID = "musicCellID"
    let tvShowCellID = "tvShowCellID"
    let movieCellID = "movieCellID"
    
    var itemsList: [(object: AnyObject, mediaType: MediaType)]?
    let networkService = NetworkingServices()
    
    var playerView: CustomPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Search"
        self.edgesForExtendedLayout = []
        
        initViews()
        setUpConstraints()
    }
    
    func initViews() {
        self.tableView = {
            let searchTableView = UITableView()
            searchTableView.register(SearchHeaderTableViewCell.self, forHeaderFooterViewReuseIdentifier: headerCellID)
            searchTableView.register(MusicTableViewCell.self, forCellReuseIdentifier: musicCellID)
            searchTableView.register(TvShowTableViewCell.self, forCellReuseIdentifier: tvShowCellID)
            searchTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: movieCellID)
            
            searchTableView.dataSource = self
            searchTableView.delegate = self
            
            searchTableView.estimatedRowHeight = 160
            searchTableView.rowHeight = UITableViewAutomaticDimension
            searchTableView.estimatedSectionHeaderHeight = 160
            searchTableView.sectionHeaderHeight = UITableViewAutomaticDimension
            searchTableView.separatorStyle = .none
            
            return searchTableView
        }()
        
        playerView = {
            let playerView = CustomPlayer()
            playerView.translatesAutoresizingMaskIntoConstraints = false
            return  playerView
        }()
        
    }
    
    func setUpConstraints() {
        guard let contentView = self.navigationController?.view else {
            return
        }
        
        self.navigationController?.view.addSubview(playerView)
        
        playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        
    }
    
    func getSearchResult(searchInputText: String, mediaTypes: [MediaType]) {
        if mediaTypes.isEmpty {
            showDialogBlurMessage(title: "No media type", description: "Please, select at least one media type that you want to look for.")
        }else{
            startLoading()
            self.itemsList?.removeAll()
            self.tableView.reloadData()
            networkService.getSearchResult(searchQuery: searchInputText, mediaTypes: mediaTypes) { (result, error) in
                if result.isEmpty {
                    self.showDialogBlurMessage(title: "No matchs found", description: "Please try with another keyword")
                }
                self.itemsList = result
                self.tableView.reloadData()
                self.stopLoading()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellID) as? SearchHeaderTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.titleLabel.text = "¿What are you looking for?"
        cell.parentViewController = self
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = itemsList?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mediaObject = itemsList![indexPath.row]

        switch mediaObject.mediaType {
        case .music:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: musicCellID, for: indexPath) as? MusicTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            let musicPlaceholderString = "musicPlaceholder"
            let musicObject = itemsList![indexPath.row].object as! Music
            cell.songTitleLabel.text = musicObject.title
            cell.songArtistLabel.text = musicObject.artistName
            cell.parentViewController = self
            cell.musicObject = musicObject
            guard let discPicURL = musicObject.discImageURL else{
                cell.discImageView.image = UIImage(named: musicPlaceholderString)
                return cell
            }
            
            let picURL = URL(string: discPicURL)!
            let placeholderImage = UIImage(named: musicPlaceholderString)
            cell.discImageView.kf.indicatorType = .activity
            cell.discImageView.kf.setImage(with: picURL, placeholder: placeholderImage)
            return cell
        case .tvShow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: tvShowCellID, for: indexPath) as? TvShowTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            let tvShowPlaceholderString = "tvShowPlaceholder"
            let tvShowObject = itemsList![indexPath.row].object as! TVShow
            cell.tvShowTitleLabel.text = tvShowObject.title
            cell.tvShowEpisodeNameLabel.text = tvShowObject.episodeName
            cell.tvShowDescriptionLabel.text = tvShowObject.description
            cell.parentViewController = self
            cell.previewUrl = tvShowObject.previewURL
            guard let tvShowPicURL = tvShowObject.imageURL else{
                cell.tvShowImageView.image = UIImage(named: tvShowPlaceholderString)
                return cell
            }
            
            let picURL = URL(string: tvShowPicURL)!
            let placeholderImage = UIImage(named: tvShowPlaceholderString)
            cell.tvShowImageView.kf.indicatorType = .activity
            cell.tvShowImageView.kf.setImage(with: picURL, placeholder: placeholderImage)
            return cell
        case .movie:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieCellID, for: indexPath) as? MovieTableViewCell else {
                fatalError("Unexpected Index Path")
            }
            let moviePlaceholderString = "moviePlaceholder"
            let movieObject = itemsList![indexPath.row].object as! Movie
            cell.movieTitleLabel.text = movieObject.title
            cell.movieDescriptionLabel.text = movieObject.description
            cell.parentViewController = self
            cell.previewUrl = movieObject.previewURL
            guard let moviePicURL = movieObject.imageURL else{
                cell.movieImageView.image = UIImage(named: moviePlaceholderString)
                return cell
            }
            
            let picURL = URL(string: moviePicURL)!
            let placeholderImage = UIImage(named: moviePlaceholderString)
            cell.movieImageView.kf.indicatorType = .activity
            cell.movieImageView.kf.setImage(with: picURL, placeholder: placeholderImage)
            return cell
        }
        
    }
}

class SearchHeaderTableViewCell: UITableViewHeaderFooterView {
    var titleLabel: UILabel!
    var searchInputField: UITextView!
    var searchButton: CustomButton!
    var auxSelectMediaTypeView: UIView!
    var musicOptionButton: SelectionButton!
    var movieOptionButton: SelectionButton!
    var tvShowOptionButton: SelectionButton!
    var parentViewController: SearchTableViewController!
    
    var mediaTypes: [MediaType] = []
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initViews()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        titleLabel = {
            let titleLabel = UILabel()
            titleLabel.textColor = UIColor.darkGray
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.textAlignment = .left
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.sizeToFit()
            return titleLabel
        }()
        
        searchInputField = {
            let searchInputField = UITextView()
            searchInputField.translatesAutoresizingMaskIntoConstraints = false
            searchInputField.sizeToFit()
            searchInputField.layer.backgroundColor = UIColor.lightText.cgColor
            searchInputField.font = UIFont.systemFont(ofSize: 16.0)
            searchInputField.isEditable = true
            searchInputField.autocorrectionType = .yes
            searchInputField.textColor = .black
            searchInputField.tintColor = UIColor.primaryColor
            searchInputField.delegate = self
            searchInputField.textAlignment = .left
            searchInputField.isScrollEnabled = false
            return searchInputField
        }()
        
        searchButton = {
            let searchButton = CustomButton()
            searchButton.translatesAutoresizingMaskIntoConstraints = false
            searchButton.setTitle("Search", for: .normal)
            searchButton.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
            return searchButton
        }()
        
        auxSelectMediaTypeView = {
            let auxSelectMediaTypeView = UIView()
            auxSelectMediaTypeView.translatesAutoresizingMaskIntoConstraints = false
            return auxSelectMediaTypeView
        }()
        
        musicOptionButton = {
            let musicOptionButton = SelectionButton()
            musicOptionButton.translatesAutoresizingMaskIntoConstraints = false
            musicOptionButton.setTitle(MediaType.music.description, for: .normal)
            musicOptionButton.addTarget(self, action: #selector(musicSelected), for: .touchUpInside)
            return musicOptionButton
        }()
        
        movieOptionButton = {
            let movieOptionButton = SelectionButton()
            movieOptionButton.translatesAutoresizingMaskIntoConstraints = false
            movieOptionButton.setTitle(MediaType.movie.description, for: .normal)
            movieOptionButton.addTarget(self, action: #selector(movieSelected), for: .touchUpInside)
            return movieOptionButton
        }()
        
        tvShowOptionButton = {
            let tvShowOptionButton = SelectionButton()
            tvShowOptionButton.translatesAutoresizingMaskIntoConstraints = false
            tvShowOptionButton.setTitle(MediaType.tvShow.description, for: .normal)
            tvShowOptionButton.addTarget(self, action: #selector(tvShowSelected), for: .touchUpInside)
            return tvShowOptionButton
        }()
    }
    
    func setupViews() {
        
        self.addSubview(titleLabel)
        self.addSubview(searchInputField)
        self.addSubview(searchButton)
        self.addSubview(auxSelectMediaTypeView)
        auxSelectMediaTypeView.addSubview(musicOptionButton)
        auxSelectMediaTypeView.addSubview(movieOptionButton)
        auxSelectMediaTypeView.addSubview(tvShowOptionButton)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: searchInputField.topAnchor, constant: -16.0).isActive = true
        
        searchInputField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0).isActive = true
        searchInputField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        searchInputField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -24.0).isActive = true
        searchInputField.bottomAnchor.constraint(equalTo: auxSelectMediaTypeView.topAnchor, constant: -16.0).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchInputField.trailingAnchor, constant: 24.0).isActive = true
        
        auxSelectMediaTypeView.topAnchor.constraint(equalTo: searchInputField.bottomAnchor, constant: 16.0).isActive = true
        auxSelectMediaTypeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        auxSelectMediaTypeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        auxSelectMediaTypeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24.0).isActive = true
        
        musicOptionButton.topAnchor.constraint(equalTo: auxSelectMediaTypeView.topAnchor, constant: 0.0).isActive = true
        musicOptionButton.trailingAnchor.constraint(equalTo: movieOptionButton.leadingAnchor, constant: -16.0).isActive = true
        musicOptionButton.leadingAnchor.constraint(equalTo: auxSelectMediaTypeView.leadingAnchor, constant: 0.0).isActive = true
        musicOptionButton.bottomAnchor.constraint(equalTo: auxSelectMediaTypeView.bottomAnchor, constant: 0.0).isActive = true
        
        movieOptionButton.topAnchor.constraint(equalTo: auxSelectMediaTypeView.topAnchor, constant: 0.0).isActive = true
        movieOptionButton.trailingAnchor.constraint(equalTo: tvShowOptionButton.leadingAnchor, constant: -16.0).isActive = true
        movieOptionButton.leadingAnchor.constraint(equalTo: musicOptionButton.trailingAnchor, constant: 16.0).isActive = true
        movieOptionButton.bottomAnchor.constraint(equalTo: auxSelectMediaTypeView.bottomAnchor, constant: 0.0).isActive = true
        
        tvShowOptionButton.topAnchor.constraint(equalTo: auxSelectMediaTypeView.topAnchor, constant: 0.0).isActive = true
        tvShowOptionButton.leadingAnchor.constraint(equalTo: movieOptionButton.trailingAnchor, constant: 16.0).isActive = true
        tvShowOptionButton.bottomAnchor.constraint(equalTo: auxSelectMediaTypeView.bottomAnchor, constant: 0.0).isActive = true
        
    }
    
    @objc func searchClicked() {
        searchInputField.resignFirstResponder()
        parentViewController.getSearchResult(searchInputText: searchInputField.text, mediaTypes: mediaTypes)
    }
    
    @objc func musicSelected() {
        if let index = mediaTypes.index(of: .music) {
            mediaTypes.remove(at: index)
            musicOptionButton.isSelected = false
        }else{
            mediaTypes.append(.music)
            musicOptionButton.isSelected = true
        }
    }
    
    @objc func movieSelected() {
        if let index = mediaTypes.index(of: .movie) {
            mediaTypes.remove(at: index)
            movieOptionButton.isSelected = false
        }else{
            mediaTypes.append(.movie)
            movieOptionButton.isSelected = true
        }
    }
    
    @objc func tvShowSelected() {
        if let index = mediaTypes.index(of: .tvShow) {
            mediaTypes.remove(at: index)
            tvShowOptionButton.isSelected = false
        }else{
            mediaTypes.append(.tvShow)
            tvShowOptionButton.isSelected = true
        }
    }
    
    
}

extension SearchHeaderTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            parentViewController.getSearchResult(searchInputText: searchInputField.text, mediaTypes: mediaTypes)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

class MusicTableViewCell: UITableViewCell {
    var songTitleLabel: UILabel!
    var songArtistLabel: UILabel!
    var auxSongDetailsView: UIView!
    var discImageView: UIImageView!
    
    var parentViewController: SearchTableViewController!
    var musicObject: Music!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedSong))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
        
        initViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        auxSongDetailsView = {
            let auxSongDetailsView = UIView()
            auxSongDetailsView.translatesAutoresizingMaskIntoConstraints = false
            return auxSongDetailsView
        }()
        
        songTitleLabel = {
            let songTitleLabel = UILabel()
            songTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            songTitleLabel.textColor = .black
            songTitleLabel.numberOfLines = 0
            songTitleLabel.lineBreakMode = .byWordWrapping
            songTitleLabel.sizeToFit()
            songTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            return songTitleLabel
        }()
        
        songArtistLabel = {
            let songArtistLabel = UILabel()
            songArtistLabel.translatesAutoresizingMaskIntoConstraints = false
            songArtistLabel.textColor = UIColor.darkGray
            songArtistLabel.numberOfLines = 0
            songArtistLabel.lineBreakMode = .byWordWrapping
            songArtistLabel.sizeToFit()
            songArtistLabel.font = UIFont.systemFont(ofSize: 16.0)
            return songArtistLabel
        }()
        
        discImageView = {
            let discImageView = UIImageView()
            discImageView.translatesAutoresizingMaskIntoConstraints = false
            
            discImageView.layer.cornerRadius = 4
            discImageView.layer.masksToBounds = true
            discImageView.contentMode = .scaleAspectFill
            return discImageView
        }()
    }
    
    func setUpConstraints() {
        self.addSubview(auxSongDetailsView)
        auxSongDetailsView.addSubview(songTitleLabel)
        auxSongDetailsView.addSubview(songArtistLabel)
        self.addSubview(discImageView)
        
        
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songTitleLabel]))
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songArtistLabel]))
        auxSongDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-12-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": songTitleLabel, "v1": songArtistLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": auxSongDetailsView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(56)]-24-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": discImageView, "v1": auxSongDetailsView]))
        
        let centerYConst = NSLayoutConstraint(item: discImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: discImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 56.0)
        discImageView.addConstraint(heightConstraint)
        NSLayoutConstraint.activate([centerYConst])
    }
    
    @objc func clickedSong() {
        parentViewController.playerView.playPreview(music: musicObject)
    }
}

class TvShowTableViewCell: UITableViewCell {
    var tvShowTitleLabel: UILabel!
    var tvShowDescriptionLabel: UILabel!
    var tvShowEpisodeNameLabel: UILabel!
    var auxTvShowDetailsView: UIView!
    var tvShowImageView: UIImageView!
    
    var parentViewController: SearchTableViewController!
    var previewUrl: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchVideo))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
        
        initViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        auxTvShowDetailsView = {
            let auxTvShowDetailsView = UIView()
            auxTvShowDetailsView.translatesAutoresizingMaskIntoConstraints = false
            return auxTvShowDetailsView
        }()
        
        tvShowTitleLabel = {
            let tvShowTitleLabel = UILabel()
            tvShowTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            tvShowTitleLabel.textColor = .black
            tvShowTitleLabel.numberOfLines = 0
            tvShowTitleLabel.lineBreakMode = .byWordWrapping
            tvShowTitleLabel.sizeToFit()
            tvShowTitleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            return tvShowTitleLabel
        }()
        
        tvShowEpisodeNameLabel = {
            let tvShowEpisodeNameLabel = UILabel()
            tvShowEpisodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
            tvShowEpisodeNameLabel.textColor = UIColor.black
            tvShowEpisodeNameLabel.numberOfLines = 0
            tvShowEpisodeNameLabel.lineBreakMode = .byWordWrapping
            tvShowEpisodeNameLabel.sizeToFit()
            tvShowEpisodeNameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            return tvShowEpisodeNameLabel
        }()
        
        tvShowDescriptionLabel = {
            let tvShowDescriptionLabel = UILabel()
            tvShowDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            tvShowDescriptionLabel.textColor = UIColor.darkGray
            tvShowDescriptionLabel.numberOfLines = 0
            tvShowDescriptionLabel.lineBreakMode = .byWordWrapping
            tvShowDescriptionLabel.sizeToFit()
            tvShowDescriptionLabel.font = UIFont.systemFont(ofSize: 16.0)
            return tvShowDescriptionLabel
        }()
        
        tvShowImageView = {
            let tvShowImageView = UIImageView()
            tvShowImageView.translatesAutoresizingMaskIntoConstraints = false
            
            tvShowImageView.layer.cornerRadius = 4
            tvShowImageView.layer.masksToBounds = true
            tvShowImageView.contentMode = .scaleAspectFit
            return tvShowImageView
        }()
    }
    
    func setUpConstraints() {
        self.addSubview(auxTvShowDetailsView)
        auxTvShowDetailsView.addSubview(tvShowTitleLabel)
        auxTvShowDetailsView.addSubview(tvShowDescriptionLabel)
        auxTvShowDetailsView.addSubview(tvShowEpisodeNameLabel)
        self.addSubview(tvShowImageView)
        
        
        auxTvShowDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tvShowTitleLabel]))
        auxTvShowDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tvShowDescriptionLabel]))
        auxTvShowDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tvShowEpisodeNameLabel]))
        auxTvShowDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-[v1]-12-[v2]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tvShowEpisodeNameLabel, "v1": tvShowTitleLabel, "v2": tvShowDescriptionLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": auxTvShowDetailsView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(56)]-24-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tvShowImageView, "v1": auxTvShowDetailsView]))
        
        tvShowImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
    }
    
    @objc func launchVideo() {
        let videoServices = VideoServices()
        parentViewController.playerView.clearPlayer()
        videoServices.launchVideoPlayer(previewUrl: previewUrl, presenterViewController: parentViewController)
    }
}

class MovieTableViewCell: UITableViewCell {
    var movieTitleLabel: UILabel!
    var movieDescriptionLabel: UILabel!
    var auxMovieDetailsView: UIView!
    var movieImageView: UIImageView!
    
    var parentViewController: SearchTableViewController!
    var previewUrl: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchVideo))
        gesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(gesture)
        
        initViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        auxMovieDetailsView = {
            let auxMovieDetailsView = UIView()
            auxMovieDetailsView.translatesAutoresizingMaskIntoConstraints = false
            return auxMovieDetailsView
        }()
        
        movieTitleLabel = {
            let movieTitleLabel = UILabel()
            movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            movieTitleLabel.textColor = .black
            movieTitleLabel.numberOfLines = 0
            movieTitleLabel.lineBreakMode = .byWordWrapping
            movieTitleLabel.sizeToFit()
            movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            return movieTitleLabel
        }()
        
        movieDescriptionLabel = {
            let movieDescriptionLabel = UILabel()
            movieDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            movieDescriptionLabel.textColor = UIColor.darkGray
            movieDescriptionLabel.numberOfLines = 0
            movieDescriptionLabel.lineBreakMode = .byWordWrapping
            movieDescriptionLabel.sizeToFit()
            movieDescriptionLabel.font = UIFont.systemFont(ofSize: 16.0)
            return movieDescriptionLabel
        }()
        
        movieImageView = {
            let movieImageView = UIImageView()
            movieImageView.translatesAutoresizingMaskIntoConstraints = false
            
            movieImageView.layer.cornerRadius = 4
            movieImageView.layer.masksToBounds = true
            movieImageView.contentMode = .scaleAspectFit
            return movieImageView
        }()
    }
    
    func setUpConstraints() {
        self.addSubview(auxMovieDetailsView)
        auxMovieDetailsView.addSubview(movieTitleLabel)
        auxMovieDetailsView.addSubview(movieDescriptionLabel)
        self.addSubview(movieImageView)
        
        
        auxMovieDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": movieTitleLabel]))
        auxMovieDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": movieDescriptionLabel]))
        auxMovieDetailsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-12-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": movieTitleLabel, "v1": movieDescriptionLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": auxMovieDetailsView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0(56)]-24-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": movieImageView, "v1": auxMovieDetailsView]))
        
        movieImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0).isActive = true
    }
    
    @objc func launchVideo() {
        let videoServices = VideoServices()
        parentViewController.playerView.clearPlayer()
        videoServices.launchVideoPlayer(previewUrl: previewUrl, presenterViewController: parentViewController)
    }
}


