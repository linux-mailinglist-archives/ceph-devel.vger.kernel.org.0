Return-Path: <ceph-devel+bounces-3404-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEC4B21964
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 01:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9F8262289E
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 23:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A194D286D5E;
	Mon, 11 Aug 2025 23:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i0sEKnG9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA05F28641D;
	Mon, 11 Aug 2025 23:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754954862; cv=fail; b=Uj1ZSzKaoWx6ag2ZjKtbTpzYvfU6fTrn3vEKuRE9qf77BBeer2zmaaGHirR+Wzz6r3wAp/H2sKXuBcVCMJfPKZtAP60gcOGXAN4CB4J+CISPnnBBO8PeI6E/Hw6N7kUc4Di62g0s8tC2PYg3AC8qdcUF3gn2+iBkqe49FdIy2BA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754954862; c=relaxed/simple;
	bh=oMo8KMWb3xyyfViAJmABT5gkRIZipssy0dH+p3sJSaU=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=BMUhcndivapLU/vFvyy4b2o3Ak3ZPrKs7mrkHTPf9O6qgmjxp+lONPCefK8yvswAsEb1aVLq4WV7p9mQqqQl14XWVTYXFG5wUKxDCarh3h6sLjU+9VTmffJqaXfB++9JsZTByDNWjlcZB+X0B2X2HMLWpBefFIlE+dLJCOw6cLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i0sEKnG9; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BIvxDa028932;
	Mon, 11 Aug 2025 23:27:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=oMo8KMWb3xyyfViAJmABT5gkRIZipssy0dH+p3sJSaU=; b=i0sEKnG9
	1JPW3hIYrWXoQ3tTQE9kddPPlUpJRiTnORg/qro3OlBovQAl0b0InZ0tq5K20LNh
	1BhbTkYpdxDGez+REjmS8Md2h+PxDnCjzFG3QL/XfJwEs6TyUIqjxzCJ82fGjfXN
	WP6k7+GDVTsXwkaM2iifTpvGNkMfaikmhlZlM1CPOvLMPzEYonmGVIukLdqMz2pW
	UcU6Lwj4/6m8nIGC37apeFHPnJMG+0GjVVqK0efhL2nO1tcmxc8ApE8xV+0+D6je
	hAFoyZXB+xB7QjrYxZIA67TU9Nb+/PffzotEPLFkNrWV/sZtByRW2cR5Zks+MyaU
	AJngyNjWVrzjFg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2cupp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:27:33 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BNRWoO001386;
	Mon, 11 Aug 2025 23:27:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2cupp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:27:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJjgwoRZblgfvfDIFEEFVYV/yGfNoDIqfT7oXiJStJV5TsC4HzUjiIAwqepjmQGKE8hSOMnv5l2YfSLki/TA/B4rDX+boRV6j3535HXfAAhOCDJcB6OwARPSmslwZSJNABxLlHh5z04cTUyTJqFLwVG4PSRabvv/x/tZ8bBWItI6HAt0sO7yU5134wRzNLIdezM2NE1x5rG1iIDfljYy4Ao4rqWqBcx/Tx4ECpBzMQdQdOVNf9vOVS1xYAsWdG/Xx6NUzrPzEpnhDNwnSlJekjMb+UDNySCIh1BxQercFkqCyC8E/1R78mxZ0T9mPRGgal2pXfFO6FrkUb6WNwIIKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMo8KMWb3xyyfViAJmABT5gkRIZipssy0dH+p3sJSaU=;
 b=RraPEFSlLr+GUYgjOSF8RDOKC+3fiP18I5/jUrS1oRrxa1iBpTJMphT6gQr91P8ovUaYtwYzxG2MmLJNkaj9Hgw8aXdf/ZeFon5Fij4rh/8njAKdi35jxTuyOm/pm7RpSvwEf5950srdAMzZLU00h1O36g1UAHmqs82cER8VHDdI8koQ5j66Qz0tVLiS/+dP1lhijymNaX/9RtKnIe4k5/kKxEmD1yOfvb2t0e49cgBLgaMno3mkNgHv/CiUEyqXD6dt+j7b47tjBvOSRT3O8ZslgvqaLHy7HGcGeW+mnPmPpaF0ddxkaz9FxAhOhBBGSIR2B22ZncyK083C+Rb9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB6301.namprd15.prod.outlook.com (2603:10b6:8:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 23:27:30 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 23:27:30 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "max.kellermann@ionos.com"
	<max.kellermann@ionos.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re:  [PATCH 0/3] net/ceph/messenger:
 micro-optimizations for out_msg
Thread-Index: AQHcCxeBeGmvPgZNskGZGwFBj62k2g==
Date: Mon, 11 Aug 2025 23:27:30 +0000
Message-ID: <313a950008c144541dc8c4685c4f9682c476fbdd.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
	 <bd3cc7be947770f7d3c265253573a8dd97478192.camel@ibm.com>
In-Reply-To: <bd3cc7be947770f7d3c265253573a8dd97478192.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB6301:EE_
x-ms-office365-filtering-correlation-id: 90be2a82-0e09-4005-6799-08ddd92ea47e
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WjRBbWNRK1VSTGRwNEZsMSt3NEFGUzlobGNuaFBMTEtPbTVsWi9pQWZXZDQr?=
 =?utf-8?B?SXluUzNDaGo5Q3dlK0NRdERpRXNkL0lnMTVWTHFUQzVTb21uNFUvR0RDT1dN?=
 =?utf-8?B?aE5HbjZrb1pwQnpTRCtVYktZK2g4RGkwazM2cytwcWIwVlRGc0NBdmUwcURC?=
 =?utf-8?B?dHdaVVRpTEFKbURtSUlEUmorSTkrWGw1VUtCdGNyL0M4VWdTYVYzdHNLZmxE?=
 =?utf-8?B?WnFjVEI1WlVveDVZTVQ0cWNmT29kaUtGOWlQbzdkeHMzb2NxYnU2U3Z3UE9w?=
 =?utf-8?B?TG90eDlsaUpIcjYxeGQyQ0hVdHltQ2cvazJPRHQ2WW1tTEtVUUdOQmxEZXlJ?=
 =?utf-8?B?MjZoaWlIWkxTdzB6TkM5cEFteTI1NXJ2Rkg0ckwxV01OWk03REJNOU5tY1Ra?=
 =?utf-8?B?Ky9KeEVHcC9WTG1EUHpIdE4waTZIaU9mbUZmaktEa0Q0MWNjZkdDL0FmaVcw?=
 =?utf-8?B?dy9UU0dic2ppZmpNYTJoK2lwYjJCTS80elVxclp3Ky9GTlpodFdtV21QS3Fo?=
 =?utf-8?B?OHExbDBkcXJLNU1BWWdWd05mODJ2dmN3WlU1ZlJOQ0pBbnFJdFRGLzVJK1VF?=
 =?utf-8?B?SStXWG8zcitOQjZoN01VcXVPaWZkZU1UWjY4UDIwdmRqUkVIUW9JWFg0bzBn?=
 =?utf-8?B?a0gvZXQvNTdaNGRVM2dWU1UvWnFXbldqTGlibGFRa3N4aS8weVVaWlUyOHZW?=
 =?utf-8?B?a1Y5d213Rk5MWUt6d3llYXpnWk54OGlTaTZtV2hMNEMrZFVRaWJ6Y3lHRWtX?=
 =?utf-8?B?a3lBYjVOelhFT1FMQVN5aUVsajF6MXdFWitIa0hiOHhCUFlVbnBabmxUeUdX?=
 =?utf-8?B?L05JUDAxTHNWVXd1aDFKdEpmVktUNythRVU5eno2eXIxY2djQlBJQ0FXdzJn?=
 =?utf-8?B?NVlTZWMyV1VoNGJCNVRqRUFvbW9uOENPQnlIVGdwTS93b1prTVRjdWlPUnQw?=
 =?utf-8?B?VmsycU9VaVFGR0lkWHRIWkYvNHBrSkRoL0txM0FJUDNxUHFiMlIySTlGNUZj?=
 =?utf-8?B?UE5lY3hzUTcxaDZPcWJxTG00VkF6SkVhSll2Qm5QWmp1V0tSeWtFQnkrb3h1?=
 =?utf-8?B?c0RRNDNFKzhFMTdnZUN5YVVzSTEvNjkySHNhRGZNb2R3SExRRU9IWUhqbDF6?=
 =?utf-8?B?amdPM2c3ajNCOTdiSWZGTDZZRmZWalFIYTlVS01RVG5QWnhZQVZMQXRTcUNP?=
 =?utf-8?B?UlZOSmpnREJNQjBVNU1oOWM5RlQ1RU5YQlExSFQ4cVJ3VFFnVzAwV1NFTEFx?=
 =?utf-8?B?QW5ob3F0TTk0aXhxR0NBRGVVKzFwa3BUS0hGWk5GZk4wbzdjM2p5UHRjd0tE?=
 =?utf-8?B?a29tc0NpRDlHRjBJekthVWtUZll1dzEvT2IvcTFrYmIxRTNaa1R1bFJyS2R0?=
 =?utf-8?B?U1lJM2lXeExibGZ6bTFRU1lDZjBJT2F4bFFSejBHSHcrV2lrdk5KdGlVRGlY?=
 =?utf-8?B?dDJJbnV4R1BQRTBpbE52WEc4SVVjYzdPdVZOYUR0YldSeWY5VnQvQlY3eUls?=
 =?utf-8?B?NjlreHZzR3hESnphajY4aWhiNGVJSHRNL3JqT2pXQkwyRmROSzFaV2psMEJO?=
 =?utf-8?B?eWU4L3pkK0h5QWxvajQwbWlVVm9xeU1Rc21BSUVHVW5jaUlKeU9VWHdoRm5N?=
 =?utf-8?B?WFU3YWhmWW44aTFRMkpyRjZvSHBZU1lBUThOR29uZTFvUkhLKzl1Q3daNnpm?=
 =?utf-8?B?N3R5Vko1NGpLdUVxR3FEQTBib2RlZnNWT1JKcC9yUUJEclZCeW5JUUJTZWJK?=
 =?utf-8?B?cm1jNW5sZ3orQ05wQks1MjBERElOMHZKeTE0T2JvQXV3aWF6Ty9uMlo2bnZI?=
 =?utf-8?B?ZVN0Q2pmT2dBVTlxZ0JGcm4vWEFleituL3J5Sy9Sd0poTWZYTDVQM21nYWRW?=
 =?utf-8?B?Y0RacEZNSERDQXNrYU9FYzltUFc0bHdObXF3WDVIdmJVYW1uWmV0d3E2ZEtK?=
 =?utf-8?B?RjZWVjhEekZwM3NTVGxFVDhROGxNSnNPclpxWjBkaVFnaUlCTkZjbzN2aEIv?=
 =?utf-8?B?Qm16cm1mWjFnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bThPT2xoRjdFcllLamJwYVpXNlhXNlBmS1JsTWF2eVUycFVwR3UrOXhnRkN2?=
 =?utf-8?B?TmlibGxUS1lTV2FkbFNuZFFwblJiQlFmQkJ5RVVjaUtBeHhxYlFoT3V1NFhh?=
 =?utf-8?B?S0NRZkRlR05HdW5BQ214cGVzRU1rSFpwV3dGQzFLVVhSOGIrbi9wMHp6dE14?=
 =?utf-8?B?R1BaYS9rVTRFMzVPTXFrRjBqdy9FRC80QVRwcTF2cTFKbWoxRU9YdmdXSGJm?=
 =?utf-8?B?cTYxUHFvWWJuRFdNWHJNMHhtYXZFbUw2REczOTdMS3pZNVFOMEYxaTZYQlRx?=
 =?utf-8?B?WXhReDc1dWpaSnQwTWc0dVF4MjFDazV3RVJxdXpUTVJyTFpKODRTSStHMko2?=
 =?utf-8?B?cVVOWmdZK2RRaWZ1Q0NaZVlReS9nNVFLNnNBS3RoQ09acDhjQW81NGZSeEc1?=
 =?utf-8?B?VWowYkNZYUNDM2xHTlRrVjF5eVZKMjB0ZnVwN0VXMnRHT2RxUWhuT3FRMUs3?=
 =?utf-8?B?bDEwR3BKd2cva0Vodmt2WFFJYkJSeVZZOXBOQlNmejcwcnF5S29SUkVmZXhK?=
 =?utf-8?B?RjhySWZCcWtYOENTTVlGMktHZjZYRHNMWC9KMFZBZXNxRzg1SjdaYUJ2OTBG?=
 =?utf-8?B?dXZjVEpmKytUbnRUOGxxemlCckJwRktjbXNKLzZSWmozWm9XMXc3S2RnbjZp?=
 =?utf-8?B?TVhWN3UwNkUzNE1kQzlFNGM0andYSlZTVXV5UmpQUjRST3AyMTQ0WlcrL2dy?=
 =?utf-8?B?L25MUFkzdlpmVDRTZ1R3ZlJrVVZYMXQrNG1rMDJxN0kvY3NTRWdUOG9MK1Bn?=
 =?utf-8?B?Snd3My94Q2VYemZBeXVPNGFEV083QWZiRHJGRmVYY20vaWh2VGFoRDUxK0ZU?=
 =?utf-8?B?WmdDendVK0lnNGJPbHNDNWdXMmsrOHpaVnl1c0FTMTB1QktwKzQ1UVJhM0hn?=
 =?utf-8?B?c1NwSnFXZE9wMHpwWVM2dmFVNWRvWlB5SGthOW4yUWpxNGQ3V0xiTDVpK0pQ?=
 =?utf-8?B?WThmUzRYNVlyY0thamNVOFAxU1BTN0V4RUcyQzRtQ0xhbmMrWHlYTGdGR2Nt?=
 =?utf-8?B?eC9rRHZlcktIWmYxaVpncG5SdHVUZ1haWHZYZmQwOXE4bEpZZXROWDgySFIv?=
 =?utf-8?B?M1ZEak5iTXRmY2hKdmIvdzd5bXBlNmJBbzhPdTZBMDdqcHdZUFhwY2NZT1p4?=
 =?utf-8?B?alNIc1ovUHB2bVdGdXdiQ29IeEtLaFdrK0NzRWpTUFgyWHptaVZCcjU0TG9m?=
 =?utf-8?B?RGN1Y0QvUWFQZk9DaGEyTmhlUTk3b25SQnZSTDNZRlZoRjNOdzNsR09HbSt5?=
 =?utf-8?B?aVFLTVhFMkJjUk04ZmVjWXh0dU81RFhIeFVubDgzYTRrY2g0WWZJeXdLQldE?=
 =?utf-8?B?UmZWV01zQ0NEMlRUTUJGQXFPZEhBUG1kQWE0K1RNV0VtRnJzU0JPZ0FHNUd2?=
 =?utf-8?B?NE9XeHZBaE1HTEdUT0hOemxsL0ZUTThpcGRVcGZiTTcxWlRCYTBVU3Q3UU5Q?=
 =?utf-8?B?UlJrKy9LWTZ5d05VV3ZoNVQwNnN5Y2ZCOW9ML25jQ2VwRWlxUW9mSVRsN1Fw?=
 =?utf-8?B?SmllcFQ0M0MrOVpxQUtKUDBJaDBsby9UMURIRUhra3RMd0k1VXE5SzRqMytq?=
 =?utf-8?B?YnIrL1YzUi9DM3E0Y2wxMmh5LzdMbmhHbCtNc2pGVERhZXdDbDRmdCtwUHNO?=
 =?utf-8?B?UlpNaDhxdWV1ak04ZHp4UWRwU24wSERUUWt2dzM2eFVtRzJjdjRteEtKUTBm?=
 =?utf-8?B?d2lhdzJIVS9DKzRVcVlUY0xpNVZCZ0RVWE5JODM1TzAzY3ptRmRTd1p3VHJU?=
 =?utf-8?B?R3dINDhGbjdSaFkwTk81M0x1NjFabURkaS9IdjZ5Z0JjM0k2aTFjaEVTR1RS?=
 =?utf-8?B?QnI2T3k1R0lWNGJST2tqays4SUplNG1maDNtVE91MlpCTW5NUVdRU05WYzk4?=
 =?utf-8?B?ZHI2Yk5nUlEvbnlDRXZRTDBZaHd2ejVXbjQvajRKKzBVd2gveTJjZUZKNWkv?=
 =?utf-8?B?MmhzcTNFRU5zS1hJWVByS2ttRXYrNk9vRXVuR05qY2tPMDl0N0gvV2F4TzVi?=
 =?utf-8?B?VUhpN3pSVy8yanNwWFRvaWwxWUtKalpkT1dDNG5PSWFPSWhUdEpWZjFLcDVZ?=
 =?utf-8?B?bFU2VXBIWkp1SzhzRjVUcm44VUh0bUtvbjBhWlppRDk2aDZrVGFJSjc0V2hi?=
 =?utf-8?B?MXZkY2ZKUnZvT1F5aXlvSXF2Q0N2amROWVB0cSs4VjllU1JLTzRoU1p2b3Bj?=
 =?utf-8?Q?huAIxkFZ36yoi8/3pTPQB9Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BFAC9E8C1D2634BB331E8A93E51AB8E@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 90be2a82-0e09-4005-6799-08ddd92ea47e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 23:27:30.7482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzErROI8NRvK1qDtfvIvEWNknN6wkxwa07ROfujP4VZ4qdogV92cJZODC75zItjXFAIlrY0raS3Yx6tg4nZnAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6301
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDE3MCBTYWx0ZWRfX8LdvB5+hNzX7
 XBgbi2VuhsYxV9QnH0P7dn6MVgsGw445fePWTv/iD3ktOkXxrQzJuOsxRuNHCOW5mGJdcL8L5+z
 ZF46bmwxLc4VyT5KSBG3oYZ1iAq/fJQfldw5mrCn9mhsADeOBXgYRC75/8FpoKKn2/jft24T63s
 aS/Du9Adm1LW9QlTi580YVNPvIGxuQh15JtHn+cjJ20lJlKXDGVqhvJC8k5N6PYH9MwhgsjsGlQ
 AwJOk63nCJAOaUERWHxwFbvRuNZUu1TLCyGG7w+3CYH7VWC9mICrk59MXRFqVt08pkQSX3YYcFx
 SGpbmbVUzBfUYeNtqAwDLxOzuZQ/ob1Wpn1agS7NzuKblsSczR5N0g4U8G8Ar8EAbwQHPep59jK
 ZFzJVHgR8Jqnccyuhg08nAMjWQQeQsigQz27SaglRM1eNOriVVmOuBpQrTQu/AdndOo+GQ3P
X-Proofpoint-GUID: V4YcU7P91IWWFKoySUu3x0vkyFtQviqu
X-Authority-Analysis: v=2.4 cv=C9zpyRP+ c=1 sm=1 tr=0 ts=689a7c65 cx=c_pps
 a=EMkpfQS4iubUv0iPKfbWZA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=ruPUoltP3uE0ZbO6CbkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tDd7wo1j5hugdEsjx-w4AKzLXwLCjYFK
Subject: RE:  [PATCH 0/3] net/ceph/messenger: micro-optimizations for out_msg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_05,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=881 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508110170

T24gTW9uLCAyMDI1LTA4LTExIGF0IDE3OjA1ICswMDAwLCBWaWFjaGVzbGF2IER1YmV5a28gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMTo0OCArMDIwMCwgTWF4IEtlbGxlcm1hbm4g
d3JvdGU6DQo+ID4gVGhlc2UgcGF0Y2hlcyByZWR1Y2UgcmVsb2FkcyBvZiBjb24tPm91dF9tc2cg
YnkgcGFzc2luZyBwb2ludGVycyB0aGF0DQo+ID4gd2UgYWxyZWFkeSBoYXZlIGluIGxvY2FsIHZh
cmlhYmxlcyAoaS5lLiByZWdpc3RlcnMpIGFzIHBhcmFtZXRlcnMuDQo+ID4gDQo+ID4gQWNjZXNz
IHRvIGNvbi0+b3V0X3F1ZXVlIGlzIG5vdyBnb25lIGNvbXBsZXRlbHkgZnJvbSB2MS92MiBhbmQg
b25seQ0KPiA+IGZldyByZWZlcmVuY2VzIHRvIGNvbi0+b3V0X21zZyByZW1haW4uICBJbiB0aGUg
bG9uZyBydW4sIEknZCBsaWtlIHRvDQo+ID4gZ2V0IHJpZCBvZiBjb24tPm91dF9tc2cgY29tcGxl
dGVseSBhbmQgaW5zdGVhZCBzZW5kIHRoZSB3aG9sZQ0KPiA+IGNvbi0+b3V0X3F1ZXVlIGluIG9u
ZSBrZXJuZWxfc2VuZG1zZygpIGNhbGwuICBUaGlzIHBhdGNoIHNlcmllcyBoZWxwcw0KPiA+IHdp
dGggcHJlcGFyaW5nIHRoYXQuDQo+ID4gDQo+ID4gTWF4IEtlbGxlcm1hbm4gKDMpOg0KPiA+ICAg
bmV0L2NlcGgvbWVzc2VuZ2VyOiBjZXBoX2Nvbl9nZXRfb3V0X21zZygpIHJldHVybnMgdGhlIG1l
c3NhZ2UgcG9pbnRlcg0KPiA+ICAgbmV0L2NlcGgvbWVzc2VuZ2VyX3ZbMTJdOiBwYXNzIGNlcGhf
bXNnKiBpbnN0ZWFkIG9mIGxvYWRpbmcNCj4gPiAgICAgY29uLT5vdXRfbXNnDQo+ID4gICBuZXQv
Y2VwaC9tZXNzZW5nZXI6IGFkZCBlbXB0eSBjaGVjayB0byBjZXBoX2Nvbl9nZXRfb3V0X21zZygp
DQo+ID4gDQo+ID4gIGluY2x1ZGUvbGludXgvY2VwaC9tZXNzZW5nZXIuaCB8ICAgNiArLQ0KPiA+
ICBuZXQvY2VwaC9tZXNzZW5nZXIuYyAgICAgICAgICAgfCAgMTIgKy0tDQo+ID4gIG5ldC9jZXBo
L21lc3Nlbmdlcl92MS5jICAgICAgICB8ICA1OSArKysrKystLS0tLS0NCj4gPiAgbmV0L2NlcGgv
bWVzc2VuZ2VyX3YyLmMgICAgICAgIHwgMTYwICsrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLQ0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDExOSBpbnNlcnRpb25zKCspLCAxMTggZGVsZXRp
b25zKC0pDQo+IA0KPiBVbmV4cGVjdGVkbHksIEkgY2FuIHNlZSB4ZnN0ZXN0cyBmYWlsdXJlcyB3
aXRoIGFwcGxpZWQgcGF0Y2hzZXQ6DQo+IA0KPiBGYWlsdXJlczogZ2VuZXJpYy82MzMgZ2VuZXJp
Yy82NDQgZ2VuZXJpYy82NDUgZ2VuZXJpYy82ODkgZ2VuZXJpYy82OTYNCj4gZ2VuZXJpYy82OTcN
Cj4gRmFpbGVkIDYgb2YgNjEwIHRlc3RzDQo+IA0KPiBJIHdpbGwgcmVwZWF0IHhmZXN0ZXN0cyBy
dW4gd2l0aCBhbmQgd2l0aG91dCBwYXRjaHNldC4gTWF5YmUsIGl0IGlzIHRoZSBnbGl0Y2gNCj4g
b24gbXkgc2lkZS4NCj4gDQo+IA0KDQpJIGRvdWJsZSBjaGVja2VkIHRoZSB4ZnN0ZXN0cyBydW4u
IEV2ZXJ5dGhpbmcgd29ya3Mgd2VsbC4gSXQgd2FzIGdsaXRjaCBvbiBteQ0Kc2lkZS4NCg0KVGhh
bmtzLA0KU2xhdmEuDQoNCg==

