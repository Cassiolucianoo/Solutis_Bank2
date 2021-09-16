//
//  UserModel.swift
//  Solutis_Teste
//
//  Created by Virtual Machine on 13/09/21.
//

import Foundation

struct UserAPI: Decodable{
    let nome: String
    let cpf: String
    let saldo: Double
    let token: String
    

}

struct StatementAPI: Decodable {
    let data: String
    let descricao: String
    let valor: Double
}



