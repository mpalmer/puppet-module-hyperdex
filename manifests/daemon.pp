# Configure a hyperdex data storage daemon.
#
# Attributes:
#
#  * `name` (*namevar*)
#
#     This will be used as the name of the daemontools service, and as part
#     of the default path to the daemon's data directory.
#
#  * `listen_address` (string; optional; default `undef`)
#
#     If specified, will tell hyperdex to listen on a particular address.
#     By default, hyperdex will automatically decide what address to listen
#     on...  which may not end well for anyone.  Both the coordinator and
#     daemon will listen on the same address.
#
#  * `listen_port` (integer; optional; default `2012`)
#
#     Which port the data daemon listens on.
#
#  * `coordinator_address` (string; optional; default `localhost`)
#
#     The address of a coordinator to talk to in order to join the data
#     storage cluster.  This can be a hostname or an IP address.  The
#     default assumes that you are running coordinators on all nodes you are
#     running data daemons on.
#
#  * `coordinator_port` (integer; optional; default `1982`)
#
#     The port to use to talk to the coordinator.
#
#  * `data_directory` (string; optional; default `/srv/hyperdex/$name/data`)
#
#     Where to store the database files that the data daemon uses.  This
#     resource will automatically create the directory you specify, but not
#     any parents of it (with the exception of `/srv/hyperdex/$name`, if you
#     stick with the default).
#
define hyperdex::daemon(
		$listen_address      = undef,
		$listen_port         = 2012,
		$coordinator_address = "localhost",
		$coordinator_port    = 1982,
		$data_directory      = undef,
) {
	include hyperdex::user
	include hyperdex::packages::server

	if $data_directory == undef {
		$_data_directory = "/srv/hyperdex/${name}/data"
		file { "/srv/hyperdex/${name}":
			ensure => directory,
			mode   => 0755,
			owner  => "root",
			group  => "root",
		}
	} else {
		$_data_directory = $data_directory
	}

	file { $_data_directory:
		ensure  => directory,
		mode    => 0755,
		owner   => "hyperdex",
		group   => "hyperdex",
		require => Class["hyperdex::packages::server"],
	}

	if $listen_address {
		$listen_addr_opt = " -l ${listen_address}"
	}

	daemontools::service { $name:
		command => "/usr/bin/hyperdex daemon -f -D ${_data_directory}${listen_addr_opt} -p ${listen_port} -c ${coordinator_address} -P ${coordinator_port}",
		user    => "hyperdex",
		require => [
			Class["hyperdex::packages::server"],
			File[$_data_directory],
		],
	}
}
