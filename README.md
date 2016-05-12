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
1. What is Rails concerns folder for?
1. remove definitions
    1. now it is hidden. going to remove it later
1. remove request_model and response_model
    1. now they are hidden, going to remove them later
1. link models, unless it doesn't exist
1. edit model redirection, annoying. cannot find the model being edit
1. Advanced swagger spec
1. remove duplication of table code in views
    1. create partials


## notes

1. In API Reference doc, "Collection of parameters" means following parameters in the table.
1. In swagger spec, every `type: xxx`  could be replaced with `$ref: xxx`
1. in erb files, `<% end %>` in commented code still take effects.


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
