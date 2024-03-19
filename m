Return-Path: <ceph-devel+bounces-983-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872AA87F8CE
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 09:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE556B22357
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 08:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500E353804;
	Tue, 19 Mar 2024 08:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="tMRkBeqJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11021007.outbound.protection.outlook.com [52.101.128.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA9C537E4
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 08:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835364; cv=fail; b=gDsh+307dNxcAPXMtmeLgCWqXfqFflH7YbRm7TLxbXp5Ru8F47moq0Ti8jLzwaZJJSWC79BQ6WPFh42iCWvMJVreL57kV+vv+pu3kG47UB8J+3qFBTehzWVpYWAVKc2Jg+W1PHylumXfnZbyTWPj3G7EJqsWHyXWGLoJmT51eoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835364; c=relaxed/simple;
	bh=uzUAmkESa80NMB2yF6KJJEbQIrTOc6Ywl1dR2lJqaNU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iMrITcCBj26oCYnH74UQedmgARy78+XJ72M7gnmXDLjIU6XEgQU9FtunwMkzmvOylIa00Oq6LgJ3AkDyQx9WjjmT6yfa6chc5ayuhxLcgKnhOTlbzz143SqA+fiAHLr6/X4E4Um4seMpYVpkpFQXgWtxNcyBuoELTkUr1QdGi94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=tMRkBeqJ; arc=fail smtp.client-ip=52.101.128.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpKaTA1c9+pGi2wFUI1jAkSvtov6B+oWO6h7IZ4dMHcBLHdL1Vz78qvvEMDhvtRS9iADioeADgjkkFodPjQ8jD6quZYdRUKGLfyfAQ37nt8c+bPB37Pp7Y0g7boANF6NLiQgP6UE0TdmUQ8kRXh4XZIbTvNDqWNlmb1TEpARBJzOmJ2HXmc7b7tIZ4H5PndCYrqAWyMJyBrMxpPJguS+H1383MDprSEP9Gb5i7TxJiuvIuY/Rv9ayGWiW4mFxGCmBTL4u5oTLAhpS7kvCstnqzc6OtBukZn1IrXB/YZlg5P1CA4uUWw3h1xpMoMhv30y0Bs0HQea0HCVgLMpekQx8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnsXhhKAlfsnN799bWoONAbQM1VwQMW+conGbkwdVj4=;
 b=ApH3CyZY93pn0VFzCaAtskdxq61XzE/lulwQ86nag3v/Abjs5PaPCJTBDAUcav+0Vu0wmaE34pA92Owx1RwowIo7fSnX+AxPORTI1oVkPilqj2QZXZ6vDh/r4ISV2TMeZmvRjZMM4UIMvR9gj5RtrFfaL5hI6wCkR5jJIGcVBsYtasmjeKXmIMICwHO8q/arRIlGDMXdkRTu4XAd8HPogzV0dTnC8Hi2txx6w+ZpmkgLroOvosyykvRwZ7qkveD6gM4HaZJGd7ATl9wfqlsOGuxDdEnI4JKRm7QE0RBUpErhFa3l7ODrKe/yi7m8eFPBLOjVIVhQ1eYQLDnDkZcClg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnsXhhKAlfsnN799bWoONAbQM1VwQMW+conGbkwdVj4=;
 b=tMRkBeqJq/eKy2ItwXgg8IipJdS8icdu+d6NkFBYBQ89h/rjfUunbAY8Ws8yz1Rnw3u3BkFpkxjZ0srFaVPf2+kX7cu87kOaHbapfkbcLE99KkAqjVcBuZzTX+futFTlt0wbl9jvCj+pU3z6+yTbWkDZfp6KcRPnQvOgB7A68eEwY+fxxuq3VDQPUXm59G4WiYxqatxI0v+tGDKaqmHcg+w0CpK2MT8lzriEaENqyXEwb97kzVJQbZKG0m6Vb7XsIuUJKjRZL3OCxAHAzLrkVHdc0VTb8whttb6lzaxW+fVueZxDaKb+udmQibn3KMxUMdYaqOCiaz0brxVh7cV5Ag==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by SEYPR04MB7400.apcprd04.prod.outlook.com (2603:1096:101:1b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.23; Tue, 19 Mar
 2024 08:02:36 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0%4]) with mapi id 15.20.7386.025; Tue, 19 Mar 2024
 08:02:36 +0000
From: =?iso-2022-jp?B?RnJhbmsgSHNpYW8gGyRCaStLIUBrGyhC?= <frankhsiao@qnap.com>
To: "xiubli@redhat.com" <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"idryomov@gmail.com" <idryomov@gmail.com>
Subject:
 =?iso-2022-jp?B?GyRCMnNKJBsoQjogW1BBVENIIHYzIDIvMl0gY2VwaDogc2V0IHRoZSBj?=
 =?iso-2022-jp?B?b3JyZWN0IG1hc2sgZm9yIGdldGF0dHIgcmVxZXVzdCBmb3IgcmVhZA==?=
Thread-Topic: [PATCH v3 2/2] ceph: set the correct mask for getattr reqeust
 for read
Thread-Index: AQHaeZTuYuFNXjBs5UCeognteGrdDLE+tFnF
Date: Tue, 19 Mar 2024 08:02:36 +0000
Message-ID:
 <SEZPR04MB69726C80F867BBBD2DFD21A2B72C2@SEZPR04MB6972.apcprd04.prod.outlook.com>
References: <20240319002925.1228063-1-xiubli@redhat.com>
 <20240319002925.1228063-3-xiubli@redhat.com>
In-Reply-To: <20240319002925.1228063-3-xiubli@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|SEYPR04MB7400:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zh+dIp52IjMlsFMB5eMELGuaCz45LdOlk8xziSzQKkwxMx7yjABo3c0sG5dSEWARZonhuKH4fxbHUVKQILQCGrl8f8QQFLvHENkXKY7/l645LFnRGXTzFx4WPQv98i3nElKVSQtirUv52VWw+p9BdY1FeJm1MxfZ0tMwJU4eAfv3UGURBm+WhAsC7XvjW23KejOlwMP/uxcqAywJlevh8dbCpZBjF0+RmdfElA1ujVgLJ+6Uo2kUSeESNv8OofS+F56yE68nHQ4b9dQiJc/M3EDahqogjLpL6ElOqqLislcY1DQsTAspcc6Iv7/tFxUOdgqmTPm/YyZ117PtpC+RhAAWBSa1fByYo5EkT7WRyAnx1Qye1EyVaMJeKRi+blrul4OgU1tQgbGoDYrgJPsG9eM0Cs2MqSh71YF+MChvLzKow9+oWDH+kUEIeWgYj6QYyepfn7Nn80ps5vuFqpZ0HGecS8xuzLZouf6VngmIstkEdFzWaBy/iYwaZk6sqoFVpI0LUM9bpX3INC7fMSriemPHMMxoF0b0MJoQC8qE3e5o7jNKmQ1h2E09l3oZk6Zuk55qN1+UKEuZ+BJviacr9gQrffl/CvwURCoDmJVkx9M=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?QW1aQjBWVk5aWmNGTXJHUzFCdjRFd0haMHMrVWZibnpZaGw4QUpjdEE3?=
 =?iso-2022-jp?B?NGg3V2gyYjU3VEZCOExLODE0emM2ZGFiNmQ4TkRKQ2JsTERQR3h5WjRG?=
 =?iso-2022-jp?B?UkZmOVNvVy9kU0FIZXRRZGhvM0ZBU3hMbTc5SHdGcnNKbnBYSFRzOXpG?=
 =?iso-2022-jp?B?RDNWaFN2YVkrUmdLam9TblM5b3kwUnlCdDg0VEY1RGRuUlEwZmN3a2pu?=
 =?iso-2022-jp?B?cldYb0ZzcGljKzRGYVc2ZWxWOEZaejJrS2hESDZCRUNpOFc2TmhsWVND?=
 =?iso-2022-jp?B?UUR5b0tGUGVnSnIxeXdTYzBvM0U0VzdWQUlFWUxLdnVqbGwwMy96WWhZ?=
 =?iso-2022-jp?B?WUFTOW8yeC9IekZGYXl0akNpSk0wcnpRV0VuclJJV3ZTdVAwcVdQNmEw?=
 =?iso-2022-jp?B?WS9ZcmpaWm1oN0NaWTFzck5sKzF4aGlWU1pSckpoYU45VklUcHA3b3dY?=
 =?iso-2022-jp?B?SE5lYXBZY2hwWWgxU004V041TEtVTXdOc0lBSWwremltWW9ZY0xSeU9I?=
 =?iso-2022-jp?B?SitNZWtINGxnU2lEK21CUldHNkM0TFBhMzBOWHE0YU5xcHVTYmZma3pk?=
 =?iso-2022-jp?B?dm13MFBlSUxXRTk1eERsWHU4eGpQUE41MG5LaU9XQkcvRzFvS2ZOdk53?=
 =?iso-2022-jp?B?L1lNSzJwTmtWWmg3dDFCdE91TU55ZThkaUN5K3lXSkd5K2w1SndaMTRD?=
 =?iso-2022-jp?B?UVlobi84OVdPRkRWTjFQTFQvK2s4bzJJRy9MQy9HNWNVTXdHUUsrbjI3?=
 =?iso-2022-jp?B?SXh0UDhtUVNGUzhrWTdIdVlVWGxla0pVTlJuY1hhaGlERVZNd2FYeHpZ?=
 =?iso-2022-jp?B?SDRuU2RyQVhmcnhKY1BZZWh3UWE2aWIwMVhXaUpnUnZnaWI3R09pbXJ3?=
 =?iso-2022-jp?B?NDd4Tyt4aHQwYjVuMDVNamZINGtPYTgyK2ZQZDl6SCt5M2lFZjNvKzNW?=
 =?iso-2022-jp?B?K09WajUzZURSaDZHRzYxbGNab3R6ckNKbytIQlBWVmZjZko2SWVVWDBG?=
 =?iso-2022-jp?B?VWlXTkdMMmxTc05qRW1jYXhLZXhlSGtLNWJZY2VGQWlPVHRYd1ZmU3BH?=
 =?iso-2022-jp?B?dFB0QmdmRTRKb2l4THFYby9UUzB0VVFVU1N1Unl4YkEvNHMxREdKM1JV?=
 =?iso-2022-jp?B?VytPek9GNWZyMEtUaVhMay9DVTM3Q0d1RngwTjUrY0svcG56SHg2RVM5?=
 =?iso-2022-jp?B?RTIrb1RLWWZNVzdYK09wSjBZV0kwUEZDRFVpTGZzZ0hiRnhLVkZlTGoy?=
 =?iso-2022-jp?B?MkgxbGlnTEhHcnlsT3ppRllFa3Y2Znpnaml6SzQ2RFh6bjlyR0tHZXpz?=
 =?iso-2022-jp?B?TWdWV050WVd4cHBmUHlJQndjeXNEUVB2YUhudFlPblFTMXZsYi9jb0k2?=
 =?iso-2022-jp?B?NklTZkhZWnJBUkp3V0lpSkc4ci9FUXpOTTFZMGZFcDk0UUliMTVzUk51?=
 =?iso-2022-jp?B?ejlnM0R5aWhFeGJueDZiMGhFSm9CaW1nQ1Rwd1FxUW9Uck5wU0xPSTIz?=
 =?iso-2022-jp?B?MG5EUm1WUGlsdUNKeW9qZlpBak52OGpoQWJ5ZmpDNk0xV0dSOFRMZEYw?=
 =?iso-2022-jp?B?YjhLSGI4QzV0V09WODFmS0hXcmZ4YS8xVE5GaEtUVWhVbUtRRE96OWg3?=
 =?iso-2022-jp?B?Q2VxYS83cVRKWC9HZkZZWEcxSE9kUmV4bnVkU3Y1VGdsZWo2aERLbndU?=
 =?iso-2022-jp?B?V3VaUnFxemtpY2l4U2lzVzkxUzJiUDRjcThUV2dFZHhZaElYVlBYcEd2?=
 =?iso-2022-jp?B?blYxTS9UWjAzR1JPS0tJSEJUTGRnWmt6diswaWxOZDNYOWRTQzZKLy9T?=
 =?iso-2022-jp?B?aVpSWkYwSmNuMEljaTg5SCsxVmQxMWluREhLSmozTjdlRXV6U1p4Nzd1?=
 =?iso-2022-jp?B?N2tVRDltVGUwSGYwY09Yc2x0NmRzUE9TQ09wZ1V1ZzAwdHY5R0E1M205?=
 =?iso-2022-jp?B?WTZBaDFvVU95MEhJMFMvc1NNakxNNUw4R1l2YkxnQVFrZkN5ZktBOVNJ?=
 =?iso-2022-jp?B?dWdqZHJrb0s2Sjl4dHhEOWpQN2wyUFNuMmo3eWNTZXgzb0V4dEZoQkVz?=
 =?iso-2022-jp?B?VEFjbHBSZlozY1RqMzl4eEJMeEp4WDhVY20rWHpSWXo0YnYzdFhqYjZn?=
 =?iso-2022-jp?B?WTdaZnMxZlpVeC84VSszRFF6UU1zWk1vaHRqY1dYNlBqRTRXYmJpRXg1?=
 =?iso-2022-jp?B?ZWVCOHJxN1dObjNnNUE4VElZK3Fud3ZzbVJRS0QxajRlZkpFVmJUMGZi?=
 =?iso-2022-jp?B?eFZ4MFNCSHV3eEJ0VFdmNkV1elA0OTBvcz0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6972.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca85afc-2d84-456f-6ae4-08dc47eaf091
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 08:02:36.3368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7eHgCilzkDaKKMQ22oki/9RxgIGZ2r8xnkicEs+Yqais3Iq4EbYgzBXxC2BVBKRNWNzRZXHpHopUd5UUjoxWTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR04MB7400

Reviewed-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
Tested-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>

________________________________________
=1B$B4s7o<T=1B(B: xiubli@redhat.com <xiubli@redhat.com>
=1B$B4s7oF|4|=1B(B: 2024=1B$BG/=1B(B3=1B$B7n=1B(B19=1B$BF|=1B(B =1B$B>e8a=
=1B(B 08:29
=1B$BZ@7o<T=1B(B: ceph-devel@vger.kernel.org
=1B$BI{K\=1B(B: idryomov@gmail.com; jlayton@kernel.org; vshankar@redhat.com=
; mchangir@redhat.com; Frank Hsiao =1B$Bi+K!@k=1B(B; Xiubo Li
=1B$B<g;]=1B(B: [PATCH v3 2/2] ceph: set the correct mask for getattr reqeu=
st for read

From: Xiubo Li <xiubli@redhat.com>

In case of hitting the file EOF the ceph_read_iter() needs to
retrieve the file size from MDS, and the Fr caps is not a neccessary.

URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=3D819323
Reported-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Tested-by: Frank Hsiao =1B$Bi+K!@k=1B(B <frankhsiao@qnap.com>
---
 fs/ceph/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c35878427985..a85f95c941fc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2191,14 +2191,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, s=
truct iov_iter *to)
                int statret;
                struct page *page =3D NULL;
                loff_t i_size;
+               int mask =3D CEPH_STAT_CAP_SIZE;
                if (retry_op =3D=3D READ_INLINE) {
                        page =3D __page_cache_alloc(GFP_KERNEL);
                        if (!page)
                                return -ENOMEM;
                }

-               statret =3D __ceph_do_getattr(inode, page,
-                                           CEPH_STAT_CAP_INLINE_DATA, !!pa=
ge);
+               if (retry_op =3D=3D READ_INLINE)
+                       mask =3D CEPH_STAT_CAP_INLINE_DATA;
+               statret =3D __ceph_do_getattr(inode, page, mask, !!page);
                if (statret < 0) {
                        if (page)
                                __free_page(page);
@@ -2239,7 +2241,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, str=
uct iov_iter *to)
                /* hit EOF or hole? */
                if (retry_op =3D=3D CHECK_EOF && iocb->ki_pos < i_size &&
                    ret < len) {
-                       doutc(cl, "hit hole, ppos %lld < size %lld, reading=
 more\n",
+                       doutc(cl, "may hit hole, ppos %lld < size %lld, rea=
ding more\n",
                              iocb->ki_pos, i_size);

                        read +=3D ret;
--
2.43.0


