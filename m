Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D032F035E
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 21:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhAIUPW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 15:15:22 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60810 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIUPV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 15:15:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610223320; x=1641759320;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Hj5dZ6YuX80YbYGFFIP70jDOB+mOxjlxmIBr84tFLrY=;
  b=JP2RhEPGXMpIpfpgCwoB5lQCZdE5CFvF+MW2DJQSzknv8w/YDBQQwA+8
   3fxDM2LgF0BwBROzDlMx0Wm5QczmwRxtWHuhsde/aYnM4J80KTPISwkEr
   ObHxR87mUIqXHnEdXaCVHt27bZIE4yuJr0TJxQHRTEXdvjgQrcnfquCIR
   s/MC4OpDrz5hXfmP4fDMINQU3DFUlHLIpWN538tpxoBb9dO8ILWIINl4j
   nHVIZfVC6hNE+0UoEFPW2iZGG0p7fHp9Q1+WddmypLpMTJlqdOZllTHME
   kUUVcsE2+jn62iD5ESPTVG1XGaPMX/9T6pdzO5l0XbtdjqoNOX/clqt5a
   A==;
IronPort-SDR: PvvqJk4relNj3XwhWCYU2YqOl98sp1f0Upr5983aEnn8cG6boSnJrYTB2tW050nnZpyxQPnFAf
 B42o1EtSNC/1waPd29LVdxkIllU77DcORmSzD6sDJ8/fesf/WePUECLLqKWzh/oIvFOYpzpknX
 TYjAWV01dvAcwoZkcveoCl6F839LqZRyMZeXUpIQfKKypJmjomrFT35yDINsnXMbGz3jnJbi59
 D2BZoK32oklI9zjHcWLiiHPfs9deECLDNBYpc2V3KT35XoMMPamWj7Qnu3elXIrC3fTc7BZj1v
 E34=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; 
   d="scan'208";a="157042328"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 04:14:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYp8DwN59Hvp/8IQolNx1E8LUjR0Q7p7fLNwPP1Pp0mkoz5kI7fTTz69HC8xLQuhMtnrcZ911rDc7IRiQl6nqI7n+5Rb8/uQ0DZ2UCVvQdU/dkOqs1klHq6C0x0Pr7X9TW8udrtT5HnDNxxZR7zfI+wBsKn6xIBo8mMMhYVt+V+Y9EGluJKX4JifZJnGx4+3XqCTxXC1uj5yjPyHKl0FcppfCz70zi7ezVAQyxbvMTUFOR3UvYE1Rc8ukQEpMttWLFQsCIV0Ty3hN7eHOq9Tv6BIyE0GslaekwLetx59u8Bhnw0SiPngLrFHY1grU/fv8aEsWG9tUkT04258+uJOrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj5dZ6YuX80YbYGFFIP70jDOB+mOxjlxmIBr84tFLrY=;
 b=Io12Iw227XNiUfN2ehWGX8xAsDTvCTqihRADHvItBZvLXjAbeLK3FQjFZO/HAHPQ1Dsl3/8anAoDTHkq4S2TmVusJXG2w6BUEjw7UKNGziHGC9+1RMFFniQazYN5FTKmGHErNbgXW4ozstZvB6VgbLoqOLIj3dodJa0Nv9lePe6VO9x8BOcX8/5oLo4KlBQpeYrF/eHcXC+mpqRQe4cS+9ziniLOAi//bv4eXhHgRTrM4ff3hQydYo0uXVlfyTluuo8XldY2JnzbvSRuL192CCGAdIZyEDnyUIFzsl6DQG3pCdX+poSBPGrVGIlB2KdZVX1uF9hx3GeDfSFbtPzA4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj5dZ6YuX80YbYGFFIP70jDOB+mOxjlxmIBr84tFLrY=;
 b=pzthVwZBbS/1EJfbvyptz+57oE86nztM0EQfaS5tmHii9UmQlQkFNY4NQb8xfKP1t9VG1Z/jAExTPJuMfU5eMXK/0SMUOcHXZaAiv5qgy/0YRZ/S6ElNQQCs10P8YdoLO2wiIFUnC5GZ/AmAPlGMS4VGJUj4BwBPGdSJAT9wdk8=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4871.namprd04.prod.outlook.com (2603:10b6:a03:4e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Sat, 9 Jan
 2021 20:14:12 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009; Sat, 9 Jan 2021
 20:14:12 +0000
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
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Thread-Topic: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Thread-Index: AQHW5nUARX/fpWP0iEiSGjKZobcLZg==
Date:   Sat, 9 Jan 2021 20:14:09 +0000
Message-ID: <BYAPR04MB4965B6AC1FAAC270F636F7BE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210109104254.1077093-1-hch@lst.de>
 <20210109104254.1077093-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8fb53c66-fb7b-4a57-94fb-08d8b4db2134
x-ms-traffictypediagnostic: BYAPR04MB4871:
x-microsoft-antispam-prvs: <BYAPR04MB48712A5FCCA99373D3D3201486AD0@BYAPR04MB4871.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7oZkUxkxVyoFipLgsp9UbOFpsF/tSlNuEkSJhwYQk7QcHNgpGkqLSUGchtqvEkCyT4zyUO/pRkahIOisKaTSx66mLY88MHRcnRCZOhk+7Otpm8T75OdGVhuvft5qGshvLSMeCBbyeMd7rDsxxb52lLhHOqSidODGVu/Ze/VJCC/qVj2PJgPbBrM2AhEt7E2URxSGV/4t6Q2hEf624wR1npy1s6haNRRiuyQ190aOoqAajFhSeQc9DsAuLvHcH8N2GYY5xs7F+Llyscy9EuLjPo1vuEr1CUsfBi97ZZwcs2u760JgdJZxmJ1hGmVnd4aeAazjPNbmTUxwHKktOKPH9I4jNF8yEpUvfWsxseXjiWRIity0S5TmFXwQSfchdKLATFkAV/obBDcrwdRM2CNDxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(6666004)(7416002)(52536014)(8676002)(2906002)(316002)(110136005)(66556008)(66446008)(66476007)(54906003)(64756008)(66946007)(5660300002)(558084003)(478600001)(9686003)(7696005)(26005)(6506007)(4326008)(53546011)(76116006)(8936002)(33656002)(55016002)(86362001)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QKij9sd/Bt6PfCE8fE8UdZaFOkMnEMhA8sW3k9Q9wU/bIUy1MeBfOOaPk9dk?=
 =?us-ascii?Q?c9CACvTv6Jq6mPSL799jA3NHgp4wN6hlqQt/ZApz1zaVWcBpBdTPsdi/x1zD?=
 =?us-ascii?Q?Wepbi5k966rvX6LLVBsufpu8TcwatQyyjgPT+VxR7tNNeiZaDlhWeUKGqq7R?=
 =?us-ascii?Q?BC1LBOdyIxFlVH2ssXcCUGi7CZk4K4ngoARWUCaqC82Ho5Ku+R2GhIvPNLj+?=
 =?us-ascii?Q?ywx2sC5x+qoF6oYyppdrVulDZDISHy3jYJVFUO+nIwtfHgTe0ceIbKAxHqGD?=
 =?us-ascii?Q?HvBmvvyoQ5+RCrgk6CMMiNzUgmG2p6VGxPPi3dJCn/JWE50Aqx/opDip8SKT?=
 =?us-ascii?Q?h0y1e+Axbh++1gY5RAJyqCpCNHC4vK5nZqowPGGhqPczb9mHS+sHmHGYyUsC?=
 =?us-ascii?Q?uU8DrX7ematvUT76DE/40lTQi+lmwWw/FdAdYsCZ+bxvMDOCfUW3EIjwnKJt?=
 =?us-ascii?Q?RVS2nrlHMloiCZzGPYAa2ORbARWr/EaRBTUd9JNFcGRDy2qHKX8loj4IAhgd?=
 =?us-ascii?Q?gDzsSDy4+d81FDOf/GSNtVquiL6Ygtld3rOefUQ8IdHBChg6sK8JHzxGTJgm?=
 =?us-ascii?Q?i4s4/xJJMfIVC5K8Xw3gexzjCjuCjapJQYI/uAX3nbcsnp+B5kSRWHCco3w3?=
 =?us-ascii?Q?jfFqRwiGZP/3smra+9zRivLouccQ0TV9gCpRTj9J25byzLTQgzcepJHJagzA?=
 =?us-ascii?Q?mqWt+SYk0eSFjnWeHD747LyF5d4CW5AMx0fJ6IZTIhxlSiWPKo+5X9jB7b0g?=
 =?us-ascii?Q?lVr4dWJddJXpnQvDw6MTgXZLRuFUv6n+Pj71HNROsrSMIkTJfAEFBSwP10Ca?=
 =?us-ascii?Q?dOk4MCAGAzsSHGUqw11ptUBqylf+/29nyVBqwRn3ihJ31UUb+ohE9iWZ4r1x?=
 =?us-ascii?Q?7aH2dVA+2dn2OwvPtUQkEob2XNZmxTosftCwylo8OsAZrNarBq34dQ0OVFJC?=
 =?us-ascii?Q?9TFjKKv1FwURNbsSfAvgf50NR1cJPdxEZMTC1uAIe314SMTwUVqFxXj83XIy?=
 =?us-ascii?Q?uAJq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb53c66-fb7b-4a57-94fb-08d8b4db2134
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:14:10.7871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8euVf79BlGS6rvGZCtLDknXZ5/NhRi7GjebyP34cSbb9SyJASKB9edWBwdG2QzejrRwJmcVpMtZgeYenY/mYwlK0H+tPXKJcZe7Oed+iKOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4871
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/9/21 02:48, Christoph Hellwig wrote:=0A=
> Only a single caller can end up in bdev_read_only, so move the check=0A=
> there.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Ming Lei <ming.lei@redhat.com>=0A=
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
