Return-Path: <ceph-devel+bounces-902-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E138668D5
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 04:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAB7D28163D
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Feb 2024 03:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5A117BC5;
	Mon, 26 Feb 2024 03:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="D/y1rFtO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2122.outbound.protection.outlook.com [40.107.215.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC311B7E1
	for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 03:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708919158; cv=fail; b=G52R7Vn7aqTe20tTCwtKoYLp0ma+QWUuCWCd6qfXt7CAOwbeIOp6pKlSL5mwIzqc7Vo01jKBX3JNevUn4BI/TX3D7QJ7SLo1qnKWEviverm+IPY67ZWoFM3TS3bFFT7Nor2YsC3RbMsUmFfhlQ7CSG+os14WCNOr1liU9UKWDdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708919158; c=relaxed/simple;
	bh=pHijPo7EC4F+31H7gi8jbnyMoAiE51Q8jkyjCr4yinQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ad7WtDM8Ht3J397rfWWw6Jjk0/KwZeORNwC24UoQDkSMtlAHOXABU6V0oXGu3AZ7gT44ROzU5psali12qODTDJfyvy8MVWqoNG+8D0vvaIdblmOkPFVM8LdoGBMvon6ywbuLGDKKkSijQi/0C8iHm0UIq8VvjqjyWzhVNiMjVcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=D/y1rFtO; arc=fail smtp.client-ip=40.107.215.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me8mSkHNmsisT4yZFnLsNY31A85vYi8dUVh4bMkEHEgms/Z0ywB6vU0psD+L2umedph0HXJvDZKypxkq/R2LbGoWeUSZONYd9qmztJwIQ6b2E3FoVtQWK86pDGrMe12j8KEnYLS0ZAuElLsP9WgnpFVWTBCthtB+DXLIFJumCihqleL1m4QZxLBi1nB2/oJNgFIg60gu4vbDq3Kl1fHiq14LR2SN6e272ZJykDSORyptGCzJzys1y4/6blduQOcbsSYop/CesndPzlMlEGIJoUJTJgED+RWNAkjT8XvTIAja3jCHOs+dYkwtUDqVbFxNBYfbOv8iqJzoKU4WKI9tuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHijPo7EC4F+31H7gi8jbnyMoAiE51Q8jkyjCr4yinQ=;
 b=AuQvI+Rnyd8vWV5jfA+4MxxxckhR3zVfXYISbkkCtGvCA/zrhLb6vQzBBbEozFMRb+sV71Qjw/xDM5MHu3OEDNbrfdXc5QqpZv+AVjc4diENKr5v4A+kFudty7qzB/TniIFRyh06M6GsEoY1kBM8BYFM0/YnMlZtcyRPV8F3QBb/zt4I/UPCehCX5wq7xd0yXSRG4TOUqEXKuPpN5leUb1jMimu/0BXMWPf/pLAZGRUy+kQNNd6ttjrbdOvYQMyEXMMDpmuhfdLOhz8kyYZOTnnrQlUIQwA0/klep3AXBujfeUGm0wGUke3Bct300tZlzlarnvo+WMJWOaaiDgc30w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHijPo7EC4F+31H7gi8jbnyMoAiE51Q8jkyjCr4yinQ=;
 b=D/y1rFtOdgmY5OXRB2uzt2wjsiQE6yp1x2mS5xpaOM2KsKEyGz1VULhnJwAjU53qb3DjroVQ53d6pMqxMW9JSql49gcevsXWY75LJUp4U/69I2PeofdW2lQiYZfXcSZ3E/a/MZD+l6djTKfmN/r18dy3SNPyhhXA+p38DGbJztpL5faWizF1OoaA4Np1vrckEB44OwUT+IPvuK0clBLZhbyzB/7+zXy928AEywjDfQiYbIncb1jcFjoiVE4gMvyHijms5QsQCi9LFkl6flGOD2eMFtqDH1MDGn3if35p8UG63LZmOArWbepOCu22kgH+KqBwW7ZdaQ+DcYMO6DAyRA==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by TYUPR04MB6743.apcprd04.prod.outlook.com (2603:1096:400:352::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 03:45:51 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::4aff:c1d:f18b:5e0%4]) with mapi id 15.20.7316.023; Mon, 26 Feb 2024
 03:45:51 +0000
From: =?big5?B?RnJhbmsgSHNpYW8gv72qa6vF?= <frankhsiao@qnap.com>
To: "xiubli@redhat.com" <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject:
 =?big5?B?pl7C0DogW1BBVENIIHYyIDEvMl0gY2VwaDogc2tpcCBjb3B5aW5nIHRoZSBkYXRh?=
 =?big5?Q?_extends_the_file_EOF?=
Thread-Topic: [PATCH v2 1/2] ceph: skip copying the data extends the file EOF
Thread-Index: AQHaZZIF9yaN96YFq0e2GCNr/Yguw7EcASRQ
Date: Mon, 26 Feb 2024 03:45:51 +0000
Message-ID:
 <SEZPR04MB69729D8E7073F9C85D919A94B75A2@SEZPR04MB6972.apcprd04.prod.outlook.com>
References: <20240222131900.179717-1-xiubli@redhat.com>
 <20240222131900.179717-2-xiubli@redhat.com>
In-Reply-To: <20240222131900.179717-2-xiubli@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|TYUPR04MB6743:EE_
x-ms-office365-filtering-correlation-id: de651a5d-b1f7-48f5-f489-08dc367d6d44
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 CwoAuUckDRb548XMiGT1b5KZeyhxJUZ6htySW8K1wveEJVSot+7RPkauefqsc3QObewlJmbot0uYhRh9S9Vwt5IYIllSTqyX2Zcu5T+goJJ3bEyGrLhqm/lkbXt1LfUygIRoTPep8U+DrhTXL3BnbFJN5SPydl1XwvUO8GLQUUQ2qJjOyBrcJUtIbKSYckKwZ8Xa16UYIl7ZSBu5I7rqdpgONonk/Uuh7svkrPMDd4BRwQcivZk/kBM4KmkopCEsPLurpduCCZueTtBL6mSIMsh0Rr3L4RipaDUordWtrcF63x0GuANGPrWAcqwN4T3QVk/LAU6jKw+I8vGjG0TH3/n9Ni1hzDjmDEu4e7/q9DwjZI5fXT9OnLa3klanlDLqH0KoSwIXwQVzbT1z/qU42wpJPAJat0uPcqYsfZjcQWNF9ALSZYqQr3GTP7jhk4lMMs3qnT9cSKglKB+mEQA+V9Y7NQyn0tO/1KghWSg09BUyCEHNqqMu+GcDRdIyU5g0qFckOPN10vz6fnbXxrUCfKyvtGe4AynQiuYoeMvbaDsTbnGQ9QlGyAYlH/2RvkO+rp2vz4+BZvD8vKzTmOOAeUvYg+5LQNwutVPdxUBH2dyj5TDjbSvYl9ZduJMUAWHR66mhZEMWNQGNpfa9eO/+cYOMpyj0LoJI8c0DNAkHYRAlkdoBCQiKXZ3sqWZNfwE5
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?big5?B?c0pNeXdBL0pKSEdXTkZQSUwwRkRVREg0TDhxQ0N5YlVqZlJ5eTVNOG1PdThXZVl3?=
 =?big5?B?NnpQaFcvRitja2w5UGhVcDEzRWRVdVRQYm9YUnE3ZkNKMkxPaTV3VCtieHVWa2xr?=
 =?big5?B?UUdrTUt6aFVyTm1HVEpEUjg0Z2lQUHNwWVBlWWNXR05kVkNRTVM1RWFobEFqdWtM?=
 =?big5?B?RSszYm9QQ1BjdmplWVYwUnViSFpPK2FacWk1T3ZDQTMxbElBVWFZMWpFcmxMUnVB?=
 =?big5?B?aGg1SzVYa3ZsNXloblJ2cWVuczR4NHp4aHlWYWR4MkpqNkg2WG1PK1l6OFJwRjJq?=
 =?big5?B?QnprNTZoNklWSVFUTE13YjJDN1p3T3JuS2EyRSs4cnBPa2xvaTAxdUdjRHQxcFdv?=
 =?big5?B?QzE4Y3hJdWlvZ3VybXhBVXZZVmF6cHlWQmJBeHVMMVBuSnBBTVZGSXhFa0I5SC9o?=
 =?big5?B?RE5reUxreHIvenJEdlNLY081WlBOczJVWXZpdER0dGVzVXhPVHAvTDJoVjlFa1VK?=
 =?big5?B?RDJHZmdFWjY2dWpnSHBVK3NaVnYvVGNTbVlzRGZlVHpjaW82TUdqNStQN1UvT2d3?=
 =?big5?B?Q1NCVFlKN2Vxektld05WT0pQZnBJY2RoKzZpT1lCZG90K3FnVUpBMUN6QUVRYVRs?=
 =?big5?B?U0hmNzM5eFJmWlQxV0pDVkZ6MVV2MWpvbVZCT0tSMTE4ZGc4VnRJc2MreiswWmZP?=
 =?big5?B?SE4vWmpRZFdrMU5KaXNaemdkU0Yxb2EvejdaTUNqckREVXRyWmswYkV5bldHRXUw?=
 =?big5?B?TEl4dWpFNmRPWXB3dE9oV2NybnFTNkdaOFNDdExKR0oxZWQxdE8vVEluYU5kdEMx?=
 =?big5?B?dkVSaDZpQnJsQUVHN2g3d1pXV2duTG9qSkVQOGFrREhvajBMUmExQnBZMkhETUlU?=
 =?big5?B?dEhIT1FRY0wyUUFsQkRKc3lSVCs0WTFkS0NJOGRTeFJiYXVEMmVDOVZRRUlhcm1z?=
 =?big5?B?ZXo5VnZ3SE5lYTlmRVRiMFd1SnE2QmRnQ2hQZWl4cm8yUVpKeWdzT0o1WWFJcGRN?=
 =?big5?B?YmRBRnRCNG1kUng5R29tSkhEbW5XWHNVVTZmWnI2TEN6YzFnWTN0WWNLVmpUTjZu?=
 =?big5?B?RFYvWlBpNnhuZHB3UXNRQ3Rrclc0NjFjcTNwdHUzaXhiSVlrVlpOcmYxc2llZUFW?=
 =?big5?B?c1VZbWtDdGRkeWZ4V2dIN0pWNW5EZ0lDcStaUFgvMUg2MWlSTTJKb0FnaXkwa2FO?=
 =?big5?B?Slh3Q1B1S2ZVMHIvRkZ2aUwrUFRkMENJUjdTNnlXbWVDY1R3SXZtS2dNSXIzVVpx?=
 =?big5?B?QmhYZU9rbXZZRlBwRTh6T0haNDEyQVpOMjhhaGtMY2pYZHZwcDJXeUZWVWNiRXVP?=
 =?big5?B?VVQ4Z3NscmVqVG5QbjZQeCtXaFF1THJtdlROcU43dExjeEtXblg2UmpEcy9YRFJH?=
 =?big5?B?UDV6VnBpeUM0bDBPY1JLdEJTeCtZQ2lmdE95eDhZd2g2YVVqWVRaaVRpc1lpL01S?=
 =?big5?B?aXBTV3lnRkM5U3JLR291UkpLbTFIUm50Mkt1eTdvTzNKOVZSNmNDVEtnRWZGdDJ1?=
 =?big5?B?dFpReUY0U2IxcEQ2dXM5MUdoaXI2RHdFbmM1dzA4UlFFd0tZNGFIR1JIV2NIbUtw?=
 =?big5?B?Z1BSMU91cHU0TU5Id2QzZUZ6MStqaE5tQWEyWlIzTWJ2bC9XUk5XTG12dGNkbVE4?=
 =?big5?B?OVBVaU5KbDg1by9YTDlYV0srUjhmRkc5WTl2dnc0em5tS0xBNGJGMkVQMTZVQU9h?=
 =?big5?B?NnBscEZoYmNPKzdFNHd3S3FpMkxiNUJNbmEyL1ZUTS93VVhKWjZ2UFpXWlJpU0Ro?=
 =?big5?B?UndJaElrdUo5LzZaY0IwL2NUTUJwNFZPUExUZnNBQU1VZC83dWR6b1g2ckRpSHpU?=
 =?big5?B?Vi9KWjV4cVFLWU1hNnhEdWNhcFhJM01qbkdlSGhFZVZOVm9WZFNZU2dJSThvZThZ?=
 =?big5?B?aE5aR1BHS1hjVjNlYkZvbmhXUGJSY1ExWG1mS2ZsTnB6UHFzcEZMTXVwbXJsa0w5?=
 =?big5?B?T1VrMmJWb3hiVGo5d3FPclRLK2VxZmVmV3oxOUJuNk50d2pKeG8rZnlLQUEydHcr?=
 =?big5?Q?1qDrRbjToftjz5wBrUvQ1k5sJgbU3/9MU8hoDoRyfq8=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de651a5d-b1f7-48f5-f489-08dc367d6d44
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2024 03:45:51.1589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bC+K6NAArT4qE/ZkA6dG656Fcaz9jrQyCI70tK9PDF4jdXF6Y3Nfom7NZJKrwfVtydCmJRHalnnJgy1uIQXvIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR04MB6743

VGVzdGVkLWJ5OiBGcmFuayBIc2lhbyC/vaprq8UgPGZyYW5raHNpYW9AcW5hcC5jb20+DQoNCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCrFIpfOqzDogeGl1YmxpQHJl
ZGhhdC5jb20gPHhpdWJsaUByZWRoYXQuY29tPg0KsUil86TptME6IDIwMjSmfjKk6zIypOkgpFWk
yCAwOToxOA0Kpqyl86rMOiBjZXBoLWRldmVsQHZnZXIua2VybmVsLm9yZw0KsMaluzogaWRyeW9t
b3ZAZ21haWwuY29tOyBqbGF5dG9uQGtlcm5lbC5vcmc7IHZzaGFua2FyQHJlZGhhdC5jb207IG1j
aGFuZ2lyQHJlZGhhdC5jb207IFhpdWJvIExpOyBGcmFuayBIc2lhbyC/vaprq8UNCqVEpq46IFtQ
QVRDSCB2MiAxLzJdIGNlcGg6IHNraXAgY29weWluZyB0aGUgZGF0YSBleHRlbmRzIHRoZSBmaWxl
IEVPRg0KDQpGcm9tOiBYaXVibyBMaSA8eGl1YmxpQHJlZGhhdC5jb20+DQoNCklmIGhpdHMgdGhl
IEVPRiBpdCB3aWxsIHJldmlzZSB0aGUgcmV0dXJuIHZhbHVlIHRvIHRoZSBpX3NpemUNCmluc3Rl
YWQgb2YgdGhlIHJlYWwgbGVuZ3RoIHJlYWQsIGJ1dCBpdCB3aWxsIGFkdmFuY2UgdGhlIG9mZnNl
dA0Kb2YgaW92YywgdGhlbiBmb3IgdGhlIG5leHQgdHJ5IGl0IG1heSBiZSBpbmNvcnJlY3RseSBz
a2lwcGVkLg0KDQpUaGlzIHdpbGwganVzdCBza2lwIGFkdmFuY2luZyB0aGUgaW92YydzIG9mZnNl
dCBtb3JlIHRoYW4gaV9zaXplLg0KDQpVUkw6IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcv
cHJvamVjdC9jZXBoLWRldmVsL2xpc3QvP3Nlcmllcz04MTkzMjMNClJlcG9ydGVkLWJ5OiBGcmFu
ayBIc2lhbyC/vaprq8UgPGZyYW5raHNpYW9AcW5hcC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBYaXVi
byBMaSA8eGl1YmxpQHJlZGhhdC5jb20+DQotLS0NCiBmcy9jZXBoL2ZpbGUuYyB8IDE4ICsrKysr
KysrLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEwIGRlbGV0
aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZnMvY2VwaC9maWxlLmMgYi9mcy9jZXBoL2ZpbGUuYw0K
aW5kZXggNzFkMjk1NzE3MTJkLi4yYjJiMDdhMGE2MWIgMTAwNjQ0DQotLS0gYS9mcy9jZXBoL2Zp
bGUuYw0KKysrIGIvZnMvY2VwaC9maWxlLmMNCkBAIC0xMTk1LDcgKzExOTUsNyBAQCBzc2l6ZV90
IF9fY2VwaF9zeW5jX3JlYWQoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90ICpraV9wb3MsDQog
ICAgICAgICAgICAgICAgfQ0KDQogICAgICAgICAgICAgICAgaWR4ID0gMDsNCi0gICAgICAgICAg
ICAgICBsZWZ0ID0gcmV0ID4gMCA/IHJldCA6IDA7DQorICAgICAgICAgICAgICAgbGVmdCA9IHJl
dCA+IDAgPyB1bWluKHJldCwgaV9zaXplKSA6IDA7DQogICAgICAgICAgICAgICAgd2hpbGUgKGxl
ZnQgPiAwKSB7DQogICAgICAgICAgICAgICAgICAgICAgICBzaXplX3QgcGxlbiwgY29waWVkOw0K
DQpAQCAtMTIyNCwxNSArMTIyNCwxMyBAQCBzc2l6ZV90IF9fY2VwaF9zeW5jX3JlYWQoc3RydWN0
IGlub2RlICppbm9kZSwgbG9mZl90ICpraV9wb3MsDQogICAgICAgIH0NCg0KICAgICAgICBpZiAo
cmV0ID4gMCkgew0KLSAgICAgICAgICAgICAgIGlmIChvZmYgPiAqa2lfcG9zKSB7DQotICAgICAg
ICAgICAgICAgICAgICAgICBpZiAob2ZmID49IGlfc2l6ZSkgew0KLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqcmV0cnlfb3AgPSBDSEVDS19FT0Y7DQotICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHJldCA9IGlfc2l6ZSAtICpraV9wb3M7DQotICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICpraV9wb3MgPSBpX3NpemU7DQotICAgICAgICAgICAgICAgICAgICAgICB9
IGVsc2Ugew0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBvZmYgLSAqa2lf
cG9zOw0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqa2lfcG9zID0gb2ZmOw0KLSAg
ICAgICAgICAgICAgICAgICAgICAgfQ0KKyAgICAgICAgICAgICAgIGlmIChvZmYgPj0gaV9zaXpl
KSB7DQorICAgICAgICAgICAgICAgICAgICAgICAqcmV0cnlfb3AgPSBDSEVDS19FT0Y7DQorICAg
ICAgICAgICAgICAgICAgICAgICByZXQgPSBpX3NpemUgLSAqa2lfcG9zOw0KKyAgICAgICAgICAg
ICAgICAgICAgICAgKmtpX3BvcyA9IGlfc2l6ZTsNCisgICAgICAgICAgICAgICB9IGVsc2Ugew0K
KyAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gb2ZmIC0gKmtpX3BvczsNCisgICAgICAgICAg
ICAgICAgICAgICAgICpraV9wb3MgPSBvZmY7DQogICAgICAgICAgICAgICAgfQ0KDQogICAgICAg
ICAgICAgICAgaWYgKGxhc3Rfb2JqdmVyKQ0KLS0NCjIuNDMuMA0KDQo=

