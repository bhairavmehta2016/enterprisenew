sed -i -r "s|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g" %ZK_HOME%\conf\log4j.properties
sed -i -r "s|#autopurge|autopurge|g" %ZK_HOME%\conf\zoo.cfg

call %ZK_HOME%\bin\zkServer.cmd