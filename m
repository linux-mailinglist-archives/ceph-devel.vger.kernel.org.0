Return-Path: <ceph-devel+bounces-3513-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0D1B42919
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 20:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2C79488211
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 18:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82198369324;
	Wed,  3 Sep 2025 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g0Vq0Z+w"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9AB3680B9;
	Wed,  3 Sep 2025 18:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756925518; cv=fail; b=Qh8rOD14Rcdhi9DCvsEOF7BtpAJ1FEpdT5VCwb1gybWS3B1cMTm0Jv+S9AbGM2waJ36rzezOMNXb2i9q4K1IT6cHiJKw585GOFuoR+lctIfmjquvf/D2P88KoARc2TE/G48+VGJeNXA4mZsv0Evni7bhB8P0uHcdS7g87AdZh7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756925518; c=relaxed/simple;
	bh=0x8YQOLK0fkWZ+KhdC+QwHZ8OPza+0DCkpxuk1ru6dI=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=UndPsm+3rgN4/G4qHktrLe60NUSbjxaC+kcJs7GbVkd5DsKwk8d0G5RX20Fow/TT9t4NQhP1FcUjKAopIPmBsaOz37EPryUJ3D4RIs0ojwsVG7r8tiewH/ZOjZFk+mnx3VE2VSmK2xY2Hx9UmBFy4/lmCAKgjGpNo8uPlRnkUtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g0Vq0Z+w; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583DgU0R024938;
	Wed, 3 Sep 2025 18:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0x8YQOLK0fkWZ+KhdC+QwHZ8OPza+0DCkpxuk1ru6dI=; b=g0Vq0Z+w
	nYBezV3eC1m4MCdko8fxXQwxkpoBW86EV/+/kZPbM6jYqhmoZKZZ9lB8Q8XsYtrg
	Pm5uzEO+BhvWcKSnfxWGdh+hqCN6z+wuSF1QRZFVeiVwsmrc8YPjYuMhE6LIRiRU
	G9EZPYCNK35AZGcf2njkFekrYCUOqaJpRDf4LAifIUlDzlV4/x8/jPTfIYcjf/nC
	gl8SOpxxLaBNMCOl9ebv3WVe+1dug8I4Y20WVRC3WQ32TzNtW01G4mWDH5CKa73m
	5nSREYGw/JcC1CuHbkPuGkNT46p7U8ID8PU+4T8ZvnVJ1UKID9P5OSkOz8R8F5s4
	aE7SIrbUIyDeFg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usua5nya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 18:51:53 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 583IprY8023982;
	Wed, 3 Sep 2025 18:51:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usua5ny4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Sep 2025 18:51:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1FZgUq7i2aCJIagKwc8+gWus7rMhT77LuezovfMSEOpEKyZHgFsWIsDyEjZZlkN8M53lA+YQcyFL8ujR3ijXDsFRBQq/s0FHU3irwz+oCCnP3OBa96BBa5regzliVR+Rmr+ScCPsv8AvSZwLWPimx3lxIKaonJiP0Al7ns183OUOmwHgGkrS7dYqinsh61iN2lMLU6pMclqOy1J2PRVd5KT6nFqCVbBfrVGkHVX/8+h1870D4qLoimxBgCVeB9vNV1k/JQGqBEQv4hd4gVvOhBp3+mxMMHpJ/n8dsbmb+xvD7GHaVAK5fVXNJRntk5iph7168Te0gtPfSrppaCyIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x8YQOLK0fkWZ+KhdC+QwHZ8OPza+0DCkpxuk1ru6dI=;
 b=nfGEWZzHii0CCD/a4kAiKu13Xk+z2iDdjrRqBPXdgsTTNdI3TTWaSsyhl3p92RJlPkEDX0s0K+8DNjlyvf0wJDQHRS8Ys17wAYjxgZwcaVGDhvdfKPcNUEE43tiZOGhAVzqmopa5vEqN4QFn1Qxhqe7j4vVR61eRE7NXuiLeYNSEqMBiOej8AUcgTyed8931EvFqAlA1cOqw46fB4X+BYM1MerAPuFnm8smpJatp9u8kpr/7Ingnn5LByIHFBpA7xQH2TJIoPy7h8QHdEMivjqxwpduaz2GrjT5oK1D5cARqAHnlU0k5ChA9i7EWTvsjNT23vywNQikvsDUfRR6M2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CO1PR15MB4889.namprd15.prod.outlook.com (2603:10b6:303:e0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 18:51:49 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Wed, 3 Sep 2025
 18:51:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
Thread-Index: AQHcG1M1QePS1tl7H06UqQ3CqvGZErSB0PQA
Date: Wed, 3 Sep 2025 18:51:48 +0000
Message-ID: <1e0d2fb235e306fac4b003fc62c961405aef7c6b.camel@ibm.com>
References: <20250901151448.726098-1-amarkuze@redhat.com>
	 <20250901151448.726098-2-amarkuze@redhat.com>
In-Reply-To: <20250901151448.726098-2-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CO1PR15MB4889:EE_
x-ms-office365-filtering-correlation-id: af0d77e5-cb6d-42a4-5121-08ddeb1af055
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VHNzR2gySUZkY1h2WkFJakYyK2xDeXU3SEplRU1XN2NXYkl6ZmZlRVcya0dR?=
 =?utf-8?B?UVpPQnBHU3o1UmIwTStpMkRnWGdXQlhHL0EzZldaazVzVTl1bVF3VXkzRXI4?=
 =?utf-8?B?M2hicmZzZHYvcE1UdXZ2N2dEcW5FMDFDYklaTFlKRTRjREFTNGl4WWtXV3RL?=
 =?utf-8?B?UVBrbFBJNmtqL1lOdHJ5NU1vdlJUZm5tRHpIOGQydXpFTDRUdWlaQmhIb2JD?=
 =?utf-8?B?ZWx4QnBJNGxNeHN1dlpuRVVzclJ3VytSMWFMVFZkMHlMK0dyZ1A2L1hJclNM?=
 =?utf-8?B?cFVqUGxjM3hmSGNRNndrdlJ2MUpXcVRDUGNtaCtrWm51Vzl1RUFpVW04cmxG?=
 =?utf-8?B?cndIWTh6dVBXZTN2K3JWUnFvZy9Ta3pYN3l4UldvZWEwcnhvK09odVJhWmJS?=
 =?utf-8?B?NzBkR0k5WWtNdzBQVmJDNXo1K25ENFJQc3FZMHB6ZzVGK0F5RFZBQlM2YTl6?=
 =?utf-8?B?SWE3NTVTNS9qcGhiZ2xtQ0RXY2RJb0E3VzBScDJydXl0ODZGR3ViblMrNVdW?=
 =?utf-8?B?U2ZRdlg0TTllV1FmUjdLUHhMa3RRdXFQMnNrU0s2aGtGWDFOMmhqQmk3eTVv?=
 =?utf-8?B?QTdSSUJtclZ5MzRGdnZUVlpWcWh1UGp2SmtPUFJSSEovRFhGbXBSRy9VZEN5?=
 =?utf-8?B?cWt3d1NBUndzMUdESUpKaUxXMjdEVGs4dHBZUFB2VVdkMEYvemRUN3hWZ0ph?=
 =?utf-8?B?STRxNGVZZDYxNnN1b1lPVitKOG5iWUY4K3ZXbzNJUWpQUXlPenNPY2ROYy9p?=
 =?utf-8?B?ZGdkRWt2UkFUOENqcm03QlVpQlNjSFBKcXZaMS9ndHo2MjZNMlAzZ1hHaUp0?=
 =?utf-8?B?dFlLSmw0TFpiNTkxRHVDdjhTQWljcHRFZnhPdndJUGZHRkpzY1EzS3VOQjY5?=
 =?utf-8?B?alcrSWJ1alV5c1Qzb2xWaE9rK0RSSmI4RlJpdWwyWVNOamZWYzBFdmFwSzRk?=
 =?utf-8?B?bjV3QnlaYjFMbldvWFkxdXIzMFVrc25LbWNHVDcvVGNsZlZRUmFXOEJOZU9F?=
 =?utf-8?B?cHJzTC9qTFRYV3QxRUxydzdZSEVjZXgvWkhxSzJNZTFBNHdJZkFROWI1alFp?=
 =?utf-8?B?MkFTcmhJSXpMd2FEOGNEVzRCbDVMaEswWm9TS2MrSWtyd0pwVmtZZEpnV1dW?=
 =?utf-8?B?di9WUncyOWZEMGF3ajkvNlYwUHlGZSt2aEU5SFV3YTVZanZWU0d1R1pDaVEr?=
 =?utf-8?B?QVF2dVg2bkR0eFVKTlJ5RUZJMHk1NGZ5R3hNL3h5eHBMeldLMFdIdTlHLzA2?=
 =?utf-8?B?VHJ1K1FibEx2Y0JVL1RlU1IrQnduWllqNVVUZFVpZXMwT0RaaHJYWkJ2bmhD?=
 =?utf-8?B?Qi9MWnhBMitVRm5UQlVnTXN4TEgybmUrSmFaeHo3a1A5QWh0bHJtYzU4UG8w?=
 =?utf-8?B?am9vVWljMVVxWDRPUXU1L3djK1FCbDZaZGZMcm1aaXBNb3hJTDc0b2ZZOXcy?=
 =?utf-8?B?M1d2VG1Dcy8vaTRacThNMFFucjVKeUpDamtuVHlHOUJ4VjVwaG5DRGsyNE1w?=
 =?utf-8?B?dENXaEtkZnpjeWtjK2FhVDhERXBaRWovRTJpMWR2NWtpNUdTVjBrc0lQVXUw?=
 =?utf-8?B?OWVMZ0pBNFp1ajdicHpESmx6bzJScUxzRklsVXUyZjkvNWs3aHpZcVJKUWdl?=
 =?utf-8?B?eTdydDlNUXd4TmVuNmZGQzlRejhvWllNQ1pyOEZSckdmTzVkeXJ3Rkk3ZWht?=
 =?utf-8?B?Vm15NDd0bC8xcHhwR1Y1WndPa1dEb3FWVWtMZHZBQ01TNTZxZVBxaUxnRk0z?=
 =?utf-8?B?R0pZRGRpUlpGaVRuSklFSWpPN3hObFdZTmpQbHNkejg1UTVjUkNqMTNtVkNW?=
 =?utf-8?B?RzQ5OVBYUlBTVUl2Vk1UZjI5Q3g5cDN0eFErcVUyTDNudzcxYi95VW1nUGgw?=
 =?utf-8?B?MlQ0Y0RkSFBtZUNKbkRsN2R2bWVyN2Z2Mnd3SDYzenF1akhJb0RYTTZZdnpy?=
 =?utf-8?B?R0pzVStSM1pVUHVmcHZ6ejNZaGNtRDdjUmkzdE5pSFNCVFhidUpNRm9pUDhy?=
 =?utf-8?B?eEV1cjNicG9RPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MmZLUWVrSU5FNHc1VmdCQU5WcmkreGVmckRvMGpTUS8yMk81YUFhejA3b051?=
 =?utf-8?B?QXRkMmNmbllYMUJnVTlabC9pdE5KZDVuU0pGTVhaakw2bXlFUXRERStWRjZY?=
 =?utf-8?B?N25hc1RUMVpzNUNTVjBJa0lFL2EyT0FTSGpLM0RwQU85VWxHajBiRHhGM25h?=
 =?utf-8?B?YlBsUFJ5Qklpd2trUlNUd3Z5Y09RSXE5RGFoUU1mS3JLa0EzbGRlZjF5MjFQ?=
 =?utf-8?B?UlhBUDI0d0VObGhLQ05qV2YwQUxhdEJpZ01JY2FXWTV3SVl2eHJqUTBIblkr?=
 =?utf-8?B?MVlyTlhtWnV2TThha0lGVEdlZGd1UGZycWdRVVNXeXhESVlwQ3RUU3piZ3JG?=
 =?utf-8?B?T2VGUUlUQXd5WURkN1RhYVhMV2QxRDBOZ1l5Q0t4U2dBQ2NhMVp3Vkd3Sngv?=
 =?utf-8?B?dk8yNi9UZ21rZVZOeWVUVTZNRGJrdjBXSjJBaGRxMWNoQ2RwbGYyMkNrc3kw?=
 =?utf-8?B?amkzWWcrakdQeUprZkxTMDBQWWZraFBMOVM2NW0wbzNLOXYyeU9BY0w3T1Ri?=
 =?utf-8?B?Q3ErTThETExlTVFmWVRNVUd6Vm0vemVJZnNteHFhbSsvWkZsMjZVK1RwaHB4?=
 =?utf-8?B?NHR1amM4bmlURi9jRm1GRVZBWlZ6WlBPVU40cnc0T1grbXpOa3FMRTdQdUQ1?=
 =?utf-8?B?aGJWM09MeUFvakhTQysvS25YUTd0RG9Nd3BFZlg4OWxaU0JQNW5JMzBHWk90?=
 =?utf-8?B?QWRNK3dPT0VkNlo3S2tsd3g2cW5ia2UxQ1Jkck5VSEYrTStUaU8rcEswUS81?=
 =?utf-8?B?VXJnc3ZPUjE2RDBlZ0w5ZlZjZng4bWVZcUtKS3Y2ZjlvTDZRTEtqWUNHeVJa?=
 =?utf-8?B?cXV0dCsvUy9IeEdJQitsUmJHN3lMcnpFUHlMeUFWMk5yV1JxdHhyWEZOVlUy?=
 =?utf-8?B?ZGV4QXdsMm94UnlIU0hxWEU2cS9Xa2xBZG8yZXdEWGI5WFBvZlNxT0JxWGM3?=
 =?utf-8?B?bDZHMWNDZHJVTFg4Q00yNThROFoydHV5R1l1emRTS3d4WlQxT1I5MGw1M2U4?=
 =?utf-8?B?bjRDMi8yakYvSjh0WkZ2VW1uajdVOWJnOGdscVFDNUNlN2NmVHh2OEpZTGNT?=
 =?utf-8?B?dURmdHJhNzhiVDd0T1U4cWVOYTd6OHduckkxWmFyUmtnaGVLcnE2R21JaGlG?=
 =?utf-8?B?aGdQR1hCVTJCcFdzdVdDdkRuZnNBVE1YQmh0cm5VMVlvWXpaSzBUNnpubnV1?=
 =?utf-8?B?YzVFL25rWGZaYTVyRXNDakhUUG9TMmM0MEVBWjU4TTFGRW95a0NGTjkvYm5q?=
 =?utf-8?B?ZlE4dkRRcXZpNWZaUXZJa0tacFlLMXg1bE1yQ1ovTm5kdE82SEN2b0RzOXky?=
 =?utf-8?B?T1ZiVFozQ3dJTHlva3VabWJ5VmdCNFlCTEdoMFRaK2Q1cktvbzVKdCtaaHB3?=
 =?utf-8?B?YUJqTG1SS1Axa3NOZFcwVit4ZnFZSkZDeGNIWWxQeGc2ZjhFQ3RpL0JtVE1z?=
 =?utf-8?B?cXExaUxCcnZQZVY0bmVrV1Z3Z2UzZzlZMkJGV0UxQnZuV3Z0eGZUaGMxbXVr?=
 =?utf-8?B?ZCtlcVJZcUUzQUZYckV5ZEdQZmxJNlJReFIySzc3SUlRTUt2WTd4cjU5d0tt?=
 =?utf-8?B?MDhFSUdvb0FZZ2dMakg1OXU4NFJKZWxYcEhkd0tPZktNbGZhcExEWlVMWEVu?=
 =?utf-8?B?MUZTcXA3b3AwcFZSaEtycE5PV3dZQTU2enRGV2VJU0NrOCtmOEFDN3d6d29J?=
 =?utf-8?B?UkljUFFCdXhNbXVtdlhnbHhxd25kODZKUFB5dHNXN013dG5MZTdScmIvclpw?=
 =?utf-8?B?YjFFaXlZT0tMWDVlQTMxVWdEUjltT0pyNWhkZm1XSDQ3eUhaZEp4bGpQYnVS?=
 =?utf-8?B?OXdnVFRWTkZXK1JXSVE1UmUyVnlpZkQyTy9SdEhraU51MkFhRXpwSVZUcHJL?=
 =?utf-8?B?U1RwbTErUExoNE5TeUNNd2ZMeUNWS1NUWjFEb0VKQ0xqRWNDWGJsKzhkcGFM?=
 =?utf-8?B?L2dldkp6WS9sK2Z5STFxalVKU0JNSE5Lc0s3LzFIdmtmYlpmV1NmOFhBK2F6?=
 =?utf-8?B?QTNSbFhmT3pyNUZlTWdTQjVXT2d0RFg3Q0lZd1VOdXArOGQrMkJLWUpONU9W?=
 =?utf-8?B?b1plVzRjUUI2OGJRTmxrYzdjWXUwVUtYaTFuQ1FoWS9rMFpsVEhXTDA3MWlC?=
 =?utf-8?B?RzZRWCt0WUVOODJqSzIybWdVQ0hHWWZTRm5NU29EWHpscXpkcWRkTkwxWHBi?=
 =?utf-8?Q?3MDqgfTWdbkb08S3V5BLtfA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4CBE9B11A91984AA845F75EA82B56C7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: af0d77e5-cb6d-42a4-5121-08ddeb1af055
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 18:51:48.9920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYSIbYswg4L40GDMrx4gKW6QZwMXeipwpeTfHR/CggzI6GLuJAWj+qFebpd0kCHNWlgIhKV2ojxYrE4TPwqwbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4889
X-Proofpoint-GUID: I2hQiDGL6EjR1fz_GDDD121y4qVKfFMn
X-Authority-Analysis: v=2.4 cv=U6uSDfru c=1 sm=1 tr=0 ts=68b88e49 cx=c_pps
 a=Pyh3CA1es36lNkRVDm3xrw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=ssNVhGyKZhjaYj54hyIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfX8zM8Hv5bDu19
 6xYTdFu5+mUTx1QEdoiJ6AEY2NtU9BJ0zv8yZbkxdNU9hg862DUFI+o3hQfoi3GBe8Ec7dj5Ngn
 QSO+TZjNhU3dMdm99GGVz/nETkJ+a6xfjR2rPJAC41rXr5I3qVKCINVS9Ymqae0fjWcLP/IKpKm
 jEH8mz4iQfEr57Xdt1Ia/kzDKiQqTkiwDt7UgZvW8bkbrVQDZ+s1ACGpoZSGkF5zeXFHPubUZZ4
 viU5SF0IRE6bmCOTd3ZFgtMuJMWMrAFoVdl5zWlVm4Ddp1NUBIunDvU523VgEf+MAFzeXxazEiK
 MRdtXYYDiAhZmSlRb4XcrU1SR27jvQBMuwVvZt9JLfLrom4N1kfyySpGMEYVNFfMwY+CH9s8hmF
 HvbklT8J
X-Proofpoint-ORIG-GUID: Y4xc0pznBTDgmoftAixWGBkWJIKw9EfM
Subject: Re:  [PATCH 2/2] ceph/inode: drop extra reference from
 ceph_get_reply_dir() in ceph_fill_trace()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_09,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508300034

T24gTW9uLCAyMDI1LTA5LTAxIGF0IDE1OjE0ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IGNlcGhfZ2V0X3JlcGx5X2RpcigpIG1heSByZXR1cm4gYSBkaWZmZXJlbnQsIHJlZmVyZW5jZWQg
aW5vZGUgd2hlbiByX3BhcmVudCBpcyBzdGFsZSBhbmQgdGhlIHBhcmVudCBkaXJlY3RvcnkgbG9j
ayBpcyBub3QgaGVsZC4NCj4gY2VwaF9maWxsX3RyYWNlKCkgdXNlZCB0aGF0IGlub2RlIGJ1dCBm
YWlsZWQgdG8gZHJvcCB0aGUgcmVmZXJlbmNlIHdoZW4gaXQgZGlmZmVyZWQgZnJvbSByZXEtPnJf
cGFyZW50LCBsZWFraW5nIGFuIGlub2RlIHJlZmVyZW5jZS4NCj4gDQo+IEtlZXAgdGhlIGRpcmVj
dG9yeSBpbm9kZSBpbiBhIGxvY2FsIGFuZCBpcHV0KCkgaXQgYXQgZnVuY3Rpb24gZW5kIGlmIGl0
IGRvZXMgbm90IG1hdGNoIHJlcS0+cl9wYXJlbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4
IE1hcmt1emUgPGFtYXJrdXplQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9pbm9kZS5j
IHwgMTAgKysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvaW5vZGUuYyBiL2ZzL2NlcGgv
aW5vZGUuYw0KPiBpbmRleCA0NzBlZTU5NWVjZjIuLjQzOWMwOGVjZTI4MyAxMDA2NDQNCj4gLS0t
IGEvZnMvY2VwaC9pbm9kZS5jDQo+ICsrKyBiL2ZzL2NlcGgvaW5vZGUuYw0KPiBAQCAtMTU4NSw2
ICsxNTg1LDcgQEAgaW50IGNlcGhfZmlsbF90cmFjZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCBz
dHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCAqcmVxKQ0KPiAgCXN0cnVjdCBjZXBoX2ZzX2NsaWVudCAq
ZnNjID0gY2VwaF9zYl90b19mc19jbGllbnQoc2IpOw0KPiAgCXN0cnVjdCBjZXBoX2NsaWVudCAq
Y2wgPSBmc2MtPmNsaWVudDsNCj4gIAlpbnQgZXJyID0gMDsNCj4gKwlzdHJ1Y3QgaW5vZGUgKmRp
ciA9IE5VTEw7DQoNClByb2JhYmx5LCB3ZSBuZWVkIHRvIGRlY2xhcmUgdGhlIGRpciBwb2ludGVy
IGJlZm9yZSBlcnIgZGVjbGFyYXRpb24uIFdoYXQgZG8geW91DQp0aGluaz8NCg0KPiAgDQo+ICAJ
ZG91dGMoY2wsICIlcCBpc19kZW50cnkgJWQgaXNfdGFyZ2V0ICVkXG4iLCByZXEsDQo+ICAJICAg
ICAgcmluZm8tPmhlYWQtPmlzX2RlbnRyeSwgcmluZm8tPmhlYWQtPmlzX3RhcmdldCk7DQo+IEBA
IC0xNjAxLDcgKzE2MDIsMTEgQEAgaW50IGNlcGhfZmlsbF90cmFjZShzdHJ1Y3Qgc3VwZXJfYmxv
Y2sgKnNiLCBzdHJ1Y3QgY2VwaF9tZHNfcmVxdWVzdCAqcmVxKQ0KPiAgCQkgKiByX3BhcmVudCBt
YXkgYmUgc3RhbGUsIGluIGNhc2VzIHdoZW4gUl9QQVJFTlRfTE9DS0VEIGlzIG5vdCBzZXQsDQo+
ICAJCSAqIHNvIHdlIG5lZWQgdG8gZ2V0IHRoZSBjb3JyZWN0IGlub2RlDQo+ICAJCSAqLw0KPiAt
CQlzdHJ1Y3QgaW5vZGUgKmRpciA9IGNlcGhfZ2V0X3JlcGx5X2RpcihzYiwgcmVxLT5yX3BhcmVu
dCwgcmluZm8pOw0KPiArCQlkaXIgPSBjZXBoX2dldF9yZXBseV9kaXIoc2IsIHJlcS0+cl9wYXJl
bnQsIHJpbmZvKTsNCj4gKwkJaWYgKElTX0VSUihkaXIpKSB7DQo+ICsJCQllcnIgPSBQVFJfRVJS
KGRpcik7DQo+ICsJCQlnb3RvIGRvbmU7DQo+ICsJCX0NCj4gIAkJaWYgKGRpcikgew0KPiAgCQkJ
ZXJyID0gY2VwaF9maWxsX2lub2RlKGRpciwgTlVMTCwgJnJpbmZvLT5kaXJpLA0KPiAgCQkJCQkg
ICAgICByaW5mby0+ZGlyZnJhZywgc2Vzc2lvbiwgLTEsDQo+IEBAIC0xODY5LDYgKzE4NzQsOSBA
QCBpbnQgY2VwaF9maWxsX3RyYWNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHN0cnVjdCBjZXBo
X21kc19yZXF1ZXN0ICpyZXEpDQo+ICAJCQkJCSAgICAmZHZpbm8sIHB0dmlubyk7DQo+ICAJfQ0K
PiAgZG9uZToNCj4gKwkvKiBEcm9wIGV4dHJhIHJlZiBmcm9tIGNlcGhfZ2V0X3JlcGx5X2Rpcigp
IGlmIGl0IHJldHVybmVkIGEgbmV3IGlub2RlICovDQo+ICsJaWYgKCFJU19FUlIoZGlyKSAmJiBk
aXIgJiYgZGlyICE9IHJlcS0+cl9wYXJlbnQpDQoNCkkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8g
Y2hlY2sgdGhlIGRpciBvbiBOVUxMIGF0IGZpcnN0LCB0aGVuIG9uIGVycm9yLg0KTWF5YmUsIHdl
IG5lZWQgdG8gbmFtZSBkaXIgdmFyaWFibGUgYXMgcGFyZW50X2RpciBvciBzaW1wbHkgcGFyZW50
Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiArCQlpcHV0KGRpcik7DQo+ICAJZG91dGMoY2wsICJk
b25lIGVycj0lZFxuIiwgZXJyKTsNCj4gIAlyZXR1cm4gZXJyOw0KPiAgfQ0K

