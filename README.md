# Swagger Modeller


## important notice

This repository is for RingCentral only, it is not a generic tool. We do have the plan to make it a generic tool in future releases.


## Issues

In order to make fax inside API Explorer working, we have to do some hack, which makes the swagger spec invalid. So we have separate spec for API Explorer(invalid but works for API Explorer).


## todo

1. swagger required attribute
1. add validation action, tell user what's wrong
    1. verb no examples
1. clone spec. create an identical spec, with version appended ".1"
1. Markdown Plus as markdown editor
    1. postpone. because not sure Markdown is acceptable
1. export the spec as plain text and do source code version control.
    1. which means we need the feature to load/import a spec
1. API Explorer, send sms, doesn't work if extensionId is empty string, have to remove that field.
1. Export to API Reference
1. add "Error Codes" section to verb
1. Create tags, such as "Meetings", "Dictionary", "CallLog"...etc.
1. tweak label colors


## notes

1. In API Reference doc, "Collection of parameters" means following parameters in the table.
1. In swagger spec, every `type: xxx` could be replaced with `$ref: xxx`
1. in erb files, `<% end %>` in commented code still takes effects.
