Return-Path: <ceph-devel+bounces-2451-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8695DA12A1F
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 18:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BA041662DE
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 17:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C9819E7ED;
	Wed, 15 Jan 2025 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="elRIMVMh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFF14A630
	for <ceph-devel@vger.kernel.org>; Wed, 15 Jan 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736963370; cv=fail; b=Oca24ztWjaDwn+w1E102xPUq33u1jfSQ/Jhckr6u3lUHIZI9+SvpWm72oL03yAR1uAr1clv7uG5w+ECvUwKaqz06MLCMW69SIp2F8ehHp6GGOl0W32CK+QfUjGjGQTQX/jqqfCoRqq0MZnJmjWQI/HbhOhMEKrF2ucoshx2eR3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736963370; c=relaxed/simple;
	bh=U3/QClJ2WhBvCLGsyJY4s380/8mRrdfw7qTc2Jftze4=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=EYjgONEL7rmKU5PnpDLUOnog7u93AD/ZMoLnmMXNO7i6RKLWOo1h5JX4wOWxM+cVNtO94jONH4rP7nZUXenbbVFvuhS1VdLqPbT9h84te7qkPhVL20FRemvVr/TaNXg/XY4vH6Rb48KWKtZWwOcsDArJeAtVQ72Vw7+vbqEejdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=elRIMVMh; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FHX4uL019771;
	Wed, 15 Jan 2025 17:49:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=U3/QClJ2WhBvCLGsyJY4s380/8mRrdfw7qTc2Jftze4=; b=elRIMVMh
	64V8EtVyP4LKI3oR7wX64ATspxiBEvfypOxY0r7iL15zxGjY5sMncvwRtks9NcAl
	3PFT1vG6YIQtwPYLn+qtvMAsvaU2QsB//CYOB0EdS7ruL9fhTLJoeERKGzbdZECg
	DQFfyxLGrnyEsoSSOmTm+xPxdzAetomrFMpxJyCBz8N0WBLWKsuVFwrwF25KYJvg
	Vj9rXvcmfD7GdLoLp/8REbrbVLNyeAGSj1pK2UvCbEiWSuGx9M/IbNb8aEFwjOog
	qv/CNthGTaxB+YNhBrZyQPdn0IwX+wkV515FlBjST4OW2xEfdTvVTYY/8XbyfrNd
	ZWJBB1TMj9syEw==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5s81t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 17:49:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yrFp63yzgNrOISvTfXNu3lyv1Lx8MgiNYL9sjSnb3zQ6zokC5HnVFEqigSAd09Sdm91yHGFZMiDbVjj3DvK+ZC3jWsVgYqpS29us5UADJPNCnEDHWJBm545o1GZThpVw1lvx1yB6UMzfM6B3Fs7JZ2tjbgbHHQhGdkOQYdiARom5seDyQ7izJor01ZVZtzvezPaePgtim2t6MAjrCaGG1jw8Q4GeWYhvyox/XqIl5OUHpD+HnaE56S/xLBLDJCLrtuXsTLCA1SXagCdxtynC9wPobCfpSzS2CMUaepem6OXCs3NrX4/YXAQ0R1xY+P75A8EQuFBKricQhHfbt1Gv0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3/QClJ2WhBvCLGsyJY4s380/8mRrdfw7qTc2Jftze4=;
 b=LBrRLmtur9nzuk2bwZQZZjyYn51xx9Zpjg6vLXkbLi6Jok6INRkJ1TRHtx7KjTPi/n+i/G8iqEfd8+5rtImYImfw4Zk9cNHSgttgo3eFW78pS9iAmavVdE8sFWwJt1C5UxpjEeDkxTWThYb8zrbq4seO8U7/nFIArnXE5KsTYVgv/zcW2GXSas1j2GKVGNsnLhf9IPFzd4Huk/atDoTTSh8MM1Lr1ZhiWI+ChL0D3lUrDCzbXLp2Y1eYaHY3W5DUWfhQyWWhf5lxvJDnuuVK782UuYm6o67OmncZqOoXX2qpEq7cCp/PzM+sBkOmhDk359BJpIM7nWDxlFLRZgVVFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4552.namprd15.prod.outlook.com (2603:10b6:a03:379::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 17:49:20 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 17:49:20 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] [PATCH v2] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZtYErAs7xsHLA0ycXULUhWND4bMYHe8A
Date: Wed, 15 Jan 2025 17:49:20 +0000
Message-ID: <9cd7c8f4c194fcb8c63c818f2155a9b4f55ce682.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
	 <20250114224514.2399813-1-antoine@lesviallon.fr>
In-Reply-To: <20250114224514.2399813-1-antoine@lesviallon.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4552:EE_
x-ms-office365-filtering-correlation-id: f2abfda9-b1e9-4cab-bc7b-08dd358cf0b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UGNwbkcvcEtpSXVDM0h5cjFBRUo3WEtSN0FjMG5IYW9jdlk2dVY4MjJjSjNv?=
 =?utf-8?B?OUhzUUlidFlBTWNnbmV0VG14S2VJeEhza2Q4MzBqRmtTM0Z6eTVJZEZiK0R2?=
 =?utf-8?B?QXFMVm1kTmdLb2VPVjVSUksydnpsaDZxcFRHVlBQcGpDWVhUWUFBVnFXSWZy?=
 =?utf-8?B?VnFNTTZVdzFWUmVyYldpMUw4ckRLL2lTQlc5dXVNaEVBTXBnVXZwV1FrNE12?=
 =?utf-8?B?Qm5yejhKeGVobEgxcDJ1ZldrQzF6WGJINzgrZmZ6eE5CWlZLeXA1Y25ESmdJ?=
 =?utf-8?B?Yk5OVUp3SlJqMi9MejdmMTZBZ0RXU05DNmpUbk9tU0FmN20xU080NEJQQjF3?=
 =?utf-8?B?WCtoWDZGZm9oM0YzVmt6WjdzNXMwelF5T0YyMXZuaFJQOGlZVStGV1dsSTJZ?=
 =?utf-8?B?YkYxQk11NWgwUlgwY0J6MzdwOXdZQVE3SllUTDdCd0R3LzduM2F1SVNRWGdo?=
 =?utf-8?B?TC81QlpzMVpRT3pnMUczVksrUzV1WGhsUjc3cElXLy9FR3pOVEE3SHNSOC95?=
 =?utf-8?B?RkVRNzdiRmFrOGJKSDA0a2F1Q0g2WVJqdXpPUDhObjBYVW5nT0xZQlFDZ0JS?=
 =?utf-8?B?Q2xyOUF1S0tZcU5uQk5vSExzWVBhT3l4YndQWXV1S1RGT3VNeFFzWmhLWmh6?=
 =?utf-8?B?Y3RGN2pkSTY4Vlo0VFZBaVByWHRCSDUrOWJwWi9kSDZ2eUZUZ2xhYUlZS3ZX?=
 =?utf-8?B?LzhOTGtVQWVrMFhFVWF3azF4TTc5MnF1a3dtWnlxWER4amNXQVl2OVZLa3Ba?=
 =?utf-8?B?alFkUVJVYjRuWmV1NU9sR1JoVmN5ZVAydk85bVJoay9xNmh5RG9NVy9RZzcy?=
 =?utf-8?B?MnVDNXd4Z0VtZExVNzZWTzdKcS8xL0F6bE1wRE53YitJdmZmTEQ2TlhyQ2JE?=
 =?utf-8?B?TklmNnRSbjZYTWdqUHc1S2JlSEsreWJaV0dlT0laQU9zUVVzMzNwakpxNXlL?=
 =?utf-8?B?bnFNV3ZDMWhFUTNSVERtQ2RaczNiQW5zSXJGVmlhOWFIcUhkUGRzdS9xM0NP?=
 =?utf-8?B?MVc3ZlFIbU1LdFptNFJhZ242R2ZxaVZLUmNrc1RnOUdaZ2gwL29pSjlZcHV2?=
 =?utf-8?B?N0kyemM2VXdHdUc2WVE3Q0FyUVd2WVAvaWJ3ZC9ic2NGb29vRkVaZTI3QWxZ?=
 =?utf-8?B?UUpHL3hOM2wxMmZrN3BKSk8zNHNCUFFTZXA0TVdEMzFVQXh3SW9TNE0xK0du?=
 =?utf-8?B?SmhrMStWT0Ira0VUejhkTWtyOEY0MGRYN2hNTkUybnFxdnVrNS9vSXppaUNh?=
 =?utf-8?B?R05kTFJKNG5PR1FOTHRMMno1V21wcXExeXFNV3FCWm5jdFFDeVljeFNUMU1P?=
 =?utf-8?B?eEo4b0Nnak9NeFRDNkU5cGZRQVI3NEROenB2ZEZhRW9xZGVCeWJjai9LWHMv?=
 =?utf-8?B?ZHo1QnptNHJQRkhpRy9wSTVNUFBQU09xVXkyTWpOdXZZS0twUUphTllSUWJE?=
 =?utf-8?B?eFcwUkdvc1NGMHZoNzI2dFBvbHo3MGRyZTFCZXUya2dYam5YeUZxUnE0YVNz?=
 =?utf-8?B?TGIyODIva0RCODRWV2l0RWlYNWRqakVuYnhKV3lWMGthc0VxQndPNzdoanhT?=
 =?utf-8?B?bWFwRWZzcFlKSWN4MHJnTVBYWENRQ2Znc0Y1WkYzMTNvbkZocEFmdjZFbjlr?=
 =?utf-8?B?V0dQN0NrN3dGS0k4YmJWUExsUjBueHZYWVBZek1YSGJwZUJMemxYWk83VVVO?=
 =?utf-8?B?YzJLN01Hck1Hc1c3ZVRUdmgrdlNsVHF0S3pUSkZmZHp3VWlQbHhWNnYwaHVz?=
 =?utf-8?B?ZFovL2RHK0ZDbU5UUWU4QmhhQkNCUG42c2l0OVFYRS9WdkNPZlJMK3ZOeUFB?=
 =?utf-8?B?bzYvVzFmb1Y3WXA2MGlMdU5lUGkzMk1SdlRDak9yVDV5eCsxc0RmRmN0Zmdp?=
 =?utf-8?B?dVRaQ3FGK3dNbDRnei92RFhzT3NMUVA2dStHUWYxcHJiRkZVeURoQkRhT0Fw?=
 =?utf-8?Q?2PSKl+TaV/4Pl8qCH4a0R810xBfZTkMH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VUJnNzlvT0NYNGxaQ1huelpCMldURDA2YVQ1LzJLU3UwNG5tRWRSUWFQcXA0?=
 =?utf-8?B?NzRHOW96WXJQTlcyU1ZoVDVsZi9ycDNJU3RzK0dqdnlwKzN2MUNETnJ1S1Zh?=
 =?utf-8?B?MEpzNnRxdGRrWjRJeEZxTTgzYVVMTnJhR1E2R1hpYXdUcVBEY1NyVFJWWnpH?=
 =?utf-8?B?NEJWSU44RGlmSUpCYVpzYXU0Q3ZuTXBOUWNVOVN1M29naWVSeG40S0VkT3Fw?=
 =?utf-8?B?cTlhbVFWSGpxWjRmTlZRTnZYWmNnRysvYkV2aXl4YzJKVDFiK0JmcEVaWmcv?=
 =?utf-8?B?eXVXdnlaWkd3LzB6Q1czbVp6ZU9DSE9uaTFMSkp6VDd4NU1lZFdNMEdRM3BL?=
 =?utf-8?B?L3J1TE8vai81eHFjSjJTNW9sczBTbEtkL0pDV05MRjdpdXUvcFJ4cSt5cno5?=
 =?utf-8?B?ZkhTRmQ0QzJNQjk0cGE3elZWbm1kQ1pCaWw4VEdqTmYzZVVuL2tMQnVVWEFD?=
 =?utf-8?B?alBUbU1zUTNSVzl2K1cwVm9Yc1NRLzRTYTVIYjJGTEU1NjA2cHRNOTB0M1J3?=
 =?utf-8?B?VGtoS0ZQNlFlKzQ0R3JqTGtRZmh1NkdMaWZJN3lPMjdLcjBSb0J5TS9aQ09Y?=
 =?utf-8?B?QXN1dFBBYS9MZ3lwVko3WmEvbGs3YjlqQlFXWFc0UTlVTG94a2lqTnVRRFdu?=
 =?utf-8?B?cFlmRDFGRjlTRnhMU1dSK2ZlbWJvSWlPV0o3djcvNXVVbkVzUTNUZEd4NExa?=
 =?utf-8?B?b3owY045UGJOY0tPNEZwTkxLVTR1NXJ4aG5nNkJxd3Y4SmVqWlkvcHo3d1FV?=
 =?utf-8?B?ME9iRlFBSkw4SERtYzZpVCtnM3pGNVZJeHkybmM5ekNVMEZrNGVSb1lrclc1?=
 =?utf-8?B?eGk3clZLOXh5TEEvNFJIUGw3RHViRnVNRUxzVmVuV01zVng2aFlGUzIyT1Rx?=
 =?utf-8?B?b0IrVUxnd25Jblo0cjBCMkVaYjBWdFdLMGlYMXBXS2kxUFQvMmxhYWdIQytX?=
 =?utf-8?B?dTlIcmgrU09IQWJHU291TWJ1SW5Jd2o5TTNmazJTeVR2L2FCMnFkbExaM0pG?=
 =?utf-8?B?SDRGcmJrMFpORXU4b3Z5RkdneHQ2SFRUMGxoTWFyVFNBZzZmd1J1R1MvWmVJ?=
 =?utf-8?B?YmdwZG0wQ0xLZjBzaHpHTEdKdnhYb3RlczhzQ1VuS3dxKzk1RW9XV1QxeXh6?=
 =?utf-8?B?L0xqQ2NEZSt4a0lzYWtVRDhWYXFRZGdwVEY1RDBRVDRRcURUaTU4UldIUjhi?=
 =?utf-8?B?dkJpRWNSWEU5T2Q1eUU2eVdudTZraVB3NWNsMTlTeXJSVkRsQ0U3REJaV1dx?=
 =?utf-8?B?RVV1UWdmYkFQL0RvQkRLbWZQZGtDc3FsaGY5elp6SEg4NUNTM2pXNGhTRE1v?=
 =?utf-8?B?T3cvZWNJRm5FeWVQbG1NUEJXdzRHVTU0bkpEOU5CeU5YUTAraUtheGxXOEpj?=
 =?utf-8?B?cmZNU0dIaStZNjFndVE5UXlTcThVZkFMdTAvbks5MEhPUmdXMlJCMnhlYkxs?=
 =?utf-8?B?Y1lLU0dXN2JWOWIxWUs1Y3NIZDhOZ3AxSldVUDNZbTVRZUJaUmJuY3MvOW9D?=
 =?utf-8?B?Z21QWW84SG9WK0dqSE56RjVheWx3QjgxL0o4aUo4bW5uOVVZT2podE1PYUsx?=
 =?utf-8?B?TDBpYm5VTWpVNDJhaFVrQ1dWZmxJQm9reXNPSlBCcnFqY0FHbnJYbTZ2WFps?=
 =?utf-8?B?U3M5ZEk2cVVyYlhLdXBIQTlHZC9hZFRzbEZwTlpUZEFZL1l1TkkwVEpnekNz?=
 =?utf-8?B?djQ4c0xXWkdCbFJsWGNENUNxQURHeWh6R0VnOTVVS3B1a1h0RjNZRlFHdzJp?=
 =?utf-8?B?aEJnTWNDOXRMYk1QVktoRW5KMzdqNy8vV0pXZkt6cC9BY1Q0YU9ySzcrdGkz?=
 =?utf-8?B?bklDR3BUcWg4ZHlScDljMmQvQ1duZ0ZFZE45T3BCNmFESGdGdjNxY25OQzZF?=
 =?utf-8?B?OXd0TjA3K1JEbTdRRXIrWnlrWVNDbFBOaHNsLzliRGtpSHNOQmJqbWt3SHVD?=
 =?utf-8?B?RDVVdy9Na01SOXlKUmRjOTVBVkZjMHpqeHZOOWRWbDJLcVp2dmo5NlN5QkpZ?=
 =?utf-8?B?bmg5c3AvOHhwT3Z2bUFVRVdUTWdMbmpJcTFoM0RObXZvSWVVTGJKMlpIaVMv?=
 =?utf-8?B?bThkQlNJWHcvY0tSMkk3TkE4NzhSUFRETkY1UmdOcWNBVWl2bk9GWE5Qd2VU?=
 =?utf-8?B?OElGLzE4NXZLTzRqYnRhaEhyQ04wL0FyTUtrcjJkcWY0SEtZbDJlUDhHRTIx?=
 =?utf-8?Q?S3S30x2+NWxgQwTm9aSbLe4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4127F5EB14D1FE49A7B30EF4EBE35A26@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2abfda9-b1e9-4cab-bc7b-08dd358cf0b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 17:49:20.6646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EiQY8UXYs6PXfNlNPs99uMomnpnagZZpjhZ0DtRxvvbL6Lm3L5a47iWxIKWPJtu25D75svRI2x7jVYm5Awt3ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4552
X-Proofpoint-GUID: 6HYpEmyjF8MWS0Slx6XD8oufE718IPFi
X-Proofpoint-ORIG-GUID: 6HYpEmyjF8MWS0Slx6XD8oufE718IPFi
Subject: Re:  [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_08,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150128

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDIzOjQ1ICswMTAwLCBBbnRvaW5lIFZpYWxsb24gd3JvdGU6
DQo+IFdlIG5vdyBmcmVlIHRoZSB0ZW1wb3JhcnkgdGFyZ2V0IHBhdGggc3Vic3RyaW5nIGFsbG9j
YXRpb24gb24gZXZlcnkNCj4gcG9zc2libGUgYnJhbmNoLCBpbnN0ZWFkIG9mIG9taXR0aW5nIHRo
ZSBkZWZhdWx0IGJyYW5jaC4NCj4gSW4gc29tZSBjYXNlcywgYSBtZW1vcnkgbGVhayBvY2N1cmVk
LCB3aGljaCBjb3VsZCByYXBpZGx5IGNyYXNoIHRoZQ0KPiBzeXN0ZW0gKGRlcGVuZGluZyBvbiBo
b3cgbWFueSBmaWxlIGFjY2Vzc2VzIHdlcmUgYXR0ZW1wdGVkKS4NCj4gDQo+IFRoaXMgd2FzIGRl
dGVjdGVkIGluIHByb2R1Y3Rpb24gYmVjYXVzZSBpdCBjYXVzZWQgYSBjb250aW51b3VzIG1lbW9y
eQ0KPiBncm93dGgsDQo+IGV2ZW50dWFsbHkgdHJpZ2dlcmluZyBrZXJuZWwgT09NIGFuZCBjb21w
bGV0ZWx5IGhhcmQtbG9ja2luZyB0aGUNCj4ga2VybmVsLg0KPiANCj4gUmVsZXZhbnQga21lbWxl
YWsgc3RhY2t0cmFjZToNCj4gDQo+IMKgwqDCoCB1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZmZmZjg4
ODEzMWU2OTkwMCAoc2l6ZSAxMjgpOg0KPiDCoMKgwqDCoMKgIGNvbW0gImdpdCIsIHBpZCA2NjEw
NCwgamlmZmllcyA0Mjk1NDM1OTk5DQo+IMKgwqDCoMKgwqAgaGV4IGR1bXAgKGZpcnN0IDMyIGJ5
dGVzKToNCj4gwqDCoMKgwqDCoMKgwqAgNzYgNmYgNmMgNzUgNmQgNjUgNzMgMmYgNjMgNmYgNmUg
NzQgNjEgNjkgNmUgNjXCoA0KPiB2b2x1bWVzL2NvbnRhaW5lDQo+IMKgwqDCoMKgwqDCoMKgIDcy
IDczIDJmIDY3IDY5IDc0IDY1IDYxIDJmIDY3IDY5IDc0IDY1IDYxIDJmIDY3wqANCj4gcnMvZ2l0
ZWEvZ2l0ZWEvZw0KPiDCoMKgwqDCoMKgIGJhY2t0cmFjZSAoY3JjIDJmM2JiNDUwKToNCj4gwqDC
oMKgwqDCoMKgwqAgWzxmZmZmZmZmZmFhNjhmYjQ5Pl0gX19rbWFsbG9jX25vcHJvZisweDM1OS8w
eDUxMA0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYzMyYmYxZGY+XSBjZXBoX21kc19jaGVj
a19hY2Nlc3MrMHg1YmYvMHgxNGUwDQo+IFtjZXBoXQ0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZm
ZmZmYzMyMzU3MjI+XSBjZXBoX29wZW4rMHgzMTIvMHhkODAgW2NlcGhdDQo+IMKgwqDCoMKgwqDC
oMKgIFs8ZmZmZmZmZmZhYTdkZDc4Nj5dIGRvX2RlbnRyeV9vcGVuKzB4NDU2LzB4MTEyMA0KPiDC
oMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYWE3ZTM3Mjk+XSB2ZnNfb3BlbisweDc5LzB4MzYwDQo+
IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTgzMjg3NT5dIHBhdGhfb3BlbmF0KzB4MWRlNS8w
eDQzOTANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZmZmFhODM0ZmNjPl0gZG9fZmlscF9vcGVu
KzB4MTljLzB4M2MwDQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTdlNDRhMT5dIGRvX3N5
c19vcGVuYXQyKzB4MTQxLzB4MTgwDQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTdlNDk0
NT5dIF9feDY0X3N5c19vcGVuKzB4ZTUvMHgxYTANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZm
ZmFjMmNjMmY3Pl0gZG9fc3lzY2FsbF82NCsweGI3LzB4MjEwDQo+IMKgwqDCoMKgwqDCoMKgIFs8
ZmZmZmZmZmZhYzQwMDEzMD5dIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDc3LzB4
N2YNCj4gDQo+IEl0IGNhbiBiZSB0cmlnZ2VyZWQgYnkgbW91dGluZyBhIHN1YmRpcmVjdG9yeSBv
ZiBhIENlcGhGUyBmaWxlc3lzdGVtLA0KPiBhbmQgdGhlbiB0cnlpbmcgdG8gYWNjZXNzIGZpbGVz
IG9uIHRoaXMgc3ViZGlyZWN0b3J5IHdpdGggYW4gYXV0aA0KPiB0b2tlbiB1c2luZyBhIHBhdGgt
c2NvcGVkIGNhcGFiaWxpdHk6DQo+IA0KPiDCoMKgwqAgJCBjZXBoIGF1dGggZ2V0IGNsaWVudC5z
ZXJ2aWNlcw0KPiDCoMKgwqAgW2NsaWVudC5zZXJ2aWNlc10NCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBrZXkgPSBSRURBQ1RFRA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNhcHMgbWRzID0g
ImFsbG93IHJ3IGZzbmFtZT1jZXBoZnMgcGF0aD0vdm9sdW1lcy8iDQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY2FwcyBtb24gPSAiYWxsb3cgciBmc25hbWU9Y2VwaGZzIg0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNhcHMgb3NkID0gImFsbG93IHJ3IHRhZyBjZXBoZnMgZGF0YT1jZXBoZnMi
DQo+IA0KPiDCoMKgwqAgJCBjYXQgL3Byb2Mvc2VsZi9tb3VudHMNCj4gwqDCoMKgDQo+IHNlcnZp
Y2VzQDAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMC5jZXBoZnM9L3ZvbHVtZXMv
Y29udGFpbg0KPiBlcnMgL2NlcGgvY29udGFpbmVycyBjZXBoDQo+IHJ3LG5vYXRpbWUsbmFtZT1z
ZXJ2aWNlcyxzZWNyZXQ9PGhpZGRlbj4sbXNfbW9kZT1wcmVmZXItDQo+IGNyYyxtb3VudF90aW1l
b3V0PTMwMCxhY2wsbW9uX2FkZHI9W1JFREFDVEVEXTozMzAwLHJlY292ZXJfc2Vzc2lvbj1jbA0K
PiBlYW4gMCAwDQo+IA0KPiDCoMKgwqAgJCBzZXEgMSAxMDAwMDAwIHwgeGFyZ3MgLVAzMiAtLXJl
cGxhY2U9e30gdG91Y2gNCj4gL2NlcGgvY29udGFpbmVycy9maWxlLXt9ICYmIFwNCj4gwqDCoMKg
IHNlcSAxIDEwMDAwMDAgfCB4YXJncyAtUDMyIC0tcmVwbGFjZT17fSBjYXQNCj4gL2NlcGgvY29u
dGFpbmVycy9maWxlLXt9DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbnRvaW5lIFZpYWxsb24gPGFu
dG9pbmVAbGVzdmlhbGxvbi5mcj4NCj4gLS0tDQo+IMKgZnMvY2VwaC9tZHNfY2xpZW50LmMgfCAx
NSArKysrKysrKystLS0tLS0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jIGIv
ZnMvY2VwaC9tZHNfY2xpZW50LmMNCj4gaW5kZXggNzg1ZmU0ODllZjRiLi5jM2I2MzI0M2MyZGQg
MTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvbWRzX2NsaWVudC5jDQo+ICsrKyBiL2ZzL2NlcGgvbWRz
X2NsaWVudC5jDQo+IEBAIC01NjkwLDE4ICs1NjkwLDIxIEBAIHN0YXRpYyBpbnQgY2VwaF9tZHNf
YXV0aF9tYXRjaChzdHJ1Y3QNCj4gY2VwaF9tZHNfY2xpZW50ICptZHNjLA0KPiDCoAkJCSAqDQo+
IMKgCQkJICogQWxsIHRoZSBvdGhlciBjYXNlc8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgDQo+IC0tPiBtaXNtYXRjaA0KPiDCoAkJCSAqLw0KPiArCQkJaW50IHJj
ID0gMTsNCj4gwqAJCQljaGFyICpmaXJzdCA9IHN0cnN0cihfdHBhdGgsIGF1dGgtDQo+ID5tYXRj
aC5wYXRoKTsNCj4gwqAJCQlpZiAoZmlyc3QgIT0gX3RwYXRoKSB7DQo+IC0JCQkJaWYgKGZyZWVf
dHBhdGgpDQo+IC0JCQkJCWtmcmVlKF90cGF0aCk7DQo+IC0JCQkJcmV0dXJuIDA7DQo+ICsJCQkJ
cmMgPSAwOw0KPiDCoAkJCX0NCj4gwqANCj4gwqAJCQlpZiAodGxlbiA+IGxlbiAmJiBfdHBhdGhb
bGVuXSAhPSAnLycpIHsNCj4gLQkJCQlpZiAoZnJlZV90cGF0aCkNCj4gLQkJCQkJa2ZyZWUoX3Rw
YXRoKTsNCj4gLQkJCQlyZXR1cm4gMDsNCj4gKwkJCQlyYyA9IDA7DQo+IMKgCQkJfQ0KPiArDQo+
ICsJCQlpZiAoZnJlZV90cGF0aCkNCj4gKwkJCcKgIGtmcmVlKF90cGF0aCk7DQo+ICsNCj4gKwkJ
CWlmICghcmMpDQo+ICsJCQnCoCByZXR1cm4gMDsNCj4gwqAJCX0NCj4gwqAJfQ0KPiDCoA0KDQpM
b29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJl
eWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0KDQo=

