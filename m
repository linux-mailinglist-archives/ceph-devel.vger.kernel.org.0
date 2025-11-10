Return-Path: <ceph-devel+bounces-3976-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA04C4902C
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 20:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56BA4188722D
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Nov 2025 19:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A634335543;
	Mon, 10 Nov 2025 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZHjnJ6hL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7456335060;
	Mon, 10 Nov 2025 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762802929; cv=fail; b=IrHhrfdtLgDddCxUmeRHy+JSxn+QmFsdbcUzmyIi2RtbUmqEKhovGfi02C6Ea+kXMmyNCK0/uNw2Q9jMsFTelD7sHtwigDSNDhXb0QvMvX6iOYfVeNEBHwpj/exc6N2iwf4ndZeX3l3XIygppOgWubA8pXZsUhLCCw6vq1yMiIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762802929; c=relaxed/simple;
	bh=XBMXdr0gzmB91/f8b9fYL2hzbbxxM+DQTLThSkjMTEo=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=qI9ja+uvXV0l+V6B6ElmZcMyqxN23PkFqSF60tetdDCDsuedYA6UV6gWitYa38jDV8g1pKp3YvfpoX6BJ4SPeh/ecQ4u/oM1jmQOBe7tlZ7F9ZUKHjKN+64eYE7IYRbr77/wX//RLopxd6Ns9Ld8OYJxtY6NMKNbbTG9WtH20Qc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZHjnJ6hL; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAEZdE4011360;
	Mon, 10 Nov 2025 19:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=XBMXdr0gzmB91/f8b9fYL2hzbbxxM+DQTLThSkjMTEo=; b=ZHjnJ6hL
	GhNW5Wobpbch3CA4Rn/QcMHG4AZT5O+Bb+B+eei+f/iB3Na5cD0U1Cz5/eQsiS/O
	lVEW+8Mb3vPiUhhfxCS/6JHVI4OB15zPLHSJ7fMEGiynX2+4tcIvCTpOQ0zhUbUT
	HpIuGSVogJd2XX14SKtQAEur85MrLEXdcSJJpkdSXp0R/6ozrIjh/0HX3jTLU6+W
	4IlwJDJe1dnQ7hmcUHRBD6NLaG5+hZobn6HVf5u56tdMqKcqsAIW4xlbqiifybmq
	0Pw/FJQ9HIxhGPwkWPij+MT6COdvijxs6BAtOm4mdRJ/+JPY+S4QS7CD7hVZobEk
	DYr70jdodxgGSA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m8030y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:28:40 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AAJIOsF029294;
	Mon, 10 Nov 2025 19:28:39 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012005.outbound.protection.outlook.com [40.93.195.5])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa3m8030v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 19:28:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apAkg+pMYRhamWCWBbmh4SlzOPVSQZ7JPxrXLs3KyXa02n7x1eKJ/YZAkzbbzxI2sUihzQ5oaf3DiNEhslxnjNyyluk9roarDlzjMBb98zi+OG4Hybph+0zatV2tGyh2b4zvhh9WdU2ZNxVd8qOjActUDMxNDlbDc0rdgJRhadv9iaJ/rXzeYfVJGTBkUGiSbNdMZtJ9jnGjS2LqKfOu1cYjX8Fn+6EWug4gaZL24irf2QwqL7yv2wrxMDChATGvO6kIfXbUrKHzeZTsMqA2yU/ZKC19g1Vz2t+4KbNNeqo8nUK/AUmonkrv12F6Qo0hZJU7lCqAUCjf/IHMQaZmog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBMXdr0gzmB91/f8b9fYL2hzbbxxM+DQTLThSkjMTEo=;
 b=YMzzVp4DxUg4S6l6lAiaZ5Q7MNy7MMCOCp806hx63a7lzBdKoVNpkq+8Ge5978KaSBD9riaFvKFNfiz+nuSsSh537q62ZghgA21ULRfGRtgrONkayG0kxm588hzH4ps7/uNMuzz2nLsj53GXq2CBhtLLRnvT2utIghdDssYNi3D2Sh1JDh2ZFXgojeInC4r3WnKx5f0J47f9fFOsW4oHKq0+yo72JdYLtAYyRhMOy2+eiJLF7VjDtwANHQ3MKF8OKIYn1I4fVYN1PQNntbELO+K/BBTcFJZbISlWLNboeUO5LRt/it83zD38KfNgrq7s4G6iD7ypCwQmhRIrW7etxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM3PPFBE7A84C80.namprd15.prod.outlook.com (2603:10b6:f:fc00::43d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 19:28:36 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 19:28:36 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "nathan@kernel.org" <nathan@kernel.org>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "nick.desaulniers+lkml@gmail.com"
	<nick.desaulniers+lkml@gmail.com>,
        "morbo@google.com" <morbo@google.com>
Thread-Topic: [EXTERNAL] [PATCH v1 1/1] libceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcUlDyd/DWtiI+l0+MnsNIsa6gGLTsS8eA
Date: Mon, 10 Nov 2025 19:28:36 +0000
Message-ID: <8d1983c9d4c84a6c78b72ba23aa196e849b465a1.camel@ibm.com>
References: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20251110144653.375367-1-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM3PPFBE7A84C80:EE_
x-ms-office365-filtering-correlation-id: 0aa9564f-0435-4cff-a2b2-08de208f57fc
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VG9GVDhpZVF2cnhaUFRqY3BWRmJuTXkxN1Nqdm10c2swbFB5RjVJRWFrYk1t?=
 =?utf-8?B?OXlYNzhhMU9RcFJSWTlDbDI4dlNDMlk4NnZmY0RneSs3TjJzRHNGRzlyMHgw?=
 =?utf-8?B?a0RSMVQwTlowODBnWFlPSFBNYlZIYkNhbmt5bzd0Ymh6Y2tDMEZnS1Q2Vlpt?=
 =?utf-8?B?UE5mclIyMUdOWU1LVWNYcEFWRmxzOGdBT0dxM0VPNGNzVWxMeVNOZFo0TEsv?=
 =?utf-8?B?a2I2TDZ4cnlFOHBLMm92cVBHN2k5aHdXNGdPUTdFeVhNeEcvWHJ1TDlySGZP?=
 =?utf-8?B?VTNNdExFZWIrNHNLeDBiUHZWV2w0Y0ZraEgzbGErQUJCaERYeFA0eU8xeXVi?=
 =?utf-8?B?VVJudFFSbldENlBHbzN3RmN4d0FoK2hUYmQybE9DamJmMVl6V2dTa1Z1WDc4?=
 =?utf-8?B?Rko1WU42OWtFVVRqQlhXMmthRG5xSUtuSkZGeFR0dXQ4bm8ydjV2amMxeVA0?=
 =?utf-8?B?TU1NdVV0UWRhK2ZuaTZ6ZXBRVnZWZ0NrbituTElLalo2QkQ4THRWdUhIN3N2?=
 =?utf-8?B?MHVuckNJYWZZYTRCR3VTNUJmYmVXeUloYlErOUVYU1pkUlBCTSt1dGVMeHBN?=
 =?utf-8?B?ckNsVHovcCtGL1daeHh3L3VmalRJaDdMSDJzUDdnNVR5UnhIQkJKN3ZyZjU1?=
 =?utf-8?B?RVY5eithZTRUenNBVDlYZ0xvRlpvS250ZzkyRnNsZGxKM0FpY3VxQlUyMllE?=
 =?utf-8?B?RTNwcFQ0RThxQmsxTlhRaDhZNnAxQWRReVpLUE0zdy9UUmxJTExNVUlHZzNv?=
 =?utf-8?B?THRqL0dFUWc4WEtzY1Zmc1MydXplTUtlRGJ6Rk9tejlFb1JZclNVNVo4UERh?=
 =?utf-8?B?Smd4Nk9HcFVuZ2xkZ3NOR1B0K2pnS2hrME5LZFBNa3kvQi9tWEpGblVCNStv?=
 =?utf-8?B?RWJienZqS0RROSsrMmpaN1ZQNFJsUWoxZWcwbG5MMTFaQ3hhR2RnN1lWR0ZV?=
 =?utf-8?B?bVlGZ0ZvcSs4bE4vQUZDeFF0cVJUUVVQNnFWNUlQeS9TNGcyZGN2TC9vZmNm?=
 =?utf-8?B?a0l1L09zNGNoVE9wdjB2ZlNFSmwwcXpoN2dySnNvalJXbnNmU3hMNmE2ZXJI?=
 =?utf-8?B?YzlnbFdsb2FLa0p5UmErMWpqWkMrSnpUalFYMnZmV285VWhhemRzQngzNkpV?=
 =?utf-8?B?WjhWeE8zRmo5aXhaZXFDdXpJSTAvaXJsVEl2bWlobm1HR1cxNUt3STBlVG9V?=
 =?utf-8?B?bExjdzRzRGJydE42aFFxUXR3ODRQVUJkM1RsTm80YUVHbG9KVllpaTVGaEl6?=
 =?utf-8?B?ZG5BVEVRZTdsQVNzdnB3cWlJUmdNV0pmR2xVc1ZjT29lWnVRMVRUNmgrT05F?=
 =?utf-8?B?Y2JVVlZaZ2pFQTAzUFBHRkxDL1M3aDZFaElXTy9FaDRkay9odmlCZVVjOFR2?=
 =?utf-8?B?c01DRCtMeFY1TnYzNmc0cU9CQjdoYnhkU2VuTllmN2VMeHdhbk9ZcHZnbTZv?=
 =?utf-8?B?aUhRa2RyS3c2QXM5VTlldS9PUUlLNThhZStLT2o2Njh5MDd2SlFTSElDU2tj?=
 =?utf-8?B?MmxiM3U4ajZkMEJ0SFlOZUhGK3dFRGZUd1lHbEJUNytEU3FrSWovNHEzUStR?=
 =?utf-8?B?YjNWUXNFTmxJSWNjYnVoVkx0eVdUbmMyODJCVUNNVGF4RWxicUZSaEhkRTFE?=
 =?utf-8?B?dWlFTFZGQzFVdkdXZ0poMXBhSGtIYzByTTZDOGJ5Lys2b2hjWU81RVNZMzRW?=
 =?utf-8?B?YlY2VWREOWJGRjkrUUd0UnlKWUx0bng2dTFKOTNwc3Y0QUowSGlJSkJtY3A4?=
 =?utf-8?B?eGJnekIwNUd6V3ZRZnMzWkJQbStXOU8wZ3VPS1cyODYrSE53ZWpqcTBOTzdy?=
 =?utf-8?B?TUkvYUFWWmxVVXQyRllSb3JSN3JxNXB3Vit2VFplM1Y4ME1OT1pvRXFzaDht?=
 =?utf-8?B?OXJnUFZ0ZEkvOGFJazhWZERxMER5N2ZraXI1MCtaZWlobFViNS9jLzB3MkFJ?=
 =?utf-8?B?SXpzSDVpSTRDYUxHWURhN2FwYllYNklKbDZVb2xHTnpQd0h3eTJpeUVrVVMx?=
 =?utf-8?B?YVJGYkpaU0RMeGJTMUoxOW1XR2FSaEREWENSNmwvbmozL0hkMGFKeHBCdU9Y?=
 =?utf-8?Q?OUn4Vp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R2w4Yjh1MWlzOC9ON3ZGK1pqRVAzT0NOVU1iTUFyTzJBdDFoMEpDMjBCVnpT?=
 =?utf-8?B?WVVEMW9BclVoRzY3cnZrOWp3YUVkVmNLaGFDT3lHWWovMjlGSW9NdGE5SzY5?=
 =?utf-8?B?Wk5naVJCeDV4Vzlxc1RFN05TS2J2a3kvMWE2bFFwaHl1bEcvTDM0UFBVdHlP?=
 =?utf-8?B?aHc0bnFSWTdVTCtlbkxjQWpzNmJBRXR1R2U5emZtVTVSZDV3MW5CU2tWak5a?=
 =?utf-8?B?QmUrY3FOSWpwMGFxcWUyRG0zOGFta2llbGh6TFRBRVo0N2UxeUN3V0NFRWNu?=
 =?utf-8?B?NDZIQzBmRUZJYVF5TkdrSlgwcDBZYTdySmJqcllzL041b05QRmNuRjJxaTBi?=
 =?utf-8?B?RTB2WEZiRFFHMC96M1dTbElVRjdQanRLNFJ0cWl5azNFdVQ2alg4N1VyaGdk?=
 =?utf-8?B?TW1GT1BtVDErNUFRVy84VUtWOXZuT1JzaE9rM0NtSjZnMFcvMEZGcGJjUC93?=
 =?utf-8?B?RzJkQ3h2T2kxM0JqUzJqbjVxTHNqUC9uUXBNcnFiRlQwNEhYcHpqR0xaV0pv?=
 =?utf-8?B?ZUE5ODFRcU9iSUhJR05VRkZkRTRuOTlDZVp6dUhqcWJpNE1heXg1UGlaaGw0?=
 =?utf-8?B?SWo3c0N0MmlrcmFPQ2RPVVB1K2szUVoyUVNIRGhHTHJSU2VISklTL1Z2eU96?=
 =?utf-8?B?c3MwejZXN2YxQ3U3ZUxPSitFUUkyYU1JWmY3SzYxdDlGQWVhUW1uRHdZS2Jr?=
 =?utf-8?B?L3J0NVZ1T3lUYkdHbnRBUGlGSTNUNVZNb0pMTUxPUzJBOHBTNFBEYmpzMnQv?=
 =?utf-8?B?VUlyS3dpRTdsOXZCV1JFRklmRk9QN3lRVm5Ya0MrbTBNYjRxNGRabmxsUkR3?=
 =?utf-8?B?Nk4xQkZJYlk5NUt4bWFDbWlEUlNjeFNoZVFYdGU5YW5kUDNjODNKbmNnR0lm?=
 =?utf-8?B?eEdCSUhUcXF0VmJHREhGc20wcjJXYXVmMjMvRnQ1Y3orVnlzZko1c0NXRDZ1?=
 =?utf-8?B?Tm5kK1V0N1AydnBSVUtOWGxvZnlodGZPSEduRnYwSVFqVTJ2dWlVeGtnckFv?=
 =?utf-8?B?Zk5ZVTJUNHZXQUF1bEcySGpaS3k1QWxGZnBOak5BUXdmUjFGcy9Pam40NDV0?=
 =?utf-8?B?d1VVS0xHTm1nNE4zYlVpOG1IQ1N2MEl1R3I0RzE3RGdJMS9SV1ByM3hscGhE?=
 =?utf-8?B?ZlA2Q1I2OC9wWm1jTmxBNHFiQlQxNlVZSnpTZ1FQTWdFRlVUeHh0MFgwczJz?=
 =?utf-8?B?dHFuQ2dCdkNjQU5oZTNVNDk1cThYeWxWNlFBVjd6RllyNXFOVGcxK3hlWitm?=
 =?utf-8?B?UVRQakh3cVR5UERtUlJSMmVsMGdjbjQ0VU5tSkpNL0RJUEpsMDJja3Rnb2hz?=
 =?utf-8?B?cm0wLzNrUFZEakZBZHAxRWxpejl1d2RpRk0xWFdnYXVlekxVWHFmdHN5b0xs?=
 =?utf-8?B?bVI5U25rWEhmYktGRTZzd1RmcVoxcXdvalBYM1VzK3U2NURSWDRUYUlZV2tC?=
 =?utf-8?B?cmpJYUZ6cjM2R05EWURiQTI2YnFXVTFSOGdQTHRDdVFwR3Zkdzd6R01rTjh5?=
 =?utf-8?B?TTNEZTRyYUp5cWVSeEg4V3J4bnB6UjV4UkZWUDBLS3dEWXpVSU96eFJSZEx4?=
 =?utf-8?B?MmpFNnBqQmxYVlFHNzNXVGNjbE5NSFJIU1hOQm9Rb3oxeXEwSlJ1eGJtVDBp?=
 =?utf-8?B?Ky85aDVDSW9XZGU5OEp3Tm9rV3htRHNZazEwL2JlbDhMYUdoTU84TFl5Ym9U?=
 =?utf-8?B?ODIvbkY4akRVVHpDVXh0K24vbTd0QVloUlhIc09UdjJyQUxtTEY3dCtTaWRw?=
 =?utf-8?B?eVE2ajFvZ0lLWG5pMkgyRjhrUGp2WGx3bFRhUWY1QjYyRVYxMTQ4L21BS21J?=
 =?utf-8?B?SHorYjN1aTBMWTE1WkVtWDBMMVVGSGJTcjAwcTNiYVNEdTUrYnVkUHVDSTlq?=
 =?utf-8?B?ejdPUGFUQ1JXTVQ4OXNWVXE5TXI2dmRsbjBycCtXVVYwTUZ3M1pPcm1za1Zp?=
 =?utf-8?B?M3Fmb05GU3ZaRldtQjNGYlZ6ZG1CeDdSYVRlbUIwVDlrZ0M1TElOMlc0VXJZ?=
 =?utf-8?B?aUN4dys1bEFXTnBlaVhTc0dvUHdFT1BGVit6RWlHdVNYR0c0Q0tVWXMxOEMv?=
 =?utf-8?B?U0RqVTFoMVNJU2ZUSUxlT3A5amhIVVUyeTFDcU02YWZXRWNJMnJJMW56dFp5?=
 =?utf-8?B?SlpOYVVCdE1keENpcXc4ZE8ycVhDSm05MHVSRHJEaWJlWFplb3BBQ3pvVHhY?=
 =?utf-8?Q?P9ULRr4YDql2W7hAIrB2T34=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B45374741352234EA85971B0B4F82CB5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa9564f-0435-4cff-a2b2-08de208f57fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2025 19:28:36.1393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E8GDgUoAFwpaxWAFeREyWwxbk4XS3+BZ7SFkdlb+hrTnoE4gxk1GIqfLCLN7GZPgIt98fepuQRpWRXsMlK9E7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBE7A84C80
X-Authority-Analysis: v=2.4 cv=MtZfKmae c=1 sm=1 tr=0 ts=69123ce8 cx=c_pps
 a=Wms0yhV2hyGqr6ZNmSx9tw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8
 a=WwRnltSFezrtaHDMGiMA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: iBqcK2-kQQyJ2xfsJbS1_da-ymiWmeSj
X-Proofpoint-ORIG-GUID: yuNOjPbFRr63VVSZo4Ta4Nu6Fuqn6qBV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA3OSBTYWx0ZWRfX28mZwcTqZDGj
 FcvXyUQ2mnVRE6+shcfwY0EXJ/PlyEImV2AbBnVZ4raqqQTx+ASrDcVjLDHnAVfS7ZXpyd4IrKl
 Psr1Tv8323amZz6y1vYDWgo42YQ7rDypIqnQ9PM7fhGm10vHznMK9t7V9VneZfwINGj8elTHBbO
 I9IvgywJa8+JwSpuugMfzuRokF5hOtS28oC+SqjfpMnzPDAccvSVMhSCSLDWehw4rhEz3lxoenr
 kL/WcR36wH1670YGxL3yce5iNzsWYLkAjHWw5j1JV06NNHf5k5nkLPizOdHKeCVunGsxfOuNZii
 xL7BaHdcRXfSkhvA0bMGD2oIApynXWO55tjVQCYsZdpJeuF0F4D6j718JpxE/5a8oxJZZTstEvC
 bIaArBBSk6yLSHiIyVW3zGD9/oJLLQ==
Subject: Re:  [PATCH v1 1/1] libceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080079

T24gTW9uLCAyMDI1LTExLTEwIGF0IDE1OjQ2ICswMTAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
DQo+IEluIGEgZmV3IGNhc2VzIHRoZSBjb2RlIGNvbXBhcmVzIDMyLWJpdCB2YWx1ZSB0byBhIFNJ
WkVfTUFYIGRlcml2ZWQNCj4gY29uc3RhbnQgd2hpY2ggaXMgbXVjaCBoaWdoZXIgdGhhbiB0aGF0
IHZhbHVlIG9uIDY0LWJpdCBwbGF0Zm9ybXMsDQo+IENsYW5nLCBpbiBwYXJ0aWN1bGFyLCBpcyBu
b3QgaGFwcHkgYWJvdXQgdGhpcw0KPiANCj4gbmV0L2NlcGgvb3NkbWFwLmM6MTQ0MToxMDogZXJy
b3I6IHJlc3VsdCBvZiBjb21wYXJpc29uIG9mIGNvbnN0YW50IDQ2MTE2ODYwMTg0MjczODc4OTEg
d2l0aCBleHByZXNzaW9uIG9mIHR5cGUgJ3UzMicgKGFrYSAndW5zaWduZWQgaW50JykgaXMgYWx3
YXlzIGZhbHNlIFstV2Vycm9yLC1XdGF1dG9sb2dpY2FsLWNvbnN0YW50LW91dC1vZi1yYW5nZS1j
b21wYXJlXQ0KPiAgMTQ0MSB8ICAgICAgICAgaWYgKGxlbiA+IChTSVpFX01BWCAtIHNpemVvZigq
cGcpKSAvIHNpemVvZih1MzIpKQ0KPiAgICAgICB8ICAgICAgICAgICAgIH5+fiBeIH5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+IG5ldC9jZXBoL29zZG1hcC5jOjE2MjQ6
MTA6IGVycm9yOiByZXN1bHQgb2YgY29tcGFyaXNvbiBvZiBjb25zdGFudCAyMzA1ODQzMDA5MjEz
NjkzOTQ1IHdpdGggZXhwcmVzc2lvbiBvZiB0eXBlICd1MzInIChha2EgJ3Vuc2lnbmVkIGludCcp
IGlzIGFsd2F5cyBmYWxzZSBbLVdlcnJvciwtV3RhdXRvbG9naWNhbC1jb25zdGFudC1vdXQtb2Yt
cmFuZ2UtY29tcGFyZV0NCj4gIDE2MjQgfCAgICAgICAgIGlmIChsZW4gPiAoU0laRV9NQVggLSBz
aXplb2YoKnBnKSkgLyAoMiAqIHNpemVvZih1MzIpKSkNCj4gICAgICAgfCAgICAgICAgICAgICB+
fn4gXiB+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4g
ZnMvY2VwaC9zbmFwLmM6Mzc3OjEwOiBlcnJvcjogcmVzdWx0IG9mIGNvbXBhcmlzb24gb2YgY29u
c3RhbnQgMjMwNTg0MzAwOTIxMzY5Mzk0OCB3aXRoIGV4cHJlc3Npb24gb2YgdHlwZSAndTMyJyAo
YWthICd1bnNpZ25lZCBpbnQnKSBpcyBhbHdheXMgZmFsc2UgWy1XZXJyb3IsLVd0YXV0b2xvZ2lj
YWwtY29uc3RhbnQtb3V0LW9mLXJhbmdlLWNvbXBhcmVdDQo+ICAgMzc3IHwgICAgICAgICBpZiAo
bnVtID4gKFNJWkVfTUFYIC0gc2l6ZW9mKCpzbmFwYykpIC8gc2l6ZW9mKHU2NCkpDQo+ICAgICAg
IHwgICAgICAgICAgICAgfn5+IF4gfn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn4NCj4gDQo+IEZpeCB0aGlzIGJ5IGNhc3RpbmcgdG8gc2l6ZV90LiBOb3RlLCB0aGF0IHBv
c3NpYmxlIHJlcGxhY2VtZW50IG9mIFNJWkVfTUFYDQo+IGJ5IFUzMl9NQVggbWF5IGxlYWQgdG8g
dGhlIGJlaGF2aW91ciBjaGFuZ2VzIG9uIHRoZSBjb3JuZXIgY2FzZXMuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVsLmNv
bT4NCj4gLS0tDQo+ICBuZXQvY2VwaC9vc2RtYXAuYyB8IDQgKystLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9u
ZXQvY2VwaC9vc2RtYXAuYyBiL25ldC9jZXBoL29zZG1hcC5jDQo+IGluZGV4IDI5NTA5ODg3Mzg2
MS4uOGU3Y2IyZmRlNmYxIDEwMDY0NA0KPiAtLS0gYS9uZXQvY2VwaC9vc2RtYXAuYw0KPiArKysg
Yi9uZXQvY2VwaC9vc2RtYXAuYw0KPiBAQCAtMTQzOCw3ICsxNDM4LDcgQEAgc3RhdGljIHN0cnVj
dCBjZXBoX3BnX21hcHBpbmcgKl9fZGVjb2RlX3BnX3RlbXAodm9pZCAqKnAsIHZvaWQgKmVuZCwN
Cj4gIAljZXBoX2RlY29kZV8zMl9zYWZlKHAsIGVuZCwgbGVuLCBlX2ludmFsKTsNCj4gIAlpZiAo
bGVuID09IDAgJiYgaW5jcmVtZW50YWwpDQo+ICAJCXJldHVybiBOVUxMOwkvKiBuZXdfcGdfdGVt
cDogW10gdG8gcmVtb3ZlICovDQo+IC0JaWYgKGxlbiA+IChTSVpFX01BWCAtIHNpemVvZigqcGcp
KSAvIHNpemVvZih1MzIpKQ0KPiArCWlmICgoc2l6ZV90KWxlbiA+IChTSVpFX01BWCAtIHNpemVv
ZigqcGcpKSAvIHNpemVvZih1MzIpKQ0KPiAgCQlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4g
IA0KPiAgCWNlcGhfZGVjb2RlX25lZWQocCwgZW5kLCBsZW4gKiBzaXplb2YodTMyKSwgZV9pbnZh
bCk7DQo+IEBAIC0xNjIxLDcgKzE2MjEsNyBAQCBzdGF0aWMgc3RydWN0IGNlcGhfcGdfbWFwcGlu
ZyAqX19kZWNvZGVfcGdfdXBtYXBfaXRlbXModm9pZCAqKnAsIHZvaWQgKmVuZCwNCj4gIAl1MzIg
bGVuLCBpOw0KDQpJIGFtIGd1ZXNzaW5nLi4uIFdoYXQgaWYgd2UgY2hhbmdlIHRoZSBkZWNsYXJh
dGlvbiBvZiBsZW4gb24gc2l6ZV90LCB0aGVuIGNvdWxkDQppdCBiZSBtb3JlIGNsZWFyIHNvbHV0
aW9uIGhlcmU/IEZvciBleGFtcGxlLCBsZXQncyBjb25zaWRlciB0aGlzIGZvciBib3RoIGNhc2Vz
Og0KDQpzaXplX3QgbGVuLCBpOw0KDQpDb3VsZCBpdCBlbGltaW5hdGUgdGhlIGlzc3VlIGFuZCB0
byBtYWtlIHRoZSBDbGFuZyBoYXBweT8gT3IgY291bGQgaXQgaW50cm9kdWNlDQphbm90aGVyIHdh
cm5pbmdzL2lzc3Vlcz8NCg0KVGhhbmtzLA0KU2xhdmEuIA0KDQo+ICANCj4gIAljZXBoX2RlY29k
ZV8zMl9zYWZlKHAsIGVuZCwgbGVuLCBlX2ludmFsKTsNCj4gLQlpZiAobGVuID4gKFNJWkVfTUFY
IC0gc2l6ZW9mKCpwZykpIC8gKDIgKiBzaXplb2YodTMyKSkpDQo+ICsJaWYgKChzaXplX3QpbGVu
ID4gKFNJWkVfTUFYIC0gc2l6ZW9mKCpwZykpIC8gKDIgKiBzaXplb2YodTMyKSkpDQo+ICAJCXJl
dHVybiBFUlJfUFRSKC1FSU5WQUwpOw0KPiAgDQo+ICAJY2VwaF9kZWNvZGVfbmVlZChwLCBlbmQs
IDIgKiBsZW4gKiBzaXplb2YodTMyKSwgZV9pbnZhbCk7DQoNCg==

