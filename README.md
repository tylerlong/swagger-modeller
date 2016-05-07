# Swagger Modeler


## todo

1. import swagger spec
    1. but there is no 100% correct spec
    1. in the future, export then import, the data should be identical.
1. update design according to the [OPENAPI SPECIFICATION](http://swagger.io/specification/)
1. compare endpoint with RoR routes. interesting
1. code generation:
    1. comments
1. edit query parameters
1. request body
1. response body
1. flash messages


## notes

In API Reference doc, "Collection of parameters" means following parameters in the table.


## commands

Validate definitions:

```
rake definition:validate
```

Generate CSharp code:

```
rake generate:csharp dir=~/Desktop/generated
```

Code will be saved in directory `~/Desktop/generated`.
