

SELECT
  d.doctor_id,
  d.doctor_name,
  d.specialization,
  d.experience_level,
  COUNT(DISTINCT v.visit_id) AS total_visits,
  COUNT(DISTINCT v.patient_id) AS unique_patients,
  SUM(v.total_cost) AS total_revenue_generated,
  AVG(v.total_cost) AS avg_visit_cost,
  -- Prescription metrics
  COUNT(DISTINCT pr.prescription_id) AS total_prescriptions,
  SUM(pr.estimated_total_cost) AS total_prescription_value
FROM `dataeng-2025-gar`.`hospital_staging`.`doctors` d
LEFT JOIN `dataeng-2025-gar`.`hospital_intermediate`.`visits_enhanced` v ON d.doctor_id = v.doctor_id
LEFT JOIN `dataeng-2025-gar`.`hospital_intermediate`.`prescriptions_enhanced` pr ON d.doctor_id = pr.doctor_id
GROUP BY 1, 2, 3, 4
ORDER BY total_revenue_generated DESC