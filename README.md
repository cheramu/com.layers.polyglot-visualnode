Polyglot-VisualNode
===================

Shiva module that adds graph editing functionality

### Setup
- Clone/Place "com.layers.polyglot-visualnode" place in the user module directory
- Start shiva, you should have a "Node Explorer" module view availble
- Add two new controller views "Node Properies" and "Node Outliner"
  - Display mode "multiple" and bahavior "static", 
  - Enable only resource "node" with Module "Node Explorer"
- "Stage" controller view add resource "node,pdg,pdp,pds" with Module "Node Explorer" 
- Reload module wih "Node Explorer" menu "File>Reload module"


### Other
- Disabling view loading in "mainView.lua" commment
--  "guiex.openFiles ( hFile, "Stage", gui.getCurrentDesktop() )"

