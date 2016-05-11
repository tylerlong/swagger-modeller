# Swagger Modeller


## todo

1. import swagger spec
    1. but there is no 100% correct spec
    1. in the future, export then import, the data should be identical.
1. update design according to the [OPENAPI SPECIFICATION](http://swagger.io/specification/)
1. compare endpoint with RoR routes. interesting
1. code generation:
    1. comments
1. flash messages
1. remove duplication of table code in views
1. What is Rails concerns folder for?
1. remove definitions
    1. now it is hidden. going to remove it later
1. link models, unless it doesn't exist
1. don't add model prefix. add it dynamically when export
1. 凡是没有paging信息的返回结果都应该提炼成单独的model
1. 导出为swagger spec


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
