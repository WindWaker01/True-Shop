-- ============================================================
-- True Shop (trueshop) — SQL-запросы для приложения
-- Плейсхолдеры: %s (Python/pymysql) или ? (другие драйверы)
-- ============================================================

-- ------------------------------------------------------------
-- 1. ВХОД (авторизация)
-- Проверка логина и пароля; возвращает пользователя и его роль.
-- Параметры: %s = login, %s = password
-- ------------------------------------------------------------
SELECT u.id, u.full_name, u.login, r.name AS role
FROM users u
JOIN roles r ON r.id = u.role_id
WHERE u.login = %s AND u.password = %s;


-- ------------------------------------------------------------
-- 2. КАТАЛОГ (полный список товаров)
-- Товар + категория, производитель, поставщик, цена со скидкой.
-- ------------------------------------------------------------
SELECT p.id,
       p.article,
       p.name,
       c.name  AS category,
       m.name  AS manufacturer,
       s.name  AS supplier,
       p.unit,
       p.price,
       p.discount,
       ROUND(p.price * (1 - p.discount / 100), 2) AS final_price,
       p.stock_qty,
       p.description,
       p.photo
FROM products p
JOIN categories   c ON c.id = p.category_id
JOIN manufacturirs m ON m.id = p.manufacturer_id
JOIN suppliers    s ON s.id = p.supplier_id
ORDER BY p.name;


-- ------------------------------------------------------------
-- 3. ПОИСК (по названию и артикулу)
-- Параметр: %s = строка поиска (передавать как '%текст%')
-- ------------------------------------------------------------
SELECT p.id, p.article, p.name, c.name AS category,
       m.name AS manufacturer, p.price, p.discount, p.stock_qty
FROM products p
JOIN categories    c ON c.id = p.category_id
JOIN manufacturirs m ON m.id = p.manufacturer_id
WHERE p.name LIKE %s OR p.article LIKE %s
ORDER BY p.name;


-- ------------------------------------------------------------
-- 4. ФИЛЬТР (по категории / производителю / поставщику)
-- Каждый параметр: %s = id или NULL (NULL = фильтр не применяется)
-- ------------------------------------------------------------
SELECT p.id, p.article, p.name, c.name AS category,
       m.name AS manufacturer, s.name AS supplier,
       p.price, p.discount, p.stock_qty
FROM products p
JOIN categories    c ON c.id = p.category_id
JOIN manufacturirs m ON m.id = p.manufacturer_id
JOIN suppliers     s ON s.id = p.supplier_id
WHERE (%s IS NULL OR p.category_id = %s)
  AND (%s IS NULL OR p.manufacturer_id = %s)
  AND (%s IS NULL OR p.supplier_id = %s)
ORDER BY p.name;


-- ------------------------------------------------------------
-- 5. СОРТИРОВКА (варианты — выбрать один ORDER BY)
-- Цена по возрастанию:
SELECT id, article, name, price, discount, stock_qty
FROM products
ORDER BY price ASC;

-- Цена по убыванию:
SELECT id, article, name, price, discount, stock_qty
FROM products
ORDER BY price DESC;

-- По названию (А-Я):
SELECT id, article, name, price, discount, stock_qty
FROM products
ORDER BY name ASC;

-- По остатку на складе:
SELECT id, article, name, price, discount, stock_qty
FROM products
ORDER BY stock_qty DESC;


-- ------------------------------------------------------------
-- 6. ДОБАВЛЕНИЕ ТОВАРА
-- Параметры: article, name, unit, price, supplier_id,
--            manufacturer_id, category_id, discount, stock_qty,
--            description, photo
-- ------------------------------------------------------------
INSERT INTO products
    (article, name, unit, price, supplier_id, manufacturer_id,
     category_id, discount, stock_qty, description, photo)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);


-- ------------------------------------------------------------
-- 7. РЕДАКТИРОВАНИЕ ТОВАРА
-- Параметры: те же поля + id товара (последний параметр)
-- ------------------------------------------------------------
UPDATE products
SET article         = %s,
    name            = %s,
    unit            = %s,
    price           = %s,
    supplier_id     = %s,
    manufacturer_id = %s,
    category_id     = %s,
    discount        = %s,
    stock_qty       = %s,
    description     = %s,
    photo           = %s
WHERE id = %s;


-- ------------------------------------------------------------
-- 8. УДАЛЕНИЕ ТОВАРА
-- Внимание: если товар есть в заказах (prodorders), база
-- откажет — сначала проверь запросом ниже.
-- Параметр: %s = id товара
-- ------------------------------------------------------------
-- Проверка: есть ли товар в заказах
SELECT COUNT(*) AS in_orders
FROM prodorders
WHERE product_id = %s;

-- Само удаление
DELETE FROM products
WHERE id = %s;
