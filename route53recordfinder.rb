#progam code
require 'json'
# Lists DNS public DNS zones in Route53 (info is stored in new array)
dns_list_json = %x(aws-vault exec sandbox-power -- aws route53 list-hosted-zones)
parsed_dns_hash= JSON.parse(dns_list_json)
#puts JSON.pretty_generate(parsed_dns_hash).gsub(":", " =>")


# Lines 10 - 16 - Use the public DNS list and stores matching
# public zones in an array
a_zone_id_list = []
zone_list = parsed_dns_hash["HostedZones"]
zone_list.each do |a_zone|
  if a_zone["Config"]["PrivateZone"] == false
    a_zone_id_list.append(a_zone["Id"])
  end
end

# Lines 20 - 23, pulls the hosted zones from the array
# created directly above and stores it in another array
zone_ids = []
a_zone_id_list.each do |zone_id|
  zone_ids << zone_id.split('/').last
end
#puts zone_ids

a_records_list = %x(aws-vault exec sandbox-power -- aws route53 list-resource-record-sets --hosted-zone-id Z16FONIR8CZGWM --query "ResourceRecordSets[?Type == 'A'].ResourceRecords[*].Value[]")
puts a_records_list


#zone_ids.each do |zone_id|
#  %x(aws-vault exec sandbox-terraform -- aws route53 list-resource-record-sets --hosted-zone-id Z16FONIR8CZGWM --query "ResourceRecordSets[?Type == 'A'].ResourceRecords[*].Value[]")
#end

#For each public DNS zone, using the hosted zone ID, find all "A" records
# Step 1-  Loop through the "a_zone_id_list" array and pull out the Zone IDs
#zone_id_for_a_record = []
#a_zone_id_list.each do |zone_id|
#  zone_id_for_a_record.append( a_zone_id_list.split("e/",2))
#end
#print zone_id_for_a_record
# We are now working with a hash
# loop through Zones and for each zone
# loop through records for each A record
# end Zones loop
