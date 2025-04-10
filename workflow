{
  "created": "1744274179820",
  "updated": "1744274179820",
  "name": "AWS FX Inefficiency Detector Workflow",
  "tags": [],
  "services": [],
  "domains": [],
  "template": {
    "displayName": "AWS FX Inefficiency Detector Workflow",
    "trigger": {
      "name": "trigger",
      "valid": true,
      "displayName": "Every Day",
      "type": "TRIGGER",
      "settings": {
        "blockName": "@openops/block-schedule",
        "blockVersion": "~0.1.5",
        "blockType": "OFFICIAL",
        "packageType": "REGISTRY",
        "input": {
          "timezone": "UTC",
          "hour_of_the_day": 2,
          "run_on_weekends": false
        },
        "inputUiInfo": {
          "customizedInputs": {}
        },
        "triggerName": "every_day"
      },
      "nextAction": {
        "name": "step_1",
        "type": "BLOCK",
        "valid": false,
        "settings": {
          "input": {
            "auth": null,
            "dryRun": false,
            "account": {},
            "commandToRun": "aws ce get-cost-and-usage \\\n--time-period Start={{last_month_start}},End={{last_month_end}} \\\n--granularity MONTHLY \\\n--metrics UnblendedCost{{trigger}}"
          },
          "blockName": "@openops/block-aws",
          "blockType": "OFFICIAL",
          "actionName": "aws_cli",
          "inputUiInfo": {
            "customizedInputs": {}
          },
          "packageType": "REGISTRY",
          "blockVersion": "~0.0.3",
          "errorHandlingOptions": {
            "retryOnFailure": {
              "value": false
            },
            "continueOnFailure": {
              "value": false
            }
          }
        },
        "nextAction": {
          "name": "step_2",
          "type": "BLOCK",
          "valid": true,
          "settings": {
            "input": {
              "url": "https://api.exchangerate.host/{{last_month_end}}?base=USD&symbols=INR",
              "body": {},
              "method": "GET",
              "headers": {},
              "timeout": null,
              "failsafe": false,
              "body_type": "none",
              "use_proxy": false,
              "queryParams": {},
              "proxy_settings": {}
            },
            "blockName": "@openops/block-http",
            "blockType": "OFFICIAL",
            "actionName": "send_request",
            "inputUiInfo": {
              "customizedInputs": {}
            },
            "packageType": "REGISTRY",
            "blockVersion": "~0.5.1",
            "errorHandlingOptions": {
              "retryOnFailure": {
                "value": false
              },
              "continueOnFailure": {
                "value": false
              }
            }
          },
          "nextAction": {
            "name": "step_3",
            "type": "BLOCK",
            "valid": true,
            "settings": {
              "input": {
                "first_number": "{{step_1.ResultsByTime[0].Total.UnblendedCost.Amount}}",
                "second_number": "{{step_2.rates.INR}}"
              },
              "blockName": "@openops/block-math-helper",
              "blockType": "OFFICIAL",
              "actionName": "multiplication_math",
              "inputUiInfo": {
                "customizedInputs": {}
              },
              "packageType": "REGISTRY",
              "blockVersion": "~0.0.8",
              "errorHandlingOptions": {
                "retryOnFailure": {
                  "value": false
                },
                "continueOnFailure": {
                  "value": false
                }
              }
            },
            "nextAction": {
              "name": "step_4",
              "type": "BLOCK",
              "valid": true,
              "settings": {
                "input": {
                  "filters": {
                    "filters": [
                      {
                        "value": {
                          "value": "{{last_month_name}}"
                        },
                        "fieldName": "BillingMonth",
                        "filterType": "Is equal"
                      }
                    ]
                  },
                  "tableName": "FxPaymentLog",
                  "filterType": "AND"
                },
                "blockName": "@openops/block-openops-tables",
                "blockType": "OFFICIAL",
                "actionName": "get_records",
                "inputUiInfo": {
                  "customizedInputs": {}
                },
                "packageType": "REGISTRY",
                "blockVersion": "~0.0.1",
                "errorHandlingOptions": {
                  "retryOnFailure": {
                    "value": false
                  },
                  "continueOnFailure": {
                    "value": false
                  }
                }
              },
              "nextAction": {
                "name": "step_5",
                "type": "BLOCK",
                "valid": true,
                "settings": {
                  "input": {
                    "first_number": "{{step_4.records[0].AmountPaidINR}}",
                    "second_number": "{{step_3}}"
                  },
                  "blockName": "@openops/block-math-helper",
                  "blockType": "OFFICIAL",
                  "actionName": "subtraction_math",
                  "inputUiInfo": {
                    "customizedInputs": {}
                  },
                  "packageType": "REGISTRY",
                  "blockVersion": "~0.0.8",
                  "errorHandlingOptions": {
                    "retryOnFailure": {
                      "value": false
                    },
                    "continueOnFailure": {
                      "value": false
                    }
                  }
                },
                "nextAction": {
                  "name": "step_6",
                  "type": "BLOCK",
                  "valid": true,
                  "settings": {
                    "input": {
                      "first_number": "{{step_5}}",
                      "second_number": "{{step_3}}"
                    },
                    "blockName": "@openops/block-math-helper",
                    "blockType": "OFFICIAL",
                    "actionName": "division_math",
                    "inputUiInfo": {
                      "customizedInputs": {}
                    },
                    "packageType": "REGISTRY",
                    "blockVersion": "~0.0.8",
                    "errorHandlingOptions": {
                      "retryOnFailure": {
                        "value": false
                      },
                      "continueOnFailure": {
                        "value": false
                      }
                    }
                  },
                  "nextAction": {
                    "name": "step_7",
                    "type": "BLOCK",
                    "valid": true,
                    "settings": {
                      "input": {
                        "first_number": "{{step_6}}",
                        "second_number": "100"
                      },
                      "blockName": "@openops/block-math-helper",
                      "blockType": "OFFICIAL",
                      "actionName": "multiplication_math",
                      "inputUiInfo": {
                        "customizedInputs": {}
                      },
                      "packageType": "REGISTRY",
                      "blockVersion": "~0.0.8",
                      "errorHandlingOptions": {
                        "retryOnFailure": {
                          "value": false
                        },
                        "continueOnFailure": {
                          "value": false
                        }
                      }
                    },
                    "nextAction": {
                      "name": "step_8",
                      "type": "BLOCK",
                      "valid": true,
                      "settings": {
                        "input": {
                          "tableName": "FXInefficiencies",
                          "rowPrimaryKey": {
                            "rowPrimaryKey": "{{last_month_name}}"
                          },
                          "fieldsProperties": {
                            "fieldsProperties": [
                              {
                                "fieldName": "AWS_USD_Billed",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_1.ResultsByTime[0].Total.UnblendedCost.Amount}}"
                                }
                              },
                              {
                                "fieldName": "FX_Rate_Used",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_2.rates.INR}}"
                                }
                              },
                              {
                                "fieldName": "ExpectedINR",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_3}}"
                                }
                              },
                              {
                                "fieldName": "ActualINR",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_4.records[0].AmountPaidINR}}"
                                }
                              },
                              {
                                "fieldName": "FX_Loss_Percent",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_7}}"
                                }
                              },
                              {
                                "fieldName": "Status",
                                "newFieldValue": {
                                  "newFieldValue": "{{step_7 > 1 ? 'Flagged' : 'OK'}}"
                                }
                              }
                            ]
                          }
                        },
                        "blockName": "@openops/block-openops-tables",
                        "blockType": "OFFICIAL",
                        "actionName": "update_record",
                        "inputUiInfo": {
                          "customizedInputs": {}
                        },
                        "packageType": "REGISTRY",
                        "blockVersion": "~0.0.1",
                        "errorHandlingOptions": {
                          "retryOnFailure": {
                            "value": false
                          },
                          "continueOnFailure": {
                            "value": false
                          }
                        }
                      },
                      "nextAction": {
                        "name": "step_9",
                        "type": "BLOCK",
                        "valid": true,
                        "settings": {
                          "input": {},
                          "blockName": "@openops/block-end-flow",
                          "blockType": "OFFICIAL",
                          "actionName": "end_workflow",
                          "inputUiInfo": {
                            "customizedInputs": {}
                          },
                          "packageType": "REGISTRY",
                          "blockVersion": "~0.0.1",
                          "errorHandlingOptions": {
                            "retryOnFailure": {
                              "value": false
                            },
                            "continueOnFailure": {
                              "value": false
                            }
                          }
                        },
                        "displayName": "Mark as complete"
                      },
                      "displayName": "Save to FXInefficiencies"
                    },
                    "displayName": "Convert ratio to %"
                  },
                  "displayName": "(Actual - Expected) ÷ Expected"
                },
                "displayName": "Actual - Expected"
              },
              "displayName": "Get Actual INR paid from table"
            },
            "displayName": "USD × FX rate = Expected INR"
          },
          "displayName": "Fetch FX rate (USD → INR)"
        },
        "displayName": "Get AWS Bill in USD"
      }
    },
    "valid": false,
    "description": ""
  },
  "blocks": [
    "@openops/block-schedule",
    "@openops/block-aws",
    "@openops/block-http",
    "@openops/block-math-helper",
    "@openops/block-openops-tables",
    "@openops/block-end-flow"
  ]
}
