# Zerigo DNS GEM

Simple Gem that wraps around an active resource for the Zerigo DNS API

## Install

    gem install zerigo_dns
    
## How to use

    require 'zerigo_dns'
    
    Zerigo::DNS::Base.user = 'you@email.com'
    Zerigo::DNS::Base.password = 'yourtokengoeshere'
    
    # Find or create domain
    my_zone = Zerigo::DNS::Zone.find_or_create('happyplace.com')
    
    # update or create host
    my_host = Zerigo::DNS::Host.update_or_create(my_zone.zone_id, 'www', 'A', 86400, '10.10.10.10')
    
Thats it, you should now have a host and url www.happyplace.com pointing to 10.10.10.10


## Support

    http://support.jackrussellsoftware.com
    
    create a ticket
    