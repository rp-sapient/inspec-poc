# copyright: 2018, The Authors

title "Sample Section"

gcp_project_id = input("gcp_project_id")

# you add controls here
control "gcp-single-region-1.0" do                                                    # A unique ID for this control
  impact 1.0                                                                          # The criticality, if this control fails.
  title "Ensure single region has the correct properties."                            # A human-readable title
  desc "An optional description..."
  describe google_compute_region(project: gcp_project_id, name: "europe-west2") do    # The actual test
    its("zone_names") { should include "europe-west2-a" }
  end
end

# plural resources can be leveraged to loop across many resources
control "gcp-regions-loop-1.0" do                                                     # A unique ID for this control
  impact 1.0                                                                          # The criticality, if this control fails.
  title "Ensure regions have the correct properties in bulk."                         # A human-readable title
  desc "An optional description..."
  google_compute_regions(project: gcp_project_id).region_names.each do |region_name|  # Loop across all regions by name
    describe google_compute_region(project: gcp_project_id, name: region_name) do     # The test for a single region
      it { should be_up }
    end
  end
end

control "gcp-cloud-sql-1.0" do
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