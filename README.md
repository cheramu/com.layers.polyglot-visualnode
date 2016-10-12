Polyglot-VisualNode
===================

Shiva module that adds node editing functionality

### Setup
- Clone/Download-zip "com.layers.polyglot-visualnode" and place it in the user module directory
- Start shiva, you should have a "Node Explorer" module view availble
- Add two new controller views "Node Properies" and "Node Outliner"
  - Display mode "multiple" and bahavior "static"
  - Enable only resource "node" with Module "Node Explorer"
- "Stage" controller view add resource "node,pdg,pdp,pds" with Module "Node Explorer" 
- Reload module wih "Node Explorer" menu "File>Reload module"


### Development

The following is turned off because of stability issues and no yet functional
- Enable Stage view loading in "mainView.lua" uncommment
--  "guiex.openFiles ( hFile, "Stage", gui.getCurrentDesktop() )"

