require 'documentize'

describe Documentize do
  let (:doc) {Documentize.new("test.rb")}
  let (:exe) {Documentize.new("testexe")}
  let (:txt) {Documentize.new("test.txt")}
  let (:no_start) { Documentize.new }

  describe "#new" do
    it "requires a file as a parameter" do
      expect{no_start}.to raise_error(ArgumentError)
    end

    it "raises an error if not a ruby file" do
      expect{txt}.to raise_error(ArgumentError)
    end

    it "does not raise an error when given a ruby file or exe" do
      expect{doc}.not_to raise_error
    end

    it "loads a file on init" do
      expect(doc.file).not_to be_nil
    end

  end

  describe "#run" do

    it "gets the doc tree and header from Collector" do
      doc.run
      expect(doc.tree).not_to be_nil
      expect(doc.header).to be_a(String)
    end

    it "runs the gen_docs method" do
      expect(doc).to receive(:gen_docs)
      doc.run
    end

  end

end