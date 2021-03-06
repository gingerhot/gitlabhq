module Team
  def team_member_by_name_or_email(email = nil, name = nil)
    user = users.where("email like ? or name like ?", email, name).first
    users_projects.find_by_user_id(user.id) if user
  end

  # Get Team Member record by user id
  def team_member_by_id(user_id)
    users_projects.find_by_user_id(user_id)
  end

  # Add user to project
  # with passed access role
  def add_user_to_team(user, access_role)
    add_user_id_to_team(user.id, access_role)
  end

  # Add multiple users to project
  # with same access role
  def add_users_to_team(users, access_role)
    add_users_ids_to_team(users.map(&:id), access_role)
  end

  # Add user to project
  # with passed access role by user id
  def add_user_id_to_team(user_id, access_role)
    users_projects.create(
      :user_id => user_id,
      :project_access => access_role
    )
  end

  # Add multiple users to project
  # with same access role by user ids
  def add_users_ids_to_team(users_ids, access_role)
    UsersProject.bulk_import(self, users_ids, access_role)
    self.update_repository
  end
end
