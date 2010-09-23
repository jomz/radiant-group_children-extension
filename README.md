# Group Children

This is an extension for [Radiant][1], put together by [jomz][2]

Sometimes you want to iterate over a list of children, and insert something after every n-th child.
Or, for css reasons you want to group children per 3.
Until now we have sometimes used javascript to alter markup, which is very ucky..

Here is the solution;

    <r:children:grouped per="3">
      <div>
        <r:children:each> ... </r:children:each>
      </div>
    </r:children:grouped>

The children:grouped tag takes all the same arguments like children:each, except for pagination.
Furthermore, inside children:grouped, you can use r:if\_first and r:if\_last to check if you are in the first or last group.
The children:each within children:grouped does NOT take arguments; those have to be passed to the children:grouped tag itself.

This extension does not override any of the existing tags, and should be backwards-compatible with 0.8 and earlier.

# Installation

Clone or submodule this extension into vendor/extensions/group\_children
Or, gem install radiant-group\_children-extension and put this inside Radiant::Initializer;

    config.gem 'radiant-group_children-extension', :lib => false

[1]: http://radiantcms.org/ "Radiant: Content management simplified"
[2]: http://hardcoreforkingaction.com "Hard-core forking action: a low frequency, web-tech blog by Benny Degezelle"
