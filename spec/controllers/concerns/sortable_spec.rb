require 'rails_helper'

RSpec.describe Sortable do
  let(:test_class) { Class.new { include Sortable } }
  let(:sortable_instance) { test_class.new }

  describe '#apply_sort' do
    let(:collection) { double('collection') }
    let(:sort_params) { { sort: 'employees_count', direction: 'asc' } }
    let(:default_column) { 'name' }
    let(:allowed_columns) { ['name', 'employees_count', 'service_name', 'full_address'] }

    context 'when sort column is "service_name"' do
      it 'applies the correct sorting to the collection' do
        expect(collection).to receive(:joins).with(:service).and_return(collection)
        expect(collection).to receive(:order).with('services.name asc').and_return(collection)

        sortable_instance.apply_sort(collection, { sort: 'service_name', direction: 'asc' }, default_column, allowed_columns)
      end
    end
  end
end