# Zerigo DNS GEM

Simple Gem that wraps around an active resource for the Zerigo DNS API

[![Build Status](https://secure.travis-ci.org/twilson63/zerigo_dns.png)](http://travis-ci.org/twilson63/zerigo_dns)

## Install

    gem install zerigo_dns
    
## How to use

    require 'zerigo_dns'
    
    Zerigo::DNS::Base.user = 'you@email.com'
    Zerigo::DNS::Base.api_key = 'yourtokengoeshere'
    
    # Find or create domain
    my_zone = Zerigo::DNS::Zone.find_or_create('happyplace.com')
    
    # update or create host
    my_host = Zerigo::DNS::Host.update_or_create(my_zone.zone_id, 'www', 'A', 86400, '10.10.10.10')
    
Thats it, you should now have a host and url www.happyplace.com pointing to 10.10.10.10

## How to test

    spec spec
    
## Thanks for contributing

Thank you to John Axel Eriksson ([github.com/johnae](http://github.com/johnae)) for adding secure option and default, for the Zerigo DNS API.

Thank you to Anthony Scalisi
([github.com/scalp42](https://github.com/scalp42)) for requesting api change: self.api_key instead self.password


## Support

    [https://github.com/twilson63/zerigo_dns](https://github.com/twilson63/zerigo_dns)
    
    create an issue

## Credit goes to Zerigo DNS

    Copyright 2009 Zerigo, Inc.  See MIT-LICENSE for license information.
    Visit http://www.zerigo.com/docs/managed-dns for updates and documentation.

    I just put there sample code into a gem library for deployment ease. And chef
    integration.

    If you have any questions contact zerigo_dns_gem@jackhq.com


## Copyright

    Copyright 2009 Zerigo, Inc.  See MIT-LICENSE for license information.
