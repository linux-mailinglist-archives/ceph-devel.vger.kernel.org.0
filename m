Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72C2D2B41
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 13:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgLHMmV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 07:42:21 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31425 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbgLHMmU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 07:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607431339; x=1638967339;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SDDjCz3Q8d02dyHddQcPwAJHGuEVHRu6FkZnyJU4bwI=;
  b=QuaPRpXIXnOBKfyP3LAtyRXR2EoQNltn/ojxJESbc1G051GpMP1ZJhPR
   WpExfTOMxBSGPUpIFV7OaTht7K1PY0bEbKWa1/bufYVgrGOwqSQOiFbVP
   VZ805dEF9F3YEpSR65RexNOcQYqUR4xpqf625ekFS9eLIghQM/sBZS9ik
   J9yKZe1Fh78oIkuLrx/gdnsmhlKiwCOePO4jyHTafxdrkUu5C5ieFfNkh
   IZiFnFF1kvCK9Ew5CyCBjmnUGtccFowtlBL0fwKOZg669vaDSaQT0/Sxn
   V9WnQ0LchjT8mUMj4PJ6pdZ8zjPmrZKggSoB1QowcOvuym5sPq3SLHXxs
   Q==;
IronPort-SDR: mjitjmbcx3V/XXhRIGPD3YtoFwPa5sHZM5lfwa8siKK1Iwf6f1dolPd7b2Wa185lm1GTlSnYXh
 HCDNwDjG9xQnqQQafntoMA5T3pw8cHV+kPKO2t2F82znSrIipMfcsQdc/agZcdETh/vvBkAOpH
 5tqQpgViQkSXpip6PeNLH4jq1Gdr6oGXT1mGOkn5y167+bjy+BKvHr7KPwoM3Bz6MRLwqTbwIV
 rzgx9eMFi5NJfSjWzKUT8DSqdO1ORLSNkAyAOE228bkBBNbAR2ZTQ3HvitkdkMOT3oRroE+7/l
 ZdE=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="264839600"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 20:41:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P94Mf/QiOb2SGLjYzKDfiTSYFw3MMwSEvWpKhPwG6n3G28DcwR4PwSm2VnyLLmYa5Va4kR2Xsh8GMQDrdd5MsQySXhigY/1NC6B6eDolWefPZRrHd3dHHhol/Oiv60x4izOf+1XtbAfQ5kx5j5FpCyrI8NtVxKd2Z7jq8bmDmdck6tiXFwnEG8VcBWZzLifbArAUPorbJJWhGBxMWaLuKJAoalkmyenusmF19wDbpuS9p4EbImGPXe8Mwiby8+jxJcKJfOYRZJ1hSzuyTlF1Ju6GupBG2/UvMnzueYB/vMtDUBbsWUzmXRLETyxY/hTEdFwjdx1G9ka7XC8dUhGXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF0EUjK6uJjlTJ7TVtmXWsZavGryq7rxrytfpULhXCY=;
 b=cadH5Eshe5YvvOTkO9XRsUe00lnpDcKfGltxpDG+QWseFwCc+WuAbhGsG+O0YLtF6XFKRr6CDka9Ws10bdbTsYTQ8F7oRAvPAUMmoitEXN7fuJSEdrvYyRvLjvrWUIN7++8W76+s6lzkyFm4l+RQWyz6nWWuQ57fFQUuFoyCbGQ49WALwpOtAgtIFS1WggIT+9pWdUnJs3NuXgdCW6QExb78C8cH8BNgxb8s6OfmMx4eGWankc51d9zhLFnFWQljXqjSxeQbg0b3640U/vinpFMZSP69R+Kfidv2gbAEBXojiORCH64Fj8j/TgrUosJYEtx6EzdDKQtYVUxqmhTGrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF0EUjK6uJjlTJ7TVtmXWsZavGryq7rxrytfpULhXCY=;
 b=CRIRGAX3H7OIlk9DIXdiiVa2ro4MXK/5ux3H7pzO3xOkXNUTrup7E24IntOKXekDVnQ96rzyu/WH3NaUAjl6iNGeyfF3uJePavnuaTK2FuOkk8Xj6W1AFaZIIrOksa2GKeow2t4mCeQ+s8D/UdXQts7Vabes46GyOFJIup3DtDg=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4688.namprd04.prod.outlook.com
 (2603:10b6:805:ab::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 12:41:13 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038; Tue, 8 Dec 2020
 12:41:13 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
 partitions
Thread-Topic: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
 partitions
Thread-Index: AQHWzJwqypaea6Vyp0+8epdHcF8jHA==
Date:   Tue, 8 Dec 2020 12:41:12 +0000
Message-ID: <SN4PR0401MB35980E0D76B523779FA25E379BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-5-hch@lst.de> <yq1y2i8x42d.fsf@ca-mkp.ca.oracle.com>
 <20201208092545.GA13901@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c17cdc9c-941b-42dc-7682-08d89b768c01
x-ms-traffictypediagnostic: SN6PR04MB4688:
x-microsoft-antispam-prvs: <SN6PR04MB46889091982F32F8BCC9221B9BCD0@SN6PR04MB4688.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sl1nd1RqO+u4dwevOYOXgPucUsisq5LU+zWfuZVF9NDLbSxxnHN7MbtJE46SOc1toidLcyZMJ1zdyBzNjlGdFL7V6Dov3296TSIkK/bsl44xVfuE9LJkQ3V2KTQ5XGq6LkA9oRNaN0wQwdk7HdirpAKSQoUR1vkmblhkix7kURuKgjXqaJf1SxksszuR7ss99KJAVCMZ9uK3noZNFFcnWcGQXDJgnC8lEExO4gCsEATyO/fhGfCo/sOkUVUM25MwyPYY8wRpgiJ7cT3P0RjK77UxsvqhgmB3zCfX9DeTobbDhpj2YWrPwLa+YEOEe1iq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(186003)(6506007)(53546011)(5660300002)(66556008)(7416002)(54906003)(4326008)(110136005)(26005)(86362001)(8936002)(66446008)(91956017)(66946007)(66476007)(64756008)(71200400001)(76116006)(7696005)(2906002)(52536014)(508600001)(8676002)(9686003)(55016002)(33656002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jw3ecY5btQkRWBUVLOfRe4sY45sdRPxGSBJ9sCyp9LS/iJZ4bBHsRZYIIpfI?=
 =?us-ascii?Q?m+xmlWd5NhCaw/qgkzEXSP/RaQnyL3BqZnrqq7kdY97bYC/O3fQKOJ6wnpwK?=
 =?us-ascii?Q?uSdjNSnTnjTjiwRt8becBZpDG7aQ7yqD9Uo6eplpHOWQuXzLgrAq76Nnz4GD?=
 =?us-ascii?Q?1ahxxKB7tqqv9tsbj/zbvMdQGODUZG7lPKon6b2rdVGBYJ16SIyzV2NN7w3W?=
 =?us-ascii?Q?Ol72SEYgSxszty9vr4M2m24Mzorfbla88PzcLTq2a08XK68Cng9GmjDPa1xv?=
 =?us-ascii?Q?/Qpkag3COYkNUZrnysjEGy24l5PCpsujPayP+Zq8Ar079yMMy6hSBTyUvG0k?=
 =?us-ascii?Q?3JdoBjH4cFBOhdPfjuzKxCEZTQ/b7QPw4/cj8CBT7QY44alZXvcOZ/Ju3YyW?=
 =?us-ascii?Q?YpE0c09tmT22Y50Oakj0QbIjM1yEaEicJ0P8Z9kMrGmO4HDmPtf+rHfb8ljk?=
 =?us-ascii?Q?w8VE5ybHh+Fv0m16lOVTMkfqt6WLUlleiLmAJVdSjlS9ZhGtP1LQ4dcS310F?=
 =?us-ascii?Q?vEDUyZhyvDSJuOD20K7S8+4gyF7n4VW1B6EXd9f4NyImMUThTcRgTIYXf/Wo?=
 =?us-ascii?Q?R8jMWnzvLxbLLO/MOyfLPPJDLgJxA3EXEtgD6d853uIEvPCnogRagnjVw7mC?=
 =?us-ascii?Q?3npbCsxM7duReOFViV11Etw5xOD8l6V7kxU6PJhQz1gLkC4ZQdH4/UnGhfvK?=
 =?us-ascii?Q?fP5bEEy3vglh4JLRcr6zCHPdWnOHgCU8S3PHKs3Ibn4HQn4nLG4mODAYrIFG?=
 =?us-ascii?Q?Jp0dYkrAvXiT3NY1hw1/8PzOsoTJxcdEVAMPykPolFhgNxXeNwl7V3Sy32CH?=
 =?us-ascii?Q?HYxhozrDYnKFkXZmEEai8xFtiKAFSdFeD++QYv/Nf9ITEF3qX60PfDm1bi0M?=
 =?us-ascii?Q?jYiwXljswgyFEMIFkAITJgI3eNwjdWA2OlQ3L6uLrUPh6SGY7/zZeMbp3ZU6?=
 =?us-ascii?Q?IUbbBaMHhwW1/P4lsLfI2QkXYCYvvr3pm2djwbm3hvtPpdJbcVVXT1vXdog8?=
 =?us-ascii?Q?Ynmh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17cdc9c-941b-42dc-7682-08d89b768c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 12:41:12.9168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7XJCytn1pku3szi0/+ynqgTLy+5dkysgKKkDl1J9xh6QOz6rN9WVxvn1jYWUKUCZUejZVFw78KLr/yUXYwkKqdAzXlrrzlI/VkZ4MUnRFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4688
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 08/12/2020 10:28, Christoph Hellwig wrote:=0A=
> On Tue, Dec 08, 2020 at 12:27:41AM -0500, Martin K. Petersen wrote:=0A=
>>=0A=
>> Christoph,=0A=
>>=0A=
>>> The existing behavior is inconsistent in the sense that doing:=0A=
>>>=0A=
>>> permits writes. But:=0A=
>>>=0A=
>>> <something triggers revalidate>=0A=
>>>=0A=
>>> doesn't.=0A=
>>>=0A=
>>> And a subsequent:=0A=
>>=0A=
>> Looks like the command line pieces got zapped from the commit=0A=
>> description.=0A=
> =0A=
> Yeah.  It seems like git commit just removed them after I pasted them,=0A=
> weird.=0A=
> =0A=
=0A=
Might be because of a leading #, happened to me as well in the past. Just=
=0A=
add a single space on the start of the line and git commit is happy.=0A=
