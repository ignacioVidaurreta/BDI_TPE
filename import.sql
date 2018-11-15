-- Import from terminal in base directory with:
-- psql -h localhost -U (username) -f import.sql -d PROOF -p 5555

\COPY UserTP FROM 'Data/Users.tsv' HEADER DELIMITER E'\t' QUOTE E'\'' CSV;
\COPY Badges FROM 'Data/Badges.tsv' HEADER DELIMITER E'\t' QUOTE E'\'' CSV;
