# Swagger Modeller


## important notice

This repository is for RingCentral only, it is not a generic tool. We do have the plan to make it a generic tool in future releases.


## Issues

In order to make fax inside API Explorer working, we have to do some hack, which makes the swagger spec invalid. So we have separate spec for API Explorer(invalid but works for API Explorer).


## todo

1. flash messages
1. reuse db table? -- active record inheritance
    1. not necessary. It has both pros and cons
1. swagger required attribute
1. show graphs
1. add validation action, tell user what's wrong
1. show model referenced by
1. clone spec. create a identical spec, with version appended ".1"


## notes

1. In API Reference doc, "Collection of parameters" means following parameters in the table.
1. In swagger spec, every `type: xxx` could be replaced with `$ref: xxx`
1. in erb files, `<% end %>` in commented code still takes effects.
