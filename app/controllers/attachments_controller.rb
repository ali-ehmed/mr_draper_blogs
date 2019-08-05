class AttachmentsController < ApplicationController
  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { head :ok }
    end
  end
end