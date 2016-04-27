class SMTPListener
  def project_create(project, current_user)
    return nil unless smtp_enabled
    @project_needs_approval_recipients = Staff.admin.pluck(:email)
    @project_created_recipients = Staff.where(id: current_user.id).pluck(:email)
    ProjectMailer.project_created_notifications(project, @project_created_recipients).deliver_later
    ProjectMailer.project_needs_approval_notifications(project, @project_needs_approval_recipients).deliver_later
  end

  def smtp_enabled
    Setting[:smtp_enabled].nil? ? false : Setting[:smtp_enabled]
  end
end
