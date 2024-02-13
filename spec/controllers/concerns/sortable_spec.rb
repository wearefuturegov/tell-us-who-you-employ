require 'rails_helper'

RSpec.describe Sortable do
  let(:test_class) { Class.new { include Sortable } }
  let(:sortable_instance) { test_class.new }

  describe '#apply_sort' do
    let(:collection) { double('collection') }
    let(:sort_params) { { sort: 'employees_count', direction: 'asc' } }
    let(:default_column) { 'name' }
    let(:allowed_columns) { ['name', 'employees_count', 'service_name', 'full_address', 'roles', 'qualifications', 'status'] }

    context 'when sort column is "employees_count"' do
      it 'applies the correct sorting to the collection' do
        allow(collection).to receive(:table_name).and_return('mock_table')
        expect(collection).to receive(:left_joins).with(:employees).and_return(collection)
        expect(collection).to receive(:group).with("mock_table.id").and_return(collection)
        expect(collection).to receive(:select).with("mock_table.*, COUNT(employees.id) as employees_count").and_return(collection)
        expect(collection).to receive(:order).with("employees_count asc").and_return(collection)
    
        sortable_instance.apply_sort(collection, sort_params, default_column, allowed_columns)
      end
    end
    

    context 'when sort column is "service_name"' do
      it 'applies the correct sorting to the collection' do
        expect(collection).to receive(:joins).with(:service).and_return(collection)
        expect(collection).to receive(:order).with("services.name asc").and_return(collection)

        sortable_instance.apply_sort(collection, { sort: 'service_name', direction: 'asc' }, default_column, allowed_columns)
      end
    end

    context 'when sort column is "full_address"' do
      it 'applies the correct sorting to the collection' do
        expect(collection).to receive(:order_by_full_address).with('asc').and_return(collection)

        sortable_instance.apply_sort(collection, { sort: 'full_address', direction: 'asc' }, default_column, allowed_columns)
      end
    end

    context 'when sort column is "roles"' do
      it 'applies the correct sorting to the collection' do
        allow(collection).to receive(:order_by_roles).with('asc').and_return(collection)
    
        sortable_instance.apply_sort(collection, { sort: 'roles', direction: 'asc' }, default_column, allowed_columns)
    
        expect(collection).to have_received(:order_by_roles).with('asc')
      end
    end
    
    
    

    context 'when sort column is "qualifications"' do
      it 'applies the correct sorting to the collection' do
        expect(collection).to receive(:order).with("qualifications asc").and_return(collection)
    
        sortable_instance.apply_sort(collection, { sort: 'qualifications', direction: 'asc' }, default_column, allowed_columns)
      end
    end
    

    context 'when sort column is "status"' do
      it 'applies the correct sorting to the collection' do
        expect(collection).to receive(:order).with("currently_employed asc").and_return(collection)
    
        sortable_instance.apply_sort(collection, { sort: 'status', direction: 'asc' }, default_column, allowed_columns)
      end
    end
    

    context 'when sort column is not in the allowed columns' do
      it 'applies the default sorting to the collection' do
        expect(collection).to receive(:order).with("name asc").and_return(collection)

        sortable_instance.apply_sort(collection, { sort: 'invalid_column', direction: 'asc' }, default_column, allowed_columns)
      end
    end
  end
end