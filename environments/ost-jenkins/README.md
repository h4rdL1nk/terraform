
#Enable SSL listening

#Convert certificate to intermediate pkcs12 format
openssl pkcs12 -export -out jenkins_keystore.p12 -passout 'pass:securepass' -inkey test.key -in test.pem -certfile ca-certs.pem -name *.wildcard.test

#Convert pkcs12 into JKS keystore
keytool -importkeystore -srckeystore jenkins_keystore.p12 -srcstorepass 'securepass' -srcstoretype PKCS12 -srcalias *.wildcard.test -deststoretype JKS -destkeystore jenkins_keystore.jks -deststorepass 'securepass' -destalias *.wildcard.test

#Verify JKS keystore
keytool -list -keystore jenkins_keystore.jks -storepass 'securepass'

#Configure jenkins server in "/etc/sysconfig/jenkins"
JENKINS_PORT="-1"
JENKINS_HTTPS_PORT="8443"
JENKINS_HTTPS_KEYSTORE="/var/lib/jenkins/ssl/jenkins_keystore.jks"
JENKINS_HTTPS_KEYSTORE_PASSWORD="securepass"
JENKINS_HTTPS_LISTEN_ADDRESS="0.0.0.0"

#Restart server
systemctl restart jenkins

#Change jenkins URL setting to SSL
${JENKINS_HOME}/jenkins.model.JenkinsLocationConfiguration.xml
    ...
    jenkins.model.JenkinsLocationConfiguration.xml:  <jenkinsUrl>https://jenkins.wildcard.test:8443/</jenkinsUrl>
    ...