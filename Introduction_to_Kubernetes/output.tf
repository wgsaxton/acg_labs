output "servers_public_ip" {
    value = [for inst in aws_instance.k8s_instances: inst.public_ip]
}

output "servers_name" {
    value = [for inst in aws_instance.k8s_instances: inst.tags.Name]
}