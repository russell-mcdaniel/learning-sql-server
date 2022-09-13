use Learning;
GO

-- Classrooms
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	c.CampusKey				as CampusKey,
	c.DisplayName			as CampusName,
--	b.BuildingKey			as BuildingKey,
	b.DisplayName			as BuildingName,
--	r.ClassroomKey			as ClassroomKey,
	r.DisplayName			as ClassroomName
from
	Organization.Institution i
inner join
	Organization.Campus c
on
	c.InstitutionKey = i.InstitutionKey
inner join
	Organization.Building b
on
	b.InstitutionKey = c.InstitutionKey
and
	b.CampusKey = c.CampusKey
inner join
	Organization.Classroom r
on
	r.InstitutionKey = b.InstitutionKey
and
	r.CampusKey = b.CampusKey
and
	r.BuildingKey = b.BuildingKey
order by
	i.DisplayName,
	c.DisplayName,
	b.DisplayName,
	r.DisplayName;
GO

-- Programs
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	d.DepartmentKey			as DepartmentKey,
	d.DisplayName			as DepartmentName,
--	p.CourseKey				as ProgramKey,
	p.DisplayName			as ProgramName,
	p.ProgramType			as ProgramType
from
	Organization.Institution i
inner join
	Organization.Department d
on
	d.InstitutionKey = i.InstitutionKey
inner join
	Curriculum.Program p
on
	p.InstitutionKey = d.InstitutionKey
and
	p.DepartmentKey = d.DepartmentKey
order by
	i.DisplayName,
	d.DisplayName,
	p.ProgramType,
	p.DisplayName;
GO

-- Courses
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	d.DepartmentKey			as DepartmentKey,
	d.DisplayName			as DepartmentName,
--	c.CourseKey				as CourseKey,
	c.DisplayName			as CourseName,
	c.Level					as CourseLevel
from
	Organization.Institution i
inner join
	Organization.Department d
on
	d.InstitutionKey = i.InstitutionKey
inner join
	Curriculum.Course c
on
	c.InstitutionKey = d.InstitutionKey
and
	c.DepartmentKey = d.DepartmentKey
order by
	i.DisplayName,
	d.DisplayName,
	c.Level,
	c.DisplayName;
GO

-- Program-Courses
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	d.DepartmentKey			as DepartmentKey,
	d.DisplayName			as DepartmentName,
--	p.CourseKey				as ProgramKey,
	p.DisplayName			as ProgramName,
	p.ProgramType			as ProgramType,
--	c.CourseKey				as CourseKey,
	c.DisplayName			as CourseName,
	c.Level					as CourseLevel
from
	Organization.Institution i
inner join
	Organization.Department d
on
	d.InstitutionKey = i.InstitutionKey
inner join
	Curriculum.Program p
on
	p.InstitutionKey = d.InstitutionKey
and
	p.DepartmentKey = d.DepartmentKey
inner join
	Curriculum.ProgramCourse pc
on
	pc.InstitutionKey = p.InstitutionKey
and
	pc.DepartmentKey = p.DepartmentKey
and
	pc.ProgramKey = p.ProgramKey
inner join
	Curriculum.Course c
on
	c.InstitutionKey = pc.InstitutionKey
and
	c.DepartmentKey = pc.DepartmentKey
and
	c.CourseKey = pc.CourseKey
order by
	i.DisplayName,
	d.DisplayName,
	p.ProgramType,
	p.DisplayName,
	c.Level;
GO

-- Professors
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	d.DepartmentKey			as DepartmentKey,
	d.DisplayName			as DepartmentName,
--	p.ProfessorKey			as ProfessorKey,
	p.DisplayName			as ProfessorName
from
	Organization.Institution i
inner join
	Organization.Department d
on
	d.InstitutionKey = i.InstitutionKey
inner join
	Organization.Professor p
on
	p.InstitutionKey = d.InstitutionKey
and
	p.DepartmentKey = d.DepartmentKey
order by
	i.DisplayName,
	d.DisplayName,
	p.DisplayName;
GO

-- Students
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	s.StudentKey			as StudentKey,
	s.DisplayName			as StudentName
from
	Organization.Institution i
inner join
	Enrollment.Student s
on
	s.InstitutionKey = i.InstitutionKey
order by
	i.DisplayName,
	s.DisplayName;
GO

-- Student Programs
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	s.StudentKey			as StudentKey,
	s.DisplayName			as StudentName,
--	p.ProgramKey			as ProgramKey,
	p.DisplayName			as ProgramName,
	p.ProgramType			as ProgramType
from
	Organization.Institution i
inner join
	Enrollment.Student s
on
	s.InstitutionKey = i.InstitutionKey
inner join
	Enrollment.StudentProgram sp
on
	sp.InstitutionKey = s.InstitutionKey
and
	sp.StudentKey = s.StudentKey
inner join
	Curriculum.Program p
on
	p.InstitutionKey = sp.InstitutionKey
and
	p.DepartmentKey = sp.DepartmentKey
and
	p.ProgramKey = sp.ProgramKey
order by
	i.DisplayName,
	s.DisplayName,
	p.ProgramType,
	p.DisplayName
GO

-- Terms
select
--	i.InstitutionKey		as InstitutionKey,
	i.DisplayName			as InstitutionName,
--	t.TermKey				as TermKey,
	t.AcademicYear			as TermAcademicYear,
	t.CalendarYear			as TermCalendarYear,
	t.SeasonName			as TermSeasonName
from
	Organization.Institution i
inner join
	Enrollment.Term t
on
	t.InstitutionKey = i.InstitutionKey
order by
	i.DisplayName,
	t.AcademicYear,
	t.CalendarYear;
GO
