---
title : "Configure AWS Budgets"
weight : 10
chapter : false
pre : " <b> 5.3.10. </b> "
---

#### Create AWS Budgets

The `bill-n-cost.tf` file configures multiple budgets to monitor costs:

```hcl
# Monthly budget for all services
resource "aws_budgets_budget" "monthly_cost" {
  name         = "monthly-cost"
  limit_amount = 120
  budget_type  = "COST"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_emails
  }
}

# Daily budget for all services
resource "aws_budgets_budget" "daily_cost" {
  name         = "daily-cost"
  limit_amount = 3
  budget_type  = "COST"
  limit_unit   = "USD"
  time_unit    = "DAILY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_emails
  }
}

# Budget by service (daily & monthly)
resource "aws_budgets_budget" "cost_by_service" {
  name         = "cost-by-service"
  limit_amount = 0.5
  budget_type  = "COST"
  limit_unit   = "USD"
  time_unit    = "DAILY"
}

resource "aws_budgets_budget" "cost_by_service_monthly" {
  name         = "cost-by-service-monthly"
  limit_amount = 5
  budget_type  = "COST"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"
}

# Budget by region
resource "aws_budgets_budget" "cost_by_region" {
  name         = "cost-by-region"
  budget_type  = "COST"
  limit_unit   = "USD"
  limit_amount = 150
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_emails
  }
}
```

- Monthly: 120 USD, alert at 80% (all services).
- Daily: 3 USD, alert at 80% (all services).
- By service: 0.5 USD/day, 5 USD/month (per service).
- By region: 150 USD/month, alert at 100%.
- Alert email recipients: `var.budget_alert_emails`.
