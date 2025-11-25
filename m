Return-Path: <ceph-devel+bounces-4113-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E54C86967
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 19:24:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D1857352B4F
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 18:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC40732A3CA;
	Tue, 25 Nov 2025 18:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PCNUEy6z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB7C3016F7;
	Tue, 25 Nov 2025 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095059; cv=fail; b=Edg1RToYOL1ptC7j4lvo7ucQOm5Xht3tyN7yqWsk3eKL1AvrKrb8UGopFhNmYO3/I6cQo/W7EXzkahGz/e2OIgQSF9k0XG18T4TVPgtOt17HqO8zvt2D0R9GV27UNqCbH9g8mjGnYm+2qX/ag0ejq3x9pxNU9Rx+VBQPjgWfo28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095059; c=relaxed/simple;
	bh=ch9iKFmUwKVUKW9EkMmuAFOsR3oponY2CM4vineSpN8=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=rAYLig+s7DCXjeb8aMqlMEUXdYMl1iheC6Gc+oQBIj4u/KmpQCdp3zwJluJXFYLwSJLcFGxjua9Cfy8FYUDk7yVR3Hu1gie6s4GpF51Qcy8lk1ga/aWvG4N58OKm3TAlGMwK+8OUfTJHUk3PEGk6xXCmRl0FlpQw/24YUkzRAEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PCNUEy6z; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5APAUvVT009240;
	Tue, 25 Nov 2025 18:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ch9iKFmUwKVUKW9EkMmuAFOsR3oponY2CM4vineSpN8=; b=PCNUEy6z
	anayywp7RdVU2QFacwuOhrR2wHf2GUMo5ih3jmmjbRuwt0EjQHByMN1eFrPXK1Cq
	Jc8rDm/kAEpwdNSRjqyMZlaYXOtY02jSMAsVuhO/t7mV77Pdqp1Jl9WELgh1WCRe
	GfMZFfu5YfG3ocKaiDrApDHxHtTUBVfZ2k/xNIyQW0YsV6QkTbL2VXnL77XRZGyp
	sIrMXsmJH149IgPiz5vOvdFlwC1CpDTbdApMB1ticozM24fyCVAnBbVWlJdthAfn
	CzkanZgnHr/HzqCtgVKEfinBpgasC2ZCYR/HArCCpmBUQvy0HbKZYuR7ojqwg1xM
	qBQJbdrsSMI+8Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1xqkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 18:24:07 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5APIO7rw027468;
	Tue, 25 Nov 2025 18:24:07 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011002.outbound.protection.outlook.com [52.101.62.2])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1xqka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 18:24:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qr8V16oH4jEUldnjNSOe/fIpc5PtwmTSefcj5f6nkp8EcQa4sAgRrH2kyXHX5MxYJ4iRG7mGhMn5Gg9I8YtIBSvrbWvzVmKQXkg7NCssYhsrdb4HMb7EQkvKL0MnOvNiN3Ec5DqWnT8DQ+XX2R/H4sL32ItUrnjvZ3NxG5b/qCNllmTC3v3vmkAk1VJOGrVYXovDh56dzYCO3+envA/zIQ9lwXYSZvx3cdKLBOpTQxcf28/7Cmr2btVFExSYr5gKTJG6AaLlHyuRFHH8EDwBcRr1J0VRkld9+S0ef4v1UF5zEE7IqYhU2++ScgfnVoi2QCbv3nMdOa+yKf9uvMjVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ch9iKFmUwKVUKW9EkMmuAFOsR3oponY2CM4vineSpN8=;
 b=tZQBFjJRGjlkBkx6JBYujq/tXMUU1IE2Jiy4qe6aUX5abXGHRnG0fd2nn1WyaHMoxHtybFaki8iI9amtH2ZbCmwNjKWKh5Y4LmpPfDrfdMxzSo2rLU/+0VNcSiZNOSzYIEH9dcEC9F5QYW7Y5PqMZ3U5SMEhIBrRpyo1vot+vz6t4MeH3X7QYWUhykJeGIjeRT5yHLpL5WLSd895mWnss9YdWiU+uNNgh+KFXP5WEezTXbAfdFRLpkRlkdpWHZpMxNd9F+3Je8DyVKrSOmriE0BsfIk3tZVMagaLMVMMWLb+NJW9exk/5Wl091UqnbpB6nl0NryhNXwqrvy8LejTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CY8PR15MB5531.namprd15.prod.outlook.com (2603:10b6:930:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 18:24:01 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 18:24:01 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "david.laight@runbox.com" <david.laight@runbox.com>,
        "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
CC: Xiubo Li <xiubli@redhat.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com"
	<morbo@google.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "nick.desaulniers+lkml@gmail.com" <nick.desaulniers+lkml@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v1 1/1] ceph: Amend checking to fix `make
 W=1` build breakage
Thread-Index: AQHcXfGtXlOVO6u24USGvyGiQ7LpLLUDtXMA
Date: Tue, 25 Nov 2025 18:24:01 +0000
Message-ID: <8e6a4135013227ea08ab2b03a6265143b021b861.camel@ibm.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	 <20251125095516.40a3d57c@pumpkin>
In-Reply-To: <20251125095516.40a3d57c@pumpkin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CY8PR15MB5531:EE_
x-ms-office365-filtering-correlation-id: da2eb7f4-0047-4b6f-0e09-08de2c4fcec0
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dEJPL2VOSlp5QXlDVkM5c3F2RW9xRzE5VGk0Zll2aHNJZExZNXZSU21JWncy?=
 =?utf-8?B?Mk12b2xxY3pLWHlXVVJnaVVuTzhJSWZFb3I4Y1IvZEVFd3RqTWtzai9XeE0r?=
 =?utf-8?B?RnpTdFE0bGx6U0RPemF6K0RKUDNzRy9jNnhrcnB6aVRLWFhKS3ZaV2Ivam5E?=
 =?utf-8?B?RDZZQURnR3hqOUlVbnVMejRPbjdnT2hZZDJHQ3dlbEIzQm5Ec0xCMklTRy9U?=
 =?utf-8?B?ZkVMd2FZK1g0ZmJOSGI0MlhZS1pkQVB3MjNldy9RdlROSDF1ZHRnS0owVWR5?=
 =?utf-8?B?dHBJckZLaUNZWUMzTEpaU2lFSXJHYXdmMFUzTWJnV0swUVFUUitxUVI2RE1w?=
 =?utf-8?B?aVFtMjBJaEFyK0JuTmx5SEdZdE8xdUtudlBnemNiTmJBdkFxMG1tTVBjOWkv?=
 =?utf-8?B?WTdnendSOUZUVXVUeUIyaXd5R3UvLzY2Z0FFemlBZTlQU2o1amhYa2Z2Mkwy?=
 =?utf-8?B?VUhGMXBxL3Fyb1d3ZGJ0TUdKVThxYjM0c1UwZjZnb3JacjIwd1FncG5zTHJr?=
 =?utf-8?B?SVYxY1M1cGFRdTFiMEVLQzQvODJwckpMa2dQdHVRV1VxaDN3TXZGQ2ZoZml3?=
 =?utf-8?B?OFFwWVoxU2R6R1hlRDZxN1pkMTd2SWo1R21ESTJseHVtbWgwRFN2Znl1dU9W?=
 =?utf-8?B?N2hMaXgvYkFWdUxkVGVUcUlnenVqVE9pdXN3S05tWGpydW1Ca1hsTEo4Rzhp?=
 =?utf-8?B?U21zcjB6SlJKRjY5aGdtQXBwMWtZNjJmbjF6ZGdnYm5nU243cXdabjFCTm8w?=
 =?utf-8?B?NnhubG1jVDlJNnJ1R0t4b0c1VmNaa1JVMm1lbDFwNjF2U0pBYXJxNmlLK1Bv?=
 =?utf-8?B?aUpiNUt1Z2NRbW00N0ZCTHZJeDJSMVE0dG5vUW4rV0lKaUxPRElqTVRzU2xX?=
 =?utf-8?B?NEtlY1NkR3F3aGpRS3czOWNNd25qNlo3QnlzZHpoOTNBYmVWdWU5cWJidGgw?=
 =?utf-8?B?cm1xUFcvbVEwZjlyaS9IRThNaTNMdklvTjBOV1IxdlNpL1F3Y2s3b21WNDVZ?=
 =?utf-8?B?ME8wMEtraTZBS0wrTzZueG1XWW9NdDk2OU93Sks1WHoxZXlab2NCWjNiT05o?=
 =?utf-8?B?VkN0ZXhhQmNKMStzV1hBK3EvRG5TdGh1OVdybldBZUxZWExHNlNXekxsajli?=
 =?utf-8?B?RWJSdmtPOVlwcjFqRWNQdjQ4U21sU1N4Y1I5K0hlcytFMUZySFZVVkJSbnl3?=
 =?utf-8?B?VC9Ua1loa3Zad3BKNTE5ckI4SnhIbnFDUGJwKzRJc2lCNENBOEdtVXhWcXpO?=
 =?utf-8?B?U3lQM25wNWVKWE9TOUhEdi9GY0tJSSt0MHppbThWZ1ZuNC9XMkFMR25La21J?=
 =?utf-8?B?a2hvRFBCSUNUYURVeDdORzl6d1g5Z0tWeDhVUWJVckpyQk8zTlZ2YWhSRUlh?=
 =?utf-8?B?U3NRNHdkb25PY01oSThVOFRhTndtRnhKY0JZTHBEUHo4b3hmNUV0Ry9QR1Vs?=
 =?utf-8?B?NDdwdGpRK2QydXYwN2plQTJmcFVKUWlad09aZGVaYm1jSnJaWFdpVDRacHRL?=
 =?utf-8?B?TndzM1lmRGlXZHdFMEc3ZFBWTXRWd2xIK29FZU9uYUZPbkQ0SDRMa1duTXpz?=
 =?utf-8?B?UDFHN1lpVVRWMFJzMUM0dkxyOXB5YVV3WXVtWlQxcW96VTZlZUNJZVM4TXI1?=
 =?utf-8?B?SEgzNkd2QzlzS05pZXhOdEl5dlhSMlFhbW1TcGE1UytEeHcrS1pzT1J3SmUx?=
 =?utf-8?B?bTZaWkkyT1VOMTh1WGY1WHkyd1JkNkszei8zNnByQk9CcHRTdEw2NlFqV1Fn?=
 =?utf-8?B?RnMxNG1XNDd5d0NqVzR3eVRuQzEwVWVoWFF3Ky9ab2w5YmhkUlRSRmY5Z0wz?=
 =?utf-8?B?cjVrNk0yc0xDTHZCbnhHWDd5SnRtQmtMY1o2WWN5eEl3SDQwOFhMRFQ0SW9U?=
 =?utf-8?B?Rjk1OXltYktSOE93NzIzNTZBcEtaWG0ybFUxSk1qK3hGSVlSYzNnZGQvQmxL?=
 =?utf-8?B?Z2NhQXc1UlVRS1hDMlp5MEtoS25YTkJxSCs5OG84OEhLajJtdDhMTEwyOERm?=
 =?utf-8?B?bkYzcWJzUmNqNStMazBRaXRWWXptK0tGT2QyVkNxdG1nU1dMSmdYNjY3THhH?=
 =?utf-8?Q?RwskHZ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dlpXSjFGZmdXQlpuS3RhcENOSElvMExxZHJ2WFJiY2c5L0MycUVEREdRUWpI?=
 =?utf-8?B?OWdyZjEyOUdZSnQyWWVjeFNnWFZIenUrWENjTGt4ZzRkN2xSK2NIMy9aVEMz?=
 =?utf-8?B?MXN3MDRDVXYrcFFHWFNzVTRqWmZBd3k3ZTNqVVFlRVlDK1lkQ25KZEpmZ0Yw?=
 =?utf-8?B?eGR2ZkZxZHh3R0NXNjd3cjVVYUtBUncraGdKcXFLTC9qSVFtSEMwY1RkeEly?=
 =?utf-8?B?NHJxNmtZVlFlOTV3dmNMY3dCMUNFRGpTV0podTlKOGJETkxGU0J0bjdaK2ZS?=
 =?utf-8?B?K21jQWtsV3hHS3VPVng4SmtKUXdQblFjVUdqUERGWEtjTmJDTzJaOGRLUzhK?=
 =?utf-8?B?Y2ZuNENNWGM0VVVXaU4rOERNaXhpaExUODN2a1YwTG5kZTV0dkZmUVBqSHgy?=
 =?utf-8?B?OFVrb081Y3pGVkoyN0RJNVBPb3ZNd2J1S2ZZRVRlZGdQcUZNV2NDdzVEdUtq?=
 =?utf-8?B?Umh1MnNRMncyRzB3WVRmZ1hKU0FPNndyV1ROL05JTS8yeXJtK1BvbHowVzBk?=
 =?utf-8?B?cjFuS0hnWlZSY3dVa203eVNBODM4MFVzVytabEhOTFZRTU5qWS8ybEd0VFlD?=
 =?utf-8?B?KzAzSkZRajZKQ2o3N2hzK20zUzhlZ1A4TTJkZUh6bFpiT0wrR0pVaW8rNlBD?=
 =?utf-8?B?bDYrWWhQbG5PSU5XcnQxMjZGbEZlRkJpZ2JBQUNvT3oxK2xMVXNNcWxScUI5?=
 =?utf-8?B?UkJjbkk3M0hPN09jbHEvZUlXYnBYbVB0RHRqcmxzbm5ZMk1XWmtqWTNrOFpZ?=
 =?utf-8?B?cjd5cXIxeGVNenNUTkZwQ01DaDdQRjgxUG02dVE1VkdTUHZXLzlGc013Uyt3?=
 =?utf-8?B?NGdtYzRFV21iQ0hpY1gwN3VCK0xWZmxhLys0eVBQdDB2M3dvR1UrZHI1NXZV?=
 =?utf-8?B?MU1sS2dLTGVnSkFhYWdINlM4b3BIVmcyRHE2VVoxLzVOQXFlV2ZkOWZqdDNS?=
 =?utf-8?B?UGFBOElQOXE0SERWQWg4OUpHVlB5RXQrckR5UFZZUStJZ216eHRlUTN0aVFV?=
 =?utf-8?B?bC9mRFdMQ1E1Q05relRtSjJVN3BheFFpR1hyYzA1Z0FUeGpVWW16WWZRQVJ1?=
 =?utf-8?B?VGdkNk1RMUpMMERJUDl0ZWhSUW1BazdnRzVQSm9SV2E3dnFLWUtqSkx2Ullz?=
 =?utf-8?B?cDhCVXRkM3BRMHd3SjZ6Z3RZM3IzTGRGNlNBem8zRHk4QXVaRFo5bG1tbXNu?=
 =?utf-8?B?Vk1mTFBvTFB4Y0hBemY1NFRFaGo4UTZKSTRVZElab2NUNkFrV2RoY0xuY1Fq?=
 =?utf-8?B?VGhQVzJFRU0rZzFNeUJZT3hsM3RGUU9SQjZLdVpGbVJNbXF2QlVjL3ZCOEpa?=
 =?utf-8?B?OUpDYkdnNWlQRTlKNWIra0VnOHNWMFlRdDZFZ0d6MzRJQ29tTnZqK1AzZ1dM?=
 =?utf-8?B?TEFwdDlhd2JERDlXQ0picWNmUXIyakJTamlIaHVwVnFod2pEU3ZDUkdYcWxH?=
 =?utf-8?B?bTB4b0RXZlJ2TXA3c0l4QmlzQTZnREVWZGxBRkxxamkzOXRxL0VDWllvSlpW?=
 =?utf-8?B?N203Q2hLWmlDdUtJeVZRQ0N0bUFWMjV3b1A5Z2czbCtjMmpHd2FEeEw1TkZZ?=
 =?utf-8?B?MWFlbE9OY3htVnhZRGFWbVYvSXZFQmtNUHJoUUJXWTVDUXYyMHFtUHFIVkpm?=
 =?utf-8?B?eW9oUFFxM0pQTm4yUVowLzVxbWdnbjcvNDdIbmtPcHJWV2xyVzMzbkRtb21r?=
 =?utf-8?B?TEg2NjYrRnpKaWN0cS9XelNOYnl6eUw1L0JzcnRPdDRaazczYjVhRFJodFVq?=
 =?utf-8?B?NHBoZmFleHJMUnM2THBMV1lka1M1aGtyZDYvZnZibTJvL1Vnc1RSeDNnaHRs?=
 =?utf-8?B?dDBjM0F4dHhwTkI1QUQ0N0N0S2orMWI1czlSdFZWaW5HK2lsenZXUUpjRnBo?=
 =?utf-8?B?QVgydmVSSTVSMWpFdnh6ZVpZMWZzREU0Y0hiT25mVk9PT0Z0ZkRLSkkySWZ5?=
 =?utf-8?B?NVRidmlFWUVSUlRheFFPQ0hrV0dEaEpYNXA1NHZGdjE5akNOd1kzUlRkcHJ1?=
 =?utf-8?B?TTVvZElHNVJDa0NDaTI0MStOd1RlYzdjbWpGaHRIdzN6RUtiQ09xT2J2NkY0?=
 =?utf-8?B?OEdZM0w0OUtteDhOMVVrZ1gyWFRNUHozZTV5LzVtekR5SEdjSGpJM0ZZRUNG?=
 =?utf-8?B?TjRtb3ZEQlRHdGUzU1lKcGtpdDdnMFJVdVBmL2x0Ri9MbzBCMzN5dk9zNHJX?=
 =?utf-8?Q?U6Qb80f+z1GNg/De119c7lw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83ADCDF98D0F0A4D8DB98CAE5B33DC7C@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: da2eb7f4-0047-4b6f-0e09-08de2c4fcec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 18:24:01.5307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mQbaIl+OHZHo6aDVNOke+t+Yl3T7VJ6Tb7b1MoUafnehNNuRZCRX8I981/xg4dZbRwTNfdHOst4KE5RPrFTdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5531
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX0LZ6gx3WB1II
 IDch+sGI5KDGrPPyCViSrVNQ1P8x3/BdDIvFzpjjleEiLUuSh6uJPXkM8mApAvz2rxy7ibGh7LG
 uGaklR19MSIwkiINAGhOHjJkpzHC34wGgcfpcPH9xIBIVGWEM4dMHnjdBf10jNLOaJ8Z4lwIAxZ
 2UeMMWmk2TWF4fSDW9vzVfdZQv3bL3JsnIXl04Wdb0dNPcpOj8Ph5TTkZQQxYUfP2lzkS4L3AE0
 6lMsG5v47M1Qg3MG/TtNQ9Hjt3KLp+WEkJXjV7saIFv9aGIW5zAY60vdzLJgNpEOaWkXf6VbZcO
 NOmLOVzGlyi4oYAl/+F+/JzXr20xTJicvn7Tp3KxsTefSmY2VEbOb49VXbTDe2Vzdf/m9CMqSSc
 Wb4sZsA1ukTIPL1A1rPfUU+EqFsTnw==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=6925f447 cx=c_pps
 a=wqOHD3zG9oVgxNNyXktjPA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=QyXUC8HyAAAA:8
 a=K6LLQhMUMX3GFguVnNwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rjGJgOsoSlBTsLXB01UkuuNDmN9xPzT7
X-Proofpoint-GUID: HQBAfsCiZrrlh099cjNbb1WOaY7GciWc
Subject: RE: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

T24gVHVlLCAyMDI1LTExLTI1IGF0IDA5OjU1ICswMDAwLCBkYXZpZCBsYWlnaHQgd3JvdGU6DQo+
IE9uIE1vbiwgMTAgTm92IDIwMjUgMTU6NDQ6MDQgKzAxMDANCj4gQW5keSBTaGV2Y2hlbmtvIDxh
bmRyaXkuc2hldmNoZW5rb0BsaW51eC5pbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBJbiBhIGZl
dyBjYXNlcyB0aGUgY29kZSBjb21wYXJlcyAzMi1iaXQgdmFsdWUgdG8gYSBTSVpFX01BWCBkZXJp
dmVkDQo+ID4gY29uc3RhbnQgd2hpY2ggaXMgbXVjaCBoaWdoZXIgdGhhbiB0aGF0IHZhbHVlIG9u
IDY0LWJpdCBwbGF0Zm9ybXMsDQo+ID4gQ2xhbmcsIGluIHBhcnRpY3VsYXIsIGlzIG5vdCBoYXBw
eSBhYm91dCB0aGlzDQo+ID4gDQo+ID4gZnMvY2VwaC9zbmFwLmM6Mzc3OjEwOiBlcnJvcjogcmVz
dWx0IG9mIGNvbXBhcmlzb24gb2YgY29uc3RhbnQgMjMwNTg0MzAwOTIxMzY5Mzk0OCB3aXRoIGV4
cHJlc3Npb24gb2YgdHlwZSAndTMyJyAoYWthICd1bnNpZ25lZCBpbnQnKSBpcyBhbHdheXMgZmFs
c2UgWy1XZXJyb3IsLVd0YXV0b2xvZ2ljYWwtY29uc3RhbnQtb3V0LW9mLXJhbmdlLWNvbXBhcmVd
DQo+ID4gICAzNzcgfCAgICAgICAgIGlmIChudW0gPiAoU0laRV9NQVggLSBzaXplb2YoKnNuYXBj
KSkgLyBzaXplb2YodTY0KSkNCj4gPiAgICAgICB8ICAgICAgICAgICAgIH5+fiBeIH5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+ID4gDQo+ID4gRml4IHRoaXMgYnkg
Y2FzdGluZyB0byBzaXplX3QuIE5vdGUsIHRoYXQgcG9zc2libGUgcmVwbGFjZW1lbnQgb2YgU0la
RV9NQVgNCj4gPiBieSBVMzJfTUFYIG1heSBsZWFkIHRvIHRoZSBiZWhhdmlvdXIgY2hhbmdlcyBv
biB0aGUgY29ybmVyIGNhc2VzLg0KPiANCj4gRGlkIHlvdSByZWFsbHkgcmVhZCB0aGUgY29kZT8N
Cj4gVGhlIHRlc3QgaXRzZWxmIG5lZWRzIG1vdmluZyBpbnRvIGNlcGhfY3JlYXRlX3NuYXBfY29u
dGV4dCgpLg0KPiBQb3NzaWJseSBieSB1c2luZyBrbWFsbG9jX2FycmF5KCkgdG8gZG8gdGhlIG11
bHRpcGx5Lg0KPiANCj4gQnV0IGluIGFueSBjYXNlIGFyZSBsYXJnZSB2YWx1ZXMgc2FuZSBhdCBh
bGw/DQo+IEFsbG9jYXRpbmcgdmVyeSBsYXJnZSBrZXJuZWwgbWVtb3J5IGJsb2NrcyBpc24ndCBh
IGdvb2QgaWRlYSBhdCBhbGwuDQo+IA0KPiBJbiBmYWN0IHRoaXMgZG9lcyBhIGttYWxsb2MoLi4u
IEdGUF9OT0ZTKSB3aGljaCBpcyBwcmV0dHkgbGlrZWx5IHRvDQo+IGZhaWwgZm9yIGV2ZW4gbW9k
ZXJhdGUgc2l6ZWQgcmVxdWVzdHMuIEkgYmV0IGl0IGZhaWxzIDY0ayAob3JkZXIgND8pDQo+IG9u
IGEgcmVndWxhciBiYXNpcy4NCj4gDQo+IFBlcmhhcHMgYWxsIHRocmVlIHZhbHVlIHRoYXQgZ2V0
IGFkZGVkIHRvIG1ha2UgJ251bScgbmVlZCAnc2FuaXR5IGxpbWl0cycNCj4gdGhhdCBtZWFuIGEg
bGFyZ2UgYWxsb2NhdGlvbiBqdXN0IGNhbid0IGhhcHBlbi4NCj4gDQo+IA0KDQpZZWFoLCBJIGFs
c28gcmVhbGx5IGRpc2xpa2UgdGhpcyBwYXR0ZXJuLiBUaGUgU0laRV9NQVggaGFzIGJlZW4gdXNl
ZCBpbiBzZXZlcmFsDQpwbGFjZXMgb2YgbmV0L2NlcGggYW5kIGluIGZzL2NlcGguIEkgYmVsaWV2
ZSB0aGF0IHRoaXMgcGFydGljdWxhciBjb2RlIHdvcmtzDQpvbmx5IGJlY2F1c2Ugbm9ib2R5IGNy
ZWF0ZXMgY3JhenkgbnVtYmVyIG9mIHNuYXBzaG90cy4gQnV0IGV2ZW4gaWYgbnVtIHZhbHVlDQp3
aWxsIGJlIGNyYXp5IGJpZywgdGhlbiBjZXBoX2NyZWF0ZV9zbmFwX2NvbnRleHQoKSB3aWxsIGZh
aWwgdG8gYWxsb2NhdGUgbWVtb3J5Lg0KU28sIGZ1bmN0aW9uYWxseSwgdGhpcyBjb2RlIGlzIG5v
dCBzbyBiYWQuIEJ1dCwgbG9naWNhbGx5IHRoaXMgY2hlY2sgb2YgdGhlIG51bQ0KdmFsdWUgaXMg
bm90IHZlcnkgcmVhc29uYWJsZSBiZWNhdXNlLCBhbnl3YXksIGl0IGRvZXNuJ3QgcHJvdGVjdCBm
cm9tIHRoZSB0cnkgdG8NCmFsbG9jYXRlIHVucmVhc29uYWJsZSBhbW91bnQgb2YgbWVtb3J5LiBT
bywgcHJvYmFibHksIGl0IG1ha2VzIHNlbnNlIHRvIGV4Y2hhbmdlDQp0aGUgU0laRV9NQVggb24g
S01BTExPQ19NQVhfU0laRS4gSSBiZWxpZXZlIGl0IHdpbGwgbWFrZSBsaWtld2lzZSBjaGVjayBt
b3JlDQpyZWFzb25hYmxlIGFuZCBmdW5jdGlvbmFsLg0KDQpUaGFua3MsDQpTbGF2YS4NCg0KPiAN
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmR5IFNoZXZjaGVua28gPGFuZHJpeS5zaGV2Y2hl
bmtvQGxpbnV4LmludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZnMvY2VwaC9zbmFwLmMgfCAyICst
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+
IA0KPiA+IGRpZmYgLS1naXQgYS9mcy9jZXBoL3NuYXAuYyBiL2ZzL2NlcGgvc25hcC5jDQo+ID4g
aW5kZXggYzY1ZjJiMjAyYjJiLi41MjE1MDdlYTgyNjAgMTAwNjQ0DQo+ID4gLS0tIGEvZnMvY2Vw
aC9zbmFwLmMNCj4gPiArKysgYi9mcy9jZXBoL3NuYXAuYw0KPiA+IEBAIC0zNzQsNyArMzc0LDcg
QEAgc3RhdGljIGludCBidWlsZF9zbmFwX2NvbnRleHQoc3RydWN0IGNlcGhfbWRzX2NsaWVudCAq
bWRzYywNCj4gPiAgDQo+ID4gIAkvKiBhbGxvYyBuZXcgc25hcCBjb250ZXh0ICovDQo+ID4gIAll
cnIgPSAtRU5PTUVNOw0KPiA+IC0JaWYgKG51bSA+IChTSVpFX01BWCAtIHNpemVvZigqc25hcGMp
KSAvIHNpemVvZih1NjQpKQ0KPiA+ICsJaWYgKChzaXplX3QpbnVtID4gKFNJWkVfTUFYIC0gc2l6
ZW9mKCpzbmFwYykpIC8gc2l6ZW9mKHU2NCkpDQo+ID4gIAkJZ290byBmYWlsOw0KPiA+ICAJc25h
cGMgPSBjZXBoX2NyZWF0ZV9zbmFwX2NvbnRleHQobnVtLCBHRlBfTk9GUyk7DQo+ID4gIAlpZiAo
IXNuYXBjKQ0KPiANCg==

