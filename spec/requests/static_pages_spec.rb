require 'spec_helper'

describe "StaticPages" do

  subject { page }
  
  describe "Home page" do

    before { visit root_path }

    it { should have_content('Wiki Practice') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }
  end

  describe "About page" do
    
    before { visit about_path }

    it { should have_content('About the project') }
    it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
    
    before { visit contact_path }

    it { should have_content('Contact us') }
    it { should have_title(full_title('Contact')) }
  end
end
