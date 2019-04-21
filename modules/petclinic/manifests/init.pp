class petclinic {

exec { 'apt-update':  
command => '/usr/bin/apt-get update'
}

$packages = ['openjdk-8-jre','tomcat8']
 
package { $packages:  
require => Exec['apt-update'],
ensure => installed,
}
file {'/usr/share/tomcat8':
owner => 'tomcat8',  
group => 'tomcat8',  
ensure => directory,  
require => Package['tomcat8'],
}
file {'/var/lib/tomcat8/webapps/petclinic.war':
owner => 'tomcat8',
group => 'tomcat8',
mode => '0644',
ensure => present,
require => Exec['download-petclinic-war']
} 
exec { 'download-petclinic-war':
command => '/usr/bin/curl -o petclinic.war http://192.241.144.123:8081/artifactory/generic-local/org/springframework/samples/spring-petclinic/1.0.1-SNAPSHOT/spring-petclinic-1.0.1-SNAPSHOT.war',  
creates => '/var/lib/tomcat8/webapps/petclinic.war',
cwd => '/var/lib/tomcat8/webapps',
require => Package['tomcat8']
}
service { tomcat8:
ensure => running,
enable => true
}
exec{'add-tomcat-java-home': 
cwd => '/etc',
path => ['/etc','/usr/bin'],
command=>'/bin/echo JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 >> /etc/default/tomcat8', 
notify => Service['tomcat8']
}
}
