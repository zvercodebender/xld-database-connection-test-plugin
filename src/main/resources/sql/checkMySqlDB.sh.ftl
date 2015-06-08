<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
#!/bin/sh

<#import "/sql/commonFunctions.ftl" as cmn>
<#include "/generic/templates/linuxExportEnvVars.ftl">

<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its MySqlClient container'
exit 1
<#else>
echo "${container.testSql}"
echo "${container.testSql}" | "${container.mySqlHome}/bin/mysql" --user=${cmn.lookup('username')} <#if cmn.lookup('password')??>--password=${cmn.lookup('password')}</#if> ${cmn.lookup('additionalOptions')!} ${container.databaseName} 
res=$?
if [ $res != 0 ] ; then
        exit $res
fi
</#if>


