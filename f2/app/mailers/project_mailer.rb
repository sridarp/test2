class ProjectMailer < ActionMailer::Base
  default from: Setting[:smtp_default_sender]

  def project_created_notifications(project, recipients)
    subject = "Project Created Notification: #{project['name'].to_s.upcase}"
    send_project_mail(project, subject, recipients)
  end

  def project_needs_approval_notifications(project, recipients)
    subject = "Project Needs Approval Notification: #{project['name'].to_s.upcase}"
    send_project_mail(project, subject, recipients)
  end

  private

  def send_project_mail(project, subject, recipients)
    set_smtp_settings
    @subject = subject
    @project = project
    @project_url = project_url(project)
    mail(subject: @subject, to: recipients)
  end

  def project_url(project)
    # TODO: FIGURE OUT BETTER WAY TO BUILD PROJECT URL
    (Rails.env != 'test') ? (Rails.application.routes.url_helpers.root_url + 'projects/' + project.id.to_s) : ('http://localhost:3000/projects/' + project.id.to_s)
  end

  def set_smtp_settings
    # TODO: REFACTOR TO ONLY RUN ONCE THE FIRST TIME ITS CALLED
    # SINCE ACTION MAILER WILL INITIALIZE WITH DEMO SMTP SETTINGS
    # WE NEED TO RUN THIS TO APPLY ACTUAL CREDENTIALS TO SEND MAIL
    ActionMailer::Base.smtp_settings = {
      address:              Setting[:smtp_address],
      port:                 Setting[:smtp_port],
      user_name:            Setting[:smtp_user_name],
      password:             Setting[:smtp_password],
      authentication:       Setting[:smtp_authentication],
      enable_starttls_auto: Setting[:smtp_enable_starttls_auto]
    }
  end
end
