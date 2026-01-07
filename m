Return-Path: <ceph-devel+bounces-4289-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4DFCFFE2F
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 21:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 715AD30080DF
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 20:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146C329B8E5;
	Wed,  7 Jan 2026 20:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="juk0b7yM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E36912F5A5;
	Wed,  7 Jan 2026 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816000; cv=fail; b=hGEP/qG6p4T/0p9fAIWEUSXIlOAAL/ISxc0ZW3DeZXuSme+9Yksuzv2pHaCgWcwm/XB5QWuyLXi4F37UR67OmvrY0nAr4mCVnyjIEgneWAv7Yzwp6FESgbkCiNYe/lRP5ov4ZaYBVpL0yde/7b2oeSwkENZFICVzwcek8FAyrXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816000; c=relaxed/simple;
	bh=rpf3tt9lXenK2S0uqOpTx5ZLlmv64gt0zOJC1kX+GfY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=FIJf3vY5c5KtWl1suc2ttbOnpYyQkupRZyO7uv9u71ZW1kJyscIGX+GdNMeF+WHsm7r7hIiqDPM1cQRnxvy9c4iVPJjH983vTY4Xvoy1BSqU1drqNhlsSMRnwNRMAuL+phdMbVFr0RAH6OjGjb9qCl5+jpf22gLIpmpI+SWIl4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=juk0b7yM; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 607AkD4Q029317;
	Wed, 7 Jan 2026 19:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=rpf3tt9lXenK2S0uqOpTx5ZLlmv64gt0zOJC1kX+GfY=; b=juk0b7yM
	dI8YsFpb9OHyY/By+vGtVEnPszQtEZ52qfFz8XOuiNtlaDPrWOkBoFJv7kXD92RI
	YROgSUCbGmU1MJF6PG3fl64fIjayrKmwwjGwntm1w6qQuWvx+4xg5C8fTi1M5uQt
	T7iiqPkqaxNGfn7icAzPv34uzl3tKCYJovS6OW8wEf83S4FiHHlKoidI/khMGA+N
	Zosui1KgaXJUQmNKSfI1EW/MMW9TJtn90PTxpSEmlrLnAsELpUwex79odSYZ6+Gm
	GYXs2E2vGIVWevN7bO1J4HOJ3Z6gdQevBfTRRFRF1odUpL7nri9Im3A8iGVLr4X1
	V9SAWf4mvSpvww==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqb34u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jan 2026 19:59:49 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 607Jxn24024324;
	Wed, 7 Jan 2026 19:59:49 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqb34r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Jan 2026 19:59:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k426+Z+wr33EKeBF2PlVK+lo0TW1SiaGbLDNlgR3K310d9KHT4blmFYOkwkuvO4WuLHDTrTEEFkD+jMel/yEn09WgtZZdTk1LlVrXBm94MF9Rui+y+2fqj2uGDD2rBjadjrZpLKQb/JenYvmCKwdyJxceTwdq2W+Yludpfp6ybB+QDTxGJAKsVA0O6Z2eO7Ia678WhAjseMrzBNSZ/sFhg6+ofqS1NTcT3iq+eGEAHTuausHdMNOhfa5bHz/zvatRH2abkVTYs5cXUieKK9efPeZKJ7MgfIWh8/0smz97Vnj3n8Bmt+j4iW+jujXr/47LMfxIKotJBBjUIcDJz5ObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpf3tt9lXenK2S0uqOpTx5ZLlmv64gt0zOJC1kX+GfY=;
 b=fytYoFDjvCLXhUQUjheyQKOYhAbuXvBscZi4guD/Awu4m+pMn6qT3xpBLEjytfX53LtNfuslrRaRWKHi3AsqrWuniai38ANaw7cLCfVdX5dw7HI6L6CLcw8H1+mZWa0sOd4rPygGkCheIoS8fxGXk3SKaaru7CZRZi4cirW6IkSyhm+shcH/shFI+ExQK5izZvMIhbY6dnmnqyLSp7aPrtfEVKfdoiDTru1unRkFhyrS57brCB1Gm2Q+UXqDJ/AFWUkK1rwNIi9xot7jyiiESGQ0J+23n1kQa3JEnyDrjq527pDUpQngD0K3v+SKk6KQ/j+Ykk7Gpnty83Q01vEznA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM6PR15MB4071.namprd15.prod.outlook.com (2603:10b6:5:2b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 19:59:46 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Wed, 7 Jan 2026
 19:59:46 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "lilei24@kuaishou.com" <lilei24@kuaishou.com>
CC: Alex Markuze <amarkuze@redhat.com>,
        "idryomov@gmail.com"
	<idryomov@gmail.com>,
        "sunzhao03@kuaishou.com" <sunzhao03@kuaishou.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic:
 =?utf-8?B?W0VYVEVSTkFMXSDnrZTlpI06ICDnrZTlpI06IOOAkOWklumDqOmCruS7tiE=?=
 =?utf-8?B?44CRUmU6ICBbUEFUQ0ggdjJdIGNlcGg6IGZpeCBkZWFkbG9jayBpbiBjZXBo?=
 =?utf-8?B?X3JlYWRkaXJfcHJlcG9wdWxhdGU=?=
Thread-Index: AQHcf+7e9FmwMmnBQ0GWL7ApTXZ3qLVHIHmA
Date: Wed, 7 Jan 2026 19:59:46 +0000
Message-ID: <ebc291d2ae5cb3702f67831dd1da932d66177ae2.camel@ibm.com>
References: <20250808070819.18878-1-sunzhao03@kuaishou.com>
			,<1d51b68168de62cc852fc147fb5e2dc8fbd9373d.camel@ibm.com>
			,<409ca87f8add4a80a7927981059b3c5f@kuaishou.com>
		 <5af9d165d05d4dddbb6c5d6d9d312367@kuaishou.com>
	,<896a69bcc26e1d808e6dfe2d35e25c8b9f8b7f02.camel@ibm.com>
	 <df02fae47a2c45c284d5269a51a2ddd5@kuaishou.com>
In-Reply-To: <df02fae47a2c45c284d5269a51a2ddd5@kuaishou.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM6PR15MB4071:EE_
x-ms-office365-filtering-correlation-id: d4bca906-d75a-4ceb-7724-08de4e274ee7
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dVZrZkFDQ0pTcklNQVQweStlRTJ1clV1TDVkcjhZU2x6Rlh4K2pXQ09VUGkx?=
 =?utf-8?B?M2tqNnpiZXAzWUJhMGZwYTcxL2M1eElnMEhabXZ0Y1JiVDJDaGpiVVhMYXV3?=
 =?utf-8?B?VCtRUWJ3WmJReDNmQ2VJQm1KSi9uNW1SRDdjSWM1bldvRklGZlVqN3Fvemd0?=
 =?utf-8?B?YTNMRHpDS3pWbnEzZWJkT0NqVWV0WmRHdGF4aTRhSzVIUEFob3Juc1dJUlpP?=
 =?utf-8?B?cWNoU2QxZ2FmalAwMkdUV1FaVHprSDZoaHVSNHltQktHSFoxejR5RHVxc3hs?=
 =?utf-8?B?STMrRlpncGZ6MFdVZkN5NnR2bU5yNHRPTE8vTnRCdjQyaUpaUzNOUnRWOVdy?=
 =?utf-8?B?YlUvTWdBSUo1b3FobW9tcWtianduMlB5eVVJWEZQSkFvVERKN0EzU2srTURT?=
 =?utf-8?B?U0NlY1N0UHJka3kyZnlWbkFOL0pJblQxbWRRVjJEdEhFeGxJeTdOb3l3WW0y?=
 =?utf-8?B?MFlQd2dYY3pSa3o3K3VWMGQ5QklNVVdrYXlBOEhBcUcrOVZaZ2NJWkJuMFJE?=
 =?utf-8?B?dHlLZUJiNjRvR0QxZE1hTmhQQ251blNFMTJqSlc0QzkzeC9Wa2UyeE51RnQ4?=
 =?utf-8?B?T2d5VmdLc3g2UnYwaUowWE02elNjWlVvWjd0QVJmSUlKVE5SNVhFRTM5UjZm?=
 =?utf-8?B?a2k0RncxeDhSMlZkNHdmZllVYzQvSmhVY2oydGxKVy9Xa3Y2Vjc3Q0E5UXBL?=
 =?utf-8?B?aFJxZ1FZNjlyOGVCMWVCQ2RTRlZkeXEzS2g5eCtZZ1lkOGtyTSt6aXNpcDVL?=
 =?utf-8?B?OVpHSnF1alBYNFpnRXZiTUpRR294TjdNVnB4SWZnSE15dXJ5bk1mb2Vlbmdv?=
 =?utf-8?B?SmMwa2hXaE9jNE9zMkU5TDduZWFEWDY2Y1JvcUk0YVdFL2lHN0JYVkpnSlRD?=
 =?utf-8?B?ZE9FanJoR0kvRTl5bkpDYWVGZ0FCc3MyOWRMTUl2YzhyUWFhaHluc0hvMnFK?=
 =?utf-8?B?WU5aampSaCtoYkJlWjl4eEdZOFNMeDVWUGxGUi9uY3BmYTNSejVhakQxMzJE?=
 =?utf-8?B?cDM5c2FjdGlwTFNXV2MxcllOS2VZSUg5V0FUSWVoTm1wM0hSVjlVbnFBMDdU?=
 =?utf-8?B?ckRaeDFIMnFvcU85ZXpNbzdjb1NsNXUvbytsNDFuMHZibE1mYWNyVlVPREph?=
 =?utf-8?B?cTVsditONVNqOUR1QlRPdmVCRUN6MXp2d0xsbS92dnlHWUJ3M1paUU8wbVNQ?=
 =?utf-8?B?WjEwYUo5bVhKbUd2ZnVLMS9Jb3VCK1JDNXpIRllLTllCeDMwdHUrWS8wdlVB?=
 =?utf-8?B?VXo2TStYTVdtczRDbTdvRlJwdG5EcmN4Y1hoQ09CTGZ6cFlhcExqdGxQZkQ3?=
 =?utf-8?B?N1BKckNDMWd0QURMQWtXc3RucG9sREU3Q0tDUU5xUUtNL0hyYTF6YXFVdE9a?=
 =?utf-8?B?aWdKZ053MDdURWtmUXREa05hVEszN05hWlh0bGZjWHZHeUg4VXJTanpMSFM5?=
 =?utf-8?B?emQzNjQ1bHc2eGVRWEV3blJkMHpqOUJBZWl2YVl0TXVUVElrK0c3MnFlQ1F4?=
 =?utf-8?B?M291RXNQZkM4Y2xGazBxNW9PV1NCV2d1MDM2eFhHaDJwbmZGOWZMUFlwUkFQ?=
 =?utf-8?B?VzBHZTQ2UTZiekhXV2QwZEVhN0hpSU8wMTR0MVQ2L0I5Q1R0bmNGbU9ONlZM?=
 =?utf-8?B?a3BOOXN2TlBUWlRWQzFNVHhsVURLQlFxTXo3VE9GaTkwZ2pEOEIvNGJ0WCtM?=
 =?utf-8?B?L2pWd1JVd3p5OU1NcE4wbFBNeFk1QU9SMEsra04yR1crN2ZrSitPcDUzYy9q?=
 =?utf-8?B?NU9RNDgwQ3JVTUNydEtML2w4N3V0d2VFb0VxeFQ4Z3g4OVczT09VZTJsVk5F?=
 =?utf-8?B?T3ZFbzlNMmE4T2duVXRRcFoxNC9acnNQd1R6cldETkw0MjJLcnozT1p2VStF?=
 =?utf-8?B?dU11VTdmczFXakxvbzNGTEpNQVQwRS8zRmtrWGdiVU9qbkVubDVjd2VvenJk?=
 =?utf-8?B?cWtKb1dndmNvcFI4dWlOZzBHaG9CTDZySXliTk1JdTE5Z2ZaVmFTbDU4RVpE?=
 =?utf-8?B?SlR1blNNWVFHdUFpVVJ4MHI0SSs4UnJrczJJSXJTeTROTnoyS3lRVTNBTTlS?=
 =?utf-8?Q?yXfgij?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YVVaN2NMd0Ezc0NGWlFMVWR0TUhDVzZlVVYyUXJsdWVlVXVTT2dORFcvSUFq?=
 =?utf-8?B?OWxpZldLUVRHajc4RzYwOTVsTWNLT04wdlBBYTNsdnpEUGllMmlIWmJqcTYr?=
 =?utf-8?B?ZytsZmc2Y2U2WHNzNzY5UXpOdWJNY3l4RnkwVnFmYTdFZ2xMWllleDhKRHlO?=
 =?utf-8?B?SGFQQTBWVE95VDMrSEpjYlVSeGhneTFtUUd6YVJ3MmFibVJGMCt3UnU1ZnBE?=
 =?utf-8?B?UzVneFhwV0hWSzA5UE8wSG9IL3k0cXJCeGFpYkJlOHpaM2JLWHRUT1FkRTUz?=
 =?utf-8?B?WVB1SXN4NXNmNVBYTTI3NFJJajYzWUNzZFRncnpHcjJIUWxtd2U2WGR6Ty90?=
 =?utf-8?B?Ni9YcWxzcnpYVWY5YWFnVHNSNFJEcnNFTkNoVWRpNmxOdExIQmMwZWd1SXBZ?=
 =?utf-8?B?RXYybml1YzFRT1c5OCtpRGVGM1VFb0VzcDZPaVNtekN6T2ovRFQ4b1V4Zlhq?=
 =?utf-8?B?NFZPcFlpRGJ3em4xZkJPSXZoZXgxNy9qb0NlWUdWMytxRHdHVjFlTGRFaFp4?=
 =?utf-8?B?dTNmUzI4dHBmL1FNZHA2bWowZGVBaFdwZjVYNkJuQWN6MHB3TDhpdG8zK3Br?=
 =?utf-8?B?WEROL2srWEcrRmZwQ2MzRVJUd0twclhMdE51WjlyR0NJRHMyZU56aVlBSkpi?=
 =?utf-8?B?eUloaUZwSmRxYVFkbVNjcTJoMk9SZWRJT3doTXd2eGp2QlFJYmJDY0JiTVow?=
 =?utf-8?B?UlF5T2NTbmFSbDYzRW1QVzNyL202MHNDZStqa0Q0TUxtM1Nrd3VhbnlMWm41?=
 =?utf-8?B?WXEvM0tVQlNabUUzMUgwaFdNejF2R3Q3SGtjd2RnSGFwd1JmU3RidU8wb2pG?=
 =?utf-8?B?OUdWTjBVd2JOYVNRTWVyQUNlOWdubjVqWEc1dGlRRjNXbDQxUG5HRTMvY0hT?=
 =?utf-8?B?T2g4eGZUYnhhRTBJQ01EY1NFaEZXZExDQ01aTXZaRkdiL1FJVjgycHIrOXhZ?=
 =?utf-8?B?WDgrb3lLcmE2c2NJQk1QdjZvSmk4UWtUNXhUNktLTmpaV2lDcHBNdXBKZG5E?=
 =?utf-8?B?Y0tGLytqc0dnTjdDdHNKMUM1SC9sUXJ4djFYZ0Rwb2x0OXczU3ZveWhCYlZu?=
 =?utf-8?B?QnNDSGlPNWVnMHpwYXpKUzhaTEIyL3ZCUU5lV21tMGJ3OVhJWHc4ZFhwT1Nv?=
 =?utf-8?B?MlZ1K1lwUDR1alVWOEU0NWVOOFJEL1lXYjA3VUg4a25NWVZ2QzFjQUVqY29i?=
 =?utf-8?B?WUZlWWRnaEIxd0Q2eWg5ajRpZ2ZtYjF6M2trU3crNWtBZ2EyYWxwU1ZURkZh?=
 =?utf-8?B?Y3VuZWsxcmRYRys3OUc2WTJ4anVjRGFRWkFPL3E2cU44UWlDa0l0d1J1MTFk?=
 =?utf-8?B?M1Vid0VJM0J5UFhoTi9XK3d3VzczVVd0YW9aSGVOclltVDNFSmZIaHdvZlRX?=
 =?utf-8?B?N3UvMlMvWVZPalhWbUlNNzZmM2YrVlJ0U2oxWTZqVXBwTWczeVpPWTRsV2g3?=
 =?utf-8?B?REtTSUd0ajl3eFUzOTYwUXdKTTd3N2w5RXR1Wk1lakszSHhKZ1F4SW5jbzZm?=
 =?utf-8?B?VjFkdlpPSkpHazd0ZHMzcDBqR1VQTGx1RkRmeldxZzZDMk9oNGgydnNBUTZw?=
 =?utf-8?B?SVUxQTBZNFdEcTVOUDRLZHZaUzF6RDNaUkVQZ1FGUVIwNnRWeTZMYVJIS0pU?=
 =?utf-8?B?WGowc3lqaUdWYXMyR2QzUnZCckdNQzZDR1IwOVd5VkM1d1ZiRnRTbFJ1V0ZG?=
 =?utf-8?B?SkMzVE9Kek5NcHVFWkl0SlFndXNCM1pNMFQzYWdlQWN5cSt4Z3NNWThpbUpZ?=
 =?utf-8?B?RDFKdWR5cjJ5d21kd05Ub0RtY2VkejAzbmw2ZmRnbkIzZksrcTBtbnIvWGxM?=
 =?utf-8?B?SWU1Y0dxMkFuTko5SGRSdm10NG5DdEUyQmlZaVdrV25RWGgybzNZellBQWdX?=
 =?utf-8?B?UGNkTm5xbEFCcUp0UE4yTHU1WDZMZTZlMC9Wd2dQaDhkZElrY3NiSzdmeUJk?=
 =?utf-8?B?NlhkRDlGdGdzUzVEbWtSTUZDMWNDc2xtMi9hRG1SK3kzQnZRREcrd0hFNW8w?=
 =?utf-8?B?M2ZQdkhScW02VFUwd3prTzRuVWNSZFJBNDRKYkJzbGxPelNnanRoNExXRXdR?=
 =?utf-8?B?SzRZMlVkaG93MmxHam15cERld2FMUmZPQnMzOTBONURxMWtoSG5ZcFFmWkMy?=
 =?utf-8?B?TE9UZWttNlV4c2F2QzVSMjl5QUZYSkp5OU14THhSUHBqaHJnU0VJWWNCbnRx?=
 =?utf-8?B?N2liWVU1SlA1cjVaZUZwRkFmWmdqSGFNRldkSVRQZ055b0kxMnE3dlp1Nm9x?=
 =?utf-8?B?anR3ZW0veVNiM0N0ZHBscFQvQ0YwVGZveHZydFE1NUpKOWlGU2RDNlhUa3VX?=
 =?utf-8?B?ZDhaeCtkM3pDKzA0YXNNSzRMbnByRkJyZGI4amdiWUVocG9rMUtQMUFJd3JN?=
 =?utf-8?Q?OZ9s5eG1smJFqWNhcxBrTmKHYf3mq4c2S3uJZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77A1C2471CC26E40B173EC77E9AD1983@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bca906-d75a-4ceb-7724-08de4e274ee7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 19:59:46.6552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tfWvbwAQZ2Vvbs5WQlGYAP70Ws44oXzPimcEtlb2cd9sEyVF3DA9A2J3jpdpZyO5kkF7d+ubxEw6DAk/Rr0wSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4071
X-Proofpoint-GUID: VUqnrtGbtt7ZH4eKXjVEjydzkPKkVFmR
X-Authority-Analysis: v=2.4 cv=Jvf8bc4C c=1 sm=1 tr=0 ts=695ebb35 cx=c_pps
 a=W+QshtcN2cchze3Z1b4Psw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=5KLPUuaC_9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SCU91OHD3mJnvllIUYIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 31g2MldaBxc5yGQaw56H_yk_BbVp_uHN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDE1NiBTYWx0ZWRfX2mmfbtcZchDq
 0fWOcdisFdiyqgy7M50Kb/EtdlAa6CXHzXwcp73B9c2AS4OtfK/w0+bwclNer8eO0p6uW9uuJtq
 Kz1lEjinYYIpx/2D0O7YDLs3qCurPSFfwHUSWK5UpXQj2z5rumbzvsG7JSwfEBRpgs7LcjJQZyZ
 Ev6Fiy9EWy/JSaRsfcd97ey/jup/QME9KtbZ3jdpHs4YiDMaurhEBf8+i0HTp7hRYoBT4NFHrgF
 ZTst+9NWEXybUV/dYae1XjcZGhPrXKJ3UqOsvznd6lr6Rewho1pZSjJXDQcBLLv0cuOkO8v6J5r
 CPA4Czqwl1NIay9sz4u5ulvrQi4g+g966TcqsQZcHODyInO4NI6dMCol6iuZYyP/Rw8nh/CAQ2T
 gM29dgvXKoEltrqTJ03oXOktgW6wyXhSFvikzkM1hsY/7/3EMzCmNdfYwCAKWO8vIeeyDSK3eqQ
 sHee3Gvcnkg5d3smN2A==
Subject: =?UTF-8?Q?Re:__=E7=AD=94=E5=A4=8D:__=E7=AD=94=E5=A4=8D:_=E3=80=90?=
 =?UTF-8?Q?=E5=A4=96=E9=83=A8=E9=82=AE=E4=BB=B6!=E3=80=91Re:__[PATCH_v2]_ceph?=
 =?UTF-8?Q?:_fix_deadlock_in_ceph=5Freaddir=5Fprepopulate?=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_03,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601070156

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDE2OjAxICswMDAwLCDmnY7no4ogd3JvdGU6DQo+IEhpIFNs
YXZhLA0KPiANCj4gVGhpcyBpc3N1ZSBpcyB2ZXJ5IHJhcmUgb24gb3VyIGludGVybmFsIGNlcGhm
cyBjbHVzdGVycy4gV2UgaGFkIG9ubHkgZW5jb3VudGVyZWQgaXQgZm9yIGFib3V0IHRocmVlIHRp
bWVzLg0KPiBCdXQgd2UgYXJlIHdvcmtpbmcgb24gc2FtZSBoYWNraW5nIG1ldGhvZHMgdG8gc3Bl
ZWQgdXAgdGhlIHJlcHJvZHVjdGlvbi4gSSB0aGluayBpdCB3aWxsIHRha2UgbWUgb25lIHdlZWsN
Cj4gaWYgZXZlcnl0aGluZyBnb2VzIHNtb290aGx5IGFuZCBJIHdpbGwgc2hhcmUgdGhlIG1ldGhv
ZHMgaGVyZS4NCj4gDQo+IFRvIGJlIGhvbmVzdCwgdGhpcyBwYXRjaCBzaG91bGQgYmUgYSByZXZl
cnQgcGF0Y2ggb2YgdGhpcyBvbmU6DQo+IA0KPiBjb21taXQgOiBiY2E5ZmMxNGM3MGZjYmJlYmM4
NDk1NGNjMzk5OTRlNDYzZmI5NDY4DQo+IGNlcGg6IHdoZW4gZmlsbGluZyB0cmFjZSwgY2FsbCBj
ZXBoX2dldF9pbm9kZSBvdXRzaWRlIG9mIG11dGV4ZXMNCj4gDQo+IEknbGwgcmVzZW5kIHRoaXMg
cGF0Y2ggbGF0ZXIuDQoNClNvdW5kcyBnb29kLiBJZiBJIHJlbWVtYmVyIGNvcnJlY3RseSwgdGhl
IG1haW4gaXNzdWUgd2l0aCB0aGUgaW5pdGlhbCBwYXRjaCB3YXMNCnRoZSBjb21taXQgbWVzc2Fn
ZSB0aGF0IGRpZG4ndCBoYXZlIGdvb2QgZXhwbGFuYXRpb24gb2YgdGhlIGlzc3VlIGFuZCB3aHkg
dGhpcw0KcmV2ZXJ0IGNhbiBmaXggdGhlIGlzc3VlLiBTbywgaWYgd2UgaGF2ZSBhbGwgb2YgdGhl
c2UgZGV0YWlscyBpbiB0aGUgY29tbWl0DQptZXNzYWdlLCB0aGVuIHRoZSBwYXRjaCBzaG91bGQg
YmUgaW4gZ29vZCBzaGFwZS4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCg==

