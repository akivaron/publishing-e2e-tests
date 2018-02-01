require_relative "../docker_service"

namespace :docker do
  task :wait_for_dbs do
    DockerService.wait_for_healthy_services(services: %w(elasticsearch mongo mysql postgres))
  end
end
