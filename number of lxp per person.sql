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
)
SELECT person_address, 
    SUM_LXP, 
    ROW_NUMBER() OVER(ORDER BY SUM_LXP DESC) AS rank
FROM LXP_HOLDERS
ORDER BY SUM_LXP DESC
