<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
@echo off
setlocal

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/windowsSetEnvVars.ftl">

<#assign commandOpts='-b -S ${deployed.container.serverName}' />

<#if cmn.lookup('username')?? && cmn.lookup('password')??>
  <#assign commandOpts="${commandOpts} -U ${cmn.lookup('username')} -P ${cmn.lookup('password')}" />
</#if>

<#if (deployed.container.databaseName?has_content) >
  <#assign commandOpts="${commandOpts} -d ${deployed.container.databaseName}" />
</#if>

<#if (cmn.lookup('additionalOptions')??) >
  <#assign commandOpts="${commandOpts} ${cmn.lookup('additionalOptions')!}" />
</#if>

sqlcmd ${commandOpts} -i ${step.uploadedArtifactPath}

set RES=%ERRORLEVEL%
if not %RES% == 0 (
  exit %RES%
)

endlocal
