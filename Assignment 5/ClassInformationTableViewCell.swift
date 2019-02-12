//
//  ClassInformationTableViewCell.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/20/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit

class ClassInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var removeCourseButton: UIButton!
    @IBAction func removeCourse(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
