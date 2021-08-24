//
//  PostCell.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit

final class PostCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    func configCell(_ post: Post?) {
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
    }
}
