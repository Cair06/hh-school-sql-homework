-- отклики считаем только те, что пришли в первые 7 дней после публикации вакансии
WITH first_week_apps AS (
  SELECT
    applications.vacancy_id,
    COUNT(*) AS application_count
  FROM applications
  INNER JOIN vacancies ON vacancies.id = applications.vacancy_id
    AND applications.created_at <= vacancies.created_at + INTERVAL '7 days'
  GROUP BY applications.vacancy_id
)
SELECT
  vacancies.id,
  vacancies.title
FROM vacancies
INNER JOIN first_week_apps ON first_week_apps.vacancy_id = vacancies.id
WHERE
  first_week_apps.application_count > 5;
