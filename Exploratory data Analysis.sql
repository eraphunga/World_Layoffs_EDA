# Exploratory Data Analysis Project
# Aim : Exploring the data and find trends or patterns

SELECT *
FROM layoff_stagging2;

SELECT MAX(total_laid_off)
FROM layoff_stagging2;

# Coverting total_laid_off, percentage_laid_off & funds_raised_millions to INT

SELECT * 
FROM `world_layoffs`.`layoff_stagging2` 
WHERE `total_laid_off` = 'NULL';

UPDATE `world_layoffs`.`layoff_stagging2` 
SET `total_laid_off` = NULL 
WHERE `total_laid_off` = 'NULL';

UPDATE `world_layoffs`.`layoff_stagging2` 
SET `funds_raised_millions` = NULL 
WHERE `funds_raised_millions` = 'NULL';

UPDATE `world_layoffs`.`layoff_stagging2` 
SET `percentage_laid_off` = NULL 
WHERE `percentage_laid_off` = 'NULL';

ALTER TABLE `world_layoffs`.`layoff_stagging2` 
CHANGE COLUMN `total_laid_off` `total_laid_off` INT NULL DEFAULT NULL,
CHANGE COLUMN `funds_raised_millions` `funds_raised_millions` INT NULL DEFAULT NULL;


ALTER TABLE `world_layoffs`.`layoff_stagging2` 
CHANGE COLUMN `percentage_laid_off` `percentage_laid_off` INT NULL DEFAULT NULL;


ALTER TABLE `world_layoffs`.`layoff_stagging2` 
CHANGE COLUMN `percentage_laid_off` `percentage_laid_off` FLOAT NULL DEFAULT NULL;


SELECT*
FROM layoff_stagging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT Company, SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY company
ORDER By SUM(total_laid_off)DESC;

SELECT MIN(`date`) , MAX(`date`)
FROM layoff_stagging2;


SELECT industry, SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY industry
ORDER By SUM(total_laid_off) DESC;	

SELECT *
FROM layoff_stagging2;

SELECT country, SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY country
ORDER By SUM(total_laid_off) DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY YEAR(`date`)
ORDER By 1 DESC;	

SELECT stage, SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY stage
ORDER By 2 DESC;	


# Rolling total of lay_offs based off months

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoff_stagging2 
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER By 1 ASC;

WITH Rolling_Total AS
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoff_stagging2 
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER By 1 ASC
)
SELECT`MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH` ) AS rolling_total
FROM Rolling_Total;


SELECT Company, SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY company
ORDER By 2 DESC;



SELECT Company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH company_year (company, years, total_laid_off)  AS 
(
SELECT Company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_stagging2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5 ;