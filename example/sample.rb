# Copyright 2009 Zerigo, Inc.  See MIT-LICENSE for license information.
# Visit http://www.zerigo.com/docs/managed-dns for updates and documentation.

# First, require the Zerigo DNS library for ActiveResource.

require 'zerigo_dns'

# All API request require a Zerigo account and an Account API key. We'll set
# them here for later reference. The 'user' is your regular login email.
# The 'password' is your API key and comes from the Preferences page
# (Manage Account -> NS -> Preferences).

Zerigo::DNS::Base.user = 'you@email.com'

Zerigo::DNS::Base.api_key = 'api_token'

# Note: This example assumes that there is at least one domain/zone already
#       existing for the above referenced account.



# We'll start by retrieving a list of domains for this account. Note that the
# API refers to domains as zones. Note that API attributes are addressed as
# instance methods: the_zone.domain
# All attributes will have underscores in the name instead of dashes.
# eg: zone.default_ttl, not zone.default-ttl

puts '', "Retrieving list of first 20 zones..."
zones = Zerigo::DNS::Zone.find(:all, :params=>{:per_page=>20, :page=>1})

# Now print a list of those zones
zones.each do |zone|
  puts "  #{zone.domain} (id: #{zone.id})"
end

# And show exactly how many results there were. Note that total_count is
# attached to each zone object, so we just pick the first one here.
if zones.empty?
  puts "  (0 of 0 displayed)"
else
  puts "  (1-#{zones.size} of #{zones.first.last_count} displayed)"
end


# We'll list all hosts for the first zone from the last request.

zone = zones.first
puts '', "Hosts for zone #{zone.domain} (id: #{zone.id})"

hosts = Zerigo::DNS::Host.find(:all, :params=>{:zone_id=>zone.id, :per_page=>20, :page=>1})
hosts.each do |host|
  puts "  #{host.hostname} (id: #{host.id})"
end

# While not demonstrated here, host.last_count works just like for
# zones.


# Now we'll load a single zone. In this case, it's the first zone returned in
# the last request.

puts '', "Loading a single zone..."
zone = Zerigo::DNS::Zone.find(zones.first.id)

puts "  Loaded zone #{zone.id} (#{zone.domain})"


# Now we'll try to load a non-existent zone and catch the error.

puts '', "Loading a non-existent zone..."
begin
  zone2 = Zerigo::DNS::Zone.find(987654321)
  puts "  Loaded zone #{zone2.id} (#{zone2.domain})"
rescue ActiveResource::ResourceNotFound
  puts "  Zone not found"
end


# Let's create a random zone with a validation error

puts '', "Creating a random zone that is invalid..."

now = Time.now.to_i
vals = {:domain=>"example-#{now}.org", :ns_type=>'not_valid' }

newzone = Zerigo::DNS::Zone.create(vals)
if newzone.errors.empty?
  puts "  Zone #{newzone.domain} created successfully with id #{newzone.id}."
else
  puts "  There was an error saving the new zone."
  newzone.errors.each {|attr, msg| puts "    #{attr} #{msg}"}
end

# now do it right

puts '', "Fixing and resubmitting that random zone..."

vals[:ns_type] = 'pri_sec' # options for this are 'pri_sec' (the default and most common), 'pri', and 'sec' -- see the API docs for details

newzone = Zerigo::DNS::Zone.create(vals)
if newzone.errors.empty?
  puts "  Zone #{newzone.domain} created successfully with id #{newzone.id}."
else
  puts "  There was an error saving the new zone."
  newzone.errors.each {|attr, msg| puts "    #{attr} #{msg}"}
end


# Then we'll update that same zone.

puts '', "Now adding slave_nameservers and changing to 'pri'..."

newzone.ns_type = 'pri'
newzone.slave_nameservers = "ns8.example-#{now}.org,ns9.example-#{now}.org"
if newzone.save
  puts "  Changes saved successfully."
else
  puts "  There was an error saving the changes."
  newzone.errors.each {|attr, msg| puts "    #{attr} #{msg}"}
end


# Add a host to the zone.

puts '', "Adding a host to the zone."

vals2 = {:hostname=>'www',
         :host_type=>'A',
         :data=>'10.10.10.10',
         :ttl=>86400,
         :zone_id=>newzone.id
        }

# A host has to be assigned to a zone. This is done by including 'zone_id'
# in the vals2 hash.
newhost = Zerigo::DNS::Host.create(vals2)
if newhost.errors.empty?
  puts "  Host #{newhost.hostname} created successfully with id #{newhost.id}."
else
  puts "  There was an error saving the new host."
  newhost.errors.each {|attr, msg| puts "    #{attr} #{msg}"}
end


# To make the new host show up in the zone, either the zone needs to be 
# reloaded or just the hosts can be reloaded. We'll also reload the host
# just for fun.

puts '', "Reloading the host..."

newhost.reload

puts '', "Reloading the zone..."

newzone.reload


# Update the host.

puts '', "Changing the host ttl to use the zone's default..."

host = newzone.hosts.first
host.ttl = nil
if host.save
  puts "  Changes saved successfully."
else
  puts "  There was an error saving the changes."
  host.errors.each {|attr, msg| puts "    #{attr} #{msg}"}
end


# Delete the host.

puts '', "Deleting this host..."

if newhost.destroy
  puts "  Successful."
else
  puts "  Failed."
end


# Now delete this zone.

puts '', "Deleting the zone..."

if newzone.destroy
  puts "  Successful."
else
  puts "  Failed."
end

