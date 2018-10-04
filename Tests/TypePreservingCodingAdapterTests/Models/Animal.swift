
public protocol Animal: Codable {

    func say() -> String
}

public class Mammal: Animal, Codable {

    public func say() -> String {
        return "__"
    }
}
