# == Class: mule
#
# Full description of class mule here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'mule':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#

class mule (
	$mule_mirror = 'http://s3.amazonaws.com/MuleEE',
		$mule_version = '3.6.0',
		$tomcat_version = '7.0.52',
		$mule_install_dir = '/opt',
		$mmc_data_dir = '/opt/mmc/mmc-data',
		$java_home = '/usr/lib/jvm/default-java',
		$user = 'root',
		$group = 'root') {
			
		$bundle = "mmc-distribution-mule-console-bundle-${mule_version}"
		$basedir = "${mule_install_dir}/${bundle}"
		$archive = "${bundle}.tar.gz"
		$esb_basedir = "${mule_install_dir}/mule"
		$mmc_basedir = "${mule_install_dir}/mmc"
		$esb_dist = "mule-enterprise-${mule_version}"
		$mmc_dist = "mmc-${mule_version}"
		$tomcat_basedir = "${mmc_basedir}/apache-tomcat-${tomcat_version}"
		
		archive { $bundle:
			ensure => present,
			url => "${mule_mirror}/${archive}",
			target => $mule_install_dir,
			checksum => false,
			timeout => 0,
		}
	

            user { 'mule' :
                ensure  => present,
                uid => 507,
                gid => $group,

            }
            file { "${mule_install_dir}/${bundle}":
                ensure => directory,
                recurse => true,
                owner => $user,
                group => $group,
                require => Archive[$bundle]
            }
            file { $esb_basedir:
                ensure => 'link',
                owner => $user,
                group => $group,
                target => "${mule_install_dir}/${bundle}/${esb_dist}",
                require => Archive[$bundle]
            }

            file { $mmc_basedir:
                ensure => 'link',
                owner => $user,
                group => $group,
                target => "${mule_install_dir}/${bundle}/${mmc_dist}",
                require => Archive[$bundle]
            }
            file { $mmc_data_dir:
                ensure => "directory",
                owner => $user,
                group => $group,
                require => File[$mmc_basedir]
            }

            file { '/etc/init.d/mmc':
                ensure => 'link',
                owner => root,
                group => root,
                target => "${tomcat_basedir}/bin/mmc"
            }
            

            file { "${esb_basedir}/bin/mule":
                ensure => present,
                owner => $user,
                group => $group,
                mode => '0755',
                content => template('mule/mule.init.erb'),
                require => File[$esb_basedir]
            }
            file { '/etc/init.d/mule':
                ensure => 'link',
                owner => root,
                group => root,
                target => "${esb_basedir}/bin/mule"
            }

            file { "${tomcat_basedir}/bin/mmc":
                ensure => present,
                owner => $user,
                group => $group,
                mode => '0755',
                content => template('mule/mmc.init.erb'),
                require => File[$mmc_basedir]
            }

            service { 'mule':
                ensure => running,
                enable => true,
                require => [
                File['/etc/init.d/mule'],
                User['mule']
                ],
                hasstatus => true
            }
            service { 'mmc':
                ensure => running,
                enable => true,
                require => [
                File['/etc/init.d/mmc'],
                User['mule']
                ],
                hasstatus => true
            }

}
