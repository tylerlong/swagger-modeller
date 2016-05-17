# Swagger Modeller

Swagger Specification built with Swagger Modeller:

- [RingCentral Swagger Specification](https://gist.github.com/tylerlong/c19bc951c99b8994bfa2b540443249d3).



## todo

1. import swagger spec
    1. export then import, the data should be remain unchanged.
1. compare endpoint with RoR routes. interesting
    1. give each path a name, then `create`, `update`...etc.
1. flash messages
1. What is Rails concerns folder for?
    1. http://stackoverflow.com/questions/14541823/how-to-use-concerns-in-rails-4
1. remove definitions
    1. now it is hidden. going to remove it later
1. remove request_model and response_model
    1. now they are hidden, going to remove them later
1. link models, unless it doesn't exist
1. edit model redirection, annoying. cannot find the model being edit
    1. models inline editing
1. remove duplication of table code in views
    1. create partials
    1. show #. of properties
1. show verbs inline with paths. collapse
1. reuse db table? -- active record inheritance
1. swagger required attribute
1. show graphs


## notes

1. In API Reference doc, "Collection of parameters" means following parameters in the table.
1. In swagger spec, every `type: xxx`  could be replaced with `$ref: xxx`
1. in erb files, `<% end %>` in commented code still takes effects.
