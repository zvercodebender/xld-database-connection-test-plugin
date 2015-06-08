<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
@echo off
setlocal

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/windowsSetEnvVars.ftl">

set ORACLE_HOME=${container.oraHome}

echo WHENEVER SQLERROR EXIT 1 ROLLBACK; > wrapper.sql
echo WHENEVER OSERROR EXIT 2 ROLLBACK; >> wrapper.sql
echo @"${step.uploadedArtifactPath}" >> wrapper.sql

<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its OracleClient container'
endlocal
exit /B 1
<#elseif !cmn.lookup('password')??>
echo 'ERROR: password not specified! Specify it in either SqlScripts or its OracleClient container'
endlocal
exit /B 1
<#else>

echo EXIT | "${container.oraHome}\bin\sqlplus" ${cmn.lookup('additionalOptions')!} -L ${cmn.lookup('username')}/${cmn.lookup('password')}@${container.sid} ${container.testSql}

set RES=%ERRORLEVEL%
if not %RES% == 0 (
  exit %RES%
)

endlocal
</#if>
