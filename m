Return-Path: <ceph-devel+bounces-2450-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 36814A12A1C
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 18:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7525E7A04FA
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2025 17:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2463155C96;
	Wed, 15 Jan 2025 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RZrz5ieo"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC5614A630
	for <ceph-devel@vger.kernel.org>; Wed, 15 Jan 2025 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736963294; cv=fail; b=WWw4df3SJm4YhemFKZXQNMZQLnbCgfPcG/hTC78AeGSBY4QvBeU8eyDAidPARsS+Spi0LsB7bC4Y6ZA3UZ8lXgIDAdsMqMJ22ZZkqDWfP8O33q4XV4FTlJeTcS2KYEf5RAILyXneQiqM7avoC4XL1C/m0lPqAmpJwaTh8ySkB6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736963294; c=relaxed/simple;
	bh=K0LUszK8R2HDRUBK/tWgQksMd5kz9I+Kam+YnslKp/c=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=gonneLqNfh2BATWO3Hyqn7TrWXlxAvoi4UMTOeSPjF9Cf74XT9OClorltHxcyLvrmzM3HdWYsezpQg+lEOPvVuvp+4XYjjj4mFSnnfQ60ARmqBrHdVzsUic7TQk0kGOKpJU2bkmzMlPDXGc0y3PJQvhPayaiUSZ+iEWbtqBPKMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RZrz5ieo; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FHX4KG019754;
	Wed, 15 Jan 2025 17:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=K0LUszK8R2HDRUBK/tWgQksMd5kz9I+Kam+YnslKp/c=; b=RZrz5ieo
	XmdwK2mSSZUSpBVt0XBeTztvP98L/Pzo/ttTmTGVI1vgp5q7NtR3V5nqANsNSClb
	vHl8gpthdQDL00ozd9FGFLzZ09IuAXj2C66jzn8KLPil3N765q4VLx/K193j5c+1
	uxmA4zXA8LM/L2xtqG5AANTIZMEvuIlYxM18WmYA7talCjFaOnQK9DhaVtcPX5Jv
	l/EDAgNfNikMN4GG4oji0p0NCMNkNu1s1vQJg9h9brKn2wRcZ9EVKa6W0XBhuffx
	VEdHc+wNUGWYjjDLC18c64e7xV/7ADLbPrS6aWefo3HDQrJZwbv6GWXmKrpCedy/
	4NUY83XfOw94Eg==
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5s7p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 17:48:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JySqn6YkMWDDmGQiy6tJLDhcxRx2H2JVGpjBwGc4uYY+TywkN0bTNGbQG1dpZEYJIQjzTLC/dEr2etfXLocdFS2kur3LmDhTzOZEiKTvnMvxKeqrOr3VQkRjjuSulj1An+iLibMMk8yionOU/WE/JWyBPsOsJAkyjJPCddnY+zFUEetsbBH1gbutg7lHnJMS6nu00Tb1LMKQKWuEy2u3m6PWZvErIS60Pk8XTcmhG6822lf1JuA5X6ZHNwW+X5R4Gp0ucRhGJ3K0i3TVwW0Z+OklMqc90KDT29AcC0Da1JSIS+Uzpe8dQ1e4hW9FWKZcJLs0Zi+yTuCN1kgTWdlj4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0LUszK8R2HDRUBK/tWgQksMd5kz9I+Kam+YnslKp/c=;
 b=y2I2VjNQ5yPcA+apT9cawK7Ycx6ePslXZDwzSLdLg1sxFsYSam5VQyJETLWOIqoCxeyrclqUdFMYHIIzR0vaUYQjcF6j3cnzuh6+N9YV/hLjBTxQOZjqGjXuj9/2TJUzrKsbR2aCW3fNeHH2D/SoYCnsEPj0KGxweFnBkxRzX/rHiWrtIJ3XkUrlwn+NyjMCuKwcUn4NJc8gFFt+F/JHVX3ZYPD9+Xw3GyHhKIGRMijjtlJL8iGy4PttE5utpxKsO4PK0s6Mu1AkVE3cl5e51CeMp01wkongVWBke8eKaUwx9f/L8QW0C9i8Jxj4AzpuTsRwplLIj+V36Eq96sdWCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB6407.namprd15.prod.outlook.com (2603:10b6:510:2fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 17:47:57 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 17:47:56 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] Re: [PATCH v2] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZx+Zqm1z+TUboUyiwT5j96Dz6rMYHPgA
Date: Wed, 15 Jan 2025 17:47:56 +0000
Message-ID: <29a3619cbade5b4df0dfd2c87a9d436bab2d4359.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
	 <20250114224514.2399813-1-antoine@lesviallon.fr>
	 <752b6575c3a8a6042bba51ad56a3d4b71c5a3bb0.camel@ibm.com>
	 <d47901b0-c0ed-4192-86a7-0afa847f892e@lesviallon.fr>
In-Reply-To: <d47901b0-c0ed-4192-86a7-0afa847f892e@lesviallon.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB6407:EE_
x-ms-office365-filtering-correlation-id: de6204f4-a1ba-4bae-92ee-08dd358cbe91
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?OXdLOHFJMVZ5WDBZZXJtVEZiY1JIcnJpbWlOR1ZCcWFvZWFka3RsMXpDVDNq?=
 =?utf-8?B?ZE9XTERQZWxOMmdMTTBPRkxDNFRnL040OWpUNGVhTHVkdXF2UkJiZmdUWE5O?=
 =?utf-8?B?elZyVkVWbDlHVTZRRHBYRnYyczlCdmhidFdrZ3dWeU02YjQvU2h4cXNxMmth?=
 =?utf-8?B?YWJzVnFhRGUvdFJCTzFhMzNLV2FRZXZYMi9pQ1VGRlJoTm9IMkpqR1FEcktG?=
 =?utf-8?B?YjF1RnJZQkE4YkNHY0U1R3JnYlRvcVlnWmQwZDNCNzdZbGFKTUorWjg5TXMy?=
 =?utf-8?B?WVZPSXpWMG8xdC8vQ2lEMSthOTdwZC9BVHkwRVRsUjluY1ZaeE44NXlrdDFO?=
 =?utf-8?B?cHo0WGNkZk9jaFlZTURMVDFIeVdLaWFadkRVWERSdHN4a2lOSWV4ZVAyUWNO?=
 =?utf-8?B?NnNsWHlCV2NwUGVJcVZ4MkNFSUc2b1ZkZjlUazkzVFNoelFXR0djVVZnMEJa?=
 =?utf-8?B?akIrTHhqaElCT0FldTg1VDRoWHVtY0dEeW1xdkNVcldDZzl1L0Joei9EOGZL?=
 =?utf-8?B?SkZUZE9hcE9RTTB2SlcrMDFud0lTN0hyZHUxY0xSeThUNnU4SS9QNUs4WWpC?=
 =?utf-8?B?czhKWVJnZ3grbkcxOVJqSmtNTVhVOHExb0s2c0ZkQ0YyMXdaKzBFVG5GK2l5?=
 =?utf-8?B?MWNKaFBpMHY2T01SdzliS2JzRHhoKzhuV2g1NlJOdmlmbTZ5N00raE1RNjNp?=
 =?utf-8?B?TXB5K1BaTUZTY2I4U2ZXV3hXeS82T0ljVTlhc2g1VkNwTTY2bGJjUlFLL1Rm?=
 =?utf-8?B?bFdzUHlFVnM4YlcyRG1xbHU1V1lBRzY0VnJFR2l6bnVkUWdqa1AweDQzcTFh?=
 =?utf-8?B?NEo4TDltc0xUTDVIT04wYnFSYXIybW1PZUViYStOT1hxblFmeDk4cUJKRlE0?=
 =?utf-8?B?TVd6Ylo4aFUxSENZTmQ5NmxSeHBONmNQZ0dDOFhIeEVsZHJTYk9GcE41WnM5?=
 =?utf-8?B?eVd0ZjMvaWx3NEtRMGxDSXJNVEJFd2lyM2lqaGVKcWZRdEp5QjhKeUdsbndW?=
 =?utf-8?B?Q3FmUjJJTk8rVHdqR2lDN1NLakJxa3RkdGlNTjNqNXdwYmt6SzJ2Y2p6Uy8z?=
 =?utf-8?B?enBzdEVaeW1OZ2NHbzROc2dPZ1lic095Y25kS3ZpeStxVmxRalZ0b2xXYURZ?=
 =?utf-8?B?T0crSHBSOVllTnFqOCtGd0hrRGJ0ZDB4Z2FxYVp3V0N4SC92RnV6WGNEdmhE?=
 =?utf-8?B?ZjNEdkdWUVZwRURmeTZWT1EyM1psSGZEdWpuVW15ZUhmdGlpM0N1a1IvdDVR?=
 =?utf-8?B?WVNNOWNmOURTbVQrLzErZXFLRWt1T0JBcDdCZWl5b0lOSTV2dTV3ZjJ2cmZt?=
 =?utf-8?B?SnlrLzFMTStoRENYMEg4Z1FWLy8yRm04VENsZ1ZVcFpIYTlzcmtwWlZaUXNH?=
 =?utf-8?B?L1ptY3pQY25VY3hCMlB1UkVseGdTODJ4R3I2L1RqMDI3U05Oa1poZ0NMNjlT?=
 =?utf-8?B?QmIwWmJVYWg0LzIrUzJKOXl1alZQMlZqaHl6V3FOdWYzYnJ0ZWN0eGtqQ3gw?=
 =?utf-8?B?UE9hQTkvc1hTamROSllwZFJ5c2crYXFKcS9xZXdHYk0rTFlPbHBVU09TUE9z?=
 =?utf-8?B?Q2R5dlQ0K0xTV3llT2F3b1h2UWxJUG56RGpIY0k5aHJsM2t4OTYzcm1HWGxQ?=
 =?utf-8?B?aVo0dkRYUzV4bC9SN3JWOUkweFpraEFLQkJoYzRaZHFHR3ZkeU9hTlJBQmg0?=
 =?utf-8?B?aWIxdjdFR2hjOG5lTXRVbWZZUEZWb0tESUc2Y2lldWh4MDU5VVAxSE53WWlz?=
 =?utf-8?B?dW5FR3dsNVA5bGRJWTdiN3J3cGc3UGhYN3htbHZ5QStTUHpHbERiWXhsNVJl?=
 =?utf-8?B?MHdZaklaZWlBSER0UnR3ZVdTODhURmhOODR0TnFWOTFUOGk5cCtHQWcvUWVF?=
 =?utf-8?B?alU1WGw3eUEwWUl6UWp2VytFQ0FOU3doQlVSVFdMVWx3bWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Y3A2NGY2QzJVUHdQUGUzR0laRStpYUFRTHovcDk3ZUlWMjBYOEdsaDlDaU9t?=
 =?utf-8?B?eUxrQmRLcGpEQ0VFaEhoaDYycXNDc3V3Y3NCMk4xb3pyeDFVNVpWYnNYNk5H?=
 =?utf-8?B?UEdkbDdXWGZ4a1AzV2JaSjRMa2d0eHUvN012aUdNWDZ6a0pud0ZmcFg1WlpF?=
 =?utf-8?B?Z0FXa21ES2FIK3Z0MThvMjBTTHlmckZvbWtiU2lCdUtaTFpWWnZiZitzUWc2?=
 =?utf-8?B?QlRJOVVaZ29yYUhIb04yZkFLUWxFeEZncmJOMXo4MUg2MW4zNE9CS0dFZFdm?=
 =?utf-8?B?WXROalRFRnVVcDJ5azJhc0hwcmRobEFZZlMwQUkwaFgrVlFXZWJQZ3labFZM?=
 =?utf-8?B?OGk1dTBSNXlWVlJXbGZCenZId0psQTFQMmcxS01JVFhXM2VWNkh5ZitBdHBH?=
 =?utf-8?B?cFpWS2dzaXdiUDAzTEVaSlNYT1dzaS9vR2lRdmZ6UHhrTVFiMjg2M1Jybzd1?=
 =?utf-8?B?RERFdGo0aXlUNGNaWWRwaWZQZENqeWxaSFQxMjJlaTg3cS9tVFRvcVFWMmxw?=
 =?utf-8?B?cFhMRlY1VjJuVVpPaUJpc0REdmt1WEhnR0V3NDl0VURuRTY4M0JQSTZxbG1J?=
 =?utf-8?B?Y1hsb0dZdU1RcWFiWUVPQkFRWjUxN0ZOZnRBRlc1Wno3cU9yQXBONTRTcHhl?=
 =?utf-8?B?TW5xK3l2eHlQemN3V3g3bmNLY01aVDNwbmdCeWdwZnZlOWNpbzJ1L0E4eHV1?=
 =?utf-8?B?blU3aTFzZWRObWNYaFNScmJlSnYwVzVFUU1Da2tZaVk5bXp5SCtPdmE4Wmcw?=
 =?utf-8?B?ZjJVMXduZHgxOGc1dGxMdVREZmZoamlsMnBOQkZvakVlRmpsOUhRZ2xmS1hL?=
 =?utf-8?B?dklWc3lscHZCOXVGbW8vckFpTEZtWjYrbkpXMXUyMERNR3lsaVA1dG9CYjlH?=
 =?utf-8?B?angwSXlkRUwwZXJBNXpXRjh6TVFyanc5YW1McUs4N016K1BwcXBVd3ZGbGtZ?=
 =?utf-8?B?OW9qeVhldVJtVjdWVW1tU09xU0toZVh1eXh3bjhlc1JCbEorK2lWU2o3eGkr?=
 =?utf-8?B?MDVrU08vUERBMnpwSDVwQUlhcTU1elV5OXZnL1RIYnlHd1J2UWV1UHFQQktu?=
 =?utf-8?B?SlhpMHFVbUJMbFRMOUhnRHBLRktVTnJMalhjWXJkR1c3MFQxeFJKK1JDQVpz?=
 =?utf-8?B?QmZtRjhrdlllK3JOZ2UyelVBZnZsNlY2bVhVVEVsSmx1bkxSbk4xalJTbUJM?=
 =?utf-8?B?TW00NjlkdHduWGk5WnYyazViRFJab09LYjRxK0lBcXFaYUtYSW9TRmhueUpM?=
 =?utf-8?B?RjYrSk11ZjRRNjQzUXkvYzdlM1BHOU0yZk1qSVZ4QWNLVDErbDN3V1pXRU1z?=
 =?utf-8?B?QUxGNCtIekNYNFh1MjdZMnJLdGY0aWEwbW9QYVdscG42djh3SGNlZUJjRmhQ?=
 =?utf-8?B?L2ZLQUNNcE5kY3RvKzZxOEp0UkFyMUNiV1o5RldsOFkwY21EemF4eDhjWTQ1?=
 =?utf-8?B?aVcyamgzeFo5RDVBa29rL2YrdDRLTGdoWm5QcjladVRJNXg2aGRNWGxhVkdy?=
 =?utf-8?B?ZjA2WFl0b0pucTR5WGFmSlh6THJPcnBXZUo3VXhKR1dPSlo2eFBodytuTGpy?=
 =?utf-8?B?bDBhNkVMN2tQTjlSeXVRdGNiYzNMUmdhSmp0eXZIS1dncVFNcFJBSytva2M1?=
 =?utf-8?B?WCsyNHpVTlMyaGFSdlVma3BrNHZOVEg4aXlvUkZXZjQzeTlSVkMyUzdPelhj?=
 =?utf-8?B?SkJYYlp2TmtyWmJMajlpd2U1aW1qKzh4MFJVMUxaTkZubm9ydjIvbjVtaVhp?=
 =?utf-8?B?TUpUZUhwRXFwZVk3ZjJXVUJuV1orVG5xUWhJSENSWEtQRktUTnltK2huZ3Iz?=
 =?utf-8?B?aExKZlExd1pMWU1SK2xvMkRiR2ROcHpHMnJrQ0JRcnozVXhwWXFja1R0dlZ1?=
 =?utf-8?B?UFlnOVAwOHNUbWQ0LzNNU0I5Y0pvODRBMkJMTFpLTkh1MWVaZ3hqN1FZZkYx?=
 =?utf-8?B?ejRBTHhWbVRzN2Ivc2I1cHRhNGVNL1N5K1UwQ2NBM1c1d09yeTUvOVhmQjJG?=
 =?utf-8?B?YXVsdEVxbktFZ2xlR0Vvb0UxbXlHUFF5Q3IwS3MzVVRzbEpSWFhvVFM5MW5Q?=
 =?utf-8?B?Nk1kaUVndXNPQmlqSW10TzNibnZ4RmNOZFVWS2JGRFVvU3hPWCs5bjhPVHBx?=
 =?utf-8?B?bXdqS0J4bEN3SEZacEdMcXdPb2ZqSEJzNlljN3ZBMUdGTHV5MDhVNUNIaW8x?=
 =?utf-8?Q?ZnsApd0iwytuwumByQhpX7c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9C3560AFB45A94B9625AFF7B647A69A@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: de6204f4-a1ba-4bae-92ee-08dd358cbe91
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 17:47:56.5136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXo9S7xGsBHtHdSIKotw/fVeSU2x0TGx5MRytGnlhZkywRn9XjBPFdqqZPs+AXCCLZV7HYPuqlLMIhYUQkYoJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB6407
X-Proofpoint-GUID: HhM0lJyoEPgohoWA072oqHSi5JG3i7Wt
X-Proofpoint-ORIG-GUID: HhM0lJyoEPgohoWA072oqHSi5JG3i7Wt
Subject: RE: [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_08,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150128

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDA4OjMyICswMTAwLCBBbnRvaW5lIFZpYWxsb24gd3JvdGU6
DQo+IE9uIDE1LzAxLzIwMjUgMDA6MjcsIFZpYWNoZXNsYXYgRHViZXlrbyB3cm90ZToNCj4gPiBJ
IGhhdmUgc29tZSB3b3JyeSBoZXJlLiBNYXliZSwgSSBhbSB3cm9uZy4gSW5pdGlhbGx5LCB3ZSBy
ZWNlaXZlDQo+ID4gdHBhdGgNCj4gPiBwb2ludGVyIGFzIGZ1bmN0aW9uIGFyZ3VtZW50Og0KPiA+
IA0KPiA+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjEzLXJjMy9zb3VyY2Uv
ZnMvY2VwaC9tZHNfY2xpZW50LmMjTDU2MDUNCj4gPiANCj4gPiBUaGVuLCB3ZSBhc3NpZ24gdHBh
dGggdG8gX3RwYXRoOg0KPiA+IA0KPiA+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4
L3Y2LjEzLXJjMy9zb3VyY2UvZnMvY2VwaC9tZHNfY2xpZW50LmMjTDU2NTENCj4gPiANCj4gPiBX
ZSBhbGxvY2F0ZSBtZW1vcnkgYnkgY29uZGl0aW9uOg0KPiA+IA0KPiA+IAkJCWlmIChzcGF0aCAm
JiAobSA9IHN0cmxlbihzcGF0aCkpICE9IDEpIHsNCj4gPiAJCQkJLyogbW91bnQgcGF0aCArICcv
JyArIHRwYXRoICsgYW4NCj4gPiBleHRyYQ0KPiA+IHNwYWNlICovDQo+ID4gCQkJCW4gPSBtICsg
MSArIHRsZW4gKyAxOw0KPiA+IAkJCQlfdHBhdGggPSBrbWFsbG9jKG4sIEdGUF9OT0ZTKTsNCj4g
PiAJCQkJaWYgKCFfdHBhdGgpDQo+ID4gCQkJCQlyZXR1cm4gLUVOT01FTTsNCj4gPiAJCQkJLyog
cmVtb3ZlIHRoZSBsZWFkaW5nICcvJyAqLw0KPiA+IAkJCQlzbnByaW50ZihfdHBhdGgsIG4sICIl
cy8lcyIsIHNwYXRoDQo+ID4gKw0KPiA+IDEsIHRwYXRoKTsNCj4gPiAJCQkJZnJlZV90cGF0aCA9
IHRydWU7DQo+ID4gCQkJCXRsZW4gPSBzdHJsZW4oX3RwYXRoKTsNCj4gPiAJCQl9DQo+ID4gDQo+
ID4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTMtcmMzL3NvdXJjZS9mcy9j
ZXBoL21kc19jbGllbnQuYyNMNTY2MA0KPiA+IA0KPiA+IFdoYXQgaWYgY29uZGl0aW9uIGlzIG5v
dCB0cnVlIGFuZCB3ZSBkb24ndCBhbGxvY2F0ZSBtZW1vcnk/IFdlDQo+ID4gc3RpbGwNCj4gPiBo
YXZlIF90cGF0aCBrZWVwaW5nIHRoZSBwb2ludGVyIG9uIHRwYXRoIGFuZCBrZnJlZSgpIHdpbGwg
YmUNCj4gPiBjYWxsZWQuIEl0DQo+ID4gc291bmRzIGZvciBtZSB0aGF0IHdlIGNhbiBmcmVlIHRw
YXRoIGFuZCBjYWxsZXIgb2YNCj4gPiBjZXBoX21kc19hdXRoX21hdGNoKCkgd2lsbCBoYXZlIHVz
ZS1hZnRlci1mcmVlIGlzc3VlLiBBbSBJIHJpZ2h0DQo+ID4gaGVyZT8NCj4gPiBEbyBJIG1pc3Mg
c29tZXRoaW5nIGhlcmU/DQo+IA0KPiBIZWxsbyBTbGF2YSwNCj4gYWN0dWFsbHksIHdlIGNoZWNr
IHRoYXQgZnJlZV90cGF0aCBpcyBzZXQgdG8gdHJ1ZSBiZWZvcmUgdHJ5aW5nIHRvDQo+IGZyZWUg
DQo+IF90cGF0aCwgYW5kIHRoZSBvbmx5IHRpbWUgZnJlZV90cGF0aCBpcyBzZXQgdG8gdHJ1ZSBp
cyBhZnRlciBhIA0KPiBzdWNjZXNzZnVsIGttYWxsb2MgYXNzaWduZWQgdG8gX3RwYXRoLg0KDQpZ
ZWFoLCBJIHNlZSBub3cuIFRoYW5rcy4gQnV0IGxpa2V3aXNlIGxvZ2ljIGxvb2tzIHNsaWdodGx5
IGNvbmZ1c2luZw0KYW5kIGl0IGNvdWxkIGJlIGEgcmVhbCBzb3VyY2Ugb2YgYnVncy4NCg0KVGhh
bmtzLA0KU2xhdmEuDQoNCg==

