//
//  NickName.swift
//  EatSSU-iOS
//
//  Created by 박윤빈 on 2023/08/02.
//

import Realm
import RealmSwift

class NickName: Object {
  @Persisted(primaryKey: true) var accessToken: String = ""
  @Persisted var nicknName: String = ""

  convenience init(accessToken: String, nickName: String) {
    self.init()

    self.accessToken = accessToken
    self.nicknName = nickName
  }
}
