--------------------------------------------------------------------------------
function generateDatamodelDialog()
    -- NODE --
    node = {}
    -- NODE TYPES DIALOG --
    --[[node["node.types"] =
    {
        "actor",
        "dialog",
        "conversation"
    }]]
    -- NODES ACTOR --
    node["actor"] =
    {
        ["TAG"] =  "",
        ["NAME"] =  "",
        ["NAME-ja-JP"] =  "",
        ["AGE"] =  "" ,
        ["BLOODTYPE"] =  "",
        ["BIRTHSIGN"] =  "",
        ["GENDER"] =  "",
        ["PICTURE"] =  "",
        ["DESCRIPTION"] =  "",
    }
    node["actor.tag"] =
    {
        ["prefix"] = "a(",
        ["suffix"] = ")",
    }
    node["actor.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }
    node["actor.view"] = {
        ["TAG"] =  "editBox",
        ["NAME"] =  "editBox",
        ["NAME-ja-JP"] =  "editBox" ,
        ["AGE"] =  "editBox",
        ["BLOODTYPE"] =   "editBox",
        ["BIRTHSIGN"] =  "editBox",
        ["GENDER"] =   "editBox",
        ["PICTURE"] =   "editBox",
        ["DESCRIPTION"] =  "editBox",
    }
    -- DIALOG --
    node["dialog"] =
    {
        ["ID"] = "" ,
        ["TAG"] = "",
        ["ACTOR_TAG"] = "",
        ["TEXT"] = "",
        ["TEXT-ja-JP"] = "",
        ["BACKGROUND"] = "",
        ["SOUND"] = "",
        ["FUCTION"] = "",
        ["NEXT"] = "",
        ["STATE"] = "",
        ["CONDITION"] = "",
        ["TYPE"] = "" ,
        ["TITLE"] = "" ,
        ["DESCRIPTION"] = "",
    }
    node["dialog.view"] =
    {
        ["ID"] = "id",
        ["TAG"] = "editBox",
        ["TEXT"] = "textBox",
        ["ACTOR_TAG"] = "editBox",
        ["TEXT-ja-JP"] = "textBox",
        ["BACKGROUND"] =  "editBox",
        ["SOUND"] = "editBox",
        ["FUCTION"] =  "editBox",
        ["NEXT"] = "editBox",
        ["STATE"] = "editBox",
        ["CONDITION"] = "editBox",
        ["TYPE"] = "editBox",
        ["TITLE"] = "editBox",
        ["DESCRIPTION"] = "editBox",
    }
    node["dialog.tag"] =
    {
        ["prefix"] = "d(",
        ["suffix"] = ")",
    }
    node["dialog.outputs"] = {
    }
    node["dialog.inputs"] = {
    }
    node["dialog.view.treeicon"] =
    {
        ["default"] = "TreeFolderClosed",
        ["linked"] = "TreeFolderClosed",
    }
    node["dialog.view.filter"] =
    {
        --["ID"] = "id",
        --["TAG"] = "editBox",
        ["TEXT"] = "false",
        ["ACTOR_TAG"] = "false",
        --["TEXT-ja-JP"] = "textBox",
        --["BACKGROUND"] =  "editBox",
        --["SOUND"] = "editBox",
        --["FUCTION"] =  "editBox",
        --["NEXT"] = "editBox",
        --["STATE"] = "editBox",
        --["CONDITION"] = "editBox",
        --["TYPE"] = "editBox",
        --["TITLE"] = "editBox",
        --["DESCRIPTION"] = "editBox",
    }
    return node
end

--------------------------------------------------------------------------------
--[[
    -- NODE --
    -- NODE TYPES DIALOG --
    node["node.types"] =
    {
        "node",
        "resource",
        "text",
        "actor",
        "conversation",
        "dialog"
    }
    node["dialog.links"] =
    {
    }
    node["dialog.link"] = {
        [".source"] = "",
        [".target"] = "",
        ["value"] = "",
    }
]]
--------------------------------------------------------------------------------
