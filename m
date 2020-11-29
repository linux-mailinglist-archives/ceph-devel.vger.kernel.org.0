Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA1A2C7B55
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 22:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgK2VOd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 16:14:33 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10334 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgK2VOd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 16:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606684472; x=1638220472;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=stdPNdUaf0rQkS5eKvbh0klPbJuH1ENoQU9qFGAWdaQ=;
  b=olpbGNYqDZ99N1LxAIrcmxjmmUFF4NVsuJ042nIPCbrCHNFJWsbE+2C9
   8s8ZZiVIv1E0y05S3tP92DsnMMPCm1SmWDVEBflE09kkp0lNKoop0qtDp
   kq3TZne6FZ7apR7OHUXqfZwItCW3287dDBKSbNTj/nWwR2NE7n6qBHzHM
   ssoVWbAf/ivXvjph+X2LldtJLmggwb+pp1vJaN+pR6Z+xz/aqjnIxdHv5
   /sC8K3X7l5iGLY0LVZJjFDhSsmrRiEEDzV1XvzUnEfExUaUCWh3zfTeiD
   AvrGBYTRTgkQ51hktlN7FhOBR4GhM/jSG1AZYN5bhebDZkVNIIZ6Gg5Gq
   Q==;
IronPort-SDR: QPMWfJwqOi+qHGPsHvAs+N+CXHYfGPyK6FhUcFtW9J2wY66ThM15PQpozopHR+sPl23Pg/t12g
 jYflHF2Oj5C6WuA2yY+MUgJhxIJmGp8e6BigoDG7YKEHsKAlEgg/jRPHmipGTQykWVb70sK0U9
 OgsHhOUVCznlM5plObUeheI0kyYddZVTwpl3W4RAP8Q3PUztg3/owmaXnJX1qv8KjwTDrZHyZj
 8phJDXHbJg/uKgyZHmxyU2j97oMMQ4IoD1+A0DessIFx+lMPcm2aIrT2dR9gqw9W1beEbuMJPn
 hjo=
X-IronPort-AV: E=Sophos;i="5.78,379,1599494400"; 
   d="scan'208";a="158225416"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 05:13:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdiN531j2YGnYNycd30iGouZCiaQIdMFjzS/KPEXyh8NcDL/pzHoi2qbZn4/XK+rNTvoKGWb+PPXN7SHsJ4VzCLGTxlz0HWX0r/hUC8LRv1ptpRkm87ylqwyr409diyA4bmthAha/JsT22MEBhbWPgwtivv8YmYktuH+H2xFMCMe5vjpN9jeS8EPyMtsG21L+0PQ34zr0hu9Cbv2mX8EuHRLDVns9u/hKvXUalOlhz/Dhl4yjCHZn3eBmfAKQwc2Vwi9u1pYSM/qASF6f2NgxZ7ROuNWqPxKw1xCXnwJo2EH64jWmWTf1HHO3fADnFjF1izSQqp5cNimClFB9wfmew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KjWeOYKd+UZhCEN8TVsriA4i7nDwqd4b1YR26gFkUQ=;
 b=WYuwkHrDushfFutHn26c6E0A6GXUATrT8GyzuzVH550bGxvt41w6nAbcEJCOdW0Iku3qDCow4ifGrvV0SH6qtLVnGCwXyTNXBNJpCzudYF3Uo2ioUZQsE33AXUm44EAcO1REzUo57Svs0WTeIEkgBLKe3NB+Ag44hHEuSx1KRQH1UiFb0S78wpjyO4CL1mbpa/rutZLF1zDWmST9H8SH5ZZUbSThDgdRfsYM/aUnwUY3nVO3XfjCRGXhO2H9aE++MOAdVjYfngmdJtaxD6oXF24M/CfrCurbBClM7I2lV+QIQ+hzk+0AwhazQBJK5mDPMTpJAoDpcGVydizwoV27Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KjWeOYKd+UZhCEN8TVsriA4i7nDwqd4b1YR26gFkUQ=;
 b=JDKayUjNeCW0zHwGDqPZQIjhKR1Bd7y0nO3GrGxNS+iacNidzNePWQXOsclW3M0GDeoupzVHfAJ7rlQk9HBsndWhD7yVC9CWva6aOcd646iBrzaLcqIV4g1X1S3xJrAv9Bw+Ixh8qDEAmPGtqTpoV7GAUa7D4E/LDEAh81g5B6E=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB6021.namprd04.prod.outlook.com (2603:10b6:a03:e6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Sun, 29 Nov
 2020 21:13:22 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Sun, 29 Nov 2020
 21:13:21 +0000
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
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 3/4] nvme: allow revalidate to set a namespace read-only
Thread-Topic: [PATCH 3/4] nvme: allow revalidate to set a namespace read-only
Thread-Index: AQHWxnyPNSwY+7eHi0eeVdR+L+5epA==
Date:   Sun, 29 Nov 2020 21:13:21 +0000
Message-ID: <BYAPR04MB4965E58F8445FB072BA752F786F60@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201129181926.897775-1-hch@lst.de>
 <20201129181926.897775-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43fc7c48-38c7-41e9-f5ce-08d894ab9a17
x-ms-traffictypediagnostic: BYAPR04MB6021:
x-microsoft-antispam-prvs: <BYAPR04MB60214E1D27DD0DAD0D6F2D2186F60@BYAPR04MB6021.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QbQeLyB4L+lXr0eGLFppAXEbdwVu++5FZzVUsNcdOtBWDu6r8xZBWEzRKfira2836sKRu83C+oV0fA6kryLy5Jl3o55aX/v7Wd5gfceGobVgypGUXAmINBpyoC/xoQEl6lOsxtABBJ5sWOPGFaeC8fePaCCdcKDWjnI3Epi8thlUng6kdo86I1rSHKf+y0xoe3J+WY2jEtzJVANE7gPzp9s0V1Ivr0qrvbAyItUjJkvqCp7245K5wGsiHw9OT2WhC8KQppu0JikNWPLme74t3olB+qXw4rQg2KWWIu/M8HVcLPSgh7shRjAAG5zw2KPzpwfKTvpKEtPtF6hMpMnSEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(7696005)(53546011)(2906002)(186003)(8936002)(54906003)(26005)(66556008)(110136005)(71200400001)(6506007)(5660300002)(4744005)(478600001)(7416002)(86362001)(83380400001)(55016002)(52536014)(8676002)(9686003)(66946007)(76116006)(64756008)(33656002)(66446008)(66476007)(4326008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y0voHwWuXgCFoVkgEEWyzvUYdiS9grJG/Fy7RmYZRtK34TJ1YZ0H5sx6+C+e?=
 =?us-ascii?Q?IryFz42iXHRBrAv2yLkLQGXTdo4eeH1HBVNRJj7nZilqbzpQcKKWi79e9qC8?=
 =?us-ascii?Q?ftJ4zFj6cxaIWRz/e9eS+35VOn8VoeFmJrZHaF+qlMC2vk0B7uMnVlI/wns+?=
 =?us-ascii?Q?neqrlPMVCa/JCwQhTpbt8MJQ/vX0PqEN1A/Bfc8BEkf4WymHuYfnqS+8sBt3?=
 =?us-ascii?Q?KRx04oevE0thij02QvGMXQDCMvVVz64fRF0IH1qJRNZc+M3Xwgu8RbJNoNtK?=
 =?us-ascii?Q?/ENEcOjI1UqyWH4PzFskbt6sGO30a2QlWuvwmoiQ2UzLNcP1sY/CAid9FpBO?=
 =?us-ascii?Q?JRmWEcGlN/dnm9X9KpjC42bP0MYZTHcctfsk4KREnF+eihZOSfQYDJQFzZrm?=
 =?us-ascii?Q?1bqpnLodfe3RcTOyr0olY187vU0MoXepz1LsyBguv0kqnghLH66oODFIxSFa?=
 =?us-ascii?Q?YGMstJ5sivItKlHyVUVzf7nGPFE/Qi2r53Bc2YwTXmRVSxGXXTy5Esf41zq/?=
 =?us-ascii?Q?0z3xCE4rdDMLLI8SSjerk6hJCK+wJNPcPht7reOwsbTwpYCBkrat87qGLWd7?=
 =?us-ascii?Q?nslFRVVQSMsEkuGRJ+bZ0mnMzsTlz15Dv//atiA1HqFZ7QgpGG16beEGs6+y?=
 =?us-ascii?Q?QjWbMQYQB8pVZy8ua7rGdoDO4fp3ZlRuPiPP8JQbUgcZWvhNFmfjt0fghqN5?=
 =?us-ascii?Q?y6QBpUdL1I6TOH/SodeyEyJjLQ+/dT2soDneIu4e0KBKIl7r/XfOOJRStdLB?=
 =?us-ascii?Q?CudgghLZkLqADDvQyvYFLQl+kqTMtGgrjQyyDudguoCBnrt2Xr8st0K7CMQz?=
 =?us-ascii?Q?z4ZLj9BkvWBm570VX0kheCC87HmFfg4OoBjo70ilg7BKGsI7QvvHVozmRgaN?=
 =?us-ascii?Q?LCNMGcWC3DdpM+n7zqwYpbRU6RfFWx9UB1UxqYgYf5dZKRmrG4xm2rmHUrvc?=
 =?us-ascii?Q?rpJ9N9+Ef2AVh7hTPd+F+AJ56khIVGzzPTzGif3fbvVCzI5r8WgfN3yJdto2?=
 =?us-ascii?Q?tXd1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fc7c48-38c7-41e9-f5ce-08d894ab9a17
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2020 21:13:21.6286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L2HTxwqmyST5ic5euC4qzK15XcgbxMr15XHpHuS7QhbTBHs+vK61cX9neYsEMhdlNlkuyuTHjdLX7vvDDhaJMrl1yyqYWdNpktadydlr14k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6021
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/29/20 10:22, Christoph Hellwig wrote:=0A=
> Unconditionally call set_disk_ro now that it only updates the hardware=0A=
> state.  This allows to properly set up the Linux devices read-only when=
=0A=
> the controller turns a previously writable namespace read-only.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
