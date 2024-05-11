import Foundation

final class CallStation {
    var userList: [User] = []
    var callsList: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return self.userList
    }
    
    func add(user: User) {
        if self.userList.contains(where: {$0 == user}){
            print("User already exists")
        }else{
            self.userList.append(user)
        }
        
    }
    
    func remove(user: User) {
        if let i = self.userList.firstIndex(where: {$0 == user}) {
            self.userList.remove(at: i)
        } else {
           print("item could not be found")
        }
       
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(from: let userFrom, to: let userTo):
            
            
            if(!userList.contains(where: {$0 == userFrom})){
                return nil
            }else if (!userList.contains(where: {$0 == userTo})){
                let newCall = Call(id: UUID(), incomingUser: userTo, outgoingUser: userFrom, status: CallStatus .ended(reason: .error))
                self.callsList.append(newCall)
                return newCall.id
            }else {
                let userToCalls = self.calls(user: userTo)
                var userBusy = false
                for call in userToCalls {
                    if (call.status == .calling || call.status == .talk){
                        userBusy = true
                    }
                }
                
                if(!userBusy) {
                    let newCall = Call(id: UUID(), incomingUser: userTo, outgoingUser: userFrom, status: CallStatus .calling)
                    self.callsList.append(newCall)
                    return newCall.id
                }else {
                    let newCall = Call(id: UUID(), incomingUser: userTo, outgoingUser: userFrom, status: CallStatus .ended(reason: .userBusy))
                    self.callsList.append(newCall)
                    return newCall.id
                }
            }

        case .answer(from: let toUser):
            if (!userList.contains(where: {$0 == toUser})){
                for (index, call) in self.callsList.enumerated() {
                    if(call.status == .calling && call.incomingUser == toUser) {
                        var newCall = call
                        newCall.status = .ended(reason: .error)
                        self.callsList.remove(at: index)
                        self.callsList.insert(newCall, at: index)
                        return nil
                    }
                }
            } else {
                for (index, call) in self.callsList.enumerated() {
                    if(call.status == .calling && call.incomingUser == toUser) {
                        var newCall = call
                        newCall.status = .talk
                        self.callsList.remove(at: index)
                        self.callsList.insert(newCall, at: index)
                        return newCall.id
                    }
                }
            }
        case .end(from: let endedFrom):
            for (index, call) in self.callsList.enumerated() {
                
                if(call.status == .talk){
                    if(call.incomingUser == endedFrom || call.outgoingUser == endedFrom){
                        var newCall = call
                        newCall.status = .ended(reason: .end)
                        self.callsList.remove(at: index)
                        self.callsList.insert(newCall, at: index)
                        return newCall.id
                    }
                }else if(call.status == .calling){
                    if(call.outgoingUser == endedFrom || call.incomingUser == endedFrom){
                        var newCall = call
                        newCall.status = .ended(reason: .cancel)
                        self.callsList.remove(at: index)
                        self.callsList.insert(newCall, at: index)
                        return newCall.id
                    }
                }
            }
        }
        
        return nil
    }
    
    func calls() -> [Call] {
        return self.callsList
    }
    
    func calls(user: User) -> [Call] {
        var userCalls: [Call] = []
        for call in self.callsList {
            if (call.incomingUser == user || call.outgoingUser == user){
                userCalls.append(call)
            }
        }
        return userCalls
    }
    
    func call(id: CallID) -> Call? {
        for call in self.callsList {
            if (call.id  == id){
                return call
            }
        }
        return nil
    }
    
    func currentCall(user: User) -> Call? {
        for call in self.callsList {
            if(call.status == .calling){
                if(call.incomingUser == user || call.outgoingUser == user) {
                    return call
                }
            }else {
                return nil
            }
        }
        return nil
    }
}
