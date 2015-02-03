require 'spec_helper'

require "generator_spec"

describe Imigrate::Generators::DataMigrationGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before(:all) do
    prepare_destination
  end

  it "create the templated file" do
    run_generator %w{toto}
    assert_migration "db/data/toto.rb"
  end

end