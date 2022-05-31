# frozen_string_literal: true

require 'minitest/autorun'
require 'csv'

class TestTools < MiniTest::Test
  def test_columns
    buildstock_directory = File.join(File.dirname(__FILE__), '..')

    ['national_baseline', 'testing_baseline'].each do |project|
      buildstockbatch_path = File.join(buildstock_directory, "buildstockbatch/project_#{project.gsub('_baseline', '')}/#{project}/results_csvs/results_up00.csv")
      buildstockbatch = CSV.read(buildstockbatch_path, headers: true)

      run_analysis_path = File.join(buildstock_directory, "run_analysis/project_#{project.gsub('_baseline', '')}/#{project}/results-Baseline.csv")
      run_analysis = CSV.read(run_analysis_path, headers: true)

      puts "\n#{project}"

      buildstockbatch_extras = buildstockbatch.headers - run_analysis.headers
      puts "buildstockbatch - run_analysis: #{buildstockbatch_extras}"

      run_analysis_extras = run_analysis.headers - buildstockbatch.headers
      puts "run_analysis - buildstockbatch: #{run_analysis_extras}"

      buildstockbatch_extras -= ['apply_upgrade.applicable', 'apply_upgrade.upgrade_name', 'apply_upgrade.reference_scenario']
      assert_equal(0, buildstockbatch_extras.size)

      assert_equal(0, run_analysis_extras.size)
    end
  end
end
