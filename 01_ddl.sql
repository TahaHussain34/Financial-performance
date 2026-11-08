

DROP TABLE IF EXISTS forecasts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS projects;

CREATE TABLE projects (
    project_id    VARCHAR(10)   NOT NULL,
    project_name  VARCHAR(100)  NOT NULL,
    region        VARCHAR(20)   NOT NULL,
    manager       VARCHAR(50)   NOT NULL,
    budget        NUMERIC(14,2) NOT NULL,
    CONSTRAINT pk_projects          PRIMARY KEY (project_id),
    CONSTRAINT uq_projects_name     UNIQUE (project_name),
    CONSTRAINT ck_projects_budget   CHECK (budget > 0)
);



CREATE TABLE transactions (
    transaction_id    VARCHAR(20)   NOT NULL,
    project_id        VARCHAR(10)   NOT NULL,
    category          VARCHAR(20)   NOT NULL,
    amount            NUMERIC(14,2) NOT NULL,
    transaction_date  DATE          NOT NULL,
    CONSTRAINT pk_transactions          PRIMARY KEY (transaction_id),
    CONSTRAINT fk_transactions_project  FOREIGN KEY (project_id)
                                        REFERENCES projects (project_id),
    CONSTRAINT ck_transactions_category CHECK (category IN
                                        ('Labor','Materials','Services','Travel','Contract')),
    CONSTRAINT ck_transactions_amount   CHECK (amount <> 0)
);

CREATE INDEX ix_transactions_project ON transactions (project_id);
CREATE INDEX ix_transactions_date    ON transactions (transaction_date);




CREATE TABLE forecasts (
    project_id       VARCHAR(10)   NOT NULL,
    month            VARCHAR(3)    NOT NULL,
    forecast_amount  NUMERIC(14,2) NOT NULL,
    CONSTRAINT pk_forecasts          PRIMARY KEY (project_id, month),
    CONSTRAINT fk_forecasts_project  FOREIGN KEY (project_id)
                                     REFERENCES projects (project_id),
    CONSTRAINT ck_forecasts_month    CHECK (month IN
                                     ('Jan','Feb','Mar','Apr','May','Jun',
                                      'Jul','Aug','Sep','Oct','Nov','Dec')),
    CONSTRAINT ck_forecasts_amount   CHECK (forecast_amount >= 0)
);
