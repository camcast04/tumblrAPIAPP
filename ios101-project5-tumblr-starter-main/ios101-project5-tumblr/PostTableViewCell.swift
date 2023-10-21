//
//  PostTableViewCell.swift
//  ios101-project5-tumblr
//
//  Created by Camila Castaneda on 10/20/23.
//
// PostTableViewCell.swift

import UIKit
import Nuke

class PostTableViewCell: UITableViewCell {
    
    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add postImageView and summaryLabel to contentView
        contentView.addSubview(postImageView)
        contentView.addSubview(summaryLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postImageView.widthAnchor.constraint(equalToConstant: 100),
            postImageView.heightAnchor.constraint(equalToConstant: 100),
            
            summaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            summaryLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 10),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        summaryLabel.text = post.summary
        if let photo = post.photos.first {
            Nuke.loadImage(with: photo.originalSize.url, into: postImageView)
        }
    }
}

//import UIKit
//
//class PostTableViewCell: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
