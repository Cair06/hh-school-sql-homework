-- сброс старой схемы
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS resumes;
DROP TABLE IF EXISTS vacancies;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS employers;
DROP TABLE IF EXISTS areas;
DROP TABLE IF EXISTS specializations;

-- специализации
CREATE TABLE specializations (
  id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

-- регионы
CREATE TABLE areas (
  id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

-- работодатели
CREATE TABLE employers (
  id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name        VARCHAR(200) NOT NULL,
  description TEXT
);

-- кандидаты
CREATE TABLE candidates (
  id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL UNIQUE,
  phone      VARCHAR(20)  UNIQUE
);

-- вакансии
CREATE TABLE vacancies (
  id                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  employer_id       INTEGER NOT NULL REFERENCES employers(id) ON DELETE RESTRICT,
  specialization_id INTEGER NOT NULL REFERENCES specializations(id),
  area_id           INTEGER NOT NULL REFERENCES areas(id),
  title             VARCHAR(200) NOT NULL,
  compensation_from INTEGER CHECK (compensation_from > 0),
  compensation_to   INTEGER CHECK (compensation_to > 0),
  experience        VARCHAR(50),
  description       TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  -- проверка на корректность
  CONSTRAINT chk_compensation_range CHECK (compensation_from <= compensation_to)
);

-- резюме
CREATE TABLE resumes (
  id                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  candidate_id      INTEGER NOT NULL REFERENCES candidates(id) ON DELETE CASCADE,
  specialization_id INTEGER NOT NULL REFERENCES specializations(id),
  title             VARCHAR(200) NOT NULL,
  about             TEXT,
  skills            TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- отклики
CREATE TABLE applications (
  id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  vacancy_id   INTEGER NOT NULL REFERENCES vacancies(id) ON DELETE CASCADE,
  resume_id    INTEGER NOT NULL REFERENCES resumes(id) ON DELETE CASCADE,
  cover_letter TEXT,
  status       VARCHAR(30) DEFAULT 'applied'
               CHECK (status IN ('applied', 'viewed', 'invited', 'rejected')),
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (vacancy_id, resume_id)
);
