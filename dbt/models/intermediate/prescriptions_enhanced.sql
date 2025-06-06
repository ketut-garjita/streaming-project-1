{{
  config(
    materialized='table',
    description='Enhanced prescriptions fact table with joined dimension data'
  )
}}

SELECT
  pr.prescription_id,
  pr.dosage,
  pr.duration,
  p.patient_id,
  p.full_name,
  p.age_group,
  p.gender,
  d.doctor_id,
  d.doctor_name,
  d.specialization,
  m.medicine_id,
  m.medicine_name,
  m.category AS medicine_category,
  m.price,
  m.price_category,
  -- Calculate estimated total cost
  CASE
    WHEN SPLIT(pr.duration, ' ')[1] = 'days' THEN CAST(SPLIT(pr.duration, ' ')[0] AS INT) * m.price
    WHEN SPLIT(pr.duration, ' ')[1] = 'weeks' THEN CAST(SPLIT(pr.duration, ' ')[0] AS INT) * 7 * m.price
    WHEN SPLIT(pr.duration, ' ')[1] = 'months' THEN CAST(SPLIT(pr.duration, ' ')[0] AS INT) * 30 * m.price
    ELSE m.price
  END AS estimated_total_cost
FROM {{ source('hospital', 'prescriptions') }} pr
LEFT JOIN {{ ref('patients') }} p ON pr.patient_id = p.patient_id
LEFT JOIN {{ ref('doctors') }} d ON pr.doctor_id = d.doctor_id
LEFT JOIN {{ ref('medicines') }} m ON pr.medicine_id = m.medicine_id

