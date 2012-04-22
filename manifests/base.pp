class rtorrent::base {
  package { 'rtorrent':
    ensure => present,
  }    

  file{'rtorrent-init':
    path    => "/etc/init.d/rtorrent",
    source  => [ "puppet:///modules/site-rtorrent/init.d/rtorrent",
                "puppet:///modules/rtorrent/init.d/rtorrent" ],
    require => Package['rtorrent'],
    owner   => root, group => 0, mode => 0755;
  }

  user{'rtorrent':
    ensure     => present,
    managehome => true,
    home       => '/home/rtorrent',
  }

  file{'rtorrent.rc':
    path    => "/home/rtorrent/.rtorrent.rc",
    source  => [ "puppet:///modules/site-rtorrent/rtorrent.rc",
                 "puppet:///modules/rtorrent/rtorrent.rc" ],
    ensure  => present,
    require => User['rtorrent'],
  }
  
  file{'session-dir':
    path    => "/home/rtorrent/session",
    ensure  => directory, 
    owner   => 'rtorrent',
    group   => 'rtorrent',
    require => User['rtorrent'],
  }

  service{'rtorrent':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [ File['/etc/init.d/rtorrent'], 
                   User['rtorrent'],
                   File['rtorrent.rc'],
                   File['session-dir']
                 ],
  }

}
