class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :read, :update, :destroy, to: :crud

    if user.super_usuario?
        can :manage, :all
    else
        if user.directivo?
            can :crud, [Concept, Cost, Department, Employee, EmployeesProjectsRol, EmployeesRol, ExpensesAttachment, Expense, ExpensesGeneralsAttachment, ExpensesGeneral, Hour, HoursEmployee, HoursReport, Income, InvoicesGot, Milestone, Period, PeriodsProjectsEmployee, Project, ProjectsRol, Rol, Task, User]
        end
        if user.pmo?
            can :cru, Customer
        end
        if user.administrador?
            can :cru, Customer
        end
        if user.consultor?
            can :cru, Customer
        end
        if user.auxiliar?
            can :cru, Customer
        end
        if user.default?
            can :read, :all
        end
    end
  end
end
