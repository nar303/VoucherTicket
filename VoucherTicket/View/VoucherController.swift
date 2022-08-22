//
//  ViewController.swift
//  VoucherTicket
//
//  Created by Narek Ghukasyan on 21.08.22.
//

import UIKit
import Alamofire

class VoucherController: UIViewController {
    
    @IBOutlet weak var voucherView: UIView!
    @IBOutlet weak var voucherTableView: UITableView!
    @IBOutlet weak var amountView: UIView!
    
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var amountToPaidLabel: UILabel!
    @IBOutlet weak var confirmButtonBackView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        print("confirm tapped")
    }
    
    
    var account = Account()
    fileprivate let cellId = "VoucherCellTableViewCell"
    
    deinit {
        removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.voucherTableView.dataSource = self
        self.voucherTableView.delegate = self
        self.configureUI()
        
    }
    
    private func configureUI() {
        self.voucherView.layer.cornerRadius = 40
        self.amountView.layer.cornerRadius = 30
        self.confirmButtonBackView.layer.cornerRadius = 20
        self.amountView.layer.borderColor = UIColor(named: "label_color_2")?.cgColor ?? UIColor.gray.cgColor
        
        self.totalAmountLabel.text = "\(Constants.TOTAL_AMOUNT) AMD"
        self.amountToPaidLabel.text =  "\(account.amountToPaid) AMD"
    }
    
}

// VoucherTableView Data Management Functionality
extension VoucherController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let textFieldWillAppear = account.haveToPaid ? 1:0
        return self.account.vouchers.count + textFieldWillAppear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! VoucherCellTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = self
        self.configureCell(cell, row: indexPath.row)
        
        return cell
    }
    
    private func configureCell(_ cell: VoucherCellTableViewCell, row id: Int) {
        if id < self.account.vouchers.count {
            DispatchQueue.main.async {
                    cell.makeAsLabel(text: self.account.vouchers[id].code)
            }
        } else {
            DispatchQueue.main.async {
                cell.makeAsTextField()
            }
        }
    }
}

// VoucherCatchingDelegate protocol points
extension VoucherController: VoucherCatchingDelegate {
    func catchTicket(voucher: Voucher) {
        let amount = self.calculateNewAmountToPaid(decreaseAmount: voucher.amountToDecrease)
        DispatchQueue.main.async {
            self.amountToPaidLabel.text = "\(amount) AMD"
        }
        
        if amount == 0 {
            self.account.haveToPaid = false
        }
        self.account.vouchers.append(voucher)
        
        //Posting catched voucher ticket
        self.postVoucherRequest(voucher: voucher)
        self.updateViews()
        
    }
    
    private func calculateNewAmountToPaid(decreaseAmount: Int) -> Int {
        var newAmountToPaid = self.account.amountToPaid - decreaseAmount
        newAmountToPaid = newAmountToPaid > 0 ? newAmountToPaid:0
        self.account.amountToPaid = newAmountToPaid
        return newAmountToPaid
    }
    
    private func postVoucherRequest(voucher: Voucher) {
        let parameters: [String: String] = [
            "OrderNumber": voucher.code,
            "Lang": "hy"
        ]

        AF.request(Connection.URL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: VoucherResponse.self) { (response) in
                guard let voucher = response.value else { return }
                print("Voucher Response: ", voucher)
            }
    }
    
    private func updateViews() {
        DispatchQueue.main.async {
            self.voucherTableView.reloadData()
        }
        
        DispatchQueue.main.async {
            let isThereTextField = self.account.haveToPaid ? 0:1
            let indexPath = IndexPath(row: self.account.vouchers.count - isThereTextField, section: 0)
            self.voucherTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

//Keyboard Managment Functionality
extension VoucherController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func kbWillShow() {
        UtilValues.KEYBOARD_IS_ACTIVE = true
    }
    
    @objc func kbWillHide() {
        UtilValues.KEYBOARD_IS_ACTIVE = false
    }
}
