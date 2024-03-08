class UpdateJobTitles < ActiveRecord::Migration[6.1]
  def up
    job_titles = {
      "ROOM LEADER/SUPERVISOR" => "Room Leader/Supervisor",
      "CHILDMINDER" => "Childminder",
      "PLAYWORKER" => "Playworker",
      "NURSERY/PRE-SCHOOL ASSISTANT" => "Nursery/Pre-School Assistant",
      "OWNER/PROPRIETOR/DIRECTOR" => "Owner/Proprietor/Director",
      "MANAGER/LEADER/SUPERVISOR" => "Manager/Leader/Supervisor",
      "ASSISTANT CHILDMINDER" => "Assistant Childminder",
      "FINANCE/ADMINISTRATOR/SECRETARY" => "Finance/Administrator/Secretary",
      "LEAD PRACTITIONER" => "Lead Practitioner",
      "CLEANER/CARETAKER/CATERING" => "Cleaner/Caretaker/Catering",
      "DEPUTY MANAGER/LEADER/SUPERVISOR" => "Deputy Manager/Leader/Supervisor",
      "VOLUNTEER" => "Volunteer",
      "CHAIR PERSON" => "Chair Person",
      "APPRENTICE/INTERN" => "Apprentice/Intern",
      "TREASURER" => "Treasurer",
      "NANNY" => "Nanny",
      "ACTING DEPUTY MANAGER/LEADER/SUPERVISOR" => "Acting Deputy Manager/Leader/Supervisor",
      "ACTING MANAGER/LEADER/SUPERVISOR" => "Acting Manager/Leader/Supervisor",
      "On maternity leave" => "On Maternity Leave"
    }

    job_titles.each do |old_title, new_title|
      Employee.where(job_title: old_title).update_all(job_title: new_title)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
