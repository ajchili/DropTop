import UIKit

class DropTableViewCell: UITableViewCell {
    
    var drop: Drop?
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func setupView() {
        contentView.addSubview(title)
        title.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        contentView.addSubview(type)
        type.anchor(top: title.bottomAnchor, left: contentView.safeAreaLayoutGuide.leftAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
}
