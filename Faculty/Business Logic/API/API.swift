import Foundation

public enum APIError : Error {
    case invalidId
}

public class API : NSObject {
    private let databaseBaseURL = "https://prof-recommender.firebaseio.com"
    private let serverBaseURL = "http://professorrecommender-env.i4ddpbpc6v.us-east-2.elasticbeanstalk.com"
    
    private lazy var session = URLSession(
        configuration: .background(withIdentifier: "download"),
        delegate: self,
        delegateQueue: nil
    )
    
    private let decoder = JSONDecoder()
    private var downloads: [ObjectIdentifier: ((Float) -> Void, ([Academic]?, Error?) -> Void)] = [:]

    public func fetchAllAcademics(
        progress: @escaping (Float) -> Void,
        result: @escaping ([Academic]?, Error?) -> Void
    ) {
        guard let url = URL(string: "\(databaseBaseURL)/.json") else {
            return result(nil, APIError.invalidId)
        }
        
        let downloadTask = session.downloadTask(with: url)
        let identifier = ObjectIdentifier(downloadTask)
        downloads[identifier] = (progress, result)
        downloadTask.resume()
    }
    
    public func fetchAcademic(id: Int, result: @escaping (Academic?, Error?) -> Void) {
        guard let url = URL(string: "\(databaseBaseURL)/\(id).json") else {
            return result(nil, APIError.invalidId)
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    return result(nil, error)
                }
                
                guard let data = data else {
                    return result(nil, error)
                }
                
                let academic = try self.decoder.decode(Academic.self, from: data)
                result(academic, nil)
            } catch {
                result(nil, error)
            }
        }
        
        task.resume()
    }
    
    public func fetchAcademicIds(keyword: String, result: @escaping ([String]?, Error?) -> Void) {
        guard let url = URL(string: "\(serverBaseURL)/query") else {
            return result(nil, APIError.invalidId)
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "query_text": keyword,
        ]
        
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error {
                    return result(nil, error)
                }
                
                guard let data = data else {
                    return result(nil, error)
                }
                
                let academicIds = try self.decoder.decode([String].self, from: data)
                result(academicIds, nil)
            } catch {
                result(nil, error)
            }
        }
        
        task.resume()
    }
}

extension API : URLSessionDownloadDelegate {
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        let identifier = ObjectIdentifier(downloadTask)
        
        guard let (progress, _) = downloads[identifier] else {
            return
        }
        
        progress(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
    
    public func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        let identifier = ObjectIdentifier(downloadTask)
        
        guard let (_, result) = downloads[identifier] else {
            return
        }
        
        downloads[identifier] = nil
        
        do {
            let data = try Data(contentsOf: location)
            let academic = try self.decoder.decode([String: Academic].self, from: data)
            result(Array(academic.values), nil)
        } catch {
            result(nil, error)
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        let identifier = ObjectIdentifier(task)
        
        guard let (_, result) = downloads[identifier] else {
            return
        }
        
        downloads[identifier] = nil
        result(nil, error)
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }.joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
