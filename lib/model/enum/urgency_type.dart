enum UrgencyType {
  veryLow,
  low,
  medium,
  high,
  critical,
}

const urgencyMap = {
  UrgencyType.veryLow: "Muito Baixa",
  UrgencyType.low: "Baixa",
  UrgencyType.medium: "Média",
  UrgencyType.high: "Alta",
  UrgencyType.critical: "Crítica",
};