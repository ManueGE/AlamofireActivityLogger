# AlamofireActivityLogger

A response serializer for [**Alamofire**](https://github.com/Alamofire/Alamofire) which logs both request and response. It provides 4 log levels and a few options to configure your logs.

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
request(.GET, URL)
    .validate()
    .log()
}
````

Additionally, you can provide the log level and some options:

````
request(.GET, URL)
    .validate()
    .log(level, options: options)
}
````

Let's see the **levels** and **options**.

### Levels

Are instances of the enum `LogLevel`. The available values are:

 * **`None`**: Do not log requests or responses.
 
 * **`All`**: Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
 
 * **`Info`**: Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
 
 * **`Error`**: Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
 
 The default value is **`All`**.

### Options

Are instances of the enum `LogOption`. The available values are:

* **`OnlyDebug`**: Only logs if the app is in Debug mode
 
* **`JSONPrettyPrint`**: Prints the JSON body on request and response 
 
* **`IncludeSeparator`**: Include a separator string at the begining and end of each section

 The default value is **`[.OnlyDebug, .JSONPrettyPrint, .IncludeSeparator]`**.

## Contact

[Manuel García-Estañ Martínez](http://github.com/ManueGE)  
[@manueGE](https://twitter.com/ManueGE)

## License

AlamofireActivityLogger is available under the [MIT license](LICENSE.md).
