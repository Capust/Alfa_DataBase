USE Order_cash
GO

SELECT 
    b.branch_id AS 'ID офиса',
    b.city AS 'Город',
    b.address AS 'Адрес',
    COUNT(o.order_id) AS 'Количество заказов',
    ISNULL(SUM(o.amount), 0) AS 'Общая сумма, руб',
    ISNULL(AVG(o.amount), 0) AS 'Средняя сумма заказа, руб',
    ISNULL(MIN(o.amount), 0) AS 'Мин. сумма, руб',
    ISNULL(MAX(o.amount), 0) AS 'Макс. сумма, руб'
FROM [dbo].[Branches] b
LEFT JOIN [dbo].[Orders] o ON b.branch_id = o.branch_id
    AND o.status = 'completed'
    AND o.actual_date IS NOT NULL
    AND MONTH(o.actual_date) = MONTH(GETDATE())
    AND YEAR(o.actual_date) = YEAR(GETDATE())
GROUP BY b.branch_id, b.city, b.address
ORDER BY 
	COUNT(o.order_id) DESC
GO

