Return-Path: <ceph-devel+bounces-654-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7031B83A010
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jan 2024 04:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECFEC1F22E74
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jan 2024 03:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE1353B9;
	Wed, 24 Jan 2024 03:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b="UjD/+uzw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA88475
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jan 2024 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706066725; cv=fail; b=RyyKYNPLeKoGVYFWTK9AECYSKRdOP4GIcinT4iid6LsR/bniUku9aSC8pvu11YAnM+hPjpn2zRnz6NzOy6n20S8uLdWFh5DaXHO+0pjj9Q+D+RWEH5hHhOamPwxx8I2+ThjlKqBwVH51OW4YOx0cMsmDr/3MAi0KzofwTaRiHdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706066725; c=relaxed/simple;
	bh=rlGkVuEJ5HUvWUDvRWRVJ6j253bzsMN1YM04gnzp8X0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ejC7RaMTlAPkOptoZkpm3cbtVXj0zU+PWZ6ymOaOT1ike6321OwXoaVaMQAHDUJV/37LEaUIevQJga5Mw0B9eEiAyibppI8iW9FdTd/kHWoVPagZCyxomkJCbibThs6J2nNiwSfWKxy1VuZlI+sQEvNIT0YKZjbB9dMP7fcNoDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com; spf=pass smtp.mailfrom=qnap.com; dkim=pass (2048-bit key) header.d=qnap.com header.i=@qnap.com header.b=UjD/+uzw; arc=fail smtp.client-ip=40.107.255.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qnap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qnap.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGxZNhEjfPfryBwvJfxpb8jmWry4Z/b6dpCRZUynqekUVEuaqoxqnyqA4ez5aGxCQlQE9fhchKk5qXnIOHf4irVVQEp397VVStRseMpsi6qOo9TacKz/wg3LG87mQHkCPnCP2p66TCKgitKRHpIwvBQHwujiF5+caUuzMEFxglohUAuP5FT4Bvf9PdkzSj/Lotvii+HbpBo76T+NS6CJgTFQyUYiVHCCOwaQivnKb3qGbXE1pZtpJrgVStg0wRP2hkjfrgbV6zcSHgT34axaxsPuStdMSuhXkntZDhBHWhM2AsZ8B1t4exVhITWXDbeo+bNElgKut12zGQYtEYU9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlGkVuEJ5HUvWUDvRWRVJ6j253bzsMN1YM04gnzp8X0=;
 b=EVXeOchpoaL6Qxqw4q3MdV9+NiTVaBXATWYH9tSjndrMqgUFimQb4FQ0CNyM261+gWLrGucZ807BPbDyogVFz0AdyepZRdOl0kgAx4M6poWClmE+2LJp5r/xviGkTEGCOdW3WUyjwJpY+kbCnf2Rtj2hxx1hb2GVk8sZFe+grEr4G86I6YDDt7WWpOqCBdt2tpI+CDO5fquAknKMrBH533HOLfLinjnKesSXzAejEP3Ou6J4FQ7dnKu8sVHcWgszk1q/jqvKlE08UIILuuGzaOjzQB6LEok9PdcfWVYZ3Mg+nr5/mjnHF+pzMh11IOa9cNBREaph7GVr+BvtcXyqqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qnap.com; dmarc=pass action=none header.from=qnap.com;
 dkim=pass header.d=qnap.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qnap.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlGkVuEJ5HUvWUDvRWRVJ6j253bzsMN1YM04gnzp8X0=;
 b=UjD/+uzwaDX+LjZz3irNKYAkWpAZc4DuKNxPYWogF18mypvNbejEjlFBzILtGjSOlWoLj/Kc2w8n7kJIeSklYm3AVW042NMMIaqLp4MJ6P+mHoTy2sqRF6l9LFqqbko3OqA7tynja4nPIUYBvCfd0FscOaytUaGro06cJ22MYYzDVZwFwP38WkHJ0t1l1D8TeHr+x2AZccMg/oYm9hxhzAc36rETaqvqidp3EfJ5HOJgOCGJNhOlte1HYgtwqJMgZTddf2mu2oYcGdetYZXUEmrmCzbfZuGjXHqo8AakuK5Yvq5/PEct1gmjB5X9zjB+WX3K9gEUhEg5mbmIdBG1pw==
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com (2603:1096:101:ef::7)
 by OSQPR04MB7730.apcprd04.prod.outlook.com (2603:1096:604:27e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Wed, 24 Jan
 2024 03:25:18 +0000
Received: from SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::43a3:875d:d7bd:409b]) by SEZPR04MB6972.apcprd04.prod.outlook.com
 ([fe80::43a3:875d:d7bd:409b%4]) with mapi id 15.20.7202.035; Wed, 24 Jan 2024
 03:25:17 +0000
From: =?utf-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Read operation gets EOF return when there is multi-client read/write
 after linux 5.16-rc1
Thread-Topic: Read operation gets EOF return when there is multi-client
 read/write after linux 5.16-rc1
Thread-Index: AQHaTnBMaFmF63blQUOSXPXYY4zuRA==
Date: Wed, 24 Jan 2024 03:25:17 +0000
Message-ID:
 <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qnap.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SEZPR04MB6972:EE_|OSQPR04MB7730:EE_
x-ms-office365-filtering-correlation-id: ec09b565-0882-4932-0670-08dc1c8c1651
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 cx8IlC/bN8+bCe+aJPiAEvLiLjKOcIOOKaDRxshO3bDWR2xy3exDJVlXCIO/NcpjzY35/12yF8CnGZW1lKd+Sq8unjagQPsMmw/wEUE10f2WbV3gUjKjlTFuJB7SVbgps1L3XkHSr653HLz13rnxYua2iSswcKGpa6zHJU6ZbDT+YdeLcBEhoKG/NuWagti5CoK1gS7ySILN8sgUe8w7E+ZVH6FpPD0QirkzYG25BS5hbymKY822d9CyFIPIN0p809z+8FlxRi9FK360EJjv5ASixjtp1kATqPXvNiiFzFXivTrmBzDdjryVRFGK/pDwESQ0EmBnZrEgu5DTAUdWkjszzbA3ybgDzsGqf8D0ozxhfyhVI/2Q8+LnJqmH6IhAfiV/tKpacTS+9eI7W1//8x5mKlJqymhkoIpy48i6vSOG6IKEbPOseV1jVAIXJpuB0/3HvxKk26tRk59b/6wWxRzE56yOXBMqHaqKNs87O/Zu/u6uPUW8IZpTxH/lIUlqYIuhzu2f4PQIZ8dBGh26eQJx9VGJ/AsL/LTFlJVhYI9DSWFz9UOUnv1cwNzC0kiDC2PWi7XW1kwYhovEPgG4SVYFqenJ4j6CGEpofEibAP5525qL2qbv9FybR3IYxxAS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR04MB6972.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(396003)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(8676002)(8936002)(9686003)(52536014)(33656002)(26005)(83380400001)(2906002)(38070700009)(5660300002)(41300700001)(478600001)(64756008)(316002)(6916009)(6506007)(7696005)(66446008)(122000001)(38100700002)(91956017)(71200400001)(76116006)(66946007)(66476007)(66556008)(86362001)(55016003)(55236004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ajhQUUtDRHVBL1QxeDdpVUlWdUJzbzBieEJpM2FGTXFsOHY1WVZzam8rWDFz?=
 =?utf-8?B?eWgrYWRHMVlkbFlZM29TMnpXM2grTlpFbllkeU9zRHFaamgrVWpoL2FaTVd1?=
 =?utf-8?B?YjBFRTNVbjJaQ1E2dEkvbm4zc3dOYUxldWgrQXFIR3lGQlVFMmYwWkdYRzUz?=
 =?utf-8?B?V01ZZGl0bzJBUGtCZW9pQUVKTGxkOUJqQytQUGNHU3BoU0QyVFVSN1l6enBr?=
 =?utf-8?B?UTFqa0lRZmRGMFh4d3laOUFUSnhSRktCNjJhRzRXbks3bTdpYW0yUC9GcTFB?=
 =?utf-8?B?OFB4MVBQNEVPY2poN1RVVGxTTjJVVWtiUmg0dUtjMVBpRWhrNi9UdkpXWUNv?=
 =?utf-8?B?QVJzWURrUzFkU3B2cmp3R2ZqWUpOV2U2ZEUwdHJJWExpWlhXSTBvUnlTZmxO?=
 =?utf-8?B?ckxMN25zd0hqN2FFZWo4empydzVCc3J5TEkzYUxyekFwUWcwdk9SeXlmVGJs?=
 =?utf-8?B?YWw3MGJKaS94MlRmdWpwYlVjYVBDYmxxVFQvUzJSMUVlRFZsMVdFZGJCWEgy?=
 =?utf-8?B?SUR1ZEpJK2JEclBNRGRaMFF4YnNRSXF2RW5DUUZaSzE0UldlL1dsTWJZZWlS?=
 =?utf-8?B?dkFHRnBPZk9sOVU1OHpoc3ByaWV0RE1VUENVQnVYS3BueU5xTXdIdUVHc0M3?=
 =?utf-8?B?Yk5GZGlOUkVxN1c2TnJwS2hsSk1pcC95ZFJJZVNIWEVjM2tOMXYxNXpnRFA5?=
 =?utf-8?B?SVJVcXRjc2dLNnQ0TDZRK2J1VzY0VGZocmZFRXdCMXhhTlJpMy9DOUJCMzR5?=
 =?utf-8?B?NVRFcEljNlZ6eUllRlk2aWUyL1BIN2N5emNmRWd0Y1BDdU9OTmZBb3Y4NTBo?=
 =?utf-8?B?a29nQU5QZU12K0JqckNnRmRTYXJBbDdmQ1RkdTV5bXluMlI5T3VsUDlXdS9i?=
 =?utf-8?B?bjF5MytDUC8xaFB0SElTRjdDS0JmdjR3aEdNMG8yUkhSeU5oOFBaUnBOUzY4?=
 =?utf-8?B?em9iWmJhbWkzSGI3bkRxbHJFcnlIZjAzSGxiQWttOVcvb1hRS01VNlRJUElT?=
 =?utf-8?B?MzAyRmZGOGhTYWFaS1R3OHl5TXEwa21RSDZzVkdreFhpR1NleXg3bGJ4aVA3?=
 =?utf-8?B?LzByMFlxSW9EYys5NzBab3N6RUV5eTBnQWVvVDYwTU1XbkJBd1BZNWhFRHVq?=
 =?utf-8?B?aWJabnUwK1hHZXltdlZHeXJWdCtuV1g4MXZwTzVUVUwyNXZCMngzOTV1RUxY?=
 =?utf-8?B?bHV0UzVsQnVDR243bFI5TGE5K1p1dEtKS013N2ZNazBVL1pWaFh5TG5wRGh5?=
 =?utf-8?B?czlML1dTN2VpMUVhRmxjMmpWTGxNSWlkdHBPK05IYk5VK0daeUVlVVByZFBK?=
 =?utf-8?B?anlsTTFRSFB2N2JON2RKVzVITGlPQm1HODQ4TDV3b1oyQnp6aEowTVo3RTFT?=
 =?utf-8?B?cityL3F2d1Z1ZFVvSGxvVmlYN0tPNXFCaVlVTTZsaHZuNkxwYWhKSnYvOFJX?=
 =?utf-8?B?NE5aNEUwTStYcGJ5UHh5VVUyYnE5QlFad2RIaGZMMDVzd3dtYjZicFl3a3Zw?=
 =?utf-8?B?SVpqazVKcXNSaGs1MkhrbGgyZTdEU3BxSGkvODNGVDc2SDdOU0Q1WjNyUVdI?=
 =?utf-8?B?bEdkOUVOY1QrS0dXd0RKK1NvaDFQSkdqMklzUmJVMzcvejU0Ums4T2FyTm05?=
 =?utf-8?B?dno3MW1NVnBPRjc2RUpiZElSNytJcE9jWTlJNXM5M0J6NjJJajVzaTZsbVVn?=
 =?utf-8?B?d2RSK1lHc2VpZHdZbkdzWXdsVk82OSs4c2xZMitWUEV6UjdMcHRPTzdhMjQz?=
 =?utf-8?B?Ym42bzZrVkxIb1V4MU05RWM0Y1RDM21USlFrMStUVzFJWHlmeUdKMHl6VXlT?=
 =?utf-8?B?RUpBSGRHaVdpa0xCM3BGT2FZaktoQ3V1aFJ6QmJCWkNRVDcxZURvOHpXR3Zr?=
 =?utf-8?B?eGxCLy90akc1UVZJZW9iWGVUVmNUaEg2cm5lZnNSN3Z5Q1ZraGVMdW1tazlt?=
 =?utf-8?B?SjVwcTZ5TWxyZEdWRGhGbEJrcFZ3aG9iM0IxRkU2dEk1RFJ0UnFKVmQ4ZE9Q?=
 =?utf-8?B?R3pHU3l5MzBGaDI2NDVJMHlzVzcwUytCeHBwVUhZK0llaDFBdG9ZRGhSOWpR?=
 =?utf-8?B?WTNEV2I2eWNoZHViZjlZOWpzVFVHVWtlbXVvbzA0WjRtNTRmalFsZW1NUmZ2?=
 =?utf-8?Q?l6IU=3D?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ec09b565-0882-4932-0670-08dc1c8c1651
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2024 03:25:17.4670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6eba8807-6ef0-4e31-890c-a6ecfbb98568
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ++nQ3V4v8UHMziGdeDjOWugq7Zi3vSmkoQ84XRkY+JZWk/djIRcHSNaKBpVSMqYIngGAho9EI/iHl+W86TMd8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR04MB7730

V2hlbiBtdWx0aXBsZSBjZXBoIGtlcm5lbCBjbGllbnRzIHBlcmZvcm0gcmVhZC93cml0ZSBvbiB0
aGUgc2FtZSBmaWxlLCB0aGUgcmVhZApvcGVyYXRpb24oY2VwaF9zeW5jX3JlYWQpIHJldHVybnMg
RU9GKHJldCA9IDApIGV2ZW4gdGhvdWdoIHRoZSBmaWxlIGhhcyBiZWVuCndyaXR0ZW4gYnkgYW5v
dGhlciBjbGllbnQuCgpNeSBlbnZzIHVzZSBDZXBoIHF1aW5jeSh2MTcuMi42KSBhbmQgbW91bnQg
Y2VwaGZzIGJ5IGNlcGgga2VybmVsIGNsaWVudC4gRm9yIHRoZQpjbGllbnQgc2lkZSwgSSB1c2Ug
U2FtYmEodjQuMTguOCkgdG8gZXhwb3J0IHRoZSBmb2xkZXIgYXMgc21iIHNoYXJlIGFuZCB0ZXN0
IGl0CndpdGggc21idG9ydHVyZS4gVGhlIHRlc3QgY2FzZSBpcyBzbWIyLnJ3LnJ3MSB3aXRoIHRo
ZSBmb2xsb3dpbmcgZmFpbHVyZQptZXNzYWdlOgoKdGVzdDogc2FtYmE0LnNtYjIucncucncxIApD
aGVja2luZyBkYXRhIGludGVncml0eSBvdmVyIDEwIG9wcyAKcmVhZCBmYWlsZWQoTlRfU1RBVFVT
X0VORF9PRl9GSUxFKSAKZmFpbHVyZTogc2FtYmE0LnNtYjIucncucncxIFsgCkV4Y2VwdGlvbjog
cmVhZCAwLCBleHBlY3RlZCA0NDAgCl0KCkFmdGVyIHNvbWUgdGVzdGluZywgSSBmaWd1cmVkIG91
dCB0aGF0IHRoZSBmYWlsdXJlIG9ubHkgaGFwcGVucyB3aGVuIEkgaGF2ZQpsaW51eCBrZXJuZWwg
dmVyc2lvbj49NS4xNi1yYzEsIHNwZWNpZmljYWxseSBhZnRlciBjb21taXQKYzNkOGUwYjVkZTQ4
N2E3YzQ2Mjc4MTc0NWJjMTc2OTRhNDI2NjY5Ni4gS2VybmVsIGxvZ3MgYXMgYmVsb3cob24gNS4x
Ni1yYzEpOgoKCltXZWQgSmFuIDEwIDA5OjQ0OjU2IDIwMjRdIFsxNTMyMjFdIGNlcGhfcmVhZF9p
dGVyOjE1NTk6IGNlcGg6IMKgYWlvX3N5bmNfcmVhZAowMDAwMDAwMDc4OWRjY2VlIDEwMDAwMDAx
MGVmLmZmZmZmZmZmZmZmZmZmZmUgMH40NDAgZ290IGNhcCByZWZzIG9uIEZyIApbV2VkIEphbiAx
MCAwOTo0NDo1NiAyMDI0XSBbMTUzMjIxXSBjZXBoX3N5bmNfcmVhZDo4NTI6IGNlcGg6IMKgc3lu
Y19yZWFkIG9uIGZpbGUgCjAwMDAwMDAwZDllODYxZmIgMH40NDAgCltXZWQgSmFuIDEwIDA5OjQ0
OjU2IDIwMjRdIFsxNTMyMjFdIGNlcGhfc3luY19yZWFkOjkxMzogY2VwaDogwqBzeW5jX3JlYWQg
MH40NDAgZ290IDQ0MCBpX3NpemUgMCAKW1dlZCBKYW4gMTAgMDk6NDQ6NTYgMjAyNF0gWzE1MzIy
MV0gY2VwaF9zeW5jX3JlYWQ6OTY2OiBjZXBoOiDCoHN5bmNfcmVhZCByZXN1bHQgMCByZXRyeV9v
cCAyIAoKLi4uICAKCltXZWQgSmFuIDEwIDA5OjQ0OjU3IDIwMjRdIFsxNTMyMjFdIGNlcGhfcmVh
ZF9pdGVyOjE1NTk6IGNlcGg6IMKgYWlvX3N5bmNfcmVhZAowMDAwMDAwMDc4OWRjY2VlIDEwMDAw
MDAxMGVmLmZmZmZmZmZmZmZmZmZmZmUgMH40NDAgZ290IGNhcCByZWZzIG9uIEZyIApbV2VkIEph
biAxMCAwOTo0NDo1NyAyMDI0XSBbMTUzMjIxXSBjZXBoX3N5bmNfcmVhZDo4NTI6IGNlcGg6IMKg
c3luY19yZWFkIG9uIGZpbGUKMDAwMDAwMDBkOWU4NjFmYiAwfjAKCgpUaGUgbG9ncyBpbmRpY2F0
ZSB0aGF0OiAKMS4gY2VwaF9zeW5jX3JlYWQgbWF5IHJlYWQgZGF0YSBidXQgaV9zaXplIGlzIG9i
c29sZXRlIGluIHNpbXVsdGFuZW91cyBydyBzaXR1YXRpb24gCjIuIFRoZSBjb21taXQgaW4gNS4x
Ni1yYzEgY2FwIHJldCB0byBpX3NpemUgYW5kIHNldCByZXRyeV9vcCA9IENIRUNLX0VPRiAKMy4g
V2hlbiByZXRyeWluZywgY2VwaF9zeW5jX3JlYWQgZ2V0cyBsZW49MCBzaW5jZSBpb3YgY291bnQg
aGFzIG1vZGlmaWVkIGluIApjb3B5X3BhZ2VfdG9faXRlciAKNC4gY2VwaF9yZWFkX2l0ZXIgcmV0
dXJuIDAKCkknbSBub3Qgc3VyZSBpZiBteSB1bmRlcnN0YW5kaW5nIGlzIGNvcnJlY3QuIEFzIGEg
cmVmZXJlbmNlLCBoZXJlIGlzIG15IHNpbXBsZQpwYXRjaCBhbmQgSSBuZWVkIG1vcmUgY29tbWVu
dHMuIFRoZSBwdXJwb3NlIG9mIHRoZSBwYXRjaCBpcyB0byBwcmV2ZW50CnN5bmMgcmVhZCBoYW5k
bGVyIGZyb20gZG9pbmcgY29weSBwYWdlIHdoZW4gcmV0ID4gaV9zaXplLgoKVGhhbmtzLgoKCmRp
ZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2NlcGgvZmlsZS5jCmluZGV4IDIyMGE0MTgz
MWI0Ni4uNTg5N2Y1MmVlOTk4IDEwMDY0NAotLS0gYS9mcy9jZXBoL2ZpbGUuYworKysgYi9mcy9j
ZXBoL2ZpbGUuYwpAQCAtOTI2LDYgKzkyNiw5IEBAIHN0YXRpYyBzc2l6ZV90IGNlcGhfc3luY19y
ZWFkKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICp0bywKCsKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGlkeCA9IDA7CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGxlZnQgPSByZXQg
PiAwID8gcmV0IDogMDsKKyDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAobGVmdCA+IGlfc2l6ZSkg
eworIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGxlZnQgPSBpX3NpemU7CisgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgfQrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB3aGlsZSAobGVmdCA+
IDApIHsKwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgc2l6ZV90IGxlbiwgY29w
aWVkOwrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBwYWdlX29mZiA9IG9mZiAm
IH5QQUdFX01BU0s7CkBAIC05NTIsNyArOTU1LDcgQEAgc3RhdGljIHNzaXplX3QgY2VwaF9zeW5j
X3JlYWQoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1Y3QgaW92X2l0ZXIgKnRvLArCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBicmVhazsKwqAgwqAgwqAgwqAgfQoKLSDCoCDCoCDC
oCBpZiAob2ZmID4gaW9jYi0+a2lfcG9zKSB7CisgwqAgwqAgwqAgaWYgKG9mZiA+IGlvY2ItPmtp
X3BvcyB8fCBpX3NpemUgPT0gMCkgewrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAob2ZmID49
IGlfc2l6ZSkgewrCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAqcmV0cnlfb3Ag
PSBDSEVDS19FT0Y7CsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJldCA9IGlf
c2l6ZSAtIGlvY2ItPmtpX3Bvczs=

