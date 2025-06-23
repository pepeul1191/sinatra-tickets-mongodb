db.issue_states.insertMany([
  {
    name: "Abierto",
    created: new Date("2024-01-01T00:00:00Z"),
    updated: new Date("2024-01-01T00:00:00Z")
  },
  {
    name: "En progreso",
    created: new Date("2024-01-01T00:00:00Z"),
    updated: new Date("2024-01-01T00:00:00Z")
  },
  {
    name: "En revisión",
    created: new Date("2024-01-01T00:00:00Z"),
    updated: new Date("2024-01-01T00:00:00Z")
  },
  {
    name: "Resuelto",
    created: new Date("2024-01-01T00:00:00Z"),
    updated: new Date("2024-01-01T00:00:00Z")
  },
  {
    name: "Cancelado",
    created: new Date("2024-01-01T00:00:00Z"),
    updated: new Date("2024-01-01T00:00:00Z")
  }
])