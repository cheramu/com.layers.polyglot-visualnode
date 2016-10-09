AI_DIALOGUE = { htCallBack = {}, tShowDialogList = {}, tConversations = {}, htDialogs = {}, htActors = {}, tDialogTypes = {}, htText = {}, tNextIds ={} , currentDialogId = "" , sLangcode = "" }
--------------------------------------------------------------------------------
--  Handler.......... : onRegister
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function AI_DIALOGUE.onRegister ( sAIModel ,sCallbackEvent  )
--------------------------------------------------------------------------------
    log.warning ( "AI_DIALOGUE.onRegister" )
    AI_DIALOGUE.htCallBack[sAIModel] = sCallbackEvent
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Handler.......... : reset
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------
function AI_DIALOGUE.reset()
    --htCallBack = {}
    AI_DIALOGUE.tShowDialogList = {}
    AI_DIALOGUE.tConversations = {}
    AI_DIALOGUE.htDialogs = {}
    AI_DIALOGUE.htActors = {}
    AI_DIALOGUE.tDialogTypes = {}
    AI_DIALOGUE.htText = {}
    AI_DIALOGUE.tNextIds ={}
    AI_DIALOGUE.currentDialogId = ""
    AI_DIALOGUE.sLangcode = ""
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Handler.......... : onDialog
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function AI_DIALOGUE.onDialog ( sINPUT_DIALOG_ID )
--------------------------------------------------------------------------------

    if(sINPUT_DIALOG_ID == "start")
    then

        local nConversations = #AI_DIALOGUE.tConversations
        log.message ( "start search conversation: " .. nConversations )
        for i = 1, nConversations
        do
            local DIALOG_ID =  AI_DIALOGUE.tConversations[i]
            local DIALOG_CONDITION = AI_DIALOGUE.htDialogs[DIALOG_ID .. "." .. "CONDITION"]

            if(AI_DIALOGUE.checkDialogCondition ( DIALOG_CONDITION ) )
            then
                table.insert (AI_DIALOGUE.tNextIds, DIALOG_ID )
                AI_DIALOGUE.currentDialogId = DIALOG_ID
                AI_DIALOGUE.setShowDialogList ( DIALOG_ID )
                break
            end
        end
    elseif(sINPUT_DIALOG_ID == "")
    then
        --exit
        log.message ( "stop conversation" )
    else
        -- continue conversation)
        log.message ( "continue conversation" )
        AI_DIALOGUE.currentDialogId = sINPUT_DIALOG_ID
        AI_DIALOGUE.getNextDialogList ( sINPUT_DIALOG_ID  )
    end

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : checkDialogCondition
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function AI_DIALOGUE.checkDialogCondition ( sCondition )
--------------------------------------------------------------------------------
    log.message ( "check conversation: "  .. sCondition)

    if(sCondition == "")
    then
      return true
    else
        local bReturnValue = false
        --UNPLAYED|PLAYABLE|PLAYED
        --"DIALOG.1.STATE.is.UNPLAYED|or|DIALOG.1.STATE.is.PLAYABLE|or|DIALOG.1.STATE.is.PLAYED"

        local tTempCon = string.explode( sCondition, "|" )
        local reset = true

        for i = 1, #tTempCon
        do
            local sCon = tTempCon[i]
            if(sCon == "or")
            then
                reset = true
                if(bReturnValue)
                then
                    --table.empty ( this.tTempCon ( ) )
                    break
                end
            else
                tTempState = string.explode ( sCon, "." )

                local sType = tTempState[1]
                local sId = tTempState[2]
                local sField = tTempState[3]
                local sOperation = tTempState[4]
                local sValue = tTempState[5]
                log.warning ( "Conditions ".. #tTempState ..": " .. sType .. ", " ..  sId .. ", " .. sField .. ", " .. sOperation .. ", " .. sValue)
                if(sType == "DIALOG")
                then
                   local sFieldValue = AI_DIALOGUE.htDialogs[sId .. "." .. sField]
                   if(sOperation == "is")
                   then
                    if(reset)
                    then
                        bReturnValue = sFieldValue == sValue
                        reset = false
                    else
                        if(bReturnValue ~= false)
                        then
                           bReturnValue = sFieldValue == sValue
                        end
                    end
                   end
                end
            end
            --table.removeFirst ( this.tTempCon ( ) )
        end

        return bReturnValue
    end
--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : setShowDialogList
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function AI_DIALOGUE.setShowDialogList ( tDIALOGS_ID_LIST )
--------------------------------------------------------------------------------
    -- build show dialog table
    AI_DIALOGUE.tShowDialogList = {}
    local tShowDialogList= AI_DIALOGUE.tShowDialogList
    -- shuffle return dialogs
    --TODO implement shufle
    --table.shuffle ( this.tNextIds ( ) )
    --math.random (  )
    local tNextIds = AI_DIALOGUE.tNextIds
    for ti = 1,  #tNextIds
    do
        local sNEXT_DIALOG_ID = tNextIds[ti]
        local htDialog = {}

        local tDialogTypes = AI_DIALOGUE.tDialogTypes
        for i = 1, #tDialogTypes
        do
            local sDIALOG_FIELD = tDialogTypes[i]
            local sDIALOG_VALUE = ""

            if( AI_DIALOGUE.htDialogs[sNEXT_DIALOG_ID .. "." .. sDIALOG_FIELD .. "-" .. AI_DIALOGUE.sLangcode] )
            then
                sDIALOG_VALUE = AI_DIALOGUE.htDialogs[sNEXT_DIALOG_ID .. "." .. sDIALOG_FIELD .. "-" .. AI_DIALOGUE.sLangcode]
            else
                sDIALOG_VALUE = AI_DIALOGUE.htDialogs[sNEXT_DIALOG_ID .. "." .. sDIALOG_FIELD]
            end

            if(sDIALOG_VALUE == nil)
            then
                log.warning ( "show dialogt type does not exsist: " .. sNEXT_DIALOG_ID .. "." .. sDIALOG_FIELD .. "."  )
                htDialog[sDIALOG_FIELD] = ""
            else
                --log.message ( "add show dialog type: " .. sNEXT_DIALOG_ID .. "." .. sDIALOG_FIELD .. "." .. sDIALOG_VALUE  )
                htDialog[sDIALOG_FIELD] = sDIALOG_VALUE
            end
        end

        table.insert ( tShowDialogList, htDialog )
        --table.removeFirst ( this.tNextIds ( ) )
    end

    AI_DIALOGUE.tNextIds = {}

    -- notify about data change
    if( #tShowDialogList > 0 )
    then
        --log.warning ( "send dialog: " .. sAIModel .. " " .. sCallBackEvent  )
        for k,v in pairs(AI_DIALOGUE.htCallBack) do
            local sAIModel = k
            local sCallBackEvent = v
            module.sendEvent ( this.getModule ( ), sAIModel .. "." ..sCallBackEvent)
        end
    else
        --log.waring ( "send dialog: ended" )
        for k,v in pairs(AI_DIALOGUE.htCallBack) do
            local sAIModel = k
            local sCallBackEvent = v
            module.sendEvent ( this.getModule ( ), sAIModel .. "." ..sCallBackEvent)
        end
    end

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Function......... : getNextDialogList
--  Author........... :
--  Description...... :
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
function AI_DIALOGUE.getNextDialogList ( sINPUT_DIALOG_ID )
--------------------------------------------------------------------------------

    local sCONVERSATION_NEXT_DIALOGS = AI_DIALOGUE.htDialogs[sINPUT_DIALOG_ID .. "." .. "NEXT"]

    local tmpTable = {}
    if(sCONVERSATION_NEXT_DIALOGS ~= nil )
    then
        log.message ( "next dialogs: " .. sCONVERSATION_NEXT_DIALOGS )

        tmpTable = string.explode (sCONVERSATION_NEXT_DIALOGS, "|" )
        if( #tmpTable == 0 and not string.isEmpty ( sCONVERSATION_NEXT_DIALOGS ) )
        then
            table.insert ( tmpTable, sCONVERSATION_NEXT_DIALOGS )
        end
    end

    for i = 1, #tmpTable do
        local sNEXT_DIALOG_ID = tmpTable[i]
        log.message ( sNEXT_DIALOG_ID  )

        if ( AI_DIALOGUE.htDialogs[sNEXT_DIALOG_ID .. "." .. "ID"] )
        then
            local sDIALOG_CONDITION = AI_DIALOGUE.htDialogs[sNEXT_DIALOG_ID .. "." .. "CONDITION"]

            if(AI_DIALOGUE.checkDialogCondition ( sDIALOG_CONDITION ) )
            then
                log.message ( "load dialog: " .. sNEXT_DIALOG_ID  )
                table.insert ( AI_DIALOGUE.tNextIds, sNEXT_DIALOG_ID )
            end
        end
        --table.removeFirst ( this.tmpTable ( ) )
    end

    AI_DIALOGUE.setShowDialogList ( AI_DIALOGUE.tNextIds )

--------------------------------------------------------------------------------
end
--------------------------------------------------------------------------------

