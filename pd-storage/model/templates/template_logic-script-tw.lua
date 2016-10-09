--------------------------------------------------------------------------------
--  Logic-script..... : ${logic.name}
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

local listener = {
    Library = "com.layers.polyglot-visualnode.lib",
    Template = "${logic.name}",
    Call = "com.layers.polyglot-visualnode.lib.${logic.name}"
}

traverse[listener["Call"] .. ".before"] = function ()
    log.message( "${logic.name}" .. ".before" )

end

traverse[listener["Call"] .. ".node"] = function (data, tNode)
    log.message( "${logic.name}" .. ".node" )
    log.message ( tNode )

end

traverse[listener["Call"] .. ".after"] = function ()
    log.message( "${logic.name}" .. ".after" )

end

--------------------------------------------------------------------------------
function  main()
--------------------------------------------------------------------------------
    log.message( "Running: " .. "${logic.name}" )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

main()
