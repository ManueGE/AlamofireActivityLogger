# AlamofireActivityLogger

A response serializer for [**Alamofire**](https://github.com/Alamofire/Alamofire) which logs both request and response. It provides 4 log levels and a few options to configure your logs.

> **NOTE**: This version is written for **Alamofire 4.x** and **Swift 3**. To support **Swift 2** and **Alamofire 3.x** use the [version 1.0.1](https://github.com/ManueGE/AlamofireActivityLogger/tree/1.0.1/).

## Installing AlamofireActivityLogger

##### Using CocoaPods

Add one of more of the following to your `Podfile`:

````
pod 'AlamofireActivityLogger'
````

Then run `$ pod install`.

And finally, in the classes where you need **AlamofireActivityLogger**: 

````
import AlamofireActivityLogger
````

If you don’t have CocoaPods installed or integrated into your project, you can learn how to do so [here](http://cocoapods.org).

## Log

To log a request you just have to write:

````
request(.get, URL)
    .validate()
    .log()
}
````

Additionally, you can provide the log level and some options:

````
request(.get, URL)
    .validate()
    .log(level, options: options)
}
````

Let's see the **levels** and **options**.

### Levels

Are instances of the enum `LogLevel`. The available values are:

 * **`none`**: Do not log requests or responses.
 
 * **`all`**: Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
 
 * **`info`**: Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
 
 * **`error`**: Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
 
 The default value is **`all`**.

### Options

Are instances of the enum `LogOption`. The available values are:

* **`onlyDebug`**: Only logs if the app is in Debug mode
 
* **`jsonPrettyPrint`**: Prints the JSON body on request and response 
 
* **`includeSeparator`**: Include a separator string at the begining and end of each section

 The default value is **`[.onlyDebug, .jsonPrettyPrint, .includeSeparator]`**.
 
## Supported requests

At the moment, **AlamofireActivityLogger** has support for `DataRequest` and `DownloadRequest`. If you need to add support to any other `Request` subclass, just make it conforms the `LoggeableRequest` protocol. Take a look at the `DataRequest` implementation to know how. 


## Contact

[Manuel García-Estañ Martínez](http://github.com/ManueGE)  
[@manueGE](https://twitter.com/ManueGE)

## License

Raccoon is available under the [MIT license](LICENSE.md).