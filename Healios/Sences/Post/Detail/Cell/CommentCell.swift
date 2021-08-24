//
//  CommentCell.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit

final class CommentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    func configCell(_ comment: Comment?) {
        nameLabel.text = comment?.name
        bodyLabel.text = comment?.body
    }
}
