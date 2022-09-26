:setvar StudentKey "A02A8D13-D8E9-4B7C-96B3-F5C20ABD985D"

use Learning;
GO

-- Display the courses enrolled in by the student.
-- NOTE: Note how adding the join to Term changes the execution plan.
--       Note same query below, but without Term.
select
	s.DisplayName					as StudentName,
	formatmessage('%s %i', t.SeasonName, t.CalendarYear)
									as TermName,
	c.DisplayName					as CourseName,
	c.Level							as CourseLevel,
	d.DisplayName					as DepartmentName,
	p.DisplayName					as ProfessorName,
	''								as CampusName,
	''								as BuildingName,
	''								as ClassroomName
from
	Enrollment.CourseOfferingEnrollment coe
inner join
	Enrollment.CourseOffering co
on
	co.InstitutionKey = coe.InstitutionKey
and
	co.CourseOfferingKey = coe.CourseOfferingKey
inner join
	Organization.Department d
on
	d.InstitutionKey = co.InstitutionKey
and
	d.DepartmentKey = co.DepartmentKey
inner join
	Curriculum.Course c
on
	c.InstitutionKey = co.InstitutionKey
and
	c.DepartmentKey = co.DepartmentKey
and
	c.CourseKey = co.CourseKey
inner join
	Organization.Professor p
on
	p.InstitutionKey = co.InstitutionKey
and
	p.DepartmentKey = co.DepartmentKey
and
	p.ProfessorKey = co.ProfessorKey
inner join
	Enrollment.Term t
on
	t.InstitutionKey = co.InstitutionKey
and
	t.TermKey = co.TermKey
inner join
	Enrollment.Student s
on
	s.InstitutionKey = coe.InstitutionKey
and
	s.StudentKey = coe.StudentKey
where
	s.StudentKey = '$(StudentKey)'
order by
	d.DisplayName,
	c.Level,
	c.DisplayName;
GO

-- Display the courses enrolled in by the student.
select
	s.DisplayName					as StudentName,
	--formatmessage('%s %i', t.SeasonName, t.CalendarYear)
	--								as TermName,
	c.DisplayName					as CourseName,
	c.Level							as CourseLevel,
	d.DisplayName					as DepartmentName,
	p.DisplayName					as ProfessorName,
	''								as CampusName,
	''								as BuildingName,
	''								as ClassroomName
from
	Enrollment.CourseOfferingEnrollment coe
inner join
	Enrollment.CourseOffering co
on
	co.InstitutionKey = coe.InstitutionKey
and
	co.CourseOfferingKey = coe.CourseOfferingKey
inner join
	Organization.Department d
on
	d.InstitutionKey = co.InstitutionKey
and
	d.DepartmentKey = co.DepartmentKey
inner join
	Curriculum.Course c
on
	c.InstitutionKey = co.InstitutionKey
and
	c.DepartmentKey = co.DepartmentKey
and
	c.CourseKey = co.CourseKey
inner join
	Organization.Professor p
on
	p.InstitutionKey = co.InstitutionKey
and
	p.DepartmentKey = co.DepartmentKey
and
	p.ProfessorKey = co.ProfessorKey
--inner join
--	Enrollment.Term t
--on
--	t.InstitutionKey = co.InstitutionKey
--and
--	t.TermKey = co.TermKey
inner join
	Enrollment.Student s
on
	s.InstitutionKey = coe.InstitutionKey
and
	s.StudentKey = coe.StudentKey
where
	s.StudentKey = '$(StudentKey)'
order by
	d.DisplayName,
	c.Level,
	c.DisplayName;
GO
