require 'spec_helper'

describe "Micropost pages" do
  
  subject { page }

  let(:user) {  FactoryGirl.create(:user) }
  let(:post_btn) { "Post" }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button post_btn }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button post_btn }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button post_btn }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end

    end

    describe "as incorrect user" do
      let(:other_user) { FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")  }
      before do
        FactoryGirl.create(:micropost, user: other_user)    
        visit user_path(other_user)
      end

      it "should not have delete link" do

        page.should_not have_link('delete')
        
      end

    end

  end
end
