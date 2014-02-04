name "mysql_server"
description "Configure host to run MySQL server."
run_list(
  "recipe[mysql::server]"
)
default_attributes(
  :mysql => {
    :bind_address => "127.0.0.1",
    :tunable => {
      :key_buffer => "384M",
      :table_cache => "4096",
      :max_allowed_packet => "64M",
      :innodb_buffer_pool_size => "512M",
      :wait_timeout => "1800",
      :innodb_additional_mem_pool_size => "24M",
      :innodb_flush_log_at_trx_commit => "1"
    }
  }
)
