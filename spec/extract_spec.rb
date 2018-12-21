require "extract"

RSpec.describe("extract") do
  let(:source) { File.dirname(__FILE__) + "/fixtures/minspecs.htm" }
  subject(:extracted) { extract(File.read(source)) }

  it "extracts the title" do
    expect(subject.title).to eq("Min Specs")
  end

  it "extracts the purpose" do
    expect(subject.purpose).to eq("Specify Only the Absolute “Must dos” and “Must not dos” for Achieving a Purpose (35-50 min.)\n\n")
  end

  it "extracts the middle paras" do
    preamble = subject.preamble
    expect(preamble).to match(/^A designer knows perfection/)
    expect(preamble).to match(/possible for the group to go wild!$/)
  end

  it "extracts the minspecs" do
    minspecs = subject.minspecs
    expect(minspecs).to match(/^Five Structural Elements – Min Specs$/)
    expect(minspecs).to match(/Compare across small groups and consolidate to the shortest list. 15 min.$/)
  end

  it "extracts the tips_and_traps" do
    expect(subject.tips_and_traps).to match(/^* Focus attention on a tangible challenge/)
  end

  it "extracts the riffs_and_variations" do
    expect(subject.riffs_and_variations).to match(/^* Do a second round of purpose testing/)
  end

  it "extracts the examples" do
    expect(subject.examples).to match(/^* Senator Lynda Bourque Moss used/)
  end

  it "extracts the attribution" do
    expect(subject.attribution).to match(/^'''Attribution''': Liberating Structure developed by Henri Lipmanowicz/)
  end

  it "extracts the purposes" do
    expect(subject.purposes).to match(/\* Evaluate and decide what is absolutely essential/)
  end

  it "extracts the collateral_material" do
    expect(subject.collateral_material).to match(/Presentation materials we use to introduce Min Specs/)
  end
end
