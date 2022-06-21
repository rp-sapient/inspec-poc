# copyright: 2018, The Authors

title "Sample Section"

gcp_project_id = input("gcp_project_id")

control "gcp-cloud-sql" do
    impact 1.0
    title "Ensure cloud sql"
    desc "An optional description..."
    google_sql_database_instances(project:gcp_project_id).instance_names.each do |instance_name|
      instance = google_sql_database_instance(project: gcp_project_id, database: instance_name)

      describe "Instance name $#{instance.name}$ of cloud sql" do
        subject{instance.settings.availability_type}
        it { should cmp 'REGIONAL' }
      end
    end
end