# Swagger Modeller


## important notice

This repository is for RingCentral only, it is not a generic tool. We do have the plan to make it a generic tool in future releases.


## Issues

In order to make fax working, we have to do some hack, which makes the swagger spec invalid. So we have separate spec for API Explorer.


## todo

1. import swagger spec
    1. export then import, the data should be remain unchanged.
1. compare endpoint with RoR routes. interesting
    1. give each path a name, then `create`, `update`...etc.
1. flash messages
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
