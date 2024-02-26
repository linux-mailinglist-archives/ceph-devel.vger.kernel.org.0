Return-Path: <ceph-devel+bounces-903-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDB18668D6
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 04:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9206281809
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 03:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4726617BCB;
	Mon, 26 Feb 2024 03:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="CbS5PU7G"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2099.outbound.protection.outlook.com [40.107.215.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2507DF44
	for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 03:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708919173; cv=fail; b=u/kVnnZE8UbPdmKSWyjrPo91kkCOFp/rSB2rHNsD2JCCpftSeURp8CLCVl0fRSr6c4Xin8su2Ie04MExRV1R9Dw2uqmXQWHM944MEZl/IUe3QDdalsGNpF71DUfj8ox7IF8ZKoQV4TdfWCOyG57p61mlGFQhxS4pd0e0PIPDViE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708919173; c=relaxed/simple;
	bh=EFVTGi8lSZonEXpVpLR3/134baqTTMUCX8YyYcfxkRk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DUmimnar6qFZiZs5zYLtAUVxDGB5stgijwWMR2cs7HPWwRsWBEZArxdyrnlCS5l6aNZsAOb2gN5TbdAog/Sxm7uhVp9fZbmsGGd89mAYsnxSoq5WOqYP1KSbvfC0XOijw7SfRkOe8oFk6hE1nVer87bWUz0UVtIGJVZSIk3quYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=CbS5PU7G; arc=fail smtp.client-ip=40.107.215.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjuouPF+W8yI8Gn5UzDWHAjE+WkTJAZQkyPsL82Tr1Wnh8OYfknnhy5NXWnQbR+z/yqwd9xBKHRKrJyZ8iaKEBevihtIUvac9YSixa3tfnO9sWWu5wG6KyGxbCVRZSePZW494I+icRFdiTtNggBStKl3JrVr7G5PPrxb3j6eUb9HLfTUEHAVewYZyGG0jkOGdWp66Dp2aex8SCbhxNQIqV2V2sTkzWk4wSa32nmuc3bLY/kOlF+L3MGKqW1vQ3dDeDRVAsoO1TdRMFM/fTCcS8d6zVT6YAXhFKZueldqaX9Tjb7NPUjsFmvqsfrmSqJAOa6T2szcfaHKKqDl8fyiqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFVTGi8lSZonEXpVpLR3/134baqTTMUCX8YyYcfxkRk=;
 b=QjY/epa6VgDrN9/pv7NWdn3uNp/1CnwNiu+GFNSL5mmMRK02g80sUoRBlGj7EwLg5zDEuC+gMDPGwGK4vh7qKriKEix1Z/ONdg/WFS39qVrhq+7b5dva6IbWFxulBUqkypvkpWkFZcxqS7yEOjz4ShhWDW0xfN+nVpxhvOmMKypvgI273hkHPf1Mcx74559NiFMhHS12p6s/sWgnhwyeEKRASors387NJUVtc+ipilkZwSIJIYpO6SEWCyylyiW8TJYFaGDiwl+DKoygad1nCbN4953jEI82ZOXJn2AayAfDYHBQi45WC6aqUqTdixt1nKF4Lr583GXerLhy7jrVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFVTGi8lSZonEXpVpLR3/134baqTTMUCX8YyYcfxkRk=;
 b=CbS5PU7GEEadrurHYIPp+0Eh8AM52+NqZv//0YHAfTPhluXtxtPyR4WJODQpFGj9aXBLYd6QuYtIZV5LFi0llY0mpbO/10dkj+Mcv/Y5w8kUKzd/bvZMrDkrla4ZG2xiGaXOGCaFTiB7XhJ49jNX5kcEOBypQSPliGNo/wp5vq2shIKgW73xFMTld1sdgwwSFYYG9qiTPQ0Qte6wDAlmtmBx3yooxYM3F1N3LjU3v5YX5pVfY9D9+hc5cumrlhHXZh8KmFAsEPz0jGoFi3R5GS8w/TLhTyAC8AXZVtR4tJ/vshKhhPA9C/rZMA5vxrwld+ddXErrS9A+qhtl7GS0+w==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by TYUPR04MB6743.apcprd04.prod.outlook.com (2603:1096:400:352::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 03:46:08 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0%4]) with mapi id 15.20.7316.023; Mon, 26 Feb 2024
 03:46:08 +0000
From: =?big5?B?RnJhbmsgSHNpYW8gv72qa6vF?= <frankhsiao@qnap.com>
To: "xiubli@redhat.com" <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject:
 =?big5?B?pl7C0DogW1BBVENIIHYyIDIvMl0gY2VwaDogc2V0IHRoZSBjb3JyZWN0IG1hc2sg?=
 =?big5?Q?for_getattr_reqeust_for_read?=
Thread-Topic: [PATCH v2 2/2] ceph: set the correct mask for getattr reqeust
 for read
Thread-Index: AQHaZZIIADxuD1eM+0u3So2PS9R36LEcAXgP
Date: Mon, 26 Feb 2024 03:46:08 +0000
Message-ID:
 <SEZPR04MB6972A30D49DE51C3E898E88EB75A2@SEZPR04MB6972.apcprd04.prod.outlook.com>
References: <20240222131900.179717-1-xiubli@redhat.com>
 <20240222131900.179717-3-xiubli@redhat.com>
In-Reply-To: <20240222131900.179717-3-xiubli@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|TYUPR04MB6743:EE_
x-ms-office365-filtering-correlation-id: 9d17a5a3-f4f9-42d6-52d9-08dc367d77c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 uiJVwgz3bDIbxWdZSt3ZspySzfeE/rA5j0Ldi2tTQCchtqH8Z9OLEX7/gqv/VLB15trTDyDx2mdFIY4zPoAgNBQMbC/wnetJFSvGYTDWtxro4ks836tdRDGW8epUOF8Yk+Z+uyn+gnq4R9hqp95HD/eVEAcurO5rZ7Jfiy2NmvGj4ayEWN8wExUkiJS9rbUCfZW/koHDnEV1DQJMTht99tW1BUoD/FgUUFN0WZI6C8GLhXb+Kh3qhdT8qlhfDdpfGJAi1CW9HMILO6i1hy9d8O4qmwtPAUWNDVlut8m2uS8WjdUKFSy5eVp3Bi73dvVD6jFxdocrgh6iFH3WnBoX0IM/yPD5+Guhr1+c5aSGd06bOZU70dYImpQVtrSKVwcrcU/ZeZyzwXP0spUDvKpkjcOvQcCJ1iopRGJhGbi6sQkO1gFTJYsSwqA+oYkfVIxWesQdNUmBrosq/hAy5BkCINCO+LMLyQe7Sba0aSK23vF9GspFVnxcLatOEfHqnq+GZ5GdaXJ3agsxy1299Jo7j0JHpLQIxcVSB9dTHzvo+GFnsN2QlAFC6jMB0OLzhNTB/xtnKbggUbfn0CWdlvHUhn6a2N/hMquD5q+gyqfZY78SyxlP2sBsZLQVkOk7MvTs4u1Y5/wNpgo34deegmUoj7H0mTsH8ZXC2dG54Gp8mk0hPqVarSpIVC65GuIy/N+wlaak/yuQlLlNZ/FlgyCeQw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?big5?B?clNSdU50bzBsU2Y4dHJXSG1nSzZiK081QldheHBvZm8xZG91RE5QSHFEVVpQQ2RO?=
 =?big5?B?S05WWkJUVWZEd3Jsd0VLU2l3WDVIRTAwUExBeSt2ZFF0UEkwNk9UbG5jYXF1TS9P?=
 =?big5?B?SUgwY2ZDaTF5ZkJHNTJsK1hBY1BzaDFsOEU4VHRsK3I3SnhRK0dySjd0ZnVQUWpK?=
 =?big5?B?KzZ2RER6QXRkSXpLczBsQVFtU2lPZzIvcWtRYmkzMW1IVDdCVFY5NElDU0ZDLzFt?=
 =?big5?B?Y283NE13d2ZwMUYwM3cyRnVwSkNLRitkbytrUE1VYnJWdGcyM0dTSS9NN216ck5t?=
 =?big5?B?NVQvSHNlQW1KTEt2Ykk2Y1p5RGJFclh4Z3BpSTZ4UmM1c2FFVFBWZERqM2dYei8x?=
 =?big5?B?WTJJRHZwOTd0bW1VaTFvTEcyK3A0VUkzMnMyWmFzWWgzUUpReWNGMjRaaXNXVEl5?=
 =?big5?B?YnViSzdvYmhBbnRYNjRvMWw3TUpoUnhvbXZXdEVVejFJUzA4V0hKV2M1blR5bjJB?=
 =?big5?B?Z0lxMzRyTU9pMURWanZHNlFSN1ExbUpEMHAySU05Nk01VGxkeFUzRDBTMTN5MHd6?=
 =?big5?B?b25qQktBSndTcFFLR29xSnpvS0lkclMzTU14T3c2cW1qclVaczNycGl1RU45c3FS?=
 =?big5?B?dGFNVHRWT2NzVzdnS2pwV1NnS0hVOWZlRUkwMXV5NVRWa1ovZzlaQlBtR2x1bWF6?=
 =?big5?B?dDdqTm04MjF6UHpwNVprUTVaUDViY01naStkY0RYdFdBc28zeHRJUGxlMEVtRXZN?=
 =?big5?B?V25Lb1FNNnRQOGJmdzA2MmtkcTMrWlVOaEpCd3ZYZ2x1ekpUUzFvNUF5YjM3Z1Jr?=
 =?big5?B?Q2tFU3hCMEJ6YjRMZWJsaGFzeGlEVE5USFlvQk0rOGJnRHVmVFdPWUtVeEU1M1BQ?=
 =?big5?B?UXg2QXRjQ2U0M0paSVdyRUpSVXpSQU1kY3hWWE1HY1lsanRzdzNPMURtUUpZaTFF?=
 =?big5?B?dkVKWjE3UUxkRzhOY05LOVR5YW1DUGtSVTZDd09EYk9aUmJ6eFV0UWRyeU5QV2tL?=
 =?big5?B?ZU5RTzBkMWFOSWJSTUN3eEZISEgvS2R6TWxxNTUwOUVXMHZHOUFiS2pzY3ZFcll3?=
 =?big5?B?a1lPdFd1VkR0WWRrU29KK2xqMEgyT2N1ekV6c2NhdXBHeFQ0YnFSbEtFaVhSWFdV?=
 =?big5?B?TFRPK3dSMFdRdFRKS0pJdkQ0dG5semt1S2lZNUlNOFdoUkpldFl4ZzRUbUJQUHlr?=
 =?big5?B?VU1na21jQ2xjbFpqTk4yWmxEOHZadFd1QUx1eEs2VHFJTTBvWnVLMzFGckVNR3Az?=
 =?big5?B?V2RkV3NDOHFmRDVWVGNFOXZ6MXEybzJoV0ZCM3dUb2xWZW1oTjdleElNbDFTak1U?=
 =?big5?B?Vk40MXhWSk03Y21zMUlwc04xc3NOckh5WGJ5NVFwOXJzMlk5dVM0dTQ2Lzh3SEZo?=
 =?big5?B?UVhCaU51aE16ZDVNZVYzNDhuMDdmS2JaRmtsTUpHazFXb3Fiek0rYnNEM0p6Mkw1?=
 =?big5?B?NWNIaWM3L3JkclJJaWFQV2VOSll6Skg2SEJhU2hzeFlZYlR1bmhXeFBBRkN2UEtF?=
 =?big5?B?MjZpaytEYzUvRlZrSEx0ODJCMXlERWVxdnUzck04c1k3TGlDRDJMQm9DYWdLMDAw?=
 =?big5?B?M1NGNThoaW9JdGIzcklBZzQvMkZ2dUVyTGxaRHJOWUtUMXJiYlNLcmIvRHE0cGJl?=
 =?big5?B?cUdRMlpDZnYzYm5KNWYranM2eHJOSlhKL1IwWkw2dG9jTENNZXBCTG9td2NpRGR6?=
 =?big5?B?S2hHYzJnWC9ObHB4bW1sUUZ5YWFVMmxWOWRUVXZRWmN1UW5UNUVBNVZpVUtWc3lk?=
 =?big5?B?Tlhaa2xVNjdZTnZianc4K0RWQ0xqTThyYS83WGNiaEdzSUt6S0lvZ1JJNVpjMUph?=
 =?big5?B?M0QxR2FaYkFMT3lZYTU0V29tRjBqMkJEdjd3c1VSd2FxdU1LcHRKa3lKc3REckd6?=
 =?big5?B?MHRiZFllQXlsRVN2d002ZGU5MUxoTFZna1VRSFRaMHNHczNTZytySk9hcnlXMXlu?=
 =?big5?B?czRza1hQcnpQZlhXNzVyd3FvVG41dFl0dWNmMmFQNDZ3MjBCYkdyL2U1Z1hmTXhV?=
 =?big5?Q?qrTQ53DfjU76XKorzrpK8QwqmxF/6GecM+Zkp0/lxkw=3D?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: qnap.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SEZPR04MB6972.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d17a5a3-f4f9-42d6-52d9-08dc367d77c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2024 03:46:08.7140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4gtffmMsewL4LCh+9qAGolZumUKINqAfckeJDTCvA6ikT7FUn/XuloLOCF4WFB66vMuI7zeONePjtpQ/kk7bww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR04MB6743

VGVzdGVkLWJ5OiBGcmFuayBIc2lhbyC/vaprq8UgPGZyYW5raHNpYW9AcW5hcC5jb20+DQoNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCrFIpfOqzDogeGl1YmxpQHJl
ZGhhdC5jb20gPHhpdWJsaUByZWRoYXQuY29tPg0KsUil86TptME6IDIwMjSmfjKk6zIypOkgpFWk
yCAwOToxOQ0Kpqyl86rMOiBjZXBoLWRldmVsQHZnZXIua2VybmVsLm9yZw0KsMaluzogaWRyeW9t
b3ZAZ21haWwuY29tOyBqbGF5dG9uQGtlcm5lbC5vcmc7IHZzaGFua2FyQHJlZGhhdC5jb207IG1j
aGFuZ2lyQHJlZGhhdC5jb207IFhpdWJvIExpOyBGcmFuayBIc2lhbyC/vaprq8UNCqVEpq46IFtQ
QVRDSCB2MiAyLzJdIGNlcGg6IHNldCB0aGUgY29ycmVjdCBtYXNrIGZvciBnZXRhdHRyIHJlcWV1
c3QgZm9yIHJlYWQNCg0KRnJvbTogWGl1Ym8gTGkgPHhpdWJsaUByZWRoYXQuY29tPg0KDQpJbiBj
YXNlIG9mIGhpdHRpbmcgdGhlIGZpbGUgRU9GIHRoZSBjZXBoX3JlYWRfaXRlcigpIG5lZWRzIHRv
DQpyZXRyaWV2ZSB0aGUgZmlsZSBzaXplIGZyb20gTURTLCBhbmQgdGhlIEZyIGNhcHMgaXMgbm90
IGEgbmVjY2Vzc2FyeS4NCg0KVVJMOiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2pl
Y3QvY2VwaC1kZXZlbC9saXN0Lz9zZXJpZXM9ODE5MzIzDQpSZXBvcnRlZC1ieTogRnJhbmsgSHNp
YW8gv72qa6vFIDxmcmFua2hzaWFvQHFuYXAuY29tPg0KU2lnbmVkLW9mZi1ieTogWGl1Ym8gTGkg
PHhpdWJsaUByZWRoYXQuY29tPg0KLS0tDQogZnMvY2VwaC9maWxlLmMgfCA4ICsrKysrLS0tDQog
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KZGlmZiAt
LWdpdCBhL2ZzL2NlcGgvZmlsZS5jIGIvZnMvY2VwaC9maWxlLmMNCmluZGV4IDJiMmIwN2EwYTYx
Yi4uMDhjOTE4YWE0MDNlIDEwMDY0NA0KLS0tIGEvZnMvY2VwaC9maWxlLmMNCisrKyBiL2ZzL2Nl
cGgvZmlsZS5jDQpAQCAtMjE4MSwxNCArMjE4MSwxNiBAQCBzdGF0aWMgc3NpemVfdCBjZXBoX3Jl
YWRfaXRlcihzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqdG8pDQogICAgICAg
ICAgICAgICAgaW50IHN0YXRyZXQ7DQogICAgICAgICAgICAgICAgc3RydWN0IHBhZ2UgKnBhZ2Ug
PSBOVUxMOw0KICAgICAgICAgICAgICAgIGxvZmZfdCBpX3NpemU7DQorICAgICAgICAgICAgICAg
aW50IG1hc2sgPSBDRVBIX1NUQVRfQ0FQX1NJWkU7DQogICAgICAgICAgICAgICAgaWYgKHJldHJ5
X29wID09IFJFQURfSU5MSU5FKSB7DQogICAgICAgICAgICAgICAgICAgICAgICBwYWdlID0gX19w
YWdlX2NhY2hlX2FsbG9jKEdGUF9LRVJORUwpOw0KICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KCFwYWdlKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsN
CiAgICAgICAgICAgICAgICB9DQoNCi0gICAgICAgICAgICAgICBzdGF0cmV0ID0gX19jZXBoX2Rv
X2dldGF0dHIoaW5vZGUsIHBhZ2UsDQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIENFUEhfU1RBVF9DQVBfSU5MSU5FX0RBVEEsICEhcGFnZSk7DQorICAgICAgICAg
ICAgICAgaWYgKHJldHJ5X29wID09IFJFQURfSU5MSU5FKQ0KKyAgICAgICAgICAgICAgICAgICAg
ICAgbWFzayA9IENFUEhfU1RBVF9DQVBfSU5MSU5FX0RBVEE7DQorICAgICAgICAgICAgICAgc3Rh
dHJldCA9IF9fY2VwaF9kb19nZXRhdHRyKGlub2RlLCBwYWdlLCBtYXNrLCAhIXBhZ2UpOw0KICAg
ICAgICAgICAgICAgIGlmIChzdGF0cmV0IDwgMCkgew0KICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKHBhZ2UpDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fZnJlZV9wYWdlKHBh
Z2UpOw0KQEAgLTIyMjksNyArMjIzMSw3IEBAIHN0YXRpYyBzc2l6ZV90IGNlcGhfcmVhZF9pdGVy
KHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICp0bykNCiAgICAgICAgICAgICAg
ICAvKiBoaXQgRU9GIG9yIGhvbGU/ICovDQogICAgICAgICAgICAgICAgaWYgKHJldHJ5X29wID09
IENIRUNLX0VPRiAmJiBpb2NiLT5raV9wb3MgPCBpX3NpemUgJiYNCiAgICAgICAgICAgICAgICAg
ICAgcmV0IDwgbGVuKSB7DQotICAgICAgICAgICAgICAgICAgICAgICBkb3V0YyhjbCwgImhpdCBo
b2xlLCBwcG9zICVsbGQgPCBzaXplICVsbGQsIHJlYWRpbmcgbW9yZVxuIiwNCisgICAgICAgICAg
ICAgICAgICAgICAgIGRvdXRjKGNsLCAibWF5IGhpdCBob2xlLCBwcG9zICVsbGQgPCBzaXplICVs
bGQsIHJlYWRpbmcgbW9yZVxuIiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlvY2It
PmtpX3BvcywgaV9zaXplKTsNCg0KICAgICAgICAgICAgICAgICAgICAgICAgcmVhZCArPSByZXQ7
DQotLQ0KMi40My4wDQoNCg==

