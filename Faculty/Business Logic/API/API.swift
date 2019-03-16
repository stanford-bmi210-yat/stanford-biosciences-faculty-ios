import Foundation

public enum APIError : Error {
    case invalidId
}

public class API : NSObject {
    private let baseURL = "https://prof-recommender.firebaseio.com"
    
    private lazy var session = URLSession(
        configuration: .background(withIdentifier: "download"),
        delegate: self,
        delegateQueue: nil
    )
    
    private let decoder = JSONDecoder()
    private var downloads: [ObjectIdentifier: ((Float) -> Void, ([Academic]?, Error?) -> Void)] = [:]

    public func queryAllAcademics(
        progress: @escaping (Float) -> Void,
        result: @escaping ([Academic]?, Error?) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/.json") else {
            return result(nil, APIError.invalidId)
        }
        
        let downloadTask = session.downloadTask(with: url)
        let identifier = ObjectIdentifier(downloadTask)
        downloads[identifier] = (progress, result)
        downloadTask.resume()
    }
    
    public func queryAcademic(id: Int, result: @escaping (Academic?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id).json") else {
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
