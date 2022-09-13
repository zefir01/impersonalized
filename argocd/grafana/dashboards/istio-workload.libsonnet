{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "datasource",
          "uid": "grafana"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "Istio Workload Dashboard version 1.13.4",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "gnetId": 7630,
  "graphTooltip": 0,
  "id": 9,
  "iteration": 1652886880002,
  "links": [],
  "liveNow": false,
  "panels": [
    {
      "collapsed": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 95,
      "panels": [],
      "title": "General",
      "type": "row"
    },
    {
      "gridPos": {
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 1
      },
      "id": 89,
      "links": [],
      "options": {
        "content": "<div class=\"dashboard-header text-center\">\n<span>WORKLOAD: $workload.$namespace</span>\n</div>",
        "mode": "html"
      },
      "pluginVersion": "8.5.2",
      "transparent": true,
      "type": "text"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "rgb(31, 120, 193)",
            "mode": "fixed"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "ops"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 8,
        "x": 0,
        "y": 4
      },
      "id": 12,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "8.5.2",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_requests_total{reporter=~\"$qrep\",destination_workload_namespace=~\"$namespace\",destination_workload=~\"$workload\", cluster_name=~\"$cluster\"}[5m])), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "refId": "A",
          "step": 4
        }
      ],
      "title": "Incoming Request Volume",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "rgb(31, 120, 193)",
            "mode": "fixed"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "rgba(50, 172, 45, 0.97)",
                "value": null
              },
              {
                "color": "rgba(237, 129, 40, 0.89)",
                "value": 95
              },
              {
                "color": "rgba(245, 54, 54, 0.9)",
                "value": 99
              }
            ]
          },
          "unit": "percentunit"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 8,
        "x": 8,
        "y": 4
      },
      "id": 14,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "8.5.2",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_requests_total{reporter=~\"$qrep\",destination_workload_namespace=~\"$namespace\",destination_workload=~\"$workload\",response_code!~\"5.*\", cluster_name=~\"$cluster\"}[5m])) / sum(irate(istio_requests_total{reporter=~\"$qrep\",destination_workload_namespace=~\"$namespace\",destination_workload=~\"$workload\", cluster_name=~\"$cluster\"}[5m]))",
          "format": "time_series",
          "intervalFactor": 1,
          "refId": "A"
        }
      ],
      "title": "Incoming Success Rate (non-5xx responses)",
      "type": "stat"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 4,
        "w": 8,
        "x": 16,
        "y": 4
      },
      "hiddenSeries": false,
      "id": 87,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": false,
        "hideZero": false,
        "max": false,
        "min": false,
        "rightSide": true,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.50, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le)) / 1000) or histogram_quantile(0.50, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le))",
          "format": "time_series",
          "interval": "",
          "intervalFactor": 1,
          "legendFormat": "P50",
          "refId": "A"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.90, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le)) / 1000) or histogram_quantile(0.90, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "P90",
          "refId": "B"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.99, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le)) / 1000) or histogram_quantile(0.99, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\",destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}[1m])) by (le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "P99",
          "refId": "C"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Request Duration",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "s",
          "logBase": 1,
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "rgb(31, 120, 193)",
            "mode": "fixed"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "Bps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "id": 84,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "8.5.2",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", cluster_name=~\"$cluster\"}[1m])) + sum(irate(istio_tcp_received_bytes_total{reporter=~\"$qrep\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", cluster_name=~\"$cluster\"}[1m]))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "TCP Server Traffic",
      "type": "stat"
    },
    {
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "fixedColor": "rgb(31, 120, 193)",
            "mode": "fixed"
          },
          "mappings": [
            {
              "options": {
                "match": "null",
                "result": {
                  "text": "N/A"
                }
              },
              "type": "special"
            }
          ],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "Bps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 12,
        "x": 12,
        "y": 8
      },
      "id": 85,
      "links": [],
      "maxDataPoints": 100,
      "options": {
        "colorMode": "none",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "horizontal",
        "reduceOptions": {
          "calcs": [
            "mean"
          ],
          "fields": "",
          "values": false
        },
        "textMode": "auto"
      },
      "pluginVersion": "8.5.2",
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", cluster_name=~\"$cluster\"}[1m])) + sum(irate(istio_tcp_received_bytes_total{reporter=~\"$qrep\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", cluster_name=~\"$cluster\"}[1m]))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "TCP Client Traffic",
      "type": "stat"
    },
    {
      "collapsed": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 12
      },
      "id": 93,
      "panels": [],
      "title": "Inbound Workloads",
      "type": "row"
    },
    {
      "gridPos": {
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 13
      },
      "id": 45,
      "links": [],
      "options": {
        "content": "<div class=\"dashboard-header text-center\">\n<span>INBOUND WORKLOADS</span>\n</div>",
        "mode": "html"
      },
      "pluginVersion": "8.5.2",
      "transparent": true,
      "type": "text"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 0,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "hiddenSeries": false,
      "id": 25,
      "legend": {
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null as zero",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_requests_total{connection_security_policy=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", reporter=~\"$qrep\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace, response_code), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace }} : {{ response_code }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_requests_total{connection_security_policy!=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", reporter=~\"$qrep\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace, response_code), 0.001)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace }} : {{ response_code }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Incoming Requests By Source And Response Code",
      "tooltip": {
        "shared": false,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": [
          "total"
        ]
      },
      "yaxes": [
        {
          "format": "ops",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 16
      },
      "hiddenSeries": false,
      "id": 26,
      "legend": {
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "hideZero": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_requests_total{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\",response_code!~\"5.*\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace) / sum(irate(istio_requests_total{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_requests_total{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\",response_code!~\"5.*\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace) / sum(irate(istio_requests_total{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[5m])) by (source_workload, source_workload_namespace)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Incoming Success Rate (non-5xx responses) By Source",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "percentunit",
          "logBase": 1,
          "max": "1.01",
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "description": "",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 0,
        "y": 22
      },
      "hiddenSeries": false,
      "id": 27,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "hideZero": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.50, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.50, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.90, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.90, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.95, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.95, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.99, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.99, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.50, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.50, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.90, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.90, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.95, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.95, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.99, sum(irate(istio_request_duration_milliseconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le)) / 1000) or histogram_quantile(0.99, sum(irate(istio_request_duration_seconds_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Incoming Request Duration By Source",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "s",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 8,
        "y": 22
      },
      "hiddenSeries": false,
      "id": 28,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}}  P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}}  P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_request_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Incoming Request Size By Source",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "decbytes",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 16,
        "y": 22
      },
      "hiddenSeries": false,
      "id": 68,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}}  P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}}  P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_response_bytes_bucket{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload=~\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{source_workload}}.{{source_workload_namespace}} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Response Size By Source",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "decbytes",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 28
      },
      "hiddenSeries": false,
      "id": 80,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_received_bytes_total{reporter=~\"$qrep\", connection_security_policy=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace), 0.001)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace}} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_received_bytes_total{reporter=~\"$qrep\", connection_security_policy!=\"mutual_tls\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace}}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Bytes Received from Incoming TCP Connection",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "Bps",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 28
      },
      "hiddenSeries": false,
      "id": 82,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_sent_bytes_total{connection_security_policy=\"mutual_tls\", reporter=~\"$qrep\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace}} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_sent_bytes_total{connection_security_policy!=\"mutual_tls\", reporter=~\"$qrep\", destination_workload_namespace=~\"$namespace\", destination_workload=~\"$workload\", source_workload=~\"$srcwl\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}[1m])) by (source_workload, source_workload_namespace), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ source_workload }}.{{ source_workload_namespace}}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Bytes Sent to Incoming TCP Connection",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "Bps",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "collapsed": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 34
      },
      "id": 91,
      "panels": [],
      "title": "Outbound Services",
      "type": "row"
    },
    {
      "gridPos": {
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 35
      },
      "id": 69,
      "links": [],
      "options": {
        "content": "<div class=\"dashboard-header text-center\">\n<span>OUTBOUND SERVICES</span>\n</div>",
        "mode": "html"
      },
      "pluginVersion": "8.5.2",
      "transparent": true,
      "type": "text"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 0,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 38
      },
      "hiddenSeries": false,
      "id": 70,
      "legend": {
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null as zero",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_requests_total{destination_principal=~\"spiffe.*\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", reporter=\"source\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service, response_code), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} : {{ response_code }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_requests_total{destination_principal!~\"spiffe.*\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", reporter=\"source\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service, response_code), 0.001)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} : {{ response_code }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Outgoing Requests By Destination And Response Code",
      "tooltip": {
        "shared": false,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": [
          "total"
        ]
      },
      "yaxes": [
        {
          "format": "ops",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 38
      },
      "hiddenSeries": false,
      "id": 71,
      "legend": {
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "hideZero": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_requests_total{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\",response_code!~\"5.*\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service) / sum(irate(istio_requests_total{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "sum(irate(istio_requests_total{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\",response_code!~\"5.*\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service) / sum(irate(istio_requests_total{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[5m])) by (destination_service)",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Outgoing Success Rate (non-5xx responses) By Destination",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "percentunit",
          "logBase": 1,
          "max": "1.01",
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "description": "",
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 0,
        "y": 44
      },
      "hiddenSeries": false,
      "id": 72,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "hideZero": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.50, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.50, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.90, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.90, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.95, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.95, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.99, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.99, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.50, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.50, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.90, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.90, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.95, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.95, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "(histogram_quantile(0.99, sum(irate(istio_request_duration_milliseconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le)) / 1000) or histogram_quantile(0.99, sum(irate(istio_request_duration_seconds_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Outgoing Request Duration By Destination",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "s",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 8,
        "y": 44
      },
      "hiddenSeries": false,
      "id": 73,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_request_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Outgoing Request Size By Destination",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "decbytes",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 8,
        "x": 16,
        "y": 44
      },
      "hiddenSeries": false,
      "id": 74,
      "legend": {
        "alignAsTable": false,
        "avg": false,
        "current": false,
        "hideEmpty": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50 (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90 (🔐mTLS)",
          "refId": "B",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95 (🔐mTLS)",
          "refId": "C",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }}  P99 (🔐mTLS)",
          "refId": "D",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.50, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P50",
          "refId": "E",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.90, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P90",
          "refId": "F",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.95, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P95",
          "refId": "G",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "histogram_quantile(0.99, sum(irate(istio_response_bytes_bucket{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service, le))",
          "format": "time_series",
          "hide": false,
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} P99",
          "refId": "H",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Response Size By Destination",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "decbytes",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": false
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 50
      },
      "hiddenSeries": false,
      "id": 76,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_received_bytes_total{connection_security_policy=\"mutual_tls\", reporter=\"source\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_received_bytes_total{connection_security_policy!=\"mutual_tls\", reporter=\"source\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Bytes Sent on Outgoing TCP Connection",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "Bps",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": {
        "type": "prometheus",
        "uid": "P46855B3906317654"
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 50
      },
      "hiddenSeries": false,
      "id": 78,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "8.5.2",
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_sent_bytes_total{reporter=\"source\", connection_security_policy=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }} (🔐mTLS)",
          "refId": "A",
          "step": 2
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "P46855B3906317654"
          },
          "expr": "round(sum(irate(istio_tcp_sent_bytes_total{reporter=\"source\", connection_security_policy!=\"mutual_tls\", source_workload_namespace=~\"$namespace\", source_workload=~\"$workload\", destination_service=~\"$dstsvc\", cluster_name=~\"$cluster\"}[1m])) by (destination_service), 0.001)",
          "format": "time_series",
          "intervalFactor": 1,
          "legendFormat": "{{ destination_service }}",
          "refId": "B",
          "step": 2
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Bytes Received from Outgoing TCP Connection",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "mode": "time",
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "Bps",
          "logBase": 1,
          "min": "0",
          "show": true
        },
        {
          "format": "short",
          "logBase": 1,
          "show": true
        }
      ],
      "yaxis": {
        "align": false
      }
    }
  ],
  "refresh": "1m",
  "schemaVersion": 36,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "selected": false,
          "text": "default",
          "value": "default"
        },
        "hide": 0,
        "includeAll": false,
        "multi": false,
        "name": "datasource",
        "options": [],
        "query": "prometheus",
        "queryValue": "",
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "type": "datasource"
      },
      {
        "current": {
          "selected": false,
          "text": "main",
          "value": "main"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "label_values(cluster_name)",
        "hide": 0,
        "includeAll": false,
        "multi": false,
        "name": "cluster",
        "options": [],
        "query": {
          "query": "label_values(cluster_name)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 0,
        "type": "query"
      },
      {
        "current": {
          "selected": false,
          "text": "blablabla",
          "value": "blablabla"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "query_result(sum(istio_requests_total{cluster_name=~\"$cluster\"}) by (destination_workload_namespace) or sum(istio_tcp_sent_bytes_total{cluster_name=~\"$cluster\"}) by (destination_workload_namespace))",
        "hide": 0,
        "includeAll": false,
        "label": "Namespace",
        "multi": false,
        "name": "namespace",
        "options": [],
        "query": {
          "query": "query_result(sum(istio_requests_total{cluster_name=~\"$cluster\"}) by (destination_workload_namespace) or sum(istio_tcp_sent_bytes_total{cluster_name=~\"$cluster\"}) by (destination_workload_namespace))",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "/.*_namespace=\"([^\"]*).*/",
        "skipUrlSync": false,
        "sort": 0,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "gear-node-main",
          "value": "gear-node-main"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "query_result((sum(istio_requests_total{destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_workload) or sum(istio_requests_total{source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload)) or (sum(istio_tcp_sent_bytes_total{destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_workload) or sum(istio_tcp_sent_bytes_total{source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload)))",
        "hide": 0,
        "includeAll": false,
        "label": "Workload",
        "multi": false,
        "name": "workload",
        "options": [],
        "query": {
          "query": "query_result((sum(istio_requests_total{destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_workload) or sum(istio_requests_total{source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload)) or (sum(istio_tcp_sent_bytes_total{destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_workload) or sum(istio_tcp_sent_bytes_total{source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload)))",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "/.*workload=\"([^\"]*).*/",
        "skipUrlSync": false,
        "sort": 1,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "destination",
          "value": "destination"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "label_values(reporter)",
        "hide": 0,
        "includeAll": false,
        "label": "Reporter",
        "multi": true,
        "name": "qrep",
        "options": [],
        "query": {
          "query": "label_values(reporter)",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "",
        "skipUrlSync": false,
        "sort": 2,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "All",
          "value": "$__all"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "query_result(sum(istio_requests_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload_namespace) or sum(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload_namespace))",
        "hide": 0,
        "includeAll": true,
        "label": "Inbound Workload Namespace",
        "multi": true,
        "name": "srcns",
        "options": [],
        "query": {
          "query": "query_result(sum(istio_requests_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload_namespace) or sum(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (source_workload_namespace))",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "/.*namespace=\"([^\"]*).*/",
        "skipUrlSync": false,
        "sort": 2,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "All",
          "value": "$__all"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "query_result(sum(istio_requests_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}) by (source_workload) or sum(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}) by (source_workload))",
        "hide": 0,
        "includeAll": true,
        "label": "Inbound Workload",
        "multi": true,
        "name": "srcwl",
        "options": [],
        "query": {
          "query": "query_result(sum(istio_requests_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}) by (source_workload) or sum(istio_tcp_sent_bytes_total{reporter=~\"$qrep\", destination_workload=\"$workload\", destination_workload_namespace=~\"$namespace\", source_workload_namespace=~\"$srcns\", cluster_name=~\"$cluster\"}) by (source_workload))",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "/.*workload=\"([^\"]*).*/",
        "skipUrlSync": false,
        "sort": 3,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "current": {
          "selected": false,
          "text": "All",
          "value": "$__all"
        },
        "datasource": {
          "type": "prometheus",
          "uid": "P46855B3906317654"
        },
        "definition": "query_result(sum(istio_requests_total{reporter=\"source\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_service) or sum(istio_tcp_sent_bytes_total{reporter=\"source\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_service))",
        "hide": 0,
        "includeAll": true,
        "label": "Destination Service",
        "multi": true,
        "name": "dstsvc",
        "options": [],
        "query": {
          "query": "query_result(sum(istio_requests_total{reporter=\"source\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_service) or sum(istio_tcp_sent_bytes_total{reporter=\"source\", source_workload=~\"$workload\", source_workload_namespace=~\"$namespace\", cluster_name=~\"$cluster\"}) by (destination_service))",
          "refId": "StandardVariableQuery"
        },
        "refresh": 1,
        "regex": "/.*destination_service=\"([^\"]*).*/",
        "skipUrlSync": false,
        "sort": 4,
        "tagValuesQuery": "",
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      }
    ]
  },
  "time": {
    "from": "now-5m",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ]
  },
  "timezone": "",
  "title": "Istio Workload Dashboard",
  "uid": "lsNka2X7k",
  "version": 10,
  "weekStart": ""
}