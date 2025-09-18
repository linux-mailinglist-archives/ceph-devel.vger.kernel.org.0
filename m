Return-Path: <ceph-devel+bounces-3681-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B45B4B86614
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 20:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B8C47AFFB4
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 18:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E723D27EC73;
	Thu, 18 Sep 2025 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="axQlonk8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F12BDC0B
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218850; cv=fail; b=RdfjtSaEbmQp6Uqn7pXQIr4q10IELo6kkicW8Tnh5PMKniuEzKExc3+oPhtfLNGGS63Zg0Azjt2lTO/RbcEiIG/PM8TWSg8rM9H/if0befEE3oHLqFe6jZvjEmfzBTPrFbJMsKgLhhZ+fV/S7HOXzpzVcH9jvovb1ttn0pNocQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218850; c=relaxed/simple;
	bh=ld9ltvb/l0tpqzvyyTsW+rk9vOLAaPMojxpX3FGwJcs=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Upre1fgRN6uL/5qMeq5mCejRtx48Y6B5cyExyXvxxAL9FBBZQTVwekG7LH0n0g79l0+LMIhvQd8dQpuRYt986yMJNOz+2uMBnYaQjA19f+F8WyY1H75zc88SpRffDtOFqbeYbApii6ABFZ0rxcUaaaQOP/suQ+a48eE06zjBnjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=axQlonk8; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IGcZjS011269
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 18:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=SMl9Xmy+ta/PoJTcRw7zTgo460v3TzjlAnnt5ng4bWg=; b=axQlonk8
	wUGEBSIEVgVoI0TFoTSr9Eh0T+kAnnFffYpr3wuczgbbTZM0r0PckU6af9hk4a60
	ifdPMTNZNGHlRTGev6mhwOI4nREqNsWabrT8iSKKM+b+Fm8pdJIyVQWohW2BjAdr
	YRpItLsFpv5Zpe6U/wOLfSQL/LAeHv/cXpGBGUZthRD7uqRUCDD2rDouHszCLqNy
	YzaQLJv7m0CHtjKWEm3jaz8KfhwCgz8IFoqbqXCvXPgBfR71VJGIVJR5CoZrF4BL
	EdULdQRwK57QR0/Fva0YwoRp7M27uPexZ1Bm24iQXFR5copioqGxcFMGDETUFFEl
	LZ06hy1DvQ8cLA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nkj66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 18:07:28 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58II2N59028074
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 18:07:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nkj60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 18:07:27 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58II0Jxe023489;
	Thu, 18 Sep 2025 18:07:26 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nkj5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 18:07:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwEpHVrzjyBCO7O+2mSOk+581zdD3ThWXvxsp0lnWYcFvqA6KmYY4ZGaqIPpoDlm28DIZAZIq/OauSdQBHMnq56umDvS9sM7hgdbppQqILwCUuaq/dkNxrpc0BV+wbrzPTxSccs1GJZukDTR7YL61iEo4K5J6+k3gSMNhHv1dF1RkrhIBU7M89a7I6vFgAVzXhwuW9HJmo97tAJzNU162DTfZ6lbz7ZTNHBkDr1Vr00mTc7H0z7Eht3QrEWM0VuY9bOmhh7CsJSREM2hrl8JtpwfF6xf7Jv8Hfh3TlwSQC+/8k7LK1ryUcRqwntSETy7r/7SjbHmy5GN6kn6nw1c5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5fgl+USXztswL1dvi5mvdKPUiyvSceBDUO2aPiANbs=;
 b=xF2npkHmoTlH9R5hU9k3VJBdQWe7hCfvLK4W7WIdy+aObVnT2JfgGpStUaX8cgoqBttPPubpi72X5mOXz8CJqk4gESymVa5Z1bruzxRUbystQxxYVqWo/c3sCVGhRODwKIh+gC3Bf+LjeMnMi01b94k8IIz5xfq54iOC247Czi0B6KshUSy69tcMql4rsoN3PE9u67OpSYjaGd5FUwlHwaruEgSrmFdbMqlZLmvL3cYxEKyLGXe+4m+N1spGHXe7a12GwUF1slsabmI3TTeRS2FZAZjmlDioxmAh6VTY93F+O0lbuv/5w2JbGgEX7qJqmqAOKRoWfYTNs0bOHBMbow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB5057.namprd15.prod.outlook.com (2603:10b6:a03:3cc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 18:07:23 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Thu, 18 Sep 2025
 18:07:23 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "lyican53@gmail.com" <lyican53@gmail.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: Fix potential undefined behavior in
 crush_ln() with GCC 11.1.0
Thread-Index: AQHcKD62wAtpkSIONkKx6UhtKA1hyLSZPasA
Date: Thu, 18 Sep 2025 18:07:23 +0000
Message-ID: <e6987f0268bd7bceddbd6ec53fa174d07cfa3114.camel@ibm.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
In-Reply-To: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB5057:EE_
x-ms-office365-filtering-correlation-id: 89e1cefc-c1d5-4254-3ee0-08ddf6de3782
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnNiRTE0SjRBZnhaRmJ5TEVzR3Q2Mmd4cmY2ZnhuRUI3TEh3dG5rSDBlTlNv?=
 =?utf-8?B?MS9XRnRPMDV3akVxOFU2dGRUbytPWjJFM0REUkNCK3cwcjA5MFhvbU0raVp2?=
 =?utf-8?B?eHczUzJ2Ymx1WmdtMUF2eEU4WHJ6UkVzaEJqMWV0MThFQ013SGxUVWFDNE5O?=
 =?utf-8?B?N3lmTnVNMkYxZHo1aTBieXJZaFNTcUZUaXVYVzhLSXY4YllzSUNuNVY5RmUw?=
 =?utf-8?B?Zyt5Um5oTnRpT0Vpbjh2M2lkVjl2Z1hmcXZZemJwRjBhNkxtakpRY0hCUzl5?=
 =?utf-8?B?Ty82ZU9kcjdkd0JQK2NaR0RYOUM0dWVRUE9qQkZuVGRQVnFzTHliaDRwNnVt?=
 =?utf-8?B?ZWNqcGN3RWsrQ1dRYzBxUTlsL0YxcU43K0Q4T0Q4SUUxV0Z6M3d2dHdLSStj?=
 =?utf-8?B?Ump2QzdGNFAvZWtnc2g0QnR4NEFuZGNJMUFNcFZFSGNocERmcTFFNktwMXU1?=
 =?utf-8?B?L2hDOC9JNUU2Z3hpNU1Wa0h5ZXVsRy9ra1M1RzB1U0doa3ZiL2hFajVjV1dj?=
 =?utf-8?B?TjNGekxIS0NMV0VBRDRqbkdESHBTc3JvMzJkU29WcU9xczBaYzgvWVRobkZH?=
 =?utf-8?B?YUlobWRYWTZMSXpBaU1TUS9qVTdnRGxYc2Q2WDNndXV2SHlRdVVKVkNadlha?=
 =?utf-8?B?MHBVRGNnZzV5d2UvOTFNb2NTNWliTGxJUFRsSnZ5dDV6SUFUMndLWTZ1eW1n?=
 =?utf-8?B?YjJmRUFOZmFmcXY3RDB3U00xUFZqS1VSV2Rxb0xKWEdGdTNHMzJXSjVmZEl3?=
 =?utf-8?B?MGozei94dEhlZ0FZZHI3TGhLbVZ6ckF4SlY2QUxIUndqa25jaXZ4eGlnUUtW?=
 =?utf-8?B?cXRUSkVFN0VOVm1DWEsvcXBWRmVyaTZ1U0VzOGk3WE1uaDUrSXN3eGM5T2Fs?=
 =?utf-8?B?enp0SGlVUjB4akw2TUNOOVQrM3lkRkl6QldlbE9CQ1QzK0FSdkp6WVVDQUNB?=
 =?utf-8?B?cGt3WGxhWWlJckp5MTVEUHhuREFCVXZFVVpJZDJiNlhMeFJDc25td1BrVkNp?=
 =?utf-8?B?K3g1VGViOGxVMjdnNUNmbmNLSEpxYWZ6WFN2ZWFzN0xPRmxheGZIRzBHampv?=
 =?utf-8?B?ZldkM1NWTVpxSjFncjdlb01mY0hhYnpiVXJhcW4wMUhsVmpnZlJTa0tyTTZo?=
 =?utf-8?B?VnB6a3hzY2VnUEpmSEN5Zmh0bWs2ei9TVmlndVpjZHpuZ2h3SXIvM3E1anA4?=
 =?utf-8?B?blY5S1QrWGdra2diTEhFeHNINmh0Y3ZQTlBaMU9qN29JQUVRNDd6ZFlIZFpk?=
 =?utf-8?B?VjUvUytqZUdZaSthUy8rQWFTdEJTcVlzc016TzRZbWl6ZlQrSXBKNUZYSE9w?=
 =?utf-8?B?TjNsR3ZzUDZ0MHI5VUErZVJjUnNzbGF6TDB2ekRhK2JaNWg1YnZ4dEJPNUtP?=
 =?utf-8?B?dTE1clNWM2JmdUdUUktxeFE1SFpQMnFKQTBxbEpub0lBS29aSlQ0OE9XQW9p?=
 =?utf-8?B?cXljTVd0UGVyVmxrQlZwZnV2bWNDWi9hMUsxamZPZ1poTk9oM3Z2REtrM2FD?=
 =?utf-8?B?ZSt0aXpyTmlqdnJPMHZOMmtlc3JIb1FxVGVaQktCbEozYUNSTDdqaWh1aUli?=
 =?utf-8?B?SDFjNFE2S3lJNyt6aDhWbmJPODRPVnRIN1ZCRUg1SXdZNFQ5RUE1T2h2L29x?=
 =?utf-8?B?eGs4ck11SVdZV3Q2QVpQejl6Y2ZleUpmeko3OUZKWmsrbFlLUGJDVzlqUU5p?=
 =?utf-8?B?SXdxSThNZHlJdSs5VTVDVXkzeU5jSHdmbitubU4rNjRkOTI3YmkrM0s1b3h1?=
 =?utf-8?B?ek1JUFExWWVGeHdWdW0wUy9pNU9TV1BtT3AxVCtIWkplQXRlYkZzS29UUkRi?=
 =?utf-8?B?aGFrNnZObFFscUFsVXl1U252OGlzdFpxOGR0cWZseHFUdDBzSWpJK25MVlZs?=
 =?utf-8?B?L2s3NDVCM0kwbXlGa3hNcXI1SGY4U1M1QktleXhOT1NJenhSRnozY1FJcmFN?=
 =?utf-8?B?a0N5MFMyaytTSG10WG9TaUozWjVZYmVmY3R0K2tlWTVGY2x2TENrcW8xV3BM?=
 =?utf-8?Q?K6SSm5PZxNFiOYUKQ3Hr8IXULhWSTA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aHdjU052dmNJVU9PL1dRek1LbENuNnI5alBvc0NmQ2h6MUxtMW5qS3UwOEZo?=
 =?utf-8?B?MHExM0c2VHlzZG1RS0Jzd1Z6b1pQSWFwaCtJTWYrQkFKY292MEpZQk5BTWEz?=
 =?utf-8?B?NjJVRURzZTRYVFUwQTVudUJIakNIUHEyU0dJVW9RUEJPcjhmV1FHRTV3UlJr?=
 =?utf-8?B?UmxVakxWdXRlaUloOUZYbXYzQWt1MEtSaVJHcHhOc2RCcHR6NFR5L3o1aFBl?=
 =?utf-8?B?MlNJZnRzZGNxMXhEa1BSZXY0UkFOSkpWUjJsbWVuUHRYUmtLTWRnU044MDVu?=
 =?utf-8?B?R2crNVBBcTBvRGJ5TDNUckNXVmZvMG9OWFlzQVg1WXJOQnVGbHhQZFVYTmg3?=
 =?utf-8?B?dmZZSlRlcnRmTHE4eENlMUJxcUM0VHlvU0tpSXFTRmFGSDBWU21KS2d4dEFz?=
 =?utf-8?B?bDJvUFh1SHNvc1k2V3lhSnc1dS9tdEpibU5zQ0RaSDdCMTJBVnkwdXJrWXpN?=
 =?utf-8?B?TUJtSjQ0OE9xSDhEOUx1RWRzUFYvNzJ0Zk1PTk1kaE5Hb1RDVCs5dXdBVGNa?=
 =?utf-8?B?UnJab1RLQ0UyeFIvQXc0bnhYMEFtMzM1aXdETEp3UTdnZk4xYTB4eVY4UUE1?=
 =?utf-8?B?L3VnQzBMaUVzVDFMcWx6NnVzN0FQd21RU1hwK3R4RlNNSjkzc2pXRkFKQ0Iz?=
 =?utf-8?B?bjE3MFZPUi9XV3BOT1FqU01wcTJadmRNa1o0SG5nSmFtNmFSNjVWc1FrNTM5?=
 =?utf-8?B?TTV2VkpxcVpNRHZILy9lOUpSRG02bzNZa0tSd1RUdytTaSs2bWI0dkpRMW5X?=
 =?utf-8?B?SDZCMytZRnBYM2hJRytzamhrSFBGQUlFZStybHN4QjZRa2lBRVNWL0hMVkRk?=
 =?utf-8?B?WlVCZ01FbklTM1ZkRUlsVW04MnRuZGpiYlhESkFTUnBldnB4eU5ocDMzNlRu?=
 =?utf-8?B?cndrM0VqMVBUd3c5enFXYWlWZXJyMGw1MVhmUWprUHB3L2NiOHV5ZU1RWlR6?=
 =?utf-8?B?ZGZHWmlVZXc0U3lSTHJsbnc3cVpaSnVhVnZWVUlFODRGVEREWWV4N0JnYmhB?=
 =?utf-8?B?VFVrRElORFJlSGtJSHZ1T1R1MUZrc2d5Y0UyUUI1aVp0a09oL0YvSkE3VVhp?=
 =?utf-8?B?SERUdGdBd05HZXd5QmpiYmJ6R3NqVGhRaWhxZmMwMk5Bdm43QXhzaDZDWnp6?=
 =?utf-8?B?U3F1Z0kzc0xCRXlkQm8rVlhNVmpCb0djSFVIcHVmUnVHY2dqaGNMS3VnVGJL?=
 =?utf-8?B?QlFRT0lhWVp4UXpPZFc4dENnN1BMMDVaUFFiM2JqcENjcGRObXpoN3RudS9u?=
 =?utf-8?B?QnE0YWZlbGdiQ1BqUjIwMUNBMzVuSXp1S04wUWVoYWc4MUhEc2hOcDBLUkc2?=
 =?utf-8?B?bUZ6UmxxNVBPRmhaR1hvT3hXZ09KbVJMNVQ3UHJUcEVEdENRNGx2Zlo2THN6?=
 =?utf-8?B?MkMvcWVPY1Y2bHYyRk1qWVpSRWI3ZURMQjh6MmdORllxdkVZSG5kOTZaVU9u?=
 =?utf-8?B?ei9SRFNzVU5ITHRld081eDZXcWNlMVNUNXlzNjdPU0FIQlN1Y1F3ZytQNzlr?=
 =?utf-8?B?dDlTb1ptckhOV2EzVm1LNnpJTnk3dTRRNkVKUWVGYlp4OCtrenRrQmV1aFdK?=
 =?utf-8?B?WnFUTERTZnRuNEF4eWZqNlJtQ2p4cHlSenBIKzZIZkN3TEEwblFHWURldm0v?=
 =?utf-8?B?WjVlY1lkYzhKb0JOVFhpQWVFVUU5d2JCVjg3WVYvRnhWeDRaVHhta05ERWdT?=
 =?utf-8?B?VE9oYzRnVHZpWmRKeFh5aXZHQ2xEazJFK0EwbWttNEN2SzFYWXZhMkxKOVZ2?=
 =?utf-8?B?VzV0QlR1S2l2RlZxRnJaT3Z3ZFF6bzU1RGxKblo4c1B3OXN0TzFQaEptNEVi?=
 =?utf-8?B?cmhXT01ZQ2hxdlRvc3RYUHIwYW41bDRlS3k5K3J0bGJUUHQyTTJuQUxBbEdQ?=
 =?utf-8?B?MEFKN2IwNFBTZW1kWEV0VGhtOGsxMGZVcXplUVh3RG5vOElLWDdEMTlwYkd1?=
 =?utf-8?B?MmpFRUVUbE9uSUUwL2JXNjl3TzQ1MUpDYnpLdllnQUZkcE9tMkI0Q1BUSDU0?=
 =?utf-8?B?WVJSWENKVFdKWmV5VSt6cFMvaXRMdUJKNWM1cktEK0daUHVESldwd1pVcHl5?=
 =?utf-8?B?Wk1zclBQazFDUkhoM01IeTg3Y1N5NnBmZm1BdTJRbngxMDFydjd6NGlwVlVm?=
 =?utf-8?B?K1RnZi91WHc2a2dHL2J1UTltK2hBZncyei9WdjlQNWxrQnBHMDhBZE94SHA3?=
 =?utf-8?Q?zcWv3Rs8l9b0FEpmBUfzCKc=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e1cefc-c1d5-4254-3ee0-08ddf6de3782
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 18:07:23.0711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GYe2X3+4OTMkikI4BCIAM7Clx/9QVI1M3cLgmzzc5pcfZYLMqYmvCHcElzovAhAAGBpnzDaGIEDahnh1twxADQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB5057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX4/OpZFHI7FNb
 j09ZaeZNdP7ykheOfT4VDbca9g27Kg7MILn4WazRCgE6brwZgYI2RGhb+fp2HKOgH8AB5xswsvv
 Vxmk8yiuSEZV8JE+Bh1JH3JYtjKUCPhT19lPZtDs4kF88r2+bg4lM81xVhutwssjGXgdHzvAUKH
 +7T3uv1UDxXTHZQx1aCFifixsgPZ4m2zKwZ8j0an0COvyc3EDY2eOFQ+XXRUFWwRNzBRDEFeJEm
 ddCjT3flDkiVD52Bh4mw9iFyIlopaNA28Ks5YPCruCQohYLGdZA4ulDnjO250t8Z16SqdIudPP2
 fyiGeKdycSjgAPjrxsv6oiY6S/w1NTOJlIPxD6hfgZ2k3PtUTRgghNB96LAXOOLUfAqGu+ibQp+
 eE4NKdZw
X-Proofpoint-ORIG-GUID: Xr7z4W9BCRESXV1XLpoDrHgp6ucZftzg
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cc4a5f cx=c_pps
 a=nAh4yJc8K/mwxcjpRfPwJQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=mDV3o1hIAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8
 a=zCXfdZZrKPHR1CA1UbsA:9 a=QEXdDO2ut3YA:10 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: pWdvmxMlorKdfwVznW7vcDCZhf4RGirV
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8177B194805F34BBD2FE64D32428424@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH] ceph: Fix potential undefined behavior in crush_ln()
 with GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=2 engine=8.19.0-2507300000 definitions=main-2509160204

On Thu, 2025-09-18 at 09:50 +0800, =E9=99=88=E5=8D=8E=E6=98=AD=EF=BC=88Lyic=
an=EF=BC=89 wrote:
> When compiled with GCC 11.1.0 and -march=3Dx86-64-v3 -O1 optimization fla=
gs,
> __builtin_clz() may generate BSR instructions without proper zero handlin=
g.
> The BSR instruction has undefined behavior when the source operand is zer=
o,
> which could occur when (x & 0x1FFFF) equals 0 in the crush_ln() function.
>=20
> This issue is documented in GCC bug 101175:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D101175 =20
>=20
> The problematic code path occurs in crush_ln() when:
> - x is incremented from xin =20
> - (x & 0x18000) =3D=3D 0 (condition for the optimization)
> - (x & 0x1FFFF) =3D=3D 0 (zero argument to __builtin_clz)
>=20
> Testing with GCC 11.5.0 confirms that specific input values like 0x7FFFF,=
=20
> 0x9FFFF, 0xBFFFF, 0xDFFFF, 0xFFFFF can trigger this condition, causing
> __builtin_clz(0) to be called with undefined behavior.
>=20
> Add a zero check before calling __builtin_clz() to ensure defined behavior
> across all GCC versions and optimization levels.
>=20
> Signed-off-by: Huazhao Chen <lyican53@gmail.com>
> ---
> net/ceph/crush/mapper.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 1234567..abcdef0 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -262,7 +262,8 @@ static __u64 crush_ln(unsigned int xin)
> 	 * do it in one step instead of iteratively
> 	 */
> 	if (!(x & 0x18000)) {
> -		int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> +		u32 masked =3D x & 0x1FFFF;
> +		int bits =3D masked ? __builtin_clz(masked) - 16 : 16;
> 		x <<=3D bits;
> 		iexpon =3D 15 - bits;
> 	}

Unfortunately, I am failing to apply the patch:

git am
./20250918_lyican53_ceph_fix_potential_undefined_behavior_in_crush_ln_with_=
gcc_1

1_1_0.mbx
Applying: ceph: Fix potential undefined behavior in crush_ln() with GCC 11.=
1.0
error: corrupt patch at line 10
Patch failed at 0001 ceph: Fix potential undefined behavior in crush_ln() w=
ith
GCC 11.1.0
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort=
".
hint: Disable this message with "git config set advice.mergeConflict false"

I am applying the patch on commit f83ec76bf285bea5727f478a68b894f5543ca76e:

Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Sep 14 14:21:14 2025 -0700

    Linux 6.17-rc6

Which kernel version do you have?

Thanks,
Slava.

