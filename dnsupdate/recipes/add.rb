include_recipe 'route53'

route53_record "create/replace A record" do
  name node[:opsworks][:instance][:hostname] + "." + node[:dns_forward_zone_name]
  value node[:opsworks][:instance][:private_ip]
  type "A"
  ttl 60
  zone_id node[:dns_forward_zone_id]
  overwrite true
  action :create
end

ruby_block "ptrrecord" do
  block do
    seg = node[:opsworks][:instance][:private_ip].strip.split(".")
    node.set['ptrrecord'] = seg[3] + "." + seg[2] + "." + node[:dns_reverse_zone_name]
  end
  action :create
end

route53_record "create/replace PTR record" do
  name lazy { node['ptrrecord'] } 
  value node[:opsworks][:instance][:hostname] + "." + node[:dns_forward_zone_name] + "."
  type "PTR"
  ttl 60
  zone_id node[:dns_reverse_zone_id]
  overwrite true
  action :create
end
