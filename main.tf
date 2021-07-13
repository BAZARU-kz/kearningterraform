terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


resource "kubernetes_namespace" "efk_namespace" {
  metadata {
    name = "efk"
  }
}

resource "kubernetes_pod" "fluentd" {
  metadata {
    name = "fluentd"
    namespace = "efk"
    labels = {
        app = "fluentd"
    }
  }

  spec {
    container {
      image = "fluentd"
      name  = "fluentd"

      port {
        container_port = 24224
      }
    }
  }
}


resource "kubernetes_pod" "elastisearch" {
  metadata {
    name = "elasticsearch"
    namespace = "efk"
    labels = {
        app = "elasticsearch"
    }
  }

  spec {


    container {
      image = "docker.elastic.co/elasticsearch/elasticsearch:7.13.3"
      name  = "elasticsearch"

      port {
        container_port = 9200
      }
    }
  }
}

resource "kubernetes_pod" "kibana" {
  metadata {
    name = "kibana"
    namespace = "efk"
    labels = {
        app = "kibana"
    }
  }
  spec {
  
    container {
      image = "docker.elastic.co/kibana/kibana:6.8.17"
      name  = "kibana"
      port {
        container_port = 5601
      }
    }
  }
}

