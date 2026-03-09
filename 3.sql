-- средние значения компенсации по регионам
-- берём только вакансии с указанной вилкой
SELECT
  vacancies.area_id,
  areas.name AS area_name,
  AVG(vacancies.compensation_from) AS avg_compensation_from,
  AVG(vacancies.compensation_to) AS avg_compensation_to,
  AVG((vacancies.compensation_from + vacancies.compensation_to) / 2.0) AS avg_compensation_mid
FROM vacancies
INNER JOIN areas ON areas.id = vacancies.area_id
WHERE
  vacancies.compensation_from IS NOT NULL
  AND vacancies.compensation_to IS NOT NULL
GROUP BY
  vacancies.area_id,
  areas.name
ORDER BY vacancies.area_id;
