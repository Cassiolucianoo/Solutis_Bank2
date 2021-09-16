//
//  LoginViewController.swift
//  Solutis_Teste
//
//  Created by Virtual Machine on 13/09/21.
//

import UIKit
import KeychainSwift
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var apiRequest: APIRequest? = APIRequest()
    var dataUser: UserData = UserData()
    let keyChain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiRequest?.delegate = self
        buttonLogin.layer.cornerRadius = 20
        
        
       
        self.textUsername.text = keyChain.get("kUsername")
        
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
       
    }
    


    // MARK:- IBActions
    
    @IBAction func btnLogin(_ sender: Any) {
        guard let login = textUsername.text else{return}
        guard let password = textPassword.text else{return}
       
        doLogin(login, password)
        
        keyChain.set(login, forKey: "kUsername")
        
    }
    
    
    @IBAction func dismissKeyboardTop(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissKeyboardMiddle(_ sender: Any) {
        self.view.endEditing(true)
    }
    

}

    // MARK:- Login Functions and Segue
extension LoginViewController{
    func doLogin(_ login: String,_ password: String){
        if ((Utils().isValidEmail(email: login) == true)) && Utils().isValidPassword(password: password) == true {
            apiRequest?.login(login, password)
        }else{
            labelError.isHidden = false
            self.buttonLogin.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginSegue") {
            
           
            
            let vc = segue.destination as? StatementViewController
            vc?.modalPresentationStyle = .fullScreen
            vc?.userLogedData = dataUser
        }
    }
}

    //MARK:- TEXT FIELD Implementations
extension LoginViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        labelError.isHidden = true
        return true
    }
}

    // MARK:- Api Response
extension LoginViewController: APIResquestDelegate{
    
    func didRequestSuccess(_: APIRequest, data: Any) {
        DispatchQueue.main.async {
            let userData = data as! UserAPI
            self.dataUser.populate(userData)
            self.buttonLogin.isEnabled = true
            self.keyChainSave()
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        
        }
    }
    
    func didRequestFailed(_: APIRequest, error: Error) {
        DispatchQueue.main.async {
            print(error)
            self.buttonLogin.isEnabled = true
        }
    }
    
    func didResponseFailed(_: APIRequest, response: HTTPURLResponse) {
        DispatchQueue.main.async {
            if (response.statusCode == 401) {
                let alert = UIAlertController(title: "Aviso", message: "Credenciais inválidas", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                self.labelError.isHidden = false
            }
            self.buttonLogin.isEnabled = true
        }
    }
}

    // MARK:- KeyChain Functions
extension LoginViewController {
    func keyChainSave(){


        textPassword.text = ""
    }
    
   


}
