Return-Path: <ceph-devel+bounces-3343-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B188FB17699
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 21:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81151A83E3F
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Jul 2025 19:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA1B2459F6;
	Thu, 31 Jul 2025 19:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="l+vYbJNv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31EB13A258;
	Thu, 31 Jul 2025 19:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753989953; cv=fail; b=mUzNzNJ20XFg1n8Fe6oqbssGMyUPUubsjKUZNPKk7isIcdjTtYWRxpMuDqK4bAhTL0QYRWJSqWC051sFD/C7B04cpJJJi4oK0E3KXrMVjYUQxLga/wUIcgWLrjA+bJpyPWBlOIpCVHoFCemRcj1HGUlCCL2Si4VB4oGFRDEh4uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753989953; c=relaxed/simple;
	bh=Heui5QxZvTaRay2Pp7K4AJLX2V2/my+kMJH77UffSm0=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TpunwI9cfyibdF3l0bn5j1BlLYH8rw+F7BrUdPsQCZfkv4p3u8qOrlcwAbYGaxSTUUr7pYa8Xp/rKxgRUGuNwEEUp7muebosHxi97bJdaGiDvRhsWDaVNtLPQnCX7smc++bVIHk5D4GslLj7kJCbrrkUu50kxnjQZWO2XPAgpoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=l+vYbJNv; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VHxaPF008953;
	Thu, 31 Jul 2025 19:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=Heui5QxZvTaRay2Pp7K4AJLX2V2/my+kMJH77UffSm0=; b=l+vYbJNv
	Ud6Ok5dOG8S6bv7RXq7rtbnDjHgIRGcJ35gpjmmLHjHbI2eEklTWe+LRm32r3di1
	XuZhTVIAJBeo42oQvUZaV38loBU6hB8Sw19GJH5ZhxhTufBlrAO5JsRhQQVklKo7
	T2vtO09/GfCEH5A+tMWBnRgMBBOd9zFEQeew3l8vLVLNTkVv7GM8J4Jj5WG7KXBl
	aJ7jQreEinsn+hTO6MbwnhhsSBquWC27NvkgQVAeSxtKJXP3NWmXlSYCRMyS5DlH
	D9Tc1x1t3/VPDnbB0gyp2r5WpDk7/9R8Y+zrg0Jhkrzf3sXz4RsEALOPTHDfOaAm
	OmE57s0pNmNXmw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qcgcty2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Jul 2025 19:25:46 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56VJEk1L014180;
	Thu, 31 Jul 2025 19:25:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qcgctxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Jul 2025 19:25:46 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JxigdLpyMFLWNG+o6iLfPO99niHQv5uzojGnHiBY/BYNNJnYw0waX+VK5qIh4VUffNXjgBQ87rqbUNoXnz82VwvwRIrdo8nza5IOa4nEvM1Okceo9XOoKGSUs2vUf3dTjqLBnH9g76Rsyc4HMTPYZJO7zSPWIZVodVh9u4yB2BiPpdjELg2GJl+9LWmp/gqnYIAke7MT1ffRdosL7fVE534hlwV26VpmnU4F1COYOGvT1BxbscuFIolduB3++9EKASNIfwMxZTv/+xGT9fxMpL9UFKg3wWiCquMovTX++JEF/r+YVhxIoSZkMbgvA/H87tvv+bbryo9LjCJbSZSmYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Heui5QxZvTaRay2Pp7K4AJLX2V2/my+kMJH77UffSm0=;
 b=CWRD94Anl5PDYTAufESw3IgqBml2+weCJgPC72I6CloHZLLMwoYXCwOWfTxA568REJ3rUoRKP6WIYQLQ7oqiXCDRZXYmbg+R//J1iUIp8eHiokjmMnaiT4OJKNUW93ftWdjzzAkf9atAsWl5xwTIgx9yPGWwyP+vCPztpiEMcuinRjKvoMG2gbJtkwoYb77auEU6NWv+sUDAwBvLpga1UZFZIEp8or6jxe/00byjiyckMa3qK/5UxvrDmv+biHzNUDWylzLuBIN0J2Q1rqzw5nT19ax86c9s7v6GUpXEQK1uH2YQnv+OH7cZ8HEMLOGRUreuoEiyLcrV4Z26JZ7EEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SA0PR15MB3952.namprd15.prod.outlook.com (2603:10b6:806:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 19:25:42 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%4]) with mapi id 15.20.8880.030; Thu, 31 Jul 2025
 19:25:42 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] libceph: Use HMAC-SHA256 library instead of
 crypto_shash
Thread-Index: AQHcAk3doLsqhrTrV0+kDkuHBgosf7RMnTKA
Date: Thu, 31 Jul 2025 19:25:42 +0000
Message-ID: <8920f2e66b6eafc825e1e1dfb312412cdb5708d3.camel@ibm.com>
References: <20250731190227.16187-1-ebiggers@kernel.org>
In-Reply-To: <20250731190227.16187-1-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SA0PR15MB3952:EE_
x-ms-office365-filtering-correlation-id: 1f4ea971-1715-4262-73b0-08ddd0680a13
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y1dwZzJiWEZjVzJlUE9lL1QvQkpVL0E3M29vVE5wZVl3UGI3VEFzMEpMN2JD?=
 =?utf-8?B?K1NXY2J0ZVZaQTFFOSs4QVRpWERmMDFGdEkvTGREKzZXNmtHUTU4UlNvMnBM?=
 =?utf-8?B?VmV6aGZ5cmJlUXpBRy9sM2JCT0E3cVVWOW8zeHhmSG40dWlwTExjMG14Sys4?=
 =?utf-8?B?T1FVTlo2V3hvUGhCUUZKMHltS0UxV1ZyT0t6WUI1RHdETWt1Q25DSXMyb0NB?=
 =?utf-8?B?YkZtbE1ETk0xQ3JjTHR2VUdTRDg3dXBUbFR0SkhybWJRZTQrUzQ1ZyszM3Zt?=
 =?utf-8?B?dFN5OWxjbUJ4Y1g5OEhyOEtGYUk3ODVKUkhWUXpOc2tUaExNNG9weDV3MWRn?=
 =?utf-8?B?dW1XRzBpZ0VDbEk1TWVPVFFSUmtidzNlTVU1c0VRUWpMMzdzNHVZM2RIZ3JI?=
 =?utf-8?B?Y1dtWEJza3NaaHJleGpkRXpGWjVPcy9FbndVQXkydHllV1R0LzBoL1NSQnVV?=
 =?utf-8?B?UDZsZkNBRVFNblh5WDVSVExGSVZNYzk3WEdaT3lQOEFETHJSSXc2aU5OaTVM?=
 =?utf-8?B?MyszV2l3VmpvUHdNM3ZZNVQ3WEhMZ0pJTkkwNmtZZEJsTXdBRVIxb1FFNjdX?=
 =?utf-8?B?RkhKN2lFUFRSSFI2TUhQZ1l0UXR2RkwwRU1SSDNnekFVQ3NFbGc5SlFpeTNk?=
 =?utf-8?B?cU9pVkEzcjZKdmJPRmViS0lSSGR1WmNpQk4vK2w4QnBMenI5N2RlRGNtRXQ3?=
 =?utf-8?B?S0pXNy9qSUI5U3gxYUJXZng5NW55OHBMMnN6VTdKZkJBNGI5dzlWeFU1QXhC?=
 =?utf-8?B?NWw1ekludmxnNG50WXgrc0xqWDhTKzhvdHBxQTEybHZnTGRMWUlMRm5adCsy?=
 =?utf-8?B?MHEwSmFUcjNsTVlaNnk4MUhPTDA0cnk0TzBxcDZUeTQyTm9vZlRNdjhBMGpM?=
 =?utf-8?B?eVcwbnl1Z2NaRGFVZXE2YTBGUmo3NjRmb3c5M09idDZJQzEveXFBUjU0OGIy?=
 =?utf-8?B?dEFOam1yK3d4eng2d25tUUNGcFVUc0dybGhaaXBEenU1NTIzNjVRT2QzQ1gw?=
 =?utf-8?B?OVdpTFErWCtrczBDblpERUZYaEQ2aUlHMkpQN3BTSmw1M1JDV3loUmpocEZw?=
 =?utf-8?B?RTdJRUdMNWxXZGlrWUJRMFVUVE4yOVRWSVJ2bVJSZUdZZzFGdU5aQWRvUTFa?=
 =?utf-8?B?WFRXY0pMQStRNkNLdlFoNGNrSVQwemtySDdBUEliKzU4RVVqYzNmNFQrQnJ4?=
 =?utf-8?B?YkROMjYyR201WXlwcG4wbUg0anMxVEhucGVqSi93aURtOUtOay96T1lvcUhq?=
 =?utf-8?B?MGNRWXlISm5kd09hTXgyQW5UTjhUanZpY0Q5WERva3NlckswNXFKLzhmY2NP?=
 =?utf-8?B?eHYxemRBUXRNQ0FCR2xaZ2wwUFoxbUcxU1lsc280OVRIS1JzbHVOeXBPYSt6?=
 =?utf-8?B?dlY2YXRNa1ZxWXAzYlRNamk1d0ZoYWM5QzArM2dFZHM2S0x0MjgydzJhdDFk?=
 =?utf-8?B?ZjlmcldtUysvdWhzc3ZMYkl2amR4bHlIUGQ4ODh3VDJRZzhxaWJrY1k1cGh2?=
 =?utf-8?B?T3ovbUZVMno5bHlLb3FJUlNDa1RlcUFWVlJWOHhaRVlRWU5xSWRJbWZEVUwr?=
 =?utf-8?B?RzBuR2VvTVFDUVZkMVRkZmJyZkJ3WmVvSjZuR3poU1FhQVZMSW9GSmcyOVk3?=
 =?utf-8?B?d3YyYjFUWGplZ3RZWmdpcWYvcmphNXU5TEpVUnpTNWl2NjRVN3dMVnhZZUJF?=
 =?utf-8?B?TnpRM1lQNUtCTVc2T2dNV2NxQUtKRXR6RUw4WDd0eDRQWnFDSDlPM3cwYzVW?=
 =?utf-8?B?UzU4MUVHVm1uci9sVEhiY2dPMngwa0svS3BOaWR6SzBxK2pTczZNNDJRVjRG?=
 =?utf-8?B?NzU1SVFQWnRIKzQ5RVEzMXZhVmZCdy93VURUTVVIRCtwbHNpTUowamdxY1pu?=
 =?utf-8?B?QXJSaGNaaUM1T2FrbWZaUXRtN0J0bzhMWUQ0YWYyekxpUXhGMGNUbldPcTVh?=
 =?utf-8?B?RTZLbVQvY0hCdFpkR1ZWYk9mbU1jUDdMNGlVOGFxVUlTaWRwYXdNMlVjbFY3?=
 =?utf-8?B?RHRhVXR6MVp3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SmY1NDBXY3owcysycjZhTmdKT0FsRnF6SDgrc0xVMStXbWJzUlUyejd0QnQz?=
 =?utf-8?B?anZuQTJmV2dzLzZIVFk4VDNLYXdySEF6VEVqWUZ0RGtpbDBPSFRDdlNsY2tU?=
 =?utf-8?B?VXZDUWNlZ2tsMnhPMTV0Tkk2aTdHcUxQWTBVem9pZEdncUdIMHVuVUp2WlU2?=
 =?utf-8?B?NnFDN1FkY0pmejlhZjNyUTcxdGxRVlRyTTdmckxUL2I1WkR0ZWhpMjRWd2NK?=
 =?utf-8?B?NHFONVVTVlpNbkdMblNaYi9TYjdvMlZrS2RBZitjbjlnOTZjYlFjbDc3UU1H?=
 =?utf-8?B?ZURvZFV1QmFjT3I1bzhBVWpIVE1CNzVpQnQ2VFZMbHFpTGFNeEpFK0lTdmhm?=
 =?utf-8?B?SE96RXZRUjY0RzJPMStSMG4zcjJvWUx3SExaYTdackc4Y3NzKzA3ck1QMlYy?=
 =?utf-8?B?TGtEYmk0M280eEY1MDYrQkl0RW4wMHpud29zVEsxTFBKcDBhS0N1YVFDV1hw?=
 =?utf-8?B?WjhDdmtUVnByZno3Z3BrMmVvQ3I0MUZGZnNXOXBoU3h4Y3RBd3Q0Ni8xOGNM?=
 =?utf-8?B?SjNJZ2V0ZHV6aFR3NkhNczdhWS9UY3NDb3ZQRjlNSTZSckl0TnhzRDE5MzhC?=
 =?utf-8?B?VkZEa1dNK0xScFc3Ym81dy9nWTR0enpYVlB4NHo0V01RdHdOUTJJL04zVFBx?=
 =?utf-8?B?VzRrb2RWVXlxVzFXdUFBbkZla3lJS09xbW9XbzdUVWVmL0dpdC9FSy9WQXFq?=
 =?utf-8?B?SlozYzhLMmRHRmVmRDFBTDV2USt4Mno1a3BsTlI4Qnh2QWZjNjFsMkhPK3FD?=
 =?utf-8?B?U0UwZ1BKZnd0OTFwSmNzeHY5a2dsUFM1ckhvSjcxREVXRlZEOWZFWU9IT0x2?=
 =?utf-8?B?STlwT3drMVpYNm4yWTloUzFyaWZHQ3Z4ay9RQ0pqL04rR08wR1F2RUZ0bHRO?=
 =?utf-8?B?RHVzM1MvLytUaFNHYXp2aTFFSmpsNGdyU1lpSWNGOVpsRWJZVUFVLzlXSHA0?=
 =?utf-8?B?b1pRaWZWa3NCT1YzRjk0ZncxVWFRdU1vYjZ3RmRjWThOckF3Q21mcFJDd2NG?=
 =?utf-8?B?ZXRDcHR5S2Q1RDc1Y3Vyek4xdnBVaUNrSVcwczRRVkUwREVpcW5QU0RnREVY?=
 =?utf-8?B?QnRCQjJGNjAwMThXZGI0TzF3WUE4aW9ibElkVEw4am01WWhwSEtueUVmV2pq?=
 =?utf-8?B?b0cwdlo2SFVQeGxQR0MzTzNNSGtweTdLbW5qWjQydzUyMkxjamtEYzhmbDZN?=
 =?utf-8?B?UmYyUGVwVU1LZG43TEtTMVpaVlJvQ0FrdnhITDVNbUs0Rit5UkFQMURNWnE1?=
 =?utf-8?B?NjNRZTlxVFUvQlVVTktxaXROT0pVbERaK0pYVjhJOER1YnVtdXdrR25LUkhT?=
 =?utf-8?B?bVA0ZXlURDVZeERCRFovRnNLU1Bpckg0Mms0cE44L3MrcG9DeFZVSlFPdFlW?=
 =?utf-8?B?QXBEU28rMnZjanlQWklKTXNKeWNSVTNDMXUyNytHVmFNTTZ2djZGUHR2Mmpk?=
 =?utf-8?B?QWVFcnpUL3FPMHlQNlhaYkN6OEpTQU1taWRtcm8xSTZ1aGczcTdDM2dWakE4?=
 =?utf-8?B?UWM0b0Voa0pIcEJHT1VpR3ZZOFhZZkp2R1UyTGI3SjNyQjVJV1kzQzM0dXdC?=
 =?utf-8?B?VmZUK3didW1DWkRqbHBKWTB4U0tUS1NYZ2hwS3JpL2ViVTV1N1FGdTRONk5E?=
 =?utf-8?B?a1JMWTlEaTl4REc0NkcrNWkvM0xrcVhMQUVNRUE4VS9IaGQ2MWNWSkR0ZzBN?=
 =?utf-8?B?NUhtYmdMbXpwYkR4dXA1d0ZXeTE2V0h0Tzl1OXB1QkFLY3J1Tll5UFE3UzFN?=
 =?utf-8?B?b1JGTU5wQTQ1QS9ucFdyaVorZ1RQSHNCMVdMbDFPOFRKY1RlOHVSN2JONnNz?=
 =?utf-8?B?TnI2RnV6NzRZMW5qR3ZNQVJERHh6WlBTM0ZkNHRheGJhbzVMbzIxN29CRnZw?=
 =?utf-8?B?ZC9IR0x4d0VpYUpMcitQQ0VaTnFEbTVoU3dqL2Z5WCtMQS9vRklHeHN2WkZm?=
 =?utf-8?B?cXhLWDZYQ0ErWTJ6UFNEUGJUc29GeEpvRjZBZHc1dDdWMk1MeXMvaTlUV3Z2?=
 =?utf-8?B?dUhHOVRtNWI0UUZvcWJBeGNSOU5CUlFucnhuSjNLalJ6ai9BUEU0TUFoa0xJ?=
 =?utf-8?B?TlIzdXhwSW9qUGNpbUdSNVYrYURjNmxubzcxZEFNVVdtMDNsSkxwZlVYV2Uy?=
 =?utf-8?B?c3VXRG1ocUFaa1lmb1ZpZnFIK0RnNUJRaWliNkFHd0J6OUpiSUFwejRXdjF5?=
 =?utf-8?Q?aYK99irDF7VdCdgIvWVspuY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC3B1F281B74C0439EBC9C660C0831D8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR15MB5821.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f4ea971-1715-4262-73b0-08ddd0680a13
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2025 19:25:42.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 01TTtucUw6DB2ufQIkWqEP2zpZ0kVYAhF0efNRBMF1PV49a83sSLJUDJEMPd4eb71Xx4Qix5Q4VEqSasIMRd6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3952
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDEzOCBTYWx0ZWRfX8vsxLZom9xXT
 QGpUW8oS76kfJBRcRwsr5AsVO0ghXRVaPh+QUwaJJ3sSA0FzLpvjEnruw5Sq6TWbjmPuvSqLhfS
 I1E80IzJRXccV79V/DO+03gc5TNQmVgcXMCBSEwsfaIUAYEPYnVzZ7TFEmveMMoMAo5q7WT+Dg2
 yjeOSrHQuLhs2BfPfjZ7ko3RjUY1iGo0kABU7+RzC47kbNzp2EpZDG+RHzh4HP4HGVvwe78ZtSx
 Pw0OrmZ2ZxTaPUeHP6kdhTMwnpxIgd1rAVcsBE5Udq8iTqZ5KupTgNfaEs6747j9OqJWoxkB3z/
 T6WSQikrJrZWbOD7H8X4Z/3izDz/hVO9sWpW8iXuigpj4SBsNqdgSSUFrC15WzjBv61vDHx/WHg
 FQVM8xx2V6s9J8Nf0gFBAaVcpuZva8LvQowOA5/cOE9eDWsAiTQ8Pk/eViGGVHHyOR+GOaWF
X-Proofpoint-ORIG-GUID: yJ4NwETs5dtcusrz0gjAnx5f52nCRu5J
X-Authority-Analysis: v=2.4 cv=Lp2Symdc c=1 sm=1 tr=0 ts=688bc33a cx=c_pps
 a=kF3hYY070rs11f8A5riTzg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=iq-_mXx9Apti9LMD1p0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: jVnPATTObFxItdYm6XvthhNPKygjYkjd
Subject: Re:  [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_03,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 clxscore=1011 lowpriorityscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507310138

T24gVGh1LCAyMDI1LTA3LTMxIGF0IDEyOjAyIC0wNzAwLCBFcmljIEJpZ2dlcnMgd3JvdGU6DQo+
IFVzZSB0aGUgSE1BQy1TSEEyNTYgbGlicmFyeSBmdW5jdGlvbnMgaW5zdGVhZCBvZiBjcnlwdG9f
c2hhc2guICBUaGlzIGlzDQo+IHNpbXBsZXIgYW5kIGZhc3Rlci4NCj4gDQoNCkxvb2tzIGdvb2Qg
YW5kIG11Y2ggY2xlYW5lci4NCg0KUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xh
dmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiBTaWduZWQtb2ZmLWJ5
OiBFcmljIEJpZ2dlcnMgPGViaWdnZXJzQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgaW5jbHVkZS9s
aW51eC9jZXBoL21lc3Nlbmdlci5oIHwgIDQgKy0NCj4gIG5ldC9jZXBoL0tjb25maWcgICAgICAg
ICAgICAgICB8ICAzICstDQo+ICBuZXQvY2VwaC9tZXNzZW5nZXJfdjIuYyAgICAgICAgfCA3NyAr
KysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDI2
IGluc2VydGlvbnMoKyksIDU4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvY2VwaC9tZXNzZW5nZXIuaCBiL2luY2x1ZGUvbGludXgvY2VwaC9tZXNzZW5nZXIu
aA0KPiBpbmRleCAxNzE3Y2M1N2NkYWNkLi40YjQ5NTkyYTczOGZjIDEwMDY0NA0KPiAtLS0gYS9p
bmNsdWRlL2xpbnV4L2NlcGgvbWVzc2VuZ2VyLmgNCj4gKysrIGIvaW5jbHVkZS9saW51eC9jZXBo
L21lc3Nlbmdlci5oDQo+IEBAIC0xLDkgKzEsMTAgQEANCj4gIC8qIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wICovDQo+ICAjaWZuZGVmIF9fRlNfQ0VQSF9NRVNTRU5HRVJfSA0KPiAg
I2RlZmluZSBfX0ZTX0NFUEhfTUVTU0VOR0VSX0gNCj4gIA0KPiArI2luY2x1ZGUgPGNyeXB0by9z
aGEyLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvYnZlYy5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2Ny
eXB0by5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2tyZWYuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9t
dXRleC5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L25ldC5oPg0KPiBAQCAtNDEwLDExICs0MTEsMTIg
QEAgc3RydWN0IGNlcGhfY29ubmVjdGlvbl92Ml9pbmZvIHsNCj4gIA0KPiAgCXN0cnVjdCBjZXBo
X2ZyYW1lX2Rlc2MgaW5fZGVzYzsNCj4gIAlzdHJ1Y3QgY2VwaF9tc2dfZGF0YV9jdXJzb3IgaW5f
Y3Vyc29yOw0KPiAgCXN0cnVjdCBjZXBoX21zZ19kYXRhX2N1cnNvciBvdXRfY3Vyc29yOw0KPiAg
DQo+IC0Jc3RydWN0IGNyeXB0b19zaGFzaCAqaG1hY190Zm07ICAvKiBwb3N0LWF1dGggc2lnbmF0
dXJlICovDQo+ICsJc3RydWN0IGhtYWNfc2hhMjU2X2tleSBobWFjX2tleTsgIC8qIHBvc3QtYXV0
aCBzaWduYXR1cmUgKi8NCj4gKwlib29sIGhtYWNfa2V5X3NldDsNCj4gIAlzdHJ1Y3QgY3J5cHRv
X2FlYWQgKmdjbV90Zm07ICAvKiBvbi13aXJlIGVuY3J5cHRpb24gKi8NCj4gIAlzdHJ1Y3QgYWVh
ZF9yZXF1ZXN0ICpnY21fcmVxOw0KPiAgCXN0cnVjdCBjcnlwdG9fd2FpdCBnY21fd2FpdDsNCj4g
IAlzdHJ1Y3QgY2VwaF9nY21fbm9uY2UgaW5fZ2NtX25vbmNlOw0KPiAgCXN0cnVjdCBjZXBoX2dj
bV9ub25jZSBvdXRfZ2NtX25vbmNlOw0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NlcGgvS2NvbmZpZyBi
L25ldC9jZXBoL0tjb25maWcNCj4gaW5kZXggMGFhMjFmY2JmNmVjZS4uZWE2MGUzZWYwODM0MyAx
MDA2NDQNCj4gLS0tIGEvbmV0L2NlcGgvS2NvbmZpZw0KPiArKysgYi9uZXQvY2VwaC9LY29uZmln
DQo+IEBAIC00LDEyICs0LDExIEBAIGNvbmZpZyBDRVBIX0xJQg0KPiAgCWRlcGVuZHMgb24gSU5F
VA0KPiAgCXNlbGVjdCBDUkMzMg0KPiAgCXNlbGVjdCBDUllQVE9fQUVTDQo+ICAJc2VsZWN0IENS
WVBUT19DQkMNCj4gIAlzZWxlY3QgQ1JZUFRPX0dDTQ0KPiAtCXNlbGVjdCBDUllQVE9fSE1BQw0K
PiAtCXNlbGVjdCBDUllQVE9fU0hBMjU2DQo+ICsJc2VsZWN0IENSWVBUT19MSUJfU0hBMjU2DQo+
ICAJc2VsZWN0IENSWVBUTw0KPiAgCXNlbGVjdCBLRVlTDQo+ICAJZGVmYXVsdCBuDQo+ICAJaGVs
cA0KPiAgCSAgQ2hvb3NlIFkgb3IgTSBoZXJlIHRvIGluY2x1ZGUgY2VwaGxpYiwgd2hpY2ggcHJv
dmlkZXMgdGhlDQo+IGRpZmYgLS1naXQgYS9uZXQvY2VwaC9tZXNzZW5nZXJfdjIuYyBiL25ldC9j
ZXBoL21lc3Nlbmdlcl92Mi5jDQo+IGluZGV4IDU0ODNiNGVlZDk0ZTEuLmM1NGM4YjVhNjUyNjEg
MTAwNjQ0DQo+IC0tLSBhL25ldC9jZXBoL21lc3Nlbmdlcl92Mi5jDQo+ICsrKyBiL25ldC9jZXBo
L21lc3Nlbmdlcl92Mi5jDQo+IEBAIC03MDcsMTEgKzcwNywxMSBAQCBzdGF0aWMgaW50IHNldHVw
X2NyeXB0byhzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24sDQo+ICAJdW5zaWduZWQgaW50IG5v
aW9fZmxhZzsNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+ICAJZG91dCgiJXMgY29uICVwIGNvbl9tb2Rl
ICVkIHNlc3Npb25fa2V5X2xlbiAlZCBjb25fc2VjcmV0X2xlbiAlZFxuIiwNCj4gIAkgICAgIF9f
ZnVuY19fLCBjb24sIGNvbi0+djIuY29uX21vZGUsIHNlc3Npb25fa2V5X2xlbiwgY29uX3NlY3Jl
dF9sZW4pOw0KPiAtCVdBUk5fT04oY29uLT52Mi5obWFjX3RmbSB8fCBjb24tPnYyLmdjbV90Zm0g
fHwgY29uLT52Mi5nY21fcmVxKTsNCj4gKwlXQVJOX09OKGNvbi0+djIuaG1hY19rZXlfc2V0IHx8
IGNvbi0+djIuZ2NtX3RmbSB8fCBjb24tPnYyLmdjbV9yZXEpOw0KPiAgDQo+ICAJaWYgKGNvbi0+
djIuY29uX21vZGUgIT0gQ0VQSF9DT05fTU9ERV9DUkMgJiYNCj4gIAkgICAgY29uLT52Mi5jb25f
bW9kZSAhPSBDRVBIX0NPTl9NT0RFX1NFQ1VSRSkgew0KPiAgCQlwcl9lcnIoImJhZCBjb25fbW9k
ZSAlZFxuIiwgY29uLT52Mi5jb25fbW9kZSk7DQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiBAQCAt
NzIxLDI2ICs3MjEsMTIgQEAgc3RhdGljIGludCBzZXR1cF9jcnlwdG8oc3RydWN0IGNlcGhfY29u
bmVjdGlvbiAqY29uLA0KPiAgCQlXQVJOX09OKGNvbi0+djIuY29uX21vZGUgIT0gQ0VQSF9DT05f
TU9ERV9DUkMpOw0KPiAgCQlXQVJOX09OKGNvbl9zZWNyZXRfbGVuKTsNCj4gIAkJcmV0dXJuIDA7
ICAvKiBhdXRoX25vbmUgKi8NCj4gIAl9DQo+ICANCj4gLQlub2lvX2ZsYWcgPSBtZW1hbGxvY19u
b2lvX3NhdmUoKTsNCj4gLQljb24tPnYyLmhtYWNfdGZtID0gY3J5cHRvX2FsbG9jX3NoYXNoKCJo
bWFjKHNoYTI1NikiLCAwLCAwKTsNCj4gLQltZW1hbGxvY19ub2lvX3Jlc3RvcmUobm9pb19mbGFn
KTsNCj4gLQlpZiAoSVNfRVJSKGNvbi0+djIuaG1hY190Zm0pKSB7DQo+IC0JCXJldCA9IFBUUl9F
UlIoY29uLT52Mi5obWFjX3RmbSk7DQo+IC0JCWNvbi0+djIuaG1hY190Zm0gPSBOVUxMOw0KPiAt
CQlwcl9lcnIoImZhaWxlZCB0byBhbGxvY2F0ZSBobWFjIHRmbSBjb250ZXh0OiAlZFxuIiwgcmV0
KTsNCj4gLQkJcmV0dXJuIHJldDsNCj4gLQl9DQo+IC0NCj4gLQlyZXQgPSBjcnlwdG9fc2hhc2hf
c2V0a2V5KGNvbi0+djIuaG1hY190Zm0sIHNlc3Npb25fa2V5LA0KPiAtCQkJCSAgc2Vzc2lvbl9r
ZXlfbGVuKTsNCj4gLQlpZiAocmV0KSB7DQo+IC0JCXByX2VycigiZmFpbGVkIHRvIHNldCBobWFj
IGtleTogJWRcbiIsIHJldCk7DQo+IC0JCXJldHVybiByZXQ7DQo+IC0JfQ0KPiArCWhtYWNfc2hh
MjU2X3ByZXBhcmVrZXkoJmNvbi0+djIuaG1hY19rZXksIHNlc3Npb25fa2V5LCBzZXNzaW9uX2tl
eV9sZW4pOw0KPiArCWNvbi0+djIuaG1hY19rZXlfc2V0ID0gdHJ1ZTsNCj4gIA0KPiAgCWlmIChj
b24tPnYyLmNvbl9tb2RlID09IENFUEhfQ09OX01PREVfQ1JDKSB7DQo+ICAJCVdBUk5fT04oY29u
X3NlY3JldF9sZW4pOw0KPiAgCQlyZXR1cm4gMDsgIC8qIGF1dGhfeCwgcGxhaW4gbW9kZSAqLw0K
PiAgCX0NCj4gQEAgLTc5MSw0MiArNzc3LDMwIEBAIHN0YXRpYyBpbnQgc2V0dXBfY3J5cHRvKHN0
cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbiwNCj4gIAkgICAgICAgY29uX3NlY3JldCArIENFUEhf
R0NNX0tFWV9MRU4gKyBDRVBIX0dDTV9JVl9MRU4sDQo+ICAJICAgICAgIENFUEhfR0NNX0lWX0xF
Tik7DQo+ICAJcmV0dXJuIDA7ICAvKiBhdXRoX3gsIHNlY3VyZSBtb2RlICovDQo+ICB9DQo+ICAN
Cj4gLXN0YXRpYyBpbnQgY2VwaF9obWFjX3NoYTI1NihzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpj
b24sDQo+IC0JCQkgICAgY29uc3Qgc3RydWN0IGt2ZWMgKmt2ZWNzLCBpbnQga3ZlY19jbnQsIHU4
ICpobWFjKQ0KPiArc3RhdGljIHZvaWQgY2VwaF9obWFjX3NoYTI1NihzdHJ1Y3QgY2VwaF9jb25u
ZWN0aW9uICpjb24sDQo+ICsJCQkgICAgIGNvbnN0IHN0cnVjdCBrdmVjICprdmVjcywgaW50IGt2
ZWNfY250LA0KPiArCQkJICAgICB1OCBobWFjW1NIQTI1Nl9ESUdFU1RfU0laRV0pDQo+ICB7DQo+
IC0JU0hBU0hfREVTQ19PTl9TVEFDSyhkZXNjLCBjb24tPnYyLmhtYWNfdGZtKTsgIC8qIHRmbSBh
cmcgaXMgaWdub3JlZCAqLw0KPiAtCWludCByZXQ7DQo+ICsJc3RydWN0IGhtYWNfc2hhMjU2X2N0
eCBjdHg7DQo+ICAJaW50IGk7DQo+ICANCj4gLQlkb3V0KCIlcyBjb24gJXAgaG1hY190Zm0gJXAg
a3ZlY19jbnQgJWRcbiIsIF9fZnVuY19fLCBjb24sDQo+IC0JICAgICBjb24tPnYyLmhtYWNfdGZt
LCBrdmVjX2NudCk7DQo+ICsJZG91dCgiJXMgY29uICVwIGhtYWNfa2V5X3NldCAlZCBrdmVjX2Nu
dCAlZFxuIiwgX19mdW5jX18sIGNvbiwNCj4gKwkgICAgIGNvbi0+djIuaG1hY19rZXlfc2V0LCBr
dmVjX2NudCk7DQo+ICANCj4gLQlpZiAoIWNvbi0+djIuaG1hY190Zm0pIHsNCj4gKwlpZiAoIWNv
bi0+djIuaG1hY19rZXlfc2V0KSB7DQo+ICAJCW1lbXNldChobWFjLCAwLCBTSEEyNTZfRElHRVNU
X1NJWkUpOw0KPiAtCQlyZXR1cm4gMDsgIC8qIGF1dGhfbm9uZSAqLw0KPiArCQlyZXR1cm47ICAv
KiBhdXRoX25vbmUgKi8NCj4gIAl9DQo+ICANCj4gLQlkZXNjLT50Zm0gPSBjb24tPnYyLmhtYWNf
dGZtOw0KPiAtCXJldCA9IGNyeXB0b19zaGFzaF9pbml0KGRlc2MpOw0KPiAtCWlmIChyZXQpDQo+
IC0JCWdvdG8gb3V0Ow0KPiAtDQo+IC0JZm9yIChpID0gMDsgaSA8IGt2ZWNfY250OyBpKyspIHsN
Cj4gLQkJcmV0ID0gY3J5cHRvX3NoYXNoX3VwZGF0ZShkZXNjLCBrdmVjc1tpXS5pb3ZfYmFzZSwN
Cj4gLQkJCQkJICBrdmVjc1tpXS5pb3ZfbGVuKTsNCj4gLQkJaWYgKHJldCkNCj4gLQkJCWdvdG8g
b3V0Ow0KPiAtCX0NCj4gLQ0KPiAtCXJldCA9IGNyeXB0b19zaGFzaF9maW5hbChkZXNjLCBobWFj
KTsNCj4gLQ0KPiAtb3V0Og0KPiAtCXNoYXNoX2Rlc2NfemVybyhkZXNjKTsNCj4gLQlyZXR1cm4g
cmV0OyAgLyogYXV0aF94LCBib3RoIHBsYWluIGFuZCBzZWN1cmUgbW9kZXMgKi8NCj4gKwkvKiBh
dXRoX3gsIGJvdGggcGxhaW4gYW5kIHNlY3VyZSBtb2RlcyAqLw0KPiArCWhtYWNfc2hhMjU2X2lu
aXQoJmN0eCwgJmNvbi0+djIuaG1hY19rZXkpOw0KPiArCWZvciAoaSA9IDA7IGkgPCBrdmVjX2Nu
dDsgaSsrKQ0KPiArCQlobWFjX3NoYTI1Nl91cGRhdGUoJmN0eCwga3ZlY3NbaV0uaW92X2Jhc2Us
IGt2ZWNzW2ldLmlvdl9sZW4pOw0KPiArCWhtYWNfc2hhMjU2X2ZpbmFsKCZjdHgsIGhtYWMpOw0K
PiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCBnY21faW5jX25vbmNlKHN0cnVjdCBjZXBoX2djbV9u
b25jZSAqbm9uY2UpDQo+ICB7DQo+ICAJdTY0IGNvdW50ZXI7DQo+IEBAIC0xNDUzLDIxICsxNDI3
LDE4IEBAIHN0YXRpYyBpbnQgcHJlcGFyZV9hdXRoX3JlcXVlc3RfbW9yZShzdHJ1Y3QgY2VwaF9j
b25uZWN0aW9uICpjb24sDQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbnQgcHJlcGFyZV9hdXRoX3Np
Z25hdHVyZShzdHJ1Y3QgY2VwaF9jb25uZWN0aW9uICpjb24pDQo+ICB7DQo+ICAJdm9pZCAqYnVm
Ow0KPiAtCWludCByZXQ7DQo+ICANCj4gIAlidWYgPSBhbGxvY19jb25uX2J1Zihjb24sIGhlYWRf
b253aXJlX2xlbihTSEEyNTZfRElHRVNUX1NJWkUsDQo+ICAJCQkJCQkgIGNvbl9zZWN1cmUoY29u
KSkpOw0KPiAgCWlmICghYnVmKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIA0KPiAtCXJldCA9
IGNlcGhfaG1hY19zaGEyNTYoY29uLCBjb24tPnYyLmluX3NpZ25fa3ZlY3MsDQo+IC0JCQkgICAg
ICAgY29uLT52Mi5pbl9zaWduX2t2ZWNfY250LCBDVFJMX0JPRFkoYnVmKSk7DQo+IC0JaWYgKHJl
dCkNCj4gLQkJcmV0dXJuIHJldDsNCj4gKwljZXBoX2htYWNfc2hhMjU2KGNvbiwgY29uLT52Mi5p
bl9zaWduX2t2ZWNzLCBjb24tPnYyLmluX3NpZ25fa3ZlY19jbnQsDQo+ICsJCQkgQ1RSTF9CT0RZ
KGJ1ZikpOw0KPiAgDQo+ICAJcmV0dXJuIHByZXBhcmVfY29udHJvbChjb24sIEZSQU1FX1RBR19B
VVRIX1NJR05BVFVSRSwgYnVmLA0KPiAgCQkJICAgICAgIFNIQTI1Nl9ESUdFU1RfU0laRSk7DQo+
ICB9DQo+ICANCj4gQEAgLTI0NTgsMTQgKzI0MjksMTIgQEAgc3RhdGljIGludCBwcm9jZXNzX2F1
dGhfc2lnbmF0dXJlKHN0cnVjdCBjZXBoX2Nvbm5lY3Rpb24gKmNvbiwNCj4gIAlpZiAoY29uLT5z
dGF0ZSAhPSBDRVBIX0NPTl9TX1YyX0FVVEhfU0lHTkFUVVJFKSB7DQo+ICAJCWNvbi0+ZXJyb3Jf
bXNnID0gInByb3RvY29sIGVycm9yLCB1bmV4cGVjdGVkIGF1dGhfc2lnbmF0dXJlIjsNCj4gIAkJ
cmV0dXJuIC1FSU5WQUw7DQo+ICAJfQ0KPiAgDQo+IC0JcmV0ID0gY2VwaF9obWFjX3NoYTI1Nihj
b24sIGNvbi0+djIub3V0X3NpZ25fa3ZlY3MsDQo+IC0JCQkgICAgICAgY29uLT52Mi5vdXRfc2ln
bl9rdmVjX2NudCwgaG1hYyk7DQo+IC0JaWYgKHJldCkNCj4gLQkJcmV0dXJuIHJldDsNCj4gKwlj
ZXBoX2htYWNfc2hhMjU2KGNvbiwgY29uLT52Mi5vdXRfc2lnbl9rdmVjcywgY29uLT52Mi5vdXRf
c2lnbl9rdmVjX2NudCwNCj4gKwkJCSBobWFjKTsNCj4gIA0KPiAgCWNlcGhfZGVjb2RlX25lZWQo
JnAsIGVuZCwgU0hBMjU2X0RJR0VTVF9TSVpFLCBiYWQpOw0KPiAgCWlmIChjcnlwdG9fbWVtbmVx
KHAsIGhtYWMsIFNIQTI1Nl9ESUdFU1RfU0laRSkpIHsNCj4gIAkJY29uLT5lcnJvcl9tc2cgPSAi
aW50ZWdyaXR5IGVycm9yLCBiYWQgYXV0aCBzaWduYXR1cmUiOw0KPiAgCQlyZXR1cm4gLUVCQURN
U0c7DQo+IEBAIC0zODEyLDE0ICszNzgxLDEyIEBAIHZvaWQgY2VwaF9jb25fdjJfcmVzZXRfcHJv
dG9jb2woc3RydWN0IGNlcGhfY29ubmVjdGlvbiAqY29uKQ0KPiAgDQo+ICAJY29uLT52Mi5jb25f
bW9kZSA9IENFUEhfQ09OX01PREVfVU5LTk9XTjsNCj4gIAltZW16ZXJvX2V4cGxpY2l0KCZjb24t
PnYyLmluX2djbV9ub25jZSwgQ0VQSF9HQ01fSVZfTEVOKTsNCj4gIAltZW16ZXJvX2V4cGxpY2l0
KCZjb24tPnYyLm91dF9nY21fbm9uY2UsIENFUEhfR0NNX0lWX0xFTik7DQo+ICANCj4gLQlpZiAo
Y29uLT52Mi5obWFjX3RmbSkgew0KPiAtCQljcnlwdG9fZnJlZV9zaGFzaChjb24tPnYyLmhtYWNf
dGZtKTsNCj4gLQkJY29uLT52Mi5obWFjX3RmbSA9IE5VTEw7DQo+IC0JfQ0KPiArCW1lbXplcm9f
ZXhwbGljaXQoJmNvbi0+djIuaG1hY19rZXksIHNpemVvZihjb24tPnYyLmhtYWNfa2V5KSk7DQo+
ICsJY29uLT52Mi5obWFjX2tleV9zZXQgPSBmYWxzZTsNCj4gIAlpZiAoY29uLT52Mi5nY21fcmVx
KSB7DQo+ICAJCWFlYWRfcmVxdWVzdF9mcmVlKGNvbi0+djIuZ2NtX3JlcSk7DQo+ICAJCWNvbi0+
djIuZ2NtX3JlcSA9IE5VTEw7DQo+ICAJfQ0KPiAgCWlmIChjb24tPnYyLmdjbV90Zm0pIHsNCj4g
DQo+IGJhc2UtY29tbWl0OiBkNjA4NGJiODE1YzQ1M2RlMjdhZjgwNzFhMjMxNjNhNzExNTg2YTZj
DQoNCg==

