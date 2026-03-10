-- DATE_TRUNC возвращает timestamp, не зависит от локали сервера
(
  SELECT
    'вакансии' AS type,
    DATE_TRUNC('month', created_at) AS period,
    COUNT(*) AS total
  FROM vacancies
  GROUP BY DATE_TRUNC('month', created_at)
  ORDER BY total DESC
  LIMIT 1
)
UNION ALL
(
  SELECT
    'резюме' AS type,
    DATE_TRUNC('month', created_at) AS period,
    COUNT(*) AS total
  FROM resumes
  GROUP BY DATE_TRUNC('month', created_at)
  ORDER BY total DESC
  LIMIT 1
);
