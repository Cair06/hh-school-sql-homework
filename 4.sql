-- берём конкретный год+месяц, а не просто номер месяца.
(
  SELECT
    'вакансии' AS type,
    TO_CHAR(created_at, 'YYYY Month') AS period,
    COUNT(*) AS total
  FROM vacancies
  GROUP BY TO_CHAR(created_at, 'YYYY Month')
  ORDER BY total DESC
  LIMIT 1
)
UNION ALL
(
  SELECT
    'резюме' AS type,
    TO_CHAR(created_at, 'YYYY Month') AS period,
    COUNT(*) AS total
  FROM resumes
  GROUP BY TO_CHAR(created_at, 'YYYY Month')
  ORDER BY total DESC
  LIMIT 1
);
