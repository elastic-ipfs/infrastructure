locals {
  multiaddr_dnsaddress_sufix = "${var.bitswap_peer_record_value}/tcp/${var.port}/${var.application_layer_protocol}/p2p/${var.peer_id}"
}
