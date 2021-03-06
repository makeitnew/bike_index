class Admin::OrganizationInvitationsController < Admin::BaseController
  before_filter :find_organization_invitation, only: [:edit, :update, :destroy]
  
  def index
    @organization_invitations = OrganizationInvitation.all
  end
  
  def new
    @organization_invitation = OrganizationInvitation.new
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
    @organizations = Organization.all
    @organization_invitations = OrganizationInvitation.where(organization_id: @organization.id)
    @organization_invitation = OrganizationInvitation.new(organization_id: @organization.id)
  end

  def edit
    @organizations = Organization.all
  end

  def update
    if @organization_invitation.update_attributes(params[:organization_invitation])
      flash[:notice] = "Invitation Saved!"
      redirect_to admin_organization_invitations_url
    else
      render action: :edit
    end
  end

  def create
    @organization_invitation = OrganizationInvitation.new(params[:organization_invitation])
    @organization_invitation.inviter = current_user
    
    @organization = @organization_invitation.organization
    if @organization.available_invitation_count > 0
      if @organization_invitation.save
        redirect_to admin_organization_url(@organization_invitation.organization.slug), notice: "#{@organization_invitation.invitee_email} was invited to #{@organization.name}!"
      else
        flash[:error] = "Oh no! Error problem things! The invitation was not saved. Maybe we're missing some information?"
        redirect_to edit_admin_organization_invitation_url(@organization_invitation.organization.id)
      end
    else
      redirect_to root_url, notice: "Oh no! This organization has no more invitations."
    end
  end

  def destroy
    @organization_invitation.destroy
    redirect_to admin_memberships_url
  end



  protected

  def find_organization_invitation
    @organization_invitation = OrganizationInvitation.find(params[:id])
  end

end
