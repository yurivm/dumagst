require 'matrix'
module Dumagst
  module Matrices
    class NativeMatrix < Base

      class MutableMatrix < ::Matrix
        public :"[]=", :set_element, :set_component
      end

      class << self
        def from_csv(filename, rows_count, columns_count)
          # add padding and discard the row 0 and column 0
          m = new(rows_count: rows_count + 1, columns_count: columns_count + 1)
          CSV.foreach(filename, col_sep: ",") do |row|
            product_id = row[0]
            user_id = row[1]
            m[product_id, user_id] = Base::VALUE_SET
          end
          m
        end
      end

      def initialize(opts)
        rows_count = opts.fetch(:rows_count)
        columns_count = opts.fetch(:columns_count)
        @matrix = MutableMatrix.zero(rows_count, columns_count)
      end

      def rows_count
        matrix.row_count
      end

      def columns_count
        matrix.column_count
      end

      def [](x, y)
        matrix[x.to_i, y.to_i]
      end

      def []=(x, y, v)
        matrix[x.to_i, y.to_i] = v
      end

      def column(y)
        raise "column #{y} is outside of the matrix column range [0..#{columns_count-1}]" unless y < columns_count
        matrix.column(y).to_a
        # col = matrix.column(y).to_a
        # col.empty? ? Array.new(rows_count, 0) : col
      end

      def row(x)
        raise "row #{x} is outside of the matrix row range [0..#{row_count-1}]" unless x < rows_count
        matrix.row(x).to_a
        # row = matrix.row(x).to_a
        # row.empty? ? Array.new(columns_count, 0) : row
      end

      def dimensions
        [rows_count, columns_count]
      end

      private

      attr_accessor :matrix

    end
  end
end