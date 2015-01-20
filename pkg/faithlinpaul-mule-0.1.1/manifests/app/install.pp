


define mule::app::install (
	$downloadurl,
	$extension = 'zip',
	$config_path = '',
	$config_template_path = ''
	) {
	
	$app_name = $title
	$bin_dest = "${mule::basedir}/apps"
	$temp_dir = "/tmp"
	
	archive::download { "${app_name}.${extension}" :
		ensure => present,
		url => $downloadurl,
		src_target => $temp_dir,
		checksum => false,
	}
	archive::extract { $app_name :
		ensure => present,
		target => "${bin_dest}/${app_name}",
		src_target => $temp_dir,
		extension => $extension,
		require => Archive::Download["${app_name}.${extension}"],
		notify => Service['mule'],
	}
	if($config_path != '') {
		if ($config_template_path == '') {
			fail("You must specify config_template_path if config_path is set")
		}
		file { "${bin_dest}/${app_name}/${config_path}" :
			ensure => present,
			mode => 0644,
			owner => $mule::user,
			group => $mule::group,
			content => template($config_template_path),
			notify => Service['mule']
		}
	}
}
