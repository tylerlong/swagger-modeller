# Swagger Modeler


## todo

1. import swagger spec
    1. but there is no 100% correct spec
1. update design according to the [OPENAPI SPECIFICATION](http://swagger.io/specification/)
1. some text needs to be truncated
1. compare endpoint with RoR routes. interesting
1. code generation:
    1. comments
1. anchors to open tab
1. replace "view" buttons with links


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
