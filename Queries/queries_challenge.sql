-- Challenge

--Joining table with employee details by title
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	t.title,
	t.from_date,
	s.salary
INTO emp_by_title
FROM retirement_info as ri
INNER JOIN titles as t
ON (ri.emp_no = t.emp_no)
INNER JOIN salaries as s
ON (ri.emp_no = s.emp_no);

--Remove duplicates and display number of employees retiring per title
SELECT title, COUNT(emp_no)
INTO emp_count_by_latest_title
FROM (SELECT *,ROW_NUMBER() OVER
	 (PARTITION BY (emp_no) ORDER BY from_date DESC) rn
	 FROM emp_by_title) tmp WHERE rn = 1
 GROUP BY title
 ORDER BY title;
 
 -- Mentorship Eligibility
SELECT e.emp_no, e.first_name, e.last_name, t.title,
 	de.from_date, t.from_date as title_date, de.to_date
INTO mentorship
FROM employees AS e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');

SELECT emp_no, first_name, last_name, title, from_date, to_date
INTO mentorship_eligibility
FROM (SELECT *,ROW_NUMBER() OVER
	 (PARTITION BY (emp_no) ORDER BY title_date DESC) rn
	 FROM mentorship) tmp WHERE rn = 1
 ORDER BY emp_no;