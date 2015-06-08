<#--
THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
-->
#!/bin/sh
#======================================================================
<#import "/sql/commonFunctions.ftl" as cmn>

ORACLE_HOME="${container.oraHome}"
export ORACLE_HOME

# will override the declarations above if ORACLE_HOME or ORACLE_SID are present
<#include "/generic/templates/linuxExportEnvVars.ftl">
<#if !cmn.lookup('username')??>
echo 'ERROR: username not specified! Specify it in either SqlScripts or its OracleClient container'
exit 1
<#elseif !cmn.lookup('password')??>
echo 'ERROR: password not specified! Specify it in either SqlScripts or its OracleClient container'
exit 1
<#else>
echo "${container.testSql}"

echo EXIT | "${container.oraHome}/bin/sqlplus" ${cmn.lookup('additionalOptions')!} -L ${cmn.lookup('username')}/${cmn.lookup('password')}@${container.sid} <<END_OF_WRAPPER
WHENEVER SQLERROR EXIT 1 ROLLBACK;
WHENEVER OSERROR EXIT 2 ROLLBACK;
${container.testSql}
END_OF_WRAPPER

res=$?
if [ $res != 0 ] ; then
        exit $res
fi
</#if>
