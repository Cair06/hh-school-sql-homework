-- очистка данных и сброс последовательностей
TRUNCATE TABLE applications, resumes, vacancies, candidates, employers, areas, specializations
  RESTART IDENTITY CASCADE;

-- специализации
INSERT INTO specializations (name) VALUES
  ('IT / Разработка'), ('Маркетинг'), ('Продажи'), ('Дизайн'), ('Финансы'),
  ('HR'), ('Юриспруденция'), ('Логистика'), ('Медицина'), ('Образование'),
  ('Строительство'), ('Производство'), ('Аналитика'), ('Менеджмент'),
  ('Бухгалтерия'), ('Административный персонал'), ('Безопасность'),
  ('Наука'), ('Медиа'), ('Туризм');

-- регионы
INSERT INTO areas (name) VALUES
  ('Москва'), ('Санкт-Петербург'), ('Казань'), ('Новосибирск'), ('Екатеринбург'),
  ('Краснодар'), ('Нижний Новгород'), ('Самара'), ('Уфа'), ('Воронеж'),
  ('Ростов-на-Дону'), ('Челябинск'), ('Омск'), ('Волгоград'), ('Пермь');

-- работодатели (500 записей)
WITH company_data AS (
  SELECT
    ARRAY['ООО','АО','ПАО','ИП','ЗАО'] AS forms,
    ARRAY['Альфа','Бета','Вектор','Прайм','Нова','Орион','Зенит','Полюс','Максима','Сигма'] AS names,
    ARRAY['Технологии','Решения','Групп','Сервис','Системы','Консалтинг','Инвест','Медиа'] AS suffixes,
    ARRAY[
      'Производство и поставка промышленного оборудования',
      'Разработка программного обеспечения на заказ',
      'Консалтинг в области управления и финансов',
      'Розничная торговля товарами для дома',
      'Строительство и проектирование объектов',
      'Логистика и грузоперевозки по России',
      'Рекрутинг и кадровые услуги',
      'Маркетинг и продвижение в интернете',
      'Бухгалтерское обслуживание малого бизнеса',
      'Юридические услуги для корпоративных клиентов'
    ] AS descriptions
)
INSERT INTO employers (name, description)
SELECT
  forms[floor(random() * 5 + 1)::int] || ' "' ||
    names[floor(random() * 10 + 1)::int] ||
    suffixes[floor(random() * 8 + 1)::int] || '"',
  descriptions[floor(random() * 10 + 1)::int]
FROM generate_series(1, 500)
CROSS JOIN company_data;

-- кандидаты (100k записей)
WITH candidate_names AS (
  SELECT
    ARRAY['Иван','Алексей','Дмитрий','Сергей','Андрей','Михаил','Николай',
          'Евгений','Максим','Никита','Лев','Павел','Руслан','Олег',
          'Анна','Мария','Елена','Ольга','Наталья','Татьяна','Юлия','Ирина'] AS first_names,
    ARRAY['Иванов','Петров','Сидоров','Козлов','Новиков','Морозов','Попов',
          'Волков','Соколов','Лебедев','Захаров','Семёнов','Орлов','Фёдоров',
          'Иванова','Петрова','Сидорова','Козлова','Новикова','Морозова'] AS last_names,
    ARRAY['yandex.ru','mail.ru','gmail.com','inbox.ru','bk.ru'] AS domains
)
INSERT INTO candidates (first_name, last_name, email, phone)
SELECT
  first_names[floor(random() * 22 + 1)::int],
  last_names[floor(random() * 20 + 1)::int],
  'user' || i || '@' || domains[floor(random() * 5 + 1)::int],
  '+7' || (9000000000 + i)::bigint
FROM generate_series(1, 100000) AS gs(i)
CROSS JOIN candidate_names;

-- вакансии (10k записей)
WITH vacancy_data AS (
  SELECT
    ARRAY['Senior','Middle','Junior','Lead','Стажер'] AS levels,
    ARRAY['разработчик','менеджер','аналитик','дизайнер','маркетолог','бухгалтер','юрист'] AS roles,
    ARRAY['Без опыта','1–3 года','3–6 лет','Более 6 лет'] AS experiences,
    ARRAY[
      'Работа в стабильной компании с оформлением по ТК РФ',
      'Удалённый формат, гибкий график',
      'Офис в центре города, соцпакет',
      'Молодая команда, задачи без бюрократии',
      'Командировки, ДМС, корпоративное обучение'
    ] AS descriptions
)
INSERT INTO vacancies (
  employer_id, specialization_id, area_id,
  title, compensation_from, compensation_to,
  experience, description, created_at
)
SELECT
  floor(random() * 500 + 1)::int,
  floor(random() * 20 + 1)::int,
  floor(random() * 15 + 1)::int,
  levels[floor(random() * 5 + 1)::int] || ' ' || roles[floor(random() * 7 + 1)::int],
  (floor(random() * 10 + 3) * 10000)::int,
  (floor(random() * 15 + 13) * 10000)::int,
  experiences[floor(random() * 4 + 1)::int],
  descriptions[floor(random() * 5 + 1)::int],
  NOW() - (floor(random() * 730) || ' days')::interval
FROM generate_series(1, 10000) AS gs(i)
CROSS JOIN vacancy_data;

-- резюме (100k записей)
WITH resume_data AS (
  SELECT
    ARRAY['Ищу работу','Открыт к предложениям','В активном поиске'] AS statuses,
    ARRAY['разработчик','менеджер','аналитик','дизайнер','маркетолог'] AS roles,
    ARRAY['Python, SQL','Java, Spring','React, JS','Excel, 1C',
          'Photoshop, Figma','SQL, Power BI'] AS skill_sets,
    ARRAY[
      'Опыт более 3 лет, ищу интересные задачи',
      'Хочу развиваться в профессии, готов к обучению',
      'Ищу стабильное место с возможностью роста',
      'Открыт к удалённым и гибридным форматам',
      'Специализируюсь на крупных проектах'
    ] AS abouts
)
INSERT INTO resumes (candidate_id, specialization_id, title, about, skills, created_at)
SELECT
  i,
  floor(random() * 20 + 1)::int,
  statuses[floor(random() * 3 + 1)::int] || ' — ' || roles[floor(random() * 5 + 1)::int],
  abouts[floor(random() * 5 + 1)::int],
  skill_sets[floor(random() * 6 + 1)::int],
  NOW() - (floor(random() * 730) || ' days')::interval
FROM generate_series(1, 100000) AS gs(i)
CROSS JOIN resume_data;

-- отклики (50k записей)
WITH application_data AS (
  SELECT
    ARRAY['applied','viewed','invited','rejected'] AS statuses,
    ARRAY[
      'Добрый день! Хочу предложить свою кандидатуру.',
      'Здравствуйте, меня заинтересовала эта вакансия.',
      'Рад откликнуться, готов к собеседованию в любое время.',
      'Ваша компания давно на моём радаре, буду рад поговорить.',
      NULL
    ] AS letters
),
generated AS (
  SELECT
    floor(random() * 10000 + 1)::int  AS vacancy_id,
    floor(random() * 100000 + 1)::int AS resume_id,
    floor(random() * 4 + 1)::int      AS status_idx,
    floor(random() * 5 + 1)::int      AS letter_idx,
    floor(random() * 30)::int         AS days_after_publish
  FROM generate_series(1, 50000)
)
INSERT INTO applications (vacancy_id, resume_id, cover_letter, status, created_at)
SELECT
  g.vacancy_id,
  g.resume_id,
  d.letters[g.letter_idx],
  d.statuses[g.status_idx],
  v.created_at + (g.days_after_publish || ' days')::interval
FROM generated AS g
JOIN vacancies AS v ON v.id = g.vacancy_id
CROSS JOIN application_data AS d
ON CONFLICT DO NOTHING;
