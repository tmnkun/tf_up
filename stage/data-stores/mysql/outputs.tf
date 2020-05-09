output "address" {
    value = aws_db_instance.example.address
    description = "Connect to the databases at this endpoint"
}

output "port" {
    value = aws_db_instance.example.port
    description = "The port the databases is listening on"
}