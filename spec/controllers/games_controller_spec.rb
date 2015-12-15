require 'rails_helper'



RSpec.describe GamesController, type: :controller do

    # This should return the minimal set of attributes required to create a valid
    # Game. As you add validations to Game, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) {
    }

    let(:invalid_attributes) {
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # GamesController. Be sure to keep this updated too.
    let(:valid_session) { {} }


      context "user is signed in" do
        let(:test_user) {
          name: "Test User",
          email: "test@test.co",
          password: "testpassword"
         }

        before "Test user" do
          sign_in test_user
          controller.stub(:user_signed_in?).and_return(true)
          controller.stub(:current_user).and_return(test_user)
          controller.stub(:authenticate_user!).and_return(test_user)
        end

        context 'user is in game' do

          before do
            controller.current_user.expect(admin?: true)#ASSIGN GAME!!!!!!
          end

          context 'user is not an admin' do
            before do
              controller.current_user.expect(admin?: false)
            end

            describe 'GET new' do
              it 'redirects user to the login page' do
                category = Game.create! valid_attributes
                get :index, {}, valid_session
                expect(controller.games).to eq([game])
              end
            end
          end

          context 'user is an admin' do
            before do
              controller.current_user.stub(admin?: true)
            end

          end
        end

        context 'user is not in game' do
        end




#TRASH!!!!!!!!!!_------------------------
        describe "POST #create" do
          context "with valid params" do
            let(:params) do
              {
                gallery: { title: "MyTitle", user: test_user, description: "MyDesc",
                    images_attributes: [{ title: "ImgTitle",
                                          description: "ImgDescription",
                                          user: test_user,
                                          picture_file_name: 'test-image.jpg' }] }
              }
            end

            subject { post :create, params }

            it "is successful" do
              subject
              expect(response).to be_successful
            end

            it "creates a new Gallery" do
              expect{ subject }.to change{ Gallery.count }.by(1)
            end

            it "creates some new Images" do
              expect{ subject }.to change(Image, :count).by(1)
            end

            it "redirects to the Gallery page" do
              subject
              expect(response).to redirect_to(gallery_path(Gallery.last))
            end
          end
        end
      end


end
