//
//  Utils.swift
//  Solutis_Teste
//
//  Created by Virtual Machine on 13/09/21.
//

import Foundation
import CPF_CNPJ_Validator
import JMMaskTextField_Swift
import UIKit

    // MARK:- Validations and cell formatter
class Utils{
    

    func isValidEmail(email: String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool{
        if password != "" {
            let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: password)
        }
        return false
    }
    

    func formatCellValues(statement: StatementData, cell: CardCellViewController) -> CardCellViewController {
      
       

        
        // corner radius
        cell.cellView.layer.cornerRadius = 10
        cell.labelDate.text = dateFormatter(date: statement.date)
        cell.labelDescription.text = statement.description
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        if statement.value < 0 {
            cell.labelType.text = "Pagamento"
            cell.labelValue.text = moneyFormatter(value: statement.value)
            cell.labelValue.textColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1)
            return cell
        }else{
            cell.labelType.text = "Recebimento"
            cell.labelValue.text = moneyFormatter(value: statement.value)
            cell.labelValue.textColor = UIColor(red: 52.0/255.0, green: 199.0/255.0, blue: 89.0/255.0, alpha: 1)
            return cell
        }
    }
}

    // MARK:- Strings, Money, Date Formatter
extension Utils{
    
    func moneyFormatter(value: Double) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(for: value)!
    }
    
    func dateFormatter(date: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy"

        if let formatedDate = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: formatedDate)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }
    
    func cpfCnpjMask(cpfCnpj: String) -> String{
        let mask: JMStringMask
        if (cpfCnpj.count > 11) {
            mask = JMStringMask(mask: "00.000.000/0000-00")
        }else {
            mask = JMStringMask(mask: "000.000.000-00")
        }
        return mask.mask(string: cpfCnpj)!
    }
    
}

