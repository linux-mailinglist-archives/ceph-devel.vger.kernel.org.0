Return-Path: <ceph-devel+bounces-2442-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6095DA113F6
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 23:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 711B4165F61
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 22:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D8D1FC7F6;
	Tue, 14 Jan 2025 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jvRRJgs6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7F4644E
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893275; cv=fail; b=KokwnQbvy5ZV4887AKvQ3F1FJgr0DaqHYx6cOID2RoKN6UTw8Ada3ygDj9dgV6LvnqAn2MlDzHAdfBDk13/61U8ChFsYJqctUtzOf6zkXDVtJHwO6867CrBhMItROan2zt6Pit8o6hEqSPxtdQOn7RgugCoO5nq3n4GH24FzEAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893275; c=relaxed/simple;
	bh=saVB5B7U/pTCxNk1jwYw9iukAvOcyyG5ajBLJ54RScU=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=WUwKNS+upJqo4JELbWdZIehlmCJTsjK8RBZZc7/TXgobqTP6zGa2PLP0LrQ4w8sSVOX0nVA57XzATWlSIXhxLZRRTvUaXUGmtUcb5+4RbHoTtJjEstA5cPlHOjE5vp/OEo92kL3Vynb1eqFDtq1Wt/36Ld0w62rX8kFL/EOIwHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jvRRJgs6; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EFSfx1006751;
	Tue, 14 Jan 2025 22:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=saVB5B7U/pTCxNk1jwYw9iukAvOcyyG5ajBLJ54RScU=; b=jvRRJgs6
	U0dS+Mtn0Qte+cOhLfiMfwKOvW2cy0bsqz9hDJ4gcO/rLUTv241umGqeG5XwvqQh
	aZQwnYikPmn42BTFpSVCfJuxuS1xbGvp+9NFZ7x/qNsy4GQ41b8grLdn5j7srLoa
	UiYt2yletvkTqiqrzuMNjVF9YPnF49hRQsyX0aaKsAzAmhifi1XMZlZn0jXJcIsw
	bpeRsLLnQz7ab1D1cCiqvsVZY9VvVv0Sz6mkjfUnquO6g2VGFsi1lTO4ulx/PtrM
	jNwdLEVxeWpTrR15N4M6CH81EhY+OLufIPTXL7USRsrbs+tm7IhHRJRzFX+2YKZW
	/DGdeTXiW1xZfQ==
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445gdjm9vx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 22:21:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GWlTlaci/dlmyOlkT7TCjdTGD95WrDUPmgOEtB8pUhcx7XbEQT8W5F6ixN8GPHJDSEIgWJffcACbrwE+s5yKOFSKiQRm4QrqzC6yjPXe4zA8QMX3IrCEnkdGJhTVM5llEX3YPkGWFelI3pzkmLC5uFyptAEbr+e9DtQwi6awDRrUMfGJ/fgAZf48wqE3ik3aFq6LqiY7msFAP5pWeGl3vY/aVqvqy9iPp/PROOMgoxP/FgFjuxsKBIOz3zGrG36NCxwS6r/QyBUcrTPL49RjnyhKgtStRQ+IKLrDPE2HZK+2lky3lhviKHUhwKfa/ahV+Go/XKQrkmgru5eS44y9gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saVB5B7U/pTCxNk1jwYw9iukAvOcyyG5ajBLJ54RScU=;
 b=sCKUrXaHD4T5+p7MBiZlqEaGFH55FFo+qpQntyHfHX87pjZQNWMmyLCWX9MfZDaXfvd9Kr8sU0ByZuLLqcua4L2FB6dpSRGpXRsUTSJXZT7mMzL/Chhdkhb0kwEGk9UelNK/ZoyBpzdIyEIFLzxtdAI+3yqzN5xr6c8R666AuRlCPqQ8ZeXettS7OjVsrGYyI8mAcHOPf4ZVJE+dwgowrpmbgqE/KxbT/YIH4NxPPglmVWgScnpBAo+NdSpezcHxOUC4+G+F6GbPU3s6OFO8jcVRHnAcmlSnvnLkLB1jIqhmA9LNltO4eZUQ5kjNCsY6WIVoOdZQ67FTaY2zZYXJXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW4PR15MB4380.namprd15.prod.outlook.com (2603:10b6:303:101::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.19; Tue, 14 Jan
 2025 22:21:02 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 22:21:02 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZtGKmz9wavnNPkmusmnFHTo+57MW140A
Date: Tue, 14 Jan 2025 22:21:02 +0000
Message-ID: <629477f65f1490e02747a732227024d4026871ee.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
	 <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>
	 <e0867174-3c3f-4ddb-b84b-12706e0c63bf@lesviallon.fr>
In-Reply-To: <e0867174-3c3f-4ddb-b84b-12706e0c63bf@lesviallon.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW4PR15MB4380:EE_
x-ms-office365-filtering-correlation-id: c9bacad0-1a92-418b-7e54-08dd34e9bb2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VFBFdWx5M3FEYjczWUI5ZnpUc3ZSNzAvek90N09qa01VdnQ0MlFrdWgzWUNN?=
 =?utf-8?B?OTZtcU1odllzNFk5aWpsdWlqSkx3ZnVkS1ZWL3BzRUFra2VORXhQSnRBZ0tD?=
 =?utf-8?B?SzlQUzhYRVdSZ0QwQ0NuMEFHS2tUWkI3bEEzODBkaGxDcTAxQ3kvSXFETVpU?=
 =?utf-8?B?eXozVy9yK1hYU1ZsOXdMT3hicjUvRDJMcnpKSVJBWitzMlhPdWF2TThxNHJp?=
 =?utf-8?B?Vi9ZT1dZK2ZoNWRBZFk3MWFGNUlpUmw3K1NkeUR3UmZpd0VBUWxhQjBFTnFS?=
 =?utf-8?B?c3h2MUtJb2pSc29KMDA2WnZkeU1IUGJvQ0FBRi9FNzNXaUVxWm8zNTlHTENG?=
 =?utf-8?B?SU5XTFErSnZTbnBLRGdadGxBaXNwUFVMRElvYjdtcVJqN0g5YUdHRTdRSVU3?=
 =?utf-8?B?aERTZHF6dEF1dlhjTWg1Y0xOc3JJWVBBdHJ2WVI2ZFo1aDBGdkt3MW91VmlS?=
 =?utf-8?B?TU5xR280cDczVFJJa1p2TzN3bHNhUm5wWGRrZHMyaGtsQVZOQS9LTjBIZzFy?=
 =?utf-8?B?ZHRtSEtRLzgvd2U5MXNkSkNQR3JDNlBVR2dCRlVNZndwYzlwZjdwZWZoV2pY?=
 =?utf-8?B?K2M1Q0hyVjNNem5HeWdsaXBUWjhVNHFBYjNieEU5eCtmY3QwRVZrdWZNTG1J?=
 =?utf-8?B?d2R0TnQxejBqQXJXb3F3NE85amc3MWZTTWZ4YVdHNmF5REhmZitYeS9ZWUNp?=
 =?utf-8?B?MGUxWEwyLzE1NmVjbEdFRkRVT2VWRVpWclQwWVM2cjQyZFF4ZVErd0JGN0ZC?=
 =?utf-8?B?b1YwZzhtUXZSRnZ1b0xRSG9DZHZXVkdQRXpRTG5Cd0pJN2ZZY0FEQ3lmdnVU?=
 =?utf-8?B?OGFSTmdEa3A3dkZPTThYd0tldFFPMU96Q2xqQk9qSmxlSHJCcXYyb0o0ek5K?=
 =?utf-8?B?UkNuOWt1V3YrUjJOMnkvWG1FQlRldmtaTzJSdExvUmhOc1QySjJFZ05VMVNP?=
 =?utf-8?B?VTU0aWJPd3RuY3BPSjlGcEc2MC9zNk9VQUZndE1KSFN5WE8xa0E0d3Z3bWpa?=
 =?utf-8?B?eEJsbkswQXhJOEdUWUozbVRUaStMU1VDNjFZTUhuYU1yUUl2aVo0d0ZKYVJE?=
 =?utf-8?B?Wm5PU2FKU3ZpTWh6Z0VFVWxyRXZQbGo5K3Nsamd2TjZDVGRWYWxUZnYyZnZB?=
 =?utf-8?B?ZW1INGtjWW9IVllRcWY4d2dvOHZlTGIxMWw1LzlYSFJsVDhoT09tdHBtUGlP?=
 =?utf-8?B?amRva3RWOWkrNzc4Z29FR3JEd3NzVGxVM0cyRTNVVjBmOU9QTk1IaGo3OSti?=
 =?utf-8?B?M015Rnc5dWtQR2hIVlRtcitLWFdoUnV6bTdQMEsvV2tjWXJadFh0ZlRIN0lK?=
 =?utf-8?B?L0h6QVFna3dEV21PeEJhVGJtQkhXRHdMdDJQWnllTnorTnVLb0lZcTNhckwz?=
 =?utf-8?B?LzlnVjA2d3VuL3YrNFhNeUpvakZ1cVF6Y281QUFiNlovRnBkdlFHYjFxc3Nw?=
 =?utf-8?B?Tzg5Y0plUFZuUnZsMnVxYVZFZU5NR1F0KzZQVzNQWXE4eUZpUk03MXJ3cmlJ?=
 =?utf-8?B?WUNkQjFPVGVhVy9lWnIzV3I5eGlYS0s0ZFlvNjV5WHhqUWs0VS9vRVJsd1Fz?=
 =?utf-8?B?Y2kzaFFuUEt0eUdtTDlCWmk0VjNKTXNNc1B4UEt4RWVjWDY3UVJnaXdrQmY1?=
 =?utf-8?B?bjhmbnFacWFiQmhHVVN2Y2tGSDdjVXFIRnZkRGpuTmdHdWFtQnNhTVBZSXQw?=
 =?utf-8?B?TWlkNVp5TXFSQ1p5QnlVZVdocVhvbmtCeHliN1BEeXhPWWUxQkRkclgvMS96?=
 =?utf-8?B?TWRaSzI1WkV4cnprN3Y2dFV3cDMzU0xUaGpzcVlRenM2NWV5a0M2MXVwclFO?=
 =?utf-8?B?WjAyRlJONWRhMnArWWk3Wjl2MnZtTFFIU2lYbDZ2ZFJLQ2hDLzdNd2ZGMGdT?=
 =?utf-8?B?M0tQTDFnRzFwY0hvOVJBMDdrWGRiTW45eTFIZU95WjF3aEE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OXpka0szTzdzZUlsM1ZpM1lZeVhDMmVZeURFb3M4T1dlandoUHhLVzJFZ0J4?=
 =?utf-8?B?d0lFRUphaE1NWEc2TzFlSVRCaUVHdTJRMHpueWs1OUN2U3VvY0NsOGlaYjJV?=
 =?utf-8?B?SkdoN3paejRaZk5IRTNld1puUEN2RzJnY0ErNGJvN2RuaTAvRUJkM3FETXZr?=
 =?utf-8?B?eHNIT3lsTjZXa0cvUld3cEYwallIc2g0R05FNXFEZHZTZ3ZlcWNnYUd3ZU0w?=
 =?utf-8?B?TzlsYWtrbkFUMFNpM1Q4dnZvS3o0dWdrK1BSZnpFcE9wMFJHNVZkdGo0TWtm?=
 =?utf-8?B?QnhJWDErRjJQSUhTNDNxeEFCRFVDaVZBVm43c3BIazZ4aGNGR1VUNmZGOFB2?=
 =?utf-8?B?NWhZbDNWaXBid3VXTHB6MEw2d2Urazk4RlZMTWVrNFIzdmc1aDNvTlJ5WVJk?=
 =?utf-8?B?VXRpVSszY2tFaTh6dlBUQVpVZC9MNHFwWndkNElxYUZtay9NS1dZdFZNMVps?=
 =?utf-8?B?TUJVQjBiZ2hUS3cydklXRVhoenZSbmJhYWdvZHUyR0lYd014cHJVWjlwWC9v?=
 =?utf-8?B?NXlDY3QxOG9acmd0ejdlNTBUU0xMOERnM1pyYXRPTlZRRXpJNlVrdndqWXRm?=
 =?utf-8?B?eGhXMFJLbElGaG1QdXNYN3JUTlE0OGMvaWQ2aWpvMjJIOTdaYTQ0aTg0dEMz?=
 =?utf-8?B?WTNpbmlrZVdHUFE3WGRRR1V0UTNHSCttT0hZQlk0QmtSWkxOVnltVDhoandO?=
 =?utf-8?B?endOL0ZOZ1A1SnJvTC9sa2ZlSkFwbm5rSSsyclJFOVRBSG5EVGo2QkJjd2VM?=
 =?utf-8?B?ekxpNVpLT0hEWDdsRE16WVBKVS9sZ3ZrQWltbXJDNjB6RWlxN2h2eVorRHRN?=
 =?utf-8?B?M0o2d1dNeXJFQXdtcW9pQlNtM1dWczVBbWYweTk3cWhZMmVDekQ4enJrcFNF?=
 =?utf-8?B?aVgyNWhxK1hBbDBHcGRPUjNtTG1aMTNQL0FQUldrSkErZStpS3U4RHJEVlRI?=
 =?utf-8?B?YUlEZ2JMeS8zUXNOUFJrRkdIQnNESlpVa1hFMUk2RGJUUzc3NnU3UU1zQUg0?=
 =?utf-8?B?a2xYcStaU044eTZ6ZVZsUFgyejFqSDR2d2UxRUcwNjJ3YWV3dlRhN3ZVa2hF?=
 =?utf-8?B?YUJsbXZTNjlwditCRUUrVjJxb0E2VTRCN0xuUjhtcEcyWEw1ZENEWCtLWDJI?=
 =?utf-8?B?QmR2L2NRcERZQjNVTE5GMTBGTlV4TVZEUGhkZmsrYW1yTEozUW9nbDRDNjhh?=
 =?utf-8?B?eVZON202MkJLUnZHOXFxZVl0UjlSVUQ5MUd5ZGl2NjNBNmtrNVVZMWtrTUVX?=
 =?utf-8?B?NXJMeEZjZmxxdWpkby9zTFpQUkY1dnFadjMra0hqaElmUHpNcHYxMzVCV1JE?=
 =?utf-8?B?djhWZkFnRDk5QkxUNEpYVHJWV3dkN1NqZjJnRytSQThVVzJ2dUQ1V2x3TGFv?=
 =?utf-8?B?OTBTVlpnd2dpZ0xtUGxYb3pHZGtlTTNIZnBDU1BlWGxybXRlYTVWYmMrd1BO?=
 =?utf-8?B?UDBoZ01wZ1JlSmJJTWJmbkVpZ0dRUEs1akdqdDlhQ3NZL1h2dldwdU9tWTBl?=
 =?utf-8?B?bVVGbUN3emcwSDYwcHNaNEFYVHo3dDVLODc1VkdONlJkeml0QmhzaGlwc1dv?=
 =?utf-8?B?ZGFIdURsSkhmNWpUcS9WUlFpL2c2YTd2aDZkcnRNV2NMVzgzK050cUt0S0FU?=
 =?utf-8?B?bmI3emorL1loS3NmU1p1RStRRXlBejNxTFpBZ0NZZm1JdUN6Z2hGS0ZWckV6?=
 =?utf-8?B?RXgrazBkaEJRY2ZnTUQ1VnRGS0o3bm1sUjVyaDZsL0dDb2NiMFM0eUxsTHYv?=
 =?utf-8?B?Nlhrc21BZlN2UGEvbll5TlJ5NTVRUnZhYko3OWE3Y0ZxMjFDdzdWbng4a0Rr?=
 =?utf-8?B?VUsrNTZVWEFIMDZhTU5FblFHdDcxSEFpUFlNcDJsT2hGdDFjSUFNNjZmenQx?=
 =?utf-8?B?UnNGSTE5M1pqcWQ3NUo5MlFONWtYcGZHa3lsSDhnS0FNUy9GVnJRRytEVGdV?=
 =?utf-8?B?NlVFWitCOUgyM0tNNlJRbTlFSWIzUmZwbXcrZ2dyL0plVVBScGJPaEdSb0dV?=
 =?utf-8?B?SCtTK2RTVGdVQzBwRmJIYUNhNyttNlJ2bWUwV1hKOVp4UGtXS1ZsMktkdit6?=
 =?utf-8?B?TlEwNGVsdXE2blBIOUEreWZ0OVh2NTdLSDRwc2JOdURJalBRbDBWRktoYmN1?=
 =?utf-8?B?R3ZIL1pySnBEQ0FGMjQvYXBGdm4veXpOdU5qLytHV093Y215Y1poN0tWa3NI?=
 =?utf-8?Q?bnaynSn6jtYaZ2v0s6RI/5E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8607C5739C8D4F448075FD11BBB86953@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bacad0-1a92-418b-7e54-08dd34e9bb2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 22:21:02.8498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXQptCQaLCEDinAAOaMjXcVMcMhAPsQMMeYMVPhogycyz+MPoAbx5DB7rYI7qIqiKFcDf9WVa9SEs84/GT9RoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4380
X-Proofpoint-GUID: Otk3YqqHnRPOX9orI1tLK50SYpzn3UQw
X-Proofpoint-ORIG-GUID: Otk3YqqHnRPOX9orI1tLK50SYpzn3UQw
Subject: RE: [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_07,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140166

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDIzOjEzICswMTAwLCBBbnRvaW5lIFZpYWxsb24gd3JvdGU6
DQo+IEhlbGxvIFZpYWNoZXNsYXYsDQo+IHRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQo+IA0KPiBP
biAxNC8wMS8yMDI1IDIwOjE3LCBWaWFjaGVzbGF2IER1YmV5a28gd3JvdGU6DQo+IA0KPiA+IERv
ZXMgaXQgZXhpc3QgYW55IHdheSB0byByZXByb2R1Y2UgdGhlIGlzc3VlIGluIHN0YWJsZSBtYW5u
ZXI/DQo+ID4gQ291bGQNCj4gPiB5b3UgcGxlYXNlIHNoYXJlIGFueSBzdGVwcyB0byByZXBlYXQg
aXQ/IEl0IHdpbGwgYmUgZ3JlYXQgdG8gaGF2ZQ0KPiA+IHRoaXMNCj4gPiBkZXNjcmlwdGlvbiBp
biB0aGUgcGF0Y2ggY29tbWVudC4NCj4gDQo+IFRoaXMgaXNzdWUgY2FuIHByb2JhYmx5IGJlIHJl
cHJvZHVjZWQgYnkgaGF2aW5nIGEgQ2VwaEZTDQo+IHN1YnZvbHVtZWdyb3VwIA0KPiBiZSBtb3Vu
dGVkIHRvIGEga2VybmVsIENlcGggY2xpZW50ICh2ZXJzaW9uIDYuMTIuOCksIHdoZXJlIHRoZSBh
dXRoIA0KPiBjcmVkZW50aWFscyBhcmUgc2NvcGVkIHRvIGEgc3BlY2lmaWMgcGF0aDoNCj4gDQo+
IGNsaWVudC5zZXJ2aWNlczoNCj4gCWtleTogUkVEQUNURUQNCj4gCWNhcHM6IFttZHNdIGFsbG93
IHJ3IGZzbmFtZT1jZXBoZnMgcGF0aD0vdm9sdW1lcy8NCj4gwqDCoMKgwqDCoMKgwqDCoCBjYXBz
OiBbbW9uXSBhbGxvdyByIGZzbmFtZT1jZXBoZnMNCj4gwqDCoMKgwqDCoMKgwqDCoCBjYXBzOiBb
b3NkXSBhbGxvdyBydyB0YWcgY2VwaGZzIGRhdGE9Y2VwaGZzDQo+IA0KPiBUaGVuLCB5b3Ugc2lt
cGx5IG5lZWQgdG8gdHJpZ2dlciBhIGxvdCBvZiBmaWxlIHBlcm1pc3Npb24gY2hlY2sNCj4gKGVp
dGhlciANCj4gYnkgdXNpbmcgdGhlIEZTIGZvciBsb25nIG9yIGRvaW5nIExPU0YgSS9PKS4gVGhp
cyBjb3VsZCBiZSBwcm9iYWJseQ0KPiBiZSANCj4gZG9uZSBieSBkb2luZzoNCj4gDQo+IMKgwqDC
oMKgIHNlcSAxIDEwMDAwMCB8IHhhcmdzIC1QMzIgLS1yZXBsYWNlIHRvdWNoIA0KPiAvcGF0aC90
by95b3VyL2NlcGhmcy9tb3VudC9maWxlLXt9DQo+IMKgwqDCoMKgIHNlcSAxIDEwMDAwMCB8IHhh
cmdzIC1QMzIgLS1yZXBsYWNlIGNhdCANCj4gL3BhdGgvdG8veW91ci9jZXBoZnMvbW91bnQvZmls
ZS17fQ0KPiANCj4gVGhlIGlkZWEgaXMgdG8gcGxhY2UgeW91cnNlbGYgaW4gYSBzaXR1YXRpb24g
d2hlcmUgdGhlIHRhcmdldCBwYXRoDQo+IGJlaW5nIA0KPiBtYXRjaGVkIGJ5IGNlcGhfbWRzX2F1
dGhfbWF0Y2ggZG9lcyBub3QgY29udGFpbiB5b3VyIGNyZWRlbnRpYWwNCj4gKGF1dGgpIA0KPiBw
YXRoIEFUIEFMTC4gVGhpcyBjYW4gYmUgZG9uZSB3aGVuIG1vdW50aW5nIGEgc3Vidm9sdW1lZ3Jv
dXAsIGZvcg0KPiBpbnN0YW5jZToNCj4gDQo+IAkNCj4gc2VydmljZXNAMDAwMDAwMDAtMDAwMC0w
MDAwLTAwMDAtMDAwMDAwMDAwMDAwLmNlcGhmcz0vdm9sdW1lcy9jb250YWluDQo+IGVycyBjZXBo
IHJ3LG5vYXRpbWUsbmFtZT1zZXJ2aWNlcyxzZWNyZXQ9PGhpZGRlbj4sbXNfbW9kZT1wcmVmZXIt
DQo+IGNyYyxtb3VudF90aW1lb3V0PTMwMCxhY2wsbW9uX2FkZHI9W1JFREFDVEVEXQ0KPiANCg0K
VGhhbmtzIGZvciB0aGUgZXhwbGFuYXRpb24uIFRoaXMgZGVzY3JpcHRpb24gaXMgdmFsdWFibGUg
dG8gdW5kZXJzdGFuZA0KdGhlIGlzc3VlIG5hdHVyZSBhbmQgdGhlIHBhdGggdG8gcmVwcm9kdWNl
IGl0LiBJdCByZWFsbHkgbmVlZHMgdG8gYmUgaW4NCnBhdGNoIGRlc2NyaXB0aW9uLg0KDQo+IFNp
bmNlIHlvdSBuZXZlciBlbnRlciANCj4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgv
djYuMTMtcmMzL3NvdXJjZS9mcy9jZXBoL21kc19jbGllbnQuYyNMNTY5Nw0KPiDCoA0KPiBvciAN
Cj4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTMtcmMzL3NvdXJjZS9mcy9j
ZXBoL21kc19jbGllbnQuYyNMNTcwMw0KPiAsDQo+IHlvdSBuZXZlciBmcmVlIF90cGF0aCAod2hh
dGV2ZXIgZnJlZV90cGF0aCdzIHZhbHVlIG1pZ2h0IGJlKS4NCj4gDQo+ID4gQXMgZmFyIGFzIEkg
Y2FuIHNlZSwgd2UgaGF2ZSBzZXZlcmFsIGtmcmVlKCkgY2FsbHMgaW4gdGhlIGxvZ2ljIG9mDQo+
ID4gdGhpcw0KPiA+IG1ldGhvZDoNCj4gPiAoMSkNCj4gPiBodHRwczovL2VsaXhpci5ib290bGlu
LmNvbS9saW51eC92Ni4xMy1yYzMvc291cmNlL2ZzL2NlcGgvbWRzX2NsaWVudC5jI0w1Njk3DQo+
ID4gKDIpDQo+ID4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTMtcmMzL3Nv
dXJjZS9mcy9jZXBoL21kc19jbGllbnQuYyNMNTcwMw0KPiA+IA0KPiA+IEFuZCB5b3UgYXJlIGFk
ZGluZyB0aGUgdGhpcmQgY2FsbC4gSSBiZWxpZXZlIHRoYXQgaXQgd2lsbCBiZSBtdWNoDQo+ID4g
Y2xlYW5lciBzb2x1dGlvbiBpZiB3ZSBoYXZlIG9ubHkgb25lIGtmcmVlKCkgY2FsbCBhbmQgZ290
byBmcm9tIGFsbA0KPiA+IG90aGVyIHBsYWNlcy4gQ291bGQgeW91IHBsZWFzZSByZXdvcmsgeW91
ciBmaXg/DQo+IA0KPiBJIGFic29sdXRlbHkgYWdyZWUsIGFuZCB3YXMgdGhpbmtpbmcgdGhlIHNh
bWUgdGhpbmcuIEknbGwgcmV3b3JrIG15IA0KPiBwYXRjaCB0byBzaW1wbGlmeSB0aGlzIGtmcmVl
IHBhdGguDQo+IA0KDQpTb3VuZHMgZ3JlYXQhDQoNClRoYW5rcywNClNsYXZhLg0KDQo=

