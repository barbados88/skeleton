import UIKit
import RealmSwift
import ObjectMapper

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

class RealmListTransform<T: Object>: TransformType where T: Mappable {
    
    typealias Object = List<T>
    typealias JSON = [[String: Any]]
    
    let mapper = Mapper<T>()
    
    func transformFromJSON(_ value: Any?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as? [Any] {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model: T = mapper.map(JSONObject: entry)!
                result.append(model)
            }
        }
        return result
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        var results = [[String:Any]]()
        if let value = value {
            for obj in value {
                let json = mapper.toJSON(obj)
                results.append(json)
            }
        }
        return results
    }
}

extension Object {
    
    func writeBlock(_ block: (Realm) -> ()) {
        if isInvalidated == true { return }
        guard let realm = realm
            else {
                let realm = try! Realm()
                checkTransaction(for: realm, block)
                return
        }
        checkTransaction(for: realm, block)
    }
    
    private func checkTransaction(for realm: Realm, _ block: (Realm) -> ()) {
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write {
                block(realm)
            }
        }
    }
    
    func deleteSelf() {
        if isInvalidated == true || realm == nil { return }
        writeBlock { realm in
            realm.delete(self)
        }
    }
    
}

extension Object: DetachableObject {
    
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else {
                continue
            }
            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else { // Then it is a primitive
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
    
}

extension List: DetachableObject {
    
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            if let detachableObject = $0 as? DetachableObject,
                let element = detachableObject.detached() as? Element {
                result.append(element)
            } else { // Then it is a primitive
                result.append($0)
            }
        }
        return result
    }
    
}

extension List {
    
    func show(size: Int) -> [Object] {
        var a: [Object] = []
        let arraySize = size > self.count ? self.count : size
        for i in 0..<arraySize {
            let object = self[i]
            if object is Object {
                guard let rmObject = object as? Object
                    else {
                        continue
                }
                a.append(rmObject)
            }
        }
        return a
    }
    
}

extension Results {
    
    func toArray() -> Array<Element> {
        return Array(self)
    }
    
}

extension Realm {
    
    static func deleteAll() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
    static func safeRealmCreate<T: Object>(array: [Object], type: T.Type) {
        let realm = try? Realm()
        try? realm?.write {
            let typeName = (type as Object.Type).className()
            for object in array {
                realm?.create(type, value: object, update: realm?.schema[typeName]?.primaryKeyProperty != nil ? .all : .modified)
            }
        }
    }
    
    func filter<ParentType: Object>(parentType: ParentType.Type, subclasses: [ParentType.Type], predicate: NSPredicate) -> [ParentType] {
        return ([parentType] + subclasses).flatMap { classType in
            return Array(self.objects(classType).filter(predicate).sorted(byKeyPath: "time"))
        }
    }
    
}
