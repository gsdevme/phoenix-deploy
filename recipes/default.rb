if node['phoenix']['vhosts'] && node['phoenix']['user'] && node['phoenix']['group']
    node['phoenix']['vhosts'].each do |vhost|
        [
            "/var/www/#{vhost}",
            "/var/www/#{vhost}/shared",
            "/var/www/#{vhost}/releases",
        ].each do |folder|
            directory folder do
              owner node['phoenix']['user']
              group node['phoenix']['group']
              mode "775"
              recursive true
              action :create
            end
        end

        node['phoenix']['apps'].each do |app|
            [
                "/var/www/#{vhost}/shared/#{app}",
                "/var/www/#{vhost}/shared/#{app}/config",
                "/var/www/#{vhost}/shared/#{app}/spool",
                "/var/www/#{vhost}/shared/#{app}/spool/default",
                "/var/www/#{vhost}/shared/#{app}/generated_images",
                "/var/www/#{vhost}/shared/#{app}/dataexchange",
                "/var/www/#{vhost}/shared/#{app}/logs",
                "/var/www/#{vhost}/shared/#{app}/cache",
                "/var/www/#{vhost}/shared/cached-copy",
            ].each do |folder|
                directory folder do
                  owner node['phoenix']['user']
                  group node['phoenix']['group']
                  mode "775"
                  recursive true
                  action :create
                end
            end
        end

        node['phoenix']['apps'].each do |app|
            [
                "/var/www/#{vhost}/shared/#{app}/spool",
                "/var/www/#{vhost}/shared/#{app}/logs",
            ].each do |folder|
                directory folder do
                  owner node['phoenix']['user']
                  group node['phoenix']['group']
                  mode "775"
                  recursive true
                  action :create
                end

                execute "setfacl #{app}" do
                  command "setfacl -dR -m u:#{node['phoenix']['user']}:rwX -m u:nginx:rwX #{folder}"
                  action :run
                end
            end
        end
        
        node['phoenix']['apps'].each do |app|
            [
                "/var/www/#{vhost}/shared/#{app}/spool/default",
            ].each do |folder|
                directory folder do
                  owner node['phoenix']['user']
                  group "nginx"
                  mode "775"
                  recursive true
                  action :create
                end

                execute "setfacl #{app}" do
                  command "setfacl -dR -m u:#{node['phoenix']['user']}:rwX -m u:nginx:rwX #{folder}"
                  action :run
                end
            end
        end
    end
end


