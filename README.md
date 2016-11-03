# AlamofireActivityLogger

A response serializer for [**Alamofire**](https://github.com/Alamofire/Alamofire) which logs both request and response. It provides 4 log levels and a few options to configure your logs.

**AlamofireActivityLogger** is available for: 

- iOS (from 9.0)
- macOS (from 10.11)
- watchOS (from 2.0)
- tvOS (from 9.0)


> **NOTE**: This version is written for **Alamofire 4.x** and **Swift 3**. To support **Swift 2** and **Alamofire 3.x** use the [version 1.0.1](https://github.com/ManueGE/AlamofireActivityLogger/tree/1.0.1/).

## Installing AlamofireActivityLogger

##### Using CocoaPods

Add the following to your `Podfile`:

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
request(.get, url)
    .validate()
    .log()
}
````

Additionally, you can provide the log level and some options:

````
request(.get, url)
    .validate()
    .log(level: level, options: options, printer: myPrinter)
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
 
### Custom printers

If you use a third party logger, you can integrate it with AlamofireActivityLogger. To do it, you must provide a `Printer` object. 

`Printer` is a protocol which just requires one method: 

````swift
func print(_ string: String, phase: Phase)
````

As an example, let’s suppose you have [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) integrated in your app. We can create a `SwiftyBeaverPrinter` struct like this: 

````swift
struct SwiftyBeaverPrinter: Printer {
    func print(_ string: String, phase: Phase) {
        if phase.isError {
            log.error(string)
        }
        else {
            log.info(string)
        }
    }
}
````

And use it this way:

````swift
request(.get, url)
    .validate()
    .log(printer: SwiftyBeaverPrinter())
}
````

By default, a instance of `NativePrinter` is used. It just make use of the native `Swift.print` to print the info.

 
## Supported requests

At the moment, **AlamofireActivityLogger** has support for `DataRequest` and `DownloadRequest`. If you need to add support to any other `Request` subclass, just make it conforms the `LoggeableRequest` protocol. Take a look at the `DataRequest` implementation to know how. 


## Contact

[Manuel García-Estañ Martínez](http://github.com/ManueGE)  
[@manueGE](https://twitter.com/ManueGE)

## License

AlamofireActivityLogger is available under the [MIT license](LICENSE.md).
