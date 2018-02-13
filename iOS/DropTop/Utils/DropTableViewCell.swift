import UIKit

class DropTableViewCell: UITableViewCell {
    
    var drop: Drop?
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        return label
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize - 2.0)
        label.textColor = .gray
        return label
    }()
    
    let data: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    fileprivate func setupView() {
        contentView.addSubview(title)
        title.anchor(top: contentView.safeAreaLayoutGuide.topAnchor, left: contentView.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        contentView.addSubview(type)
        type.anchor(top: title.bottomAnchor, left: contentView.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        contentView.addSubview(data)
        data.anchor(top: type.bottomAnchor, left: contentView.safeAreaLayoutGuide.leftAnchor, bottom: contentView.safeAreaLayoutGuide.bottomAnchor, right: contentView.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
    }
}
