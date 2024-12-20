WITH 
LXP_HOLDERS AS 
(
SELECT bytearray_ltrim(topic2) AS person_address, 
    SUM(bytearray_to_uint256(data) / 1000000000000000000) AS SUM_LXP
FROM linea.logs
WHERE tx_from = FROM_HEX('97643dd2dfe4dd0b64d43504bac4adb2923fdf7a') 
AND tx_to = FROM_HEX('3886a948ea7b4053312c3ae31a13776144aa6239')
AND contract_address = FROM_HEX('d83af4fbd77f3ab65c3b1dc4b38d7e67aecf599a')
GROUP BY bytearray_ltrim(topic2)
),
LXP_RANK AS
(
SELECT person_address, 
    SUM_LXP, 
    ROW_NUMBER() OVER(ORDER BY SUM_LXP DESC) AS rank
FROM LXP_HOLDERS
ORDER BY SUM_LXP DESC
)
SELECT
    CASE
        WHEN SUM_LXP >= 4000 THEN 'more than 4000'
        WHEN SUM_LXP >= 3000 AND SUM_LXP < 4000 THEN '3000 < LXP COUNT < 4000'
        WHEN SUM_LXP >= 2000 AND SUM_LXP < 3000 THEN '2000 < LXP COUNT < 3000'
        WHEN SUM_LXP >= 1000 AND SUM_LXP < 2000 THEN '1000 < LXP COUNT < 2000'
        WHEN SUM_LXP < 1000 THEN '0 < LXP COUNT < 1000'
    END AS LXP_status,
    COUNT(*) AS count_of_addresses
FROM
    LXP_RANK
GROUP BY
    CASE
        WHEN SUM_LXP >= 4000 THEN 'more than 4000'
        WHEN SUM_LXP >= 3000 AND SUM_LXP < 4000 THEN '3000 < LXP COUNT < 4000'
        WHEN SUM_LXP >= 2000 AND SUM_LXP < 3000 THEN '2000 < LXP COUNT < 3000'
        WHEN SUM_LXP >= 1000 AND SUM_LXP < 2000 THEN '1000 < LXP COUNT < 2000'
        WHEN SUM_LXP < 1000 THEN '0 < LXP COUNT < 1000'
    END
ORDER BY LXP_status DESC
