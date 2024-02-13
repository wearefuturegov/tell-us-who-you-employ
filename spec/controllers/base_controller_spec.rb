require 'rails_helper'

RSpec.describe Admin::EmployeesController, type: :controller do

  describe "GET #index" do
    context "when admin is not set in session" do
      it "redirects to the employees path with a notice" do
        get :index
        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to eq("You don't have permission to access the admin portal.")
      end
    end

    context "when admin is set in session" do
      before { session[:admin] = true }

      it "successfully renders the index" do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "when admin_users is not set in session" do
      it "redirects to the employees path with a notice" do
        put :update, params: { id: 1 }
        expect(response).to redirect_to(employees_path)
        expect(flash[:notice]).to eq("You don't have permission to edit records.")
      end
    end

    context "when admin_users is set in session" do
      before { session[:admin_users] = true }
      let(:service_1) { FactoryBot.create :service, name: 'Rspec Name' }
      let!(:employee_1) { FactoryBot.create :employee, organisation_id: 1, service_id: service_1.id, employed_from: Date.today - 1.year,  job_title: 'Manager/Leader/Supervisor' }

      it "allows the user to access the edit page" do
        get :edit, params: { id: employee_1.id }
        expect(response).to be_successful
      end
    end
  end
end
