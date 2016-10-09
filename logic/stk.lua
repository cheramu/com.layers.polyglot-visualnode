--------------------------------------------------------------------------------

function onExportAsStk ( sDestionationDirectoryPath, sIncludeDirectoryPath, sPackageContentType )

    local hExportJob = job.create ( this.getModuleIdentifier ( ) ..".job.export" )
    if  ( hExportJob )
    then
        job.setType ( hExportJob, job.kTypeExportEditorPackage ) -- ? kTypeExportEditionPackage

        job.setProperty ( hExportJob, job.kPropertyDestinationDirectory,      sDestionationDirectoryPath)
        job.setProperty ( hExportJob, job.kPropertyPackageContentType,        job.kPropertyPackageContentTypeModule )
        job.setProperty ( hExportJob, job.kPropertyExportFileList,            { sIncludeDirectoryPath } )
        job.setProperty ( hExportJob, job.kPropertyExportTargetProfileList,   { project.getDefaultTargetProfile ( ) } )
        job.setProperty ( hExportJob, job.kPropertyPackageContentType,        sPackageContentType )
        job.setProperty ( hExportJob, job.kPropertyCompleteCallback,          onExportAsStkJobHasCompleted )
        job.setProperty ( hExportJob, job.kPropertyLogOutput,                 true )

        -- Run the job (ASYNC)
        --
        gui.showWaitingDialog ( true )

        if ( not job.run ( hExportJob, true ) )
        then
            gui.showWaitingDialog ( false )
            log.warning ( "onExportAsStk job failed to launch" )
        end
    end

end
--------------------------------------------------------------------------------
function onExportAsStkJobHasCompleted ( hJob )
    if ( hJob )
    then
        job.finalize ( hJob )
    end
    gui.showWaitingDialog ( false )
end