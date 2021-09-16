//
//  StatementViewController.swift
//  Solutis_Teste
//
//  Created by Virtual Machine on 13/09/21.
//

import Foundation
import UIKit

class StatementViewController: UIViewController {
    var user: UserData?
    var apiRequest: APIRequest? = APIRequest()
    var statementRequest: [StatementData] = []
    var userLogedData: UserData?
    var viewsCount: Int = 0
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCpfCnpj: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var statementTable: UITableView!
    @IBOutlet weak var gradientView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        apiRequest?.delegate = self
        loadStatementData()
        setGradient()
    
    }
    
    func setGradient() {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.gradientView!.bounds
        
        let color1 = UIColor(red: 177/256, green: 199/256, blue: 228/256, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0/256, green: 116/256, blue: 178/256, alpha: 1.0).cgColor
        gradient.colors = [color1, color2]

        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true

    }
    
    
 
    @IBAction func btnLogout(_ sender: Any) {
        
        doLogout()
    }
    
    
    func doLogout(){
        let alert = UIAlertController(title: "Logout", message: "Realmente deseja deslogar?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive, handler: {_ in
                                        self.navigationController?.popViewController(animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
    
}



// MARK:- Functions
extension StatementViewController{
    
    func loadUserData() {
        lblName.text = "\((userLogedData?.name)!)"
        
       lblCpfCnpj.text = Utils().cpfCnpjMask(cpfCnpj: (userLogedData?.cpf)!)
        
        lblBalance.text = "\(Utils().moneyFormatter(value: (userLogedData!.balance)))"
    }
    
    func loadStatementData(){
        apiRequest?.statement((userLogedData?.token)!)
    }
    
}

    //MARK:- API RESPONSE
extension StatementViewController: APIResquestDelegate{
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.sync {
            let statementData = data as! [StatementAPI]
            for statement in statementData{
                let statementConverter: StatementData = StatementData()
                statementConverter.populate(statement)
                self.statementRequest.append(statementConverter)
            }
            statementTable.reloadData()
         
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        DispatchQueue.main.sync {
            print(error)
          
        }
    }
    
    func didResponseFailed(_: APIRequest, response: HTTPURLResponse) {
        DispatchQueue.main.sync {
            print(response)
        }
    }
}
    //MARK:- Table view populating
extension StatementViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statementRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = statementTable.dequeueReusableCell(withIdentifier: "statementCell", for: indexPath) as! CardCellViewController

        cell = Utils().formatCellValues(statement: statementRequest[indexPath.row], cell: cell)
        
        return cell
    }
    
    
    
 

}


