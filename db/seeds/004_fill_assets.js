db.assets.insertMany([
  // Hardware (30 examples)
  { name: "Dell XPS 15 Laptop", description: "Developer workstation i7/32GB/1TB", created: new Date(), updated: new Date() },
  { name: "MacBook Pro M1", description: "Design team laptop 16GB/512GB", created: new Date(), updated: new Date() },
  { name: "HP EliteDesk 800", description: "Accounting department desktop", created: new Date(), updated: new Date() },
  { name: "Cisco Catalyst 9300", description: "Core network switch (48-port)", created: new Date(), updated: new Date() },
  { name: "APC Smart-UPS 1500", description: "Server room battery backup", created: new Date(), updated: new Date() },
  { name: "Logitech MX Keys", description: "Wireless keyboard for conference room", created: new Date(), updated: new Date() },
  { name: "Dell U2723QE Monitor", description: "27\" 4K USB-C monitor", created: new Date(), updated: new Date() },
  { name: "Apple iPad Pro 12.9\"", description: "Field technician tablet", created: new Date(), updated: new Date() },
  { name: "Samsung Galaxy Tab S8", description: "Sales team Android tablet", created: new Date(), updated: new Date() },
  { name: "Poly Studio P15", description: "USB conference room webcam", created: new Date(), updated: new Date() },
  { name: "Jabra Evolve2 65", description: "Noise-canceling headset", created: new Date(), updated: new Date() },
  { name: "YubiKey 5C NFC", description: "Security key for MFA", created: new Date(), updated: new Date() },
  { name: "Samsung T7 SSD 1TB", description: "Encrypted portable drive", created: new Date(), updated: new Date() },
  { name: "Raspberry Pi 4 Kit", description: "IoT development kit", created: new Date(), updated: new Date() },
  { name: "Aruba AP-515", description: "Wi-Fi 6 access point", created: new Date(), updated: new Date() },
  { name: "Sony A7 IV", description: "Marketing department camera", created: new Date(), updated: new Date() },
  { name: "Epson WorkForce Pro", description: "Accounting department printer", created: new Date(), updated: new Date() },
  { name: "Microsoft Surface Hub 2", description: "Conference room display", created: new Date(), updated: new Date() },
  { name: "OWC ThunderBay 4", description: "Media storage RAID array", created: new Date(), updated: new Date() },
  { name: "Fitbit Charge 5", description: "Employee wellness device", created: new Date(), updated: new Date() },
  { name: "Nest Cam IQ Outdoor", description: "Building security camera", created: new Date(), updated: new Date() },
  { name: "Raritan Dominion KX III", description: "Server KVM over IP", created: new Date(), updated: new Date() },
  { name: "Samsung Galaxy S22", description: "Company mobile phone", created: new Date(), updated: new Date() },
  { name: "Apple Watch SE", description: "On-call notifications", created: new Date(), updated: new Date() },
  { name: "Bose QuietComfort 45", description: "Noise-canceling headphones", created: new Date(), updated: new Date() },
  { name: "Anker PowerCore 26800", description: "Portable USB-C charger", created: new Date(), updated: new Date() },
  { name: "OWC Envoy Pro FX", description: "Encrypted portable SSD", created: new Date(), updated: new Date() },
  { name: "Logitech MeetUp", description: "Small conference room system", created: new Date(), updated: new Date() },
  { name: "Elgato Stream Deck", description: "Marketing content controls", created: new Date(), updated: new Date() },
  { name: "Blue Yeti Nano", description: "Podcast microphone", created: new Date(), updated: new Date() },

  // Software (25 examples)
  { name: "Microsoft Office 365", description: "E3 license subscription", created: new Date(), updated: new Date() },
  { name: "Adobe Creative Cloud", description: "Design team subscription", created: new Date(), updated: new Date() },
  { name: "AutoCAD 2023", description: "Engineering department license", created: new Date(), updated: new Date() },
  { name: "ServiceNow", description: "ITSM platform instance", created: new Date(), updated: new Date() },
  { name: "Jira Software", description: "Cloud premium instance", created: new Date(), updated: new Date() },
  { name: "Confluence", description: "Knowledge base platform", created: new Date(), updated: new Date() },
  { name: "Slack Enterprise", description: "Company-wide messaging", created: new Date(), updated: new Date() },
  { name: "Zoom Pro", description: "Video conferencing licenses", created: new Date(), updated: new Date() },
  { name: "1Password Business", description: "Password manager", created: new Date(), updated: new Date() },
  { name: "VMware vSphere", description: "Datacenter virtualization", created: new Date(), updated: new Date() },
  { name: "Splunk Enterprise", description: "Log management system", created: new Date(), updated: new Date() },
  { name: "Trello Premium", description: "Marketing project boards", created: new Date(), updated: new Date() },
  { name: "GitHub Enterprise", description: "Code repository", created: new Date(), updated: new Date() },
  { name: "Tanium", description: "Endpoint management", created: new Date(), updated: new Date() },
  { name: "CrowdStrike Falcon", description: "Endpoint protection", created: new Date(), updated: new Date() },
  { name: "Okta", description: "SSO identity provider", created: new Date(), updated: new Date() },
  { name: "Salesforce CRM", description: "Enterprise edition", created: new Date(), updated: new Date() },
  { name: "Zendesk Suite", description: "Customer support platform", created: new Date(), updated: new Date() },
  { name: "Tableau Desktop", description: "BI analytics licenses", created: new Date(), updated: new Date() },
  { name: "Docker Enterprise", description: "Container platform", created: new Date(), updated: new Date() },
  { name: "Kubernetes", description: "Production cluster", created: new Date(), updated: new Date() },
  { name: "Terraform Enterprise", description: "Infrastructure as code", created: new Date(), updated: new Date() },
  { name: "PagerDuty", description: "Incident response platform", created: new Date(), updated: new Date() },
  { name: "New Relic", description: "APM monitoring", created: new Date(), updated: new Date() },
  { name: "Figma Organization", description: "Design collaboration", created: new Date(), updated: new Date() },

  // Cloud Services (15 examples)
  { name: "AWS Account", description: "Production (Account #12345)", created: new Date(), updated: new Date() },
  { name: "Azure Subscription", description: "Enterprise agreement", created: new Date(), updated: new Date() },
  { name: "GCP Project", description: "Data analytics platform", created: new Date(), updated: new Date() },
  { name: "Cloudflare Enterprise", description: "DNS and CDN services", created: new Date(), updated: new Date() },
  { name: "Fastly", description: "Edge compute platform", created: new Date(), updated: new Date() },
  { name: "Snowflake", description: "Data warehouse", created: new Date(), updated: new Date() },
  { name: "MongoDB Atlas", description: "Cluster M30", created: new Date(), updated: new Date() },
  { name: "Datadog", description: "Full observability suite", created: new Date(), updated: new Date() },
  { name: "Auth0", description: "Customer identity platform", created: new Date(), updated: new Date() },
  { name: "Twilio", description: "Communications API", created: new Date(), updated: new Date() },
  { name: "SendGrid", description: "Email delivery service", created: new Date(), updated: new Date() },
  { name: "Stripe", description: "Payment processing", created: new Date(), updated: new Date() },
  { name: "Workday", description: "HR management system", created: new Date(), updated: new Date() },
  { name: "ZoomInfo", description: "Sales intelligence", created: new Date(), updated: new Date() },
  { name: "Dropbox Business", description: "Enterprise file storage", created: new Date(), updated: new Date() },

  // Facilities (10 examples)
  { name: "Conference Room A", description: "Main floor (Capacity: 12)", created: new Date(), updated: new Date() },
  { name: "Server Room 1", description: "Primary datacenter", created: new Date(), updated: new Date() },
  { name: "Building Access System", description: "Badge entry controls", created: new Date(), updated: new Date() },
  { name: "HVAC System", description: "Floor 3 climate control", created: new Date(), updated: new Date() },
  { name: "Parking Space 42", description: "Assigned to CTO", created: new Date(), updated: new Date() },
  { name: "Electric Vehicle Charger", description: "Visitor parking lot", created: new Date(), updated: new Date() },
  { name: "Security Camera 7", description: "Lobby entrance", created: new Date(), updated: new Date() },
  { name: "Fire Suppression System", description: "Server room", created: new Date(), updated: new Date() },
  { name: "Network Closet B", description: "Floor 2 switching", created: new Date(), updated: new Date() },
  { name: "Generator Backup", description: "Building-wide UPS", created: new Date(), updated: new Date() },

  // Other (20 examples)
  { name: "Company Vehicle 3", description: "Ford Transit Connect", created: new Date(), updated: new Date() },
  { name: "Projector XGIMI", description: "Portable 4K projector", created: new Date(), updated: new Date() },
  { name: "3D Printer", description: "Ultimaker S5", created: new Date(), updated: new Date() },
  { name: "VR Headset", description: "Meta Quest Pro", created: new Date(), updated: new Date() },
  { name: "Drone", description: "DJI Mavic 3", created: new Date(), updated: new Date() },
  { name: "Conference Phone", description: "Polycom Trio 8800", created: new Date(), updated: new Date() },
  { name: "Digital Whiteboard", description: "Samsung Flip 2", created: new Date(), updated: new Date() },
  { name: "Fitness Equipment", description: "Peloton Bike+", created: new Date(), updated: new Date() },
  { name: "Mailroom Printer", description: "Zebra ZT410", created: new Date(), updated: new Date() },
  { name: "Time Clock", description: "Kronos 4500", created: new Date(), updated: new Date() },
  { name: "POS Terminal", description: "Square Register", created: new Date(), updated: new Date() },
  { name: "Barcode Scanner", description: "Honeywell Granit 1911i", created: new Date(), updated: new Date() },
  { name: "RFID Reader", description: "Zebra RFD8500", created: new Date(), updated: new Date() },
  { name: "Document Scanner", description: "Fujitsu ScanSnap iX1500", created: new Date(), updated: new Date() },
  { name: "Shredder", description: "Fellowes Powershred 79Ci", created: new Date(), updated: new Date() },
  { name: "Label Printer", description: "Dymo LabelWriter 450", created: new Date(), updated: new Date() },
  { name: "Microscope", description: "Olympus CX23", created: new Date(), updated: new Date() },
  { name: "Tool Kit", description: "IT maintenance tools", created: new Date(), updated: new Date() },
  { name: "First Aid Kit", description: "Floor 3 breakroom", created: new Date(), updated: new Date() },
  { name: "Emergency Flashlight", description: "Server room backup", created: new Date(), updated: new Date() }
])