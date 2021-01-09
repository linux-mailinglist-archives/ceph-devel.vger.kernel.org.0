Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC162F036E
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 21:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbhAIU2g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 15:28:36 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47248 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAIU2g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 15:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610224115; x=1641760115;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=TN8pINlTfHbCsp7dX8LsMokK4v7Vl8X3bGgYlX2BWAE=;
  b=OTD6bncSGC5gFKZtefWsml1IKm0oLMnnEPoVlpmTiniTdU8tlCakd0G2
   pa2AuZlh9PeRoivNJhqnVRUIuNcXuuB0wn1iGy43GzlYD/ZLFULnmcGka
   +TPA+v2Kh5UKfcxRFwRlIN4VSUxLECRgTd8mX8Fen4yyxHJ5xqPBzJCFe
   N61UJVVgBAQfhHFXvThvldXfWro+jCgtlrGO/BabtyTTJVu3x3h3wKh8h
   qC519ejEQBMiWy6S0ctMlyIGDN0wDiid3Fog0YKycbvfy1SmFiaepQZG4
   xirK4fRviv1rP0jhlqz24EBrGP3JLa0iw1Y5C6/BQlRDmrpCmkJeaMXTq
   w==;
IronPort-SDR: AeY8xXEamel0IdX0nPmcK2S8R9vvsbF72t0cfjqb3VWe99gvyABW7AbnDaPFlUAKY8fHIl7ix7
 Uk9LiMce8EWa1r89fKIhHoJqQ9My49KG8XYzlOWZ6DEwO+Ua0yIsQ5glizz+9erk9uAnH4I7wW
 oOt3RpuOs+c31ZmhEgz1trlAjXCxuG8TBJIeR1+CMxw/MrUPUZThtUbu9oaP7CY+FD606Ijk1g
 3nFYw0VXbIaUopLqmXInwN/1wET+fYmUDtHUNbQYr+OqB/lo9DHKtKjBQADv9PKLPSN9Yhjyth
 XGI=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; 
   d="scan'208";a="157043541"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 04:27:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMXwvcI0Jqpm/t6QnC5rzKEeTJtee/mV1AUfe+j20JOv2gWhxpiKYfaohcWfC0liIF1iGTaJVtTukEfOCALUSi93K8pVwXAqQQP3IExlRKIJafQUCkQtSk/3TPFI6q3htW8ynrYBVBQeD2FmZ5iBP5+9TzmmKcrt3i8pDhPqooMZGjI1kz5Otbryj++4felQLI+FQhf/s09EUFOXE4hUofMgANyvtVm+W5sZ429mnYKfhpFOIAcf9sVNYny7JXKZiCdr+1gxDrk8BzXXGxevw+059D3kDbizZNGAfRPiLNoDdz7TMrojz5++ImPpJvs/VmywDaAJaOYDxn4DoLYsZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dXnEEmRKGpImiYJspHCWxI+p2HI/4k6soL7QG7dQxg=;
 b=h8xW1E+sepgP1OQkEHLobtJxEkpDRF/UFe1XSxH1hG4g0z4SNNB2vV7Ec04CAX7OCMuED04/B61GNdq7oQZXcX0v8G+tq7Cfkaw0O7RMm0pkHcYvNmK9B1qxbhyGTF36j7ia/d112UGrrH/xl0/1GF1RqXUcNz4zeVjwsJjeVgR57/K6VeeJZheKXRy7+YdfhQeeT0RMu+1z3KBG+vfYbQb1ZqcwBgKyEzv1rtOUNNR8hg1tVTfkLrFXKpKUAjOF2CyCskRttD4YWT5etBJp9uev/kP0PsuEzhJKaE/ej/dJ8RkvZ7bFtFX1OyF4yOKYomlqhxJX+Aulojpi7RJdfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dXnEEmRKGpImiYJspHCWxI+p2HI/4k6soL7QG7dQxg=;
 b=iYzBf+6jYJ5iSmv7v6qCzrhNfHGzyPA7APwE8sujXW5hRGMq03F5LzrwMzyIABWbpLAovtRRRNGk7QCQID+ZO1SwgqWK51CMEqAswI/nmLwRsmLsT12l71PdHObvmNa8X83swk7Ecs8r0RUqSirru9DKTO8QfdRMyS1X9rhrB/o=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5430.namprd04.prod.outlook.com (2603:10b6:a03:c7::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sat, 9 Jan
 2021 20:27:27 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009; Sat, 9 Jan 2021
 20:27:26 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
Thread-Topic: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
Thread-Index: AQHW5nUj2CJyK2PmHkCmuBYx3pEKEQ==
Date:   Sat, 9 Jan 2021 20:27:26 +0000
Message-ID: <BYAPR04MB4965CD87B0E6CBA2FFD0B09886AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210109104254.1077093-1-hch@lst.de>
 <20210109104254.1077093-7-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d08f02bd-c482-40f0-926e-08d8b4dcfad6
x-ms-traffictypediagnostic: BYAPR04MB5430:
x-microsoft-antispam-prvs: <BYAPR04MB5430106A8922A21DF3D5531E86AD0@BYAPR04MB5430.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5zKg7IJilH0Xs1Bxa8SM4W4G5ecbM7jTulN2kAj/B5/6Wjzlr2QQ4zQu73ZKG3D15DArH4luuRplQwbyjOqO4UQK9g3MVcBWbIX4xDsk41yuZ9ALZM+3aWu0m58PH0FML0m7jzmdLqjKd7bKSHyiYK6ZM5nfWntjg5EqtJ0HFqSzcCR2yyUJIcqkS5o/yprprI5sZxfiecx/jtNAu//phRv3bArCaNukQuCHJkCUvPpNaov+tRZVVcEKSwcdGy70mh8GwxIQVBdD8+Mn5cxPai1949Us7SOBl0Y1nXHVGnlhU39EhjByW85PLe2QYprnaQzT+TNP3Ew75z73g6sV5ffukoCIzrdzclrRkgEjpRLHKCj6KJf2Dj1Icp+tQIk+8UZf6oihKy/4hojILoorOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(76116006)(2906002)(66556008)(66476007)(7416002)(5660300002)(52536014)(26005)(4326008)(53546011)(316002)(186003)(6506007)(110136005)(66946007)(33656002)(66446008)(71200400001)(7696005)(54906003)(64756008)(478600001)(8936002)(55016002)(83380400001)(8676002)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3Km9/v4XeC8e4TNNr7OdvVC0kInaVNzZ+PlvyFEDKSVROxOIdB5O9BzApV4V?=
 =?us-ascii?Q?LCx1biZw8uoWq2bsNEByXLPJE2Wn2gd3vA+PJFjo+Hc2rQfXSLuSp+TqTA9Z?=
 =?us-ascii?Q?JAyzyhKFCV+w3li26eabUOk7urAOsgZxv394ZHKbllDslE4PG/f2LUbMEGQP?=
 =?us-ascii?Q?SrLEEuvYWEUBGNnS/INZF9wH0OKtpBdym6i6TOX7rfzcReiZmfGf7syD6L0P?=
 =?us-ascii?Q?pfINU09L9yiFNfdC75fL6uQPQxGMgS8RyHo8U7CMyT8e10ikGzAwu1E+0bM2?=
 =?us-ascii?Q?gRHAgd72jSu3KPGS6e9gB9wmUtIAt6umEhHFmuDZWpLqM/IihslGrMGvqDFv?=
 =?us-ascii?Q?xg+g7cHgK8mbZcVzfDues8P6lHplWEQquztm0dqHO3xNFQ6txIpkctC152Wg?=
 =?us-ascii?Q?B1AoY7k5UXl4UXds+sQHTEeH2V22vZ/LojgQhxd9OWKomhl7XD5mKrQs2meL?=
 =?us-ascii?Q?p92VWpwTs1DFWuMUklhQKVKjWcTuear6A4Tqi7cNwzcaCbxKiEnSQXilbOlY?=
 =?us-ascii?Q?YaJ6Xt6NbkJCO54vRrXmJm7DSnEu3BFOROQxA8TnyLvQTVhl+wCChWXgtIK2?=
 =?us-ascii?Q?jM7C1L3HBTQqJEGnaGgmUNuE7tzpCNkuIhDwwZRwhDejm9Zmy2cPY0DjPy84?=
 =?us-ascii?Q?N5LcQv407+GdnRRwFQwPvxcxrZiLkJJxB0YRJ+jAz2POxq7NeDu0wT3dwbDs?=
 =?us-ascii?Q?HKYyZdqBO1pMsq+0rZ3e1dj5X6emD/DzpKLNQDto6r+KXIAgYz4TMQiTm71Z?=
 =?us-ascii?Q?i1+fIDBuRIPUlS4Vq770JXFrRY11UE/klh/6eNOFyoBeROfeMF3yqGO+8LJL?=
 =?us-ascii?Q?IRq3fLthZqBSVV7Pu54FYe4V6zmnoYLcg0P52hhyK6KCkKs9YqhwSbkWDOxq?=
 =?us-ascii?Q?A8eeYsTDTyrJTQ1vsAjdYBHc+EU0XuTIM303yG26WWcoDs7FgaOMu8LjD80Y?=
 =?us-ascii?Q?Cv7MvOOpLRJ4IzH+GFzg2wU2V8azzDNcFhFXUfBc1KTHd1wDEtJFy9n4PS3a?=
 =?us-ascii?Q?UpR3?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08f02bd-c482-40f0-926e-08d8b4dcfad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:27:26.6252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHwS9qQDhhu8i5c/fE9qdQv5ao2jZNgIeyHs0gGZZ2rUhflGDLpbwuEzb9XWsW539ENucHfztLdu0yLNc8WzFJHQ6bJ8qsPwIQnHK6JPKvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5430
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/9/21 02:49, Christoph Hellwig wrote:=0A=
> Unconditionally call set_disk_ro now that it only updates the hardware=0A=
> state.  This allows to properly set up the Linux devices read-only when=
=0A=
> the controller turns a previously writable namespace read-only.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Keith Busch <kbusch@kernel.org>=0A=
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>=0A=
> ---=0A=
>  drivers/nvme/host/core.c | 5 ++---=0A=
>  1 file changed, 2 insertions(+), 3 deletions(-)=0A=
>=0A=
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c=0A=
> index ce1b6151944131..3a0557ccc9fc5d 100644=0A=
> --- a/drivers/nvme/host/core.c=0A=
> +++ b/drivers/nvme/host/core.c=0A=
> @@ -2114,9 +2114,8 @@ static void nvme_update_disk_info(struct gendisk *d=
isk,=0A=
>  	nvme_config_discard(disk, ns);=0A=
>  	nvme_config_write_zeroes(disk, ns);=0A=
>  =0A=
> -	if ((id->nsattr & NVME_NS_ATTR_RO) ||=0A=
> -	    test_bit(NVME_NS_FORCE_RO, &ns->flags))=0A=
> -		set_disk_ro(disk, true);=0A=
> +	set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||=0A=
> +		test_bit(NVME_NS_FORCE_RO, &ns->flags));=0A=
>  }=0A=
>  =0A=
=0A=
If we are adding a multi-line function call can we please consider=0A=
following, on the top of this that matches earlier multi-line function=0A=
call in the same nvme_update_disk_into() :-=0A=
=0A=
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c=0A=
index 3a0557ccc9fc..5cf0f801a95e 100644=0A=
--- a/drivers/nvme/host/core.c=0A=
+++ b/drivers/nvme/host/core.c=0A=
@@ -2115,7 +2115,7 @@ static void nvme_update_disk_info(struct gendisk=0A=
*disk,=0A=
        nvme_config_write_zeroes(disk, ns);=0A=
 =0A=
        set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||=0A=
-               test_bit(NVME_NS_FORCE_RO, &ns->flags));=0A=
+                   test_bit(NVME_NS_FORCE_RO, &ns->flags));=0A=
 }=0A=
 =0A=
static inline bool nvme_first_scan(struct gendisk *disk)=0A=
=0A=
Otherwise, looks good.=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
>  static inline bool nvme_first_scan(struct gendisk *disk)=0A=
=0A=
