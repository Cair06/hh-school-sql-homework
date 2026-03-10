-- PostgreSQL не создаёт индексы на внешние ключи автоматически только на первичные.
-- Без этих индексов JOIN по FK идёт через последовательное сканирование всей таблицы.
CREATE INDEX idx_vacancies_employer_id ON vacancies (employer_id);
CREATE INDEX idx_vacancies_specialization_id ON vacancies (specialization_id);
CREATE INDEX idx_resumes_candidate_id ON resumes (candidate_id);
CREATE INDEX idx_resumes_specialization_id ON resumes (specialization_id);
CREATE INDEX idx_applications_resume_id ON applications (resume_id);

-- задание 5: запрос джойнит applications с vacancies и фильтрует по дате отклика.
-- композитный индекс (vacancy_id, created_at) покрывает оба условия сразу —
-- сначала находим все отклики по нужной вакансии, потом сразу режем по дате,
-- не обращаясь к самой таблице (index only scan). 15.1ms → 10.5ms.
CREATE INDEX idx_applications_vacancy_created ON applications (vacancy_id, created_at);
