provider "aws" {
  alias = "local"
}

provider "aws" {
  alias = "peer"
}

data "aws_region" "peer" {
  provider = aws.peer
}

resource "aws_ec2_transit_gateway" "local" {
  provider = aws.local

  tags = {
    Name = "Local TGW"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "local" {
  provider = aws.local

  subnet_ids         = var.main_vpc_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.local.id
  vpc_id             = var.main_vpc_id
}

resource "aws_ec2_transit_gateway" "peer" {
  provider = aws.peer

  tags = {
    Name = "Peer TGW"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "peer" {
  provider = aws.peer

  subnet_ids         = var.second_vpc_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.peer.id
  vpc_id             = var.second_vpc_id
}

resource "aws_ec2_transit_gateway_peering_attachment" "example" {
  peer_account_id         = aws_ec2_transit_gateway.peer.owner_id
  peer_region             = data.aws_region.peer.name
  peer_transit_gateway_id = aws_ec2_transit_gateway.peer.id
  transit_gateway_id      = aws_ec2_transit_gateway.local.id

  tags = {
    Name = "TGW Peering Requestor"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "example" {
  provider = aws.peer

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.example.id

  tags = {
    Name = "Example cross-account attachment"
  }
}
