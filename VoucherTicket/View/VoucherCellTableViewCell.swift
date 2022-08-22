//
//  VoucherCellTableViewCell.swift
//  VoucherTicket
//
//  Created by Narek Ghukasyan on 21.08.22.
//

import UIKit

protocol VoucherCatchingDelegate: AnyObject {
    func catchTicket(voucher: Voucher)
}

class VoucherCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var textContainerLabel: UILabel!
    @IBOutlet weak var voucherTextField: UITextField!
    
    var isLast = true
    
    weak var delegate: VoucherCatchingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.voucherTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.textContainerView.addGestureRecognizer(tap)
    }
    
    func makeAsLabel(text: String) {
        self.prepareViews()
        self.voucherTextField.isEnabled = false
        self.voucherTextField.text = text
        self.voucherTextField.rightViewMode = .never
    }
    
    func makeAsTextField() {
        self.prepareViews()
        self.voucherTextField.text = ""
        self.voucherTextField.isEnabled = true
        self.clearButtonConfigure()
    }
    
    private func clearButtonConfigure() {
        let clearButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 15)))
        let clearButtonContainer = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 15)) )
        clearButtonContainer.addSubview(clearButton)
        
        clearButton.setImage(UIImage(named: "clear_button"), for: .normal)
        self.voucherTextField.rightView = clearButtonContainer
        clearButton.addTarget(self, action: #selector(self.clearTapped) , for: .touchUpInside)
        
        self.voucherTextField.clearButtonMode = .never
        self.voucherTextField.rightViewMode = .always
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func clearTapped() {
        self.voucherTextField.text = ""
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.voucherTextField.becomeFirstResponder()
    }
    
    @IBAction func textChanged(_ sender: Any) {
        let characterCount = self.voucherTextField.text?.count ?? 0
        
        if characterCount == 10 {
            let availableTickets = Account.voucherTickets
            let text = self.voucherTextField.text ?? ""
            
            if let amount = availableTickets[text] {
                Account.voucherTickets.removeValue(forKey: text)
                let voucher = Voucher(code: text, lang: "hy", amountToDecrease: amount)
                self.delegate?.catchTicket(voucher: voucher)
                self.textViewNormalState()
            } else {
                self.textViewInvalideState()
            }
        } else if characterCount > 0 {
            self.textViewInvalideState()
        } else {
            self.textViewNormalState()
        }
    }
    
    private func textViewNormalState() {
        self.textContainerView.backgroundColor = UIColor(named: "text_field")
        self.textContainerView.layer.borderWidth = 0
    }
    
    private func textViewInvalideState() {
        self.textContainerView.backgroundColor = UIColor(named: "invalid")!.withAlphaComponent(0.49)
        self.textContainerView.layer.borderWidth = 1
        self.textContainerView.layer.borderColor = UIColor(named: "invalid_border")!.cgColor
    }
    
    private func prepareViews() {
        self.textContainerView.layer.cornerRadius = 10
        let placeHolderColor = UIColor(named: "label_color_3") ?? UIColor.white
        self.voucherTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter number of the voucher",
            attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor, NSAttributedString.Key.font: UIFont(name: "Georgia", size: 14) ?? UIFont.systemFont(ofSize: 14)]
        )
    }
}

extension VoucherCellTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCountLimit = 10
        let startingLength = self.voucherTextField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= characterCountLimit
    }
    
    
    
}
