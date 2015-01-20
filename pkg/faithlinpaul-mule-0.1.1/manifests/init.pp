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
		$log4j_properties = undef,
		$user = 'root',
		$group = 'root') {

		$bundle = "mmc-distribution-mule-console-bundle-${mule_version}"
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
			#strip_components => 1
		}

}
