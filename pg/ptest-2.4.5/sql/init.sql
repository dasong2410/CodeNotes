create extension if not exists citushelper;

create extension if not exists postgis;
create extension if not exists btree_gist;

create extension if not exists address_standardizer;
create extension if not exists address_standardizer_data_us;
create extension if not exists fuzzystrmatch;
create extension if not exists postgis_tiger_geocoder;
create extension if not exists postgis_topology;

select from master_add_node('localhost', :worker_1_port);
select from master_add_node('localhost', :worker_2_port);


\c - - - :worker_1_port
create extension if not exists citushelper;

create extension if not exists postgis;
create extension if not exists btree_gist;

create extension if not exists address_standardizer;
create extension if not exists address_standardizer_data_us;
create extension if not exists fuzzystrmatch;
create extension if not exists postgis_tiger_geocoder;
create extension if not exists postgis_topology;


\c - - - :worker_2_port
create extension if not exists citushelper;

create extension if not exists postgis;
create extension if not exists btree_gist;

create extension if not exists address_standardizer;
create extension if not exists address_standardizer_data_us;
create extension if not exists fuzzystrmatch;
create extension if not exists postgis_tiger_geocoder;
create extension if not exists postgis_topology;
