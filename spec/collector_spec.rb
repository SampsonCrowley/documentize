require 'collector'
describe Collector do

  let(:col){ Collector.new }
  let(:lines) { File.readlines("test.rb").map {|line| line.strip} - [""] }
  let(:no_header) { File.readlines("no_header.rb").map {|line| line.strip} - [""] }

  describe "#run" do

    it "parse each class" do

      expect(col.run(lines)[0][0][:type]).to eq("class")
    end

    it "parses each module" do
      expect(col.run(lines)[0][1][:type]).to eq("module")
    end

    it "parses each method" do
      expect(col.run(lines)[0][2][:type]).to eq("method")
    end

    it "returns a file header if it exists" do
      expect(col.run(lines)[1]).to eq("require 'test'")
      expect(col.run(no_header)[1]).to be_nil
    end

  end
end