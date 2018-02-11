import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    let anonymous: UILabel = {
        let label = UILabel()
        label.text = "Would you like to send your feedback anyonymously?"
        label.numberOfLines = 0
        return label
    }()
    
    let sendAnonymously: UISwitch = {
        let s = UISwitch();
        return s
    }()
    
    let feedback: UITextView = {
        let tv = UITextView()
        tv.text = "Please let us know what you think!"
        tv.textColor = .gray
        tv.font = UIFont.systemFont(ofSize: 16.0)
        return tv
    }()
    
    let send: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Feedback", for: .normal)
        button.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
        return button
    }()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Feedback"
        view.backgroundColor = .white
        
        ref = Database.database().reference();
        
        setupView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text! == "Please let us know what you think!") {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text! == "") {
            textView.text = "Please let us know what you think!"
            textView.textColor = .gray
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sendFeedback() {
        let feedbackText = feedback.text!
        if (feedbackText != "" && feedbackText != "Please let us know what you think!") {
            let key = ref.childByAutoId().key
            if (!sendAnonymously.isOn) {
                ref.child("feedback").child(key).setValue([ "feedback": feedbackText, "sender": Auth.auth().currentUser?.uid ])
            } else {
                ref.child("feedback").child(key).setValue([ "feedback": feedbackText ])
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupView() {
        view.addSubview(sendAnonymously)
        sendAnonymously.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        view.addSubview(anonymous)
        anonymous.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: sendAnonymously.leftAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        view.addSubview(send)
        send.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: -8, paddingRight: 24, width: 0, height: 0)
        
        view.addSubview(feedback)
        feedback.anchor(top: anonymous.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: send.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: -8, paddingRight: 24, width: 0, height: 0)
        feedback.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}
