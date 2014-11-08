describe Dumagst::Matrix do
  subject { Dumagst::Matrix.new }
  describe "#[]" do
    before(:each) { subject.send(:redis).flushdb }
    it "returns zero if the element has not been set" do
      expect(subject[1, 2]).to eq(0.0)
    end
    it "returns the value for x,y if set before" do
      subject[1, 42] = 1
      expect(subject[1, 42]).to eq(1)
    end
    it "increments the row count if you set an element beyond current dimensions" do
      subject[3, 0] = 1.11
      expect(subject.rows_count).to eq(3)
      subject[8, 2] = 2.11
      expect(subject.rows_count).to eq(8)
    end
    it "increments the column count if you set an element beyond current dimensions" do
      subject[3, 6] = 1.11
      expect(subject.columns_count).to eq(6)
      subject[8, 22] = 2.11
      expect(subject.columns_count).to eq(22)      
    end
    xit "raises an exception if you ask for values beyond current dimensions" do
      subject[10, 6] = "bam"
      expect { subject[10, 6] }.to raise_error
      expect { subject[9, 6] }.to raise_error
      expect { subject[10, 5] }.to raise_error
      expect { subject[12, 7] }.to raise_error
      expect { subject[9, 5]}.to_not raise_error
    end
  end

  describe ".from_csv" do
    before(:each) { subject.send(:redis).flushdb }
    let(:csv_file) { File.join(File.dirname(__FILE__), "..", "fixtures", "products_users.csv") }
    subject { Dumagst::Matrix.from_csv(csv_file) }
    it "produces a matrix with correct dimensions" do
      expect(subject).to be_a(Dumagst::Matrix)
      expect(subject.dimensions).to eq([1448, 943])
    end
    it "produces a matrix with values correctly set" do
      m = Dumagst::Matrix.from_csv(csv_file)
      expect(m[9, 200]).to eq(0.0)
      expect(m[419, 276]).to eq(1.0)
    end
  end

  describe "#column" do
    let(:csv_file) { File.join(File.dirname(__FILE__), "..", "fixtures", "products_users.csv") }
    subject { Dumagst::Matrix.from_csv(csv_file) }
    it "returns the column as an array with correct size" do
      col = subject.column(845)
      expect(col).to be_a(Array)
      expect(col.size).to eq(1448)
    end
    it "returns the column as an array with the correct number of ones" do
      col = subject.column(137)
      expect(col.select { |e| e == 1}.count).to eq(2)
    end
  end
end