--------------------------------------------------------------------------------

sdm = { node={} }


function getSharedDatamodel ()

    return sdm.node
end


function getKeys( tbl, flt)
--log.warning ( flt )
    local keys = {}
    for k, v in pairs(tbl) do
        if (flt )
        then
            for i, v2 in pairs(flt) do
                if( v2 == k)
                then
                    keys[#keys+1] = k
                end
            end
        else
            keys[#keys+1] = k
        end
    end

    return keys
end

function filter()

end

function getDatamodel ( )

    node = {}

    node["node"] = {}

    node["node.tag"] =
    {
        ["prefix"] = "n(",
        ["suffix"] = ")",
    }

    node["node.location"] =
    {
        ["path"] = "parent",
        ["name"] = "",
    }

    -- parent
    -- relative ./ or name
    -- fixed /
    node["node.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }

    node["node.types"] =
    {
        "node",
    }

    node["edittype"] =
    {
        "id",
        "editBox",
        "textBox"
    }

    node["resource"] =
    {
        ["ID"] = "",
        ["DESCRIPTION"] = "",
    }

    node["resource.tag"] =
    {
        ["prefix"] = "r(",
        ["suffix"] = ")",
    }

    node["resource.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }

    node["resource.view"] =
    {
        ["ID"] = "editBox",
        ["DESCRIPTION"] = "editBox",
    }

    node["text"] =
    {
        ["TEXT"] =  "",
        ["TEXT-ja-JP"] =  "",
    }

    node["text.tag"] =
    {
        ["prefix"] = "t(",
        ["suffix"] = ")",
    }

    node["text.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }

    node["text.view"] =
    {
        ["TEXT"] =  "editBox",
        ["TEXT-ja-JP"] =  "editBox",
    }

    node["conversation"] =
    {
        ["ID"] =  "",
        ["DESCRIPTION"] =  "",
    }

    node["conversation.view"] =
    {
        ["ID"] =  "editBox",
        ["DESCRIPTION"] =  "editBox",
    }

    node["conversation.tag"] =
    {
        ["prefix"] = "c(",
        ["suffix"] = ")",
    }

    node["conversation.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }

    node["node.links"] = {
    }

    node["node.link"] = {
        [".source"] = "",
        [".target"] = "",
        ["value"] = "",
    }

    node["node.log.info"] = {
        ["method-name"] = "info" ,
        ["package"] = "node.log",
    }

    node["node.log.warning"] = {
        ["method-name"] = "warning" ,
        ["package"] = "node.log",
    }

    node["node.log.warning.inputs"] = {
        "122",
        "node.type.param.string",
    }

    node["node.log.warning.input.1"] = {
        ["type"] = "string" ,
        ["name"] = "message",
        ["value"] = "",
    }

    node["node.type.param.string"] = {
        ["type"] = "string" ,
        ["name"] = "string",
        ["value"] = "",
    }

    node["node.log.error"] = {
        ["method-name"] = "error" ,
        ["package"] = "node.log",
    }

    node["node.log.enable"] = {
        ["method-name"] = "enable" ,
        ["package"] = "node.log",
    }

    node["node.log.isEnabled"] = {
        ["method-name"] = "isEnabled" ,
        ["package"] = "node.log",
    }
    --polyglot dialogue editor model
    node["editor.filter"] =
    {
        ["nodegui"] = "view.filter",
        ["treeview"] = "view.filter",
        ["screenplay"] = "view.filter",
        ["diagram"] = "view.filter",
        ["datamodel"] = "view.filter",
        ["translation"] = "view.filter",
    }
    node["editor.tree.view"] = {}
    node["editor.tree.item.view"] =
    {
        ["item-id-self"] = "",
        ["item-id-parent"] = "",
        ["item-id-node"] = "",
        ["item-tag"] =     "",
        ["item-user-data"] = "",
        ["item-icon"] = "",
        ["item-file-path"] = "",
        ["item-file-name"] = "",
    }

    node["editor.views"] =
    {
        --["screenplay"] = "editor.screenplay.view",
        ["datamodel"] = "editor.datamodel.view",
        --["diagram"] = "editor.diagram.view",
        ["modifydata"] = "editor.modifydata.view",
        ["translation"] = "editor.translation.view",
        --["scm"] = "editor.scm.view",
        ["node-info"] = "editor.node.view",
        ["shoteditor"] = "editor.shoteditor.view",
        ["leafView"] = "editor.leaf.view",
        ["rootView"] = "editor.root.view",
    }
    node["editor.views.instances"] =
    {
    }

    node["editor.views.order"] =
    {
        ["rootView"] = "8",
        ["leafView"] = "7",
        ["modifydata"] = "6",
        ["datamodel"] = "5",
        ["node-info"] = "4",
       -- ["screenplay"] = "3",
        --["diagram"] = "2",
        ["translation"] = "2",
        ["shoteditor"] = "1",
        --["scm"] = "7",
    }

    node["editor.views.main.leaf.filter"] =
    {
        ["leafView"] = "",
        ["node-info"] = "",
    }

    node["editor.views.main.root.filter"] =
    {
        ["rootView"] = "",
    }

    node ["editor.views.properties.filter"] =
    {
        ["datamodel"] = "",
        ["modifydata"] = "",
       -- ["translation"] = "",
       -- ["shoteditor"] = "",
    }

    node["editor.root.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "rootView",
        ["view-location"] = "top",
        ["name"] = "rootView",
        ["order"] = "8",
    }

    node["editor.leaf.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "leafView",
        ["view-location"] = "top",
        ["name"] = "leafView",
        ["order"] = "7",
    }

    node["editor.shoteditor.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "shotEditorView",
        ["view-location"] = "top",
        ["name"] = "shot-editor",
        ["order"] = "6",
    }

    node["editor.datamodel.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "datamodelView",
        ["view-location"] = "top",
        ["name"] = "datamodel",
        ["order"] = "1",
    }

    node["editor.screenplay.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "screenplayView",
        ["view-location"] = "top",
        ["name"] = "screenplay",
        ["order"] = "4",
    }

    node["editor.translation.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.packages",
        ["Template"] = "translationView",
        ["view-location"] = "top",
        ["name"] = "translation",
        ["order"] = "6",
    }

    node["editor.editor.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "editorView",
        ["view-location"] = "top",
        ["name"] = "editor",
    }


    node["editor.scm.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "scmView",
        ["view-location"] = "top",
        ["name"] = "scm",
    }

    node["editor.diagram.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "diagramView",
        ["view-location"] = "top",
        ["name"] = "diagram",
        ["order"] = "5",
    }

    node["editor.modifydata.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "modifydataView",
        ["view-location"] = "top",
        ["name"] = "modifydata",
        ["order"] = "2",
    }

    node["editor.node.view"] =
    {
        ["Library"] = "com.layers.polyglot-visualnode.lib",
        ["Template"] = "nodeView",
        ["view-location"] = "top",
        ["name"] = "node-info",
        ["order"] = "3",
    }

    node["editor.resource.file"] = {
        ["path"] = "",
        ["name"] = "",
    }

    node["editor.resource.file.traverse"] = {
        ["type"] = "", -- none, node, node-linked
        ["location"] = "", -- dynamic, root
        ["path"] = "",
        ["name"] = "",
    }

    node["editor.resource.file.tag"] =
    {
        ["prefix"] = "",
        ["suffix"] = "",
    }

    node["editor.resource.file.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }

    node["editor.package"] =
    {
        ["id"] = "",
        ["repository-url"] = "",
        ["package-file"] = "",
        ["icon"] = "",
        ["name"] = "",
        ["author"] = "",
        ["website"] = "",
        ["readme-file"] = "",
        ["email"] = "",
        ["version"] = "",
        ["description"] = "",
        ["active"] = "",
    }

    local sModuleId = "com.layers.polyglot-visualnode"
    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( sModuleId ) )  .. "pd-storage/model/nodes"
    local files = system.findFiles ( sPath , true )
    for  i, sfile in pairs(files) do
        local sNodeName = project.getFileFullName ( sfile )
        local sFilePath =  system.getFileDirectory ( project.getFilePath ( sfile )  )
        local sNodeRelativePath = string.replace ( sFilePath, sPath .. "/", "" )
        local nodeList = CLP_Node:getNode( sNodeName , "model/nodes/" .. sNodeRelativePath)
        for  i2, iNode in pairs(nodeList) do
            --log.message ( iNode )
            node[i2] = iNode
        end
    end
    --log.message ( node )
    return node
end


--------------------------------------------------------------------------------


