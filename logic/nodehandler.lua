
CLP_Node = {
    sModuleId = "com.layers.polyglot-visualnode"
}


local function istable(t)
    return type(t) == 'table'
end

local function datamodelSort( a, b )
    --log.warning ( a )
    --log.warning ( b )
    if(istable(a) or istable(b)) then return false end
    if( a < b )
    then
        return true
    elseif( a  == b )
    then
        return  a < b
    end
    --function(a,b) return a<b end
end

function pairsByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
  end
  return iter
end


local function writeNode(sPath, sNodename, tNodeData, sNodeId)
    --log.warning ( "writeNode" )
    local ltNodeData = {}

    if(not tNodeData)
    then
        local dm = getDatamodel( )
        ltNodeData = dm[sNodename]
        --log.message ( ltNodeData )
    else
        --ltNodeData = tNodeData[sNodename]
        ltNodeData = tNodeData
    end

    local sOutput = ""
    sOutput = sOutput .. 'node["' .. sNodename .. '"] =\n{\n'

    if(sNodename == "editor.view.tree")then
        for i, v in pairs(ltNodeData) do
            local vOut = v
            if(istable(v))
            then
                vOut = ""
                for i2, v2 in pairs(v) do
                    vOut = vOut .. '["' .. i2 .. '"]="' .. v2 .. '",\n'
                end
                sOutput = sOutput.. '{\n' .. vOut .. '},\n'
            else
                sOutput = sOutput.. '["' .. i .. '"] =\n"' .. vOut .. '"\n,\n'
            end
        end
    else
        for i, v in pairsByKeys(ltNodeData) do
            local vOut = v
            if(istable(v))
            then
                vOut = ""
                for i2, v2 in pairs(v) do
                    --log.message ( i2 )
                    --log.message ( v2 )
                    vOut = vOut .. '["' .. i2 .. '"]="' .. v2 .. '",\n'
                end
                sOutput = sOutput.. '{\n' .. vOut .. '},\n'
            else
                sOutput = sOutput.. '["' .. i .. '"] =\n"' .. vOut .. '"\n,\n'
            end
            --sOutput = sOutput.. '{"' .. i .. '",\n"' .. v .. '"\n},\n'
        end
        --log.message ( sOutput )
    end

    sOutput = sOutput .. '}\n'
    --log.message ( sOutput )
    local nlenght =  string.getLength ( sOutput )
    local sFilename = string.sha1 ( sNodename .. ";".. nlenght .. ";" ..  sOutput )
    if(sNodeId)
    then
        sFilename = sNodeId
    end

    file = io.open( sPath .. sFilename, "w")
    io.output( file )
    io.write( sOutput )
    io.close( file )
    --log.message ( sFilename )
    return sFilename

end


local function loadNode( sPath, sNodeId )
    --log.warning ( "loadNode"  )

    local sFilename = sNodeId
    file = io.open( sPath .. sFilename, "r")
    io.input( file )
    local sNode =  io.read( "*all" )
    io.close( file )

    --log.warning ( sNode )
    local f = load("local node = {}" .. sNode .. "return node")
    --log.warning ( f()  )
    return f()
end


function CLP_Node.isGenNode( self, sNodeId, sNodename, tNodeData )

    sOutput = ""
    sOutput = sOutput .. 'node["' .. sNodename .. '"] =\n{\n'
    for i, v in pairs( tNodeData ) do
        local vOut = v
        if(istable(v))
        then
            vOut = ""
            for i2, v2 in pairs(v) do
                --log.message ( i2 )
                --log.message ( v2 )
                vOut = vOut .. '["' .. i2 .. '"]="' .. v2 .. '",\n'
            end

            sOutput = sOutput.. '{\n' .. vOut .. '},\n'
        else
            sOutput = sOutput.. '["' .. i .. '"] =\n"' .. vOut .. '"\n,\n'
        end
        --sOutput = sOutput.. '{"' .. i .. '",\n"' .. v .. '"\n},\n'
    end

    sOutput = sOutput .. '}\n'
    --log.message ( sOutput )
    local nlenght =  string.getLength ( sOutput )
    local sFilename = string.sha1 ( sNodename .. ";".. nlenght .. ";" ..  sOutput )

    if(sFilename == sNodeId)
    then
        return sNodeId
    end

    return nil
end


function CLP_Node.AddNode( self, sNodename, tNode, sNodeId, sRelativePath )
    --local sPath = module.getHomeDirectory ( module.getModuleFromIdentifier ( self.sModuleId )  ) .. "pd/"
    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( self.sModuleId ) ) .. "pd-storage/"

    if(sRelativePath  and not string.isEmpty ( sRelativePath, true ))
    then
        sPath = sPath .. sRelativePath
    else
        sPath = sPath .. "data/"
    end

    if( not system.directoryExists ( sPath ) )
    then
        system.createDirectory ( sPath )
    end

    return writeNode( sPath, sNodename, tNode,  sNodeId )

end


function CLP_Node.getNode( self, sNodeId, sRelativePath )
    --log.warning ( sNodeId )
    if(not sNodeId or string.isEmpty ( sNodeId, true))
    then
        return {}
    end

    local sPath = module.getRootDirectory ( module.getModuleFromIdentifier ( self.sModuleId ) ) .. "pd-storage/"

    if(sRelativePath and not string.isEmpty ( sRelativePath, true ))
    then
        sPath = sPath .. sRelativePath
    else
        sPath = sPath .. "data/"
    end

    if( not system.fileExists ( sPath .. sNodeId ) )
    then
        return {}
    end

    return loadNode( sPath, sNodeId  )
end

local sGuidIndex = 0
local sPrevGuid = ""
function CLP_Node.getGuid()
    local time = system.getCurrentTime ( "yyyyMMddhhmmss" )
    local id = system.getComputerUniqueIdentifier ( )
    local guid = string.sha1 (  id  .. time  .. sGuidIndex)

    if( sPrevGuid == guid )
    then
        sGuidIndex = sGuidIndex + 1
        return CLP_Node:getGuid()
    else
        sPrevGuid = guid
        return guid
    end
end



--[[
TODO:
snode = 1234
sother = 2567
*= 134567 diff or (1234567 / 1234567)
*= 134 diff left (1234 / 1234)
*= 567 diff right (2567 / 2567)
*= 2
local CLP_Node.difference( a , b )
    return
end
--setFunctions = {difference/union/intersection/complement/in/contains/subset}

function CLP_Node.set(a, f, b)
    return f(a,b)
end
]]

-- diffence / complementary set theory
function CLP_Node.getDifferenceFrom(self, sNodeBaseFields, sOtherNodeFields)
    local returnData = {}

    if(sNodeBaseFields and sOtherNodeFields) then
        local keysetBase={}
        local n=0
        for k,v in pairs(sNodeBaseFields) do
            n=n+1
            keysetBase[n]=k
        end

        local keysetOther={}
        for k,v in pairs(sOtherNodeFields) do
            table.insert ( keysetOther, k )
        end

        for i,k in ipairs(keysetBase) do
            local got = table.find ( keysetOther, k )
            if( not got) then
                table.insert ( returnData, k )
            end
        end
    end

    return returnData
end


--[[

function CLP_Node.intersection( self, sNodeId, sOtherNodeId )

end

function CLP_Node.complement( self, sNodeId, sOtherNodeId )

end

function CLP_Node.union( self, sNodeId, sOtherNodeId )

end

function CLP_Node.difference( self, sNodeId, sOtherNodeId )

end


function CLP_Node.getUnion( self, sNodeId, sOtherNodeId )

end

function CLP_Node.getLeftUnion( self, sNodeId, sOtherNodeId )

end

function CLP_Node.getRightUnion( self, sNodeId, sOtherNodeId )

end

function CLP_Node.getView(selfs, sNodeId)

end

]]

--[[
local dm = getDatamodel( )
local nodeData = dm[sNodename]

local output = {};
--table.sort ( nodeData )
for i, v in pairs(nodeData) do
    output[i] = v[1]
end
table.sort ( output )

local sOutput = "";
for i, v in pairs(output) do
    sOutput =  sOutput .. v .. "\n"
end
log.warning ( sOutput )

--module.getRootDirectory ( )
--project.createFile ( project.kFileTypeUnknown, sDirectory..sNewFileName )
]]


--[[
local Table = {}
Table.Var = "Testing"

function Table:Test()
    log.warning (self.Var)
end

Table:Test()
]]

--[[
local Table = {}
Table.Var = "Testing"
function Table.Test(self)
    log.warning (self.Var)
end

Table:Test()

]]
