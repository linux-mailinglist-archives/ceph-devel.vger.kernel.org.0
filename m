Return-Path: <ceph-devel+bounces-3406-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F4BB2196B
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 01:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 162A53A3B35
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 23:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47AA1E47CC;
	Mon, 11 Aug 2025 23:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SHx3Jyd9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1FB276054;
	Mon, 11 Aug 2025 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754954950; cv=fail; b=onCKfu3g8sElrewOxvbJ6Jzu7Vx6MfaaKyCrhDd3l4VfqwsOUzEu2KkiH8o7estPCB3gB5YLcECKbVCPTiD8KhN9bNw6qwAuejj6i0uI8mcqbo/XvWn1PEvvq1YryDXQoCDK0aI2ky/Vj6WO1mhZPGcbOVO7jI88TLtZDbZ8kx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754954950; c=relaxed/simple;
	bh=AYH8+k0KuMh9XJeFSOGA/Oo6McY2dfoCMuMgksFGsNA=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=POhrE8bcuZxP9vNBAAvgRjIF+7kc3BJerNewWLkWqSNO7lJq+H0ES3J4wBmX11a2UIHZzvBpZ6xZgORFxdbPvM7nt20OCNLBmf8ND/8h+vJRjuM6dQ5IrfdhA1yQpPfLIoKvbuNRR+IlyTLWW9o+zZPW+M6pNrLN0bBM5Symdkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SHx3Jyd9; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BHMNwY020831;
	Mon, 11 Aug 2025 23:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=AYH8+k0KuMh9XJeFSOGA/Oo6McY2dfoCMuMgksFGsNA=; b=SHx3Jyd9
	rv6irwYsB3YDJuHDd2gw+mw7K0hxJMWDt0L4KyixS/bjUx/PdeI1UYWTu3UKSD9T
	vgRaZ+Kav9RdALAlUUqao7i1W1HHUoBT0nzB3WiSbG4Y9R4iKxSIVPUo9gTbVH1L
	6OV5jSuIwka9gLg+fa9OCubFVHJcf9IFaNRuvwUFKLd+HZxENfM8sLoVsE5p1rwy
	0GDosfz1oI/1lYEhDIsVSt/ePXnqltWiU4ctsebKPyzoco9ZdQUKbmyw+IEJ3frQ
	6+yN5XAgdAbtpepK5M9gqDTK+rz0wqkKHbQGu9od+7gZiojDjhQ9W2jmC0D0CbGr
	blLzbvrBvjaSLA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14bnjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:29:03 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BNOQTE003986;
	Mon, 11 Aug 2025 23:29:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14bnjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:29:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7kExuIDbG01Dccm8oYj/UexFnN0eWFflpVGJ9n7QG6L/RfA5wJe9VBG9qErHFYpWTuXuOwBZStlZJZ+q4+lbyxpn7YalP8WJ8GXzKuTZUreenaZZlTFPJOqo4nb3Zj/SUUvfiGOBh/L6sbeGb1FqWh7KtyURDIePjJXm0OJUPO86BIiXVqjtgs3vBIvPczWmywD1RRTJaHhKgMG+CAt2T6FR/qrZrbwvOA2UNo0+P2U4Fa1JqFTzWT5h7aFkBAjc7UqDhspan/I/HwLeXEtpSxfrVj07fJ1f9lWDSqn7qXZRpK/5Ladp6c3XYz2vFHARkBEGgE3SlzfjXJNv/e8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYH8+k0KuMh9XJeFSOGA/Oo6McY2dfoCMuMgksFGsNA=;
 b=pNLUkQ0CfoFGgI+kzzH1+Z/E0fRnxb6mr7KleoGZAEoqO3lnCuBmlKWjUtZVDd3OzAvx8a+L4KTycvypR0RamhtNCxHuwjdj/l2E9+NSfX0JwWuA1kTF1uFGv7yA90wiRXTdeqUJqC65FBU6Cj1j9ozeLPUtI+Dg/kOM1pPVWmZT024KtG4NwFOyJ8Ur5yYpIMK1iz+zw6x7Qceufjcjrgqk+a387bpdjoij3gxX/v9YgccncKW8mcdhXByhLlXONyCltY+KFaqs5aeRp+FdM4RYZWLgvi1D/DvjY8Wrek+0xLESlRA+oGQHyKRTrhlVPzN1cnEGGaXeAU3JDxjSFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB6301.namprd15.prod.outlook.com (2603:10b6:8:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 23:29:00 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 23:29:00 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "max.kellermann@ionos.com"
	<max.kellermann@ionos.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re:  [PATCH 1/3] net/ceph/messenger:
 ceph_con_get_out_msg() returns the message pointer
Thread-Index: AQHcCxe3iU35cHSYsUaFWEW59VoWEg==
Date: Mon, 11 Aug 2025 23:29:00 +0000
Message-ID: <3d0afc9ceb0f783eebded4b903dd2e16199c5bf8.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
		 <20250806094855.268799-2-max.kellermann@ionos.com>
	 <4cceb60a32d9c0c3412332843030de65ec588374.camel@ibm.com>
In-Reply-To: <4cceb60a32d9c0c3412332843030de65ec588374.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB6301:EE_
x-ms-office365-filtering-correlation-id: 3bd13185-90e3-4e95-f037-08ddd92eda19
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YzhOdnpScUltc05YRkR3VVVpZWU3S1d0RmxteThKUTV3cm5UZ0hNVnJsRkZu?=
 =?utf-8?B?UUNLSGFHVlRWQTRqcmtJNEx6V0pydDFQUUNZaERNVjg2QksyUDdTS0F6ODRK?=
 =?utf-8?B?TnJDQ2FMVzdmOVZBaVZBRlFlSXRCelhDU2MvYTRmdkgwMldCY08xd3U3ODVl?=
 =?utf-8?B?VXhqWCtmTDFPSm5EOS9iaEtXaUJOQytQamZkeEMxNDNUM0NrNm9VTUsxaDJR?=
 =?utf-8?B?M2RkQm1VaHNqUlpEY081T0JGZFhzOUErTFc1UlZPaHRLMG1NcUIzdC9oZHBT?=
 =?utf-8?B?K3l0R21RNWQ1aHVPb2Q0c0VXZmtqeTF1Q2NKVjdlaE5LeVVyem4vdkhPQlNU?=
 =?utf-8?B?TzFpeXlscXQ3NlNpdjg2R09hM1h6ZXAzTWFuRi9GNW5kS0RjNVZ5R3Z5amlz?=
 =?utf-8?B?THlRMFkzSmxjSHhRZGtjZEwyK2hEYytOcTh4eGIxdU5aVFhCdTVwMmVQU2dv?=
 =?utf-8?B?OURRR0hWMHFNbmlMWVJMT3M3RHFBL3dqbW9EUHVpcGMvRjZxSjZPMGMwNE5q?=
 =?utf-8?B?MVRURkZsSlRLeGgrb3dHb0V2NUx0ZjM3WHVIaitGRUw5WGdMRno3aURWUGpX?=
 =?utf-8?B?djczU2x2SW1HQjRwS053aUZITVFKMHhCT0c4cStIbUFPc0d5UXI1N1RCSUtj?=
 =?utf-8?B?clkxWVI0RlREcGdtR0Fqam4wK1FzNCtma3h1Sm9XNnc2cDVFa1JRcDlUVEtP?=
 =?utf-8?B?Wk5yWVIwMk1iNlgyWFk5QzhVZ3g0QnNNNW1sTGY0VXRpWVAzV1ZOQWI0YWZm?=
 =?utf-8?B?SXRBLzFiS3JqR0NwbG96WVZRZjJacTc2MkVxQzVHd0tJaU8ycGsrakhRa0Zy?=
 =?utf-8?B?TFBxR0FVVE9KNWtLN1dCejRkWjIzOUZKL0YyQS9KUURIYlk1SmFCSHN4VnZj?=
 =?utf-8?B?UVU2SzhuMnBsek05ZDN3RVhFMUpIUkFXdDY0MEdvd3p3b3lBa2F0aWxLWi9t?=
 =?utf-8?B?YmJuaVpFZCtnNER3bUdhdTFhN2NJUzkwSTByRjZRTFdrV2c0OVg5UVI5Q0FT?=
 =?utf-8?B?RHpOa1BBVGd6WFRlMU9CbVZLdExyb2EwSUFSQUF0eWN0Qk9MS29vdXVaMWx0?=
 =?utf-8?B?akwxSlJZcmhrN2VuUk1DMXFXZGRTWWhSWVY1NTZibXhJUzRRbkRzbmdRdEtC?=
 =?utf-8?B?SFhVcE1BM0t5bVhpY1hVWmZYRnFHSExiQllUbDVkOWUxY3E1enVuWlV1ZG52?=
 =?utf-8?B?cnFxSFo5M1l0M2R6UFhVY2VWdHZFSE10RUtIZEhnQlptSHV0MWluSWVhUUFt?=
 =?utf-8?B?ZW9KWi82alJleHVIUkJ0Y2FNMUhmRVVXZzlORWFYOWpoclBFVndvY3FOdkxw?=
 =?utf-8?B?dnNsc3JNT0xYaEJVQkZtN3NaV2ZNQi9EQWNpQlE1QWpJenRWbUpZNHg3bG4r?=
 =?utf-8?B?Qks5VDdlMnlsc1VEM0dYZkFycU5mbFk1Rmt2QS9iN0tHN1UvMmdkRVVaMG9m?=
 =?utf-8?B?bytIbXJDdmdmTVFWeWcwMEZtdTlUMExkUE1FSWN1anQzOHgzT0llMXJoWldn?=
 =?utf-8?B?R0VhOFh0V1R0b2o4NEJBWm9WRlYzTVFaNjJUYitDZ2REb1BlM3pJYTJ0TGVq?=
 =?utf-8?B?YkJCQkdndUFoazFVdkhTRnRDRW02ZTQvVzNEcjZ5OW54TEFzck1iY3hKRFpK?=
 =?utf-8?B?ZDNZa2lNUWN3TDBrUVZhTUF2bGhzTDJnYlM3RE43d2dncUZTam5MVWpBU0dY?=
 =?utf-8?B?NGRVQUlUTFZhWmNPUi9mT3lKMWI3UFdRbXZGMmJ0Si9IaTBXVWlBcVdBZWZ2?=
 =?utf-8?B?emN1L2lVUy9temFNd0hhaUh6MXI5KzhjNk11a01WRXJkT1NpVGYzajVVMnF1?=
 =?utf-8?B?cVVHSEQrNCtXYzU2MTFxU3lWUVRHb2RYTG9qK0FGWDVRQThUR2plL3FVOGx2?=
 =?utf-8?B?SVpOcmVxbldFZ0VaRnRzUXoybXg4TWc3enFqZjdTUTcvc1M3NGdQWjF2eVZQ?=
 =?utf-8?B?Rm5LanNuNm13ME44V1pOMlVvTlV0OHJ3WnR3THZxbmFhMlphYU4wTUFWcUhy?=
 =?utf-8?B?cVlMTTdpb3JnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q29TeVJjUm1JWG9RbDJkakZOdlJjZWlYdjNPR0FJOVQ5WEVPQnJIVm5lemM5?=
 =?utf-8?B?TlNWZG1oWkdwWWpRclROMkM2YXpOOTNJa1hEemdkakxiVXF3VXpsOFZiRi9I?=
 =?utf-8?B?ek1LbllxTUtnZm1YdzdQSjEwUy9pNm5BL2Y3V1JTckpmY2o4clVOWkFWalF4?=
 =?utf-8?B?M3JHVVhOdEowalYwOFVPTWNYMmpmRXJ3bVZzdlk1OFdTcTlndVJsZWpuYTVh?=
 =?utf-8?B?NHBva3FFOEJvTmY1SFI2WVJBZWN5MjIveDllT2JyWkdvRlRYeDNLT3BKazJl?=
 =?utf-8?B?c1BYV0hRRmg5dDllMjhUNFNHcC8wODlPaDVrSWZHQmR5ekdhTE9IVklobnJ0?=
 =?utf-8?B?UVduZVI2aTBUUlUrNW9Ja0FLTW5LLzZDZGxNOHJZTWk3R0VvRXR4VTlYVlNv?=
 =?utf-8?B?NWRSQzFnTk1ORDVoeHhXNGxIelE2aVY0eXNDaGNqZ2ZZS0FWWFUwT2RpSEQ4?=
 =?utf-8?B?QUdldW1SK2JhWDczajZsLzNMYXZiWFhWVWlLWG5kL3JEa1o2aWNTRWRkVzlX?=
 =?utf-8?B?VUlqM3Q0OUtIUzZqU0dhTk0wdVkzQlJuZk10cklobFhFT1c2SERKbmwyTlNz?=
 =?utf-8?B?NG5LWlR6QlZXdEZjb2JNZTJMTnBpbzBnVDlJSFJsZzlQUGw5blZXaVJPY2FU?=
 =?utf-8?B?N0JLZmVsUWh4M0NyUllxbGl2eUFOODloVkc1ZGo3RGd2bCtZUDFVZDdvaHln?=
 =?utf-8?B?eWZiNmxxcDlQRnNRUktycnoyaDd1VzErY05XMmVyeVYraUhhYUg0Qjk5MlBK?=
 =?utf-8?B?QjhJdjZpT0J6YnJQbkwxNzRQV1Z5NnhSbisvNGczUHNBVDFERDRpbmVFR0tt?=
 =?utf-8?B?ZVFZUGNZdnRhQ2VZM2NJRnI1ditWSjhPS0U2Z0Yvd0xxOTdVWmU3c21BNUFM?=
 =?utf-8?B?aDNLVTJxN0dCeUNRczB3U2pOT01mdnE0bWRUT1B2ZUoycjFBM2dvMHVnYkdo?=
 =?utf-8?B?aW1uV3I2KzF0S2xiZHZmZ1dZMjJNSHNVMDZQL2FkN3V1aFhMaDB0SnNCUFdk?=
 =?utf-8?B?UHIwVTBzOXpTYWRDRVN5aS8zUGtxamx3TGN4U29yVkxKL2JlSHVUV2V0VnlV?=
 =?utf-8?B?Y0NPZ2ZzaE0vdkYwTmlWMnZlMHdKeFJsaVBwN00wbjZITHFkVzVnR1ZwNU9k?=
 =?utf-8?B?eEJOQmNXM0NDZVFOMzd5aGpWaW5Jd0RRSXdleTlnenVqWS8rRk5aL2drM3U0?=
 =?utf-8?B?blYwODgrZEtIcFRJSzAvWnpXT0RTcjh4UGc5TmJsTDBOaUEySTJIVzUwejdt?=
 =?utf-8?B?VFhYbnBCcncweUQvQ09YRDU5MjEvY0E1eFlzakVIUnBXZGRrVFZXTnFCT3Nm?=
 =?utf-8?B?UXJmeTMvTHJOWXRtKzBKRXgxZ2ZicnBtdDA2dE44WnJvcGd0cm5GcnQvUU9y?=
 =?utf-8?B?M3R5Zy9CRXZxdHU1WG9XRXluUlFLc1d4cEkvYUt2YUdhU0FnWll0VHVZSnBE?=
 =?utf-8?B?Y0lQR2RVd0t4STBVa25wdlRIS0poQU96djZ2YkVHQzBBWTBkSlZwWEJZaVNz?=
 =?utf-8?B?aFNjeGhGL1Z5UUFjdHRzSkE3ZUQyNXp6RWRQakxXMHhTS2Q1MHJSa043MVJI?=
 =?utf-8?B?SHBNa0lHRnFLQmtYQWZxWDc3eDN0cmJZMnlKR3ZKSzFzMHFCaDlnVXV4OVRj?=
 =?utf-8?B?Z3pBVmw2TmdQNVBHbTVoa01FK0F2QThVY2c5dGRLTE85UHdFY0M4K0F6Y3Bo?=
 =?utf-8?B?QncrZjhGb0RmenU4RndsVVRwcUovSUFybk5IeGxyRW50MlNtd0tlY2NQQ1Mx?=
 =?utf-8?B?R01ZekI0Y2FPYWZ0QkZCVXRnT0JaUkIwR29kYXhRcC9hRFpWbTNRZlRraW15?=
 =?utf-8?B?YUEvcXp3S1Zxd0s5MFM3TFhFVGNZdG40N1pxbU4vWkVLd3RNajFSV0YxTy9V?=
 =?utf-8?B?blBLUUppWm9pdldVZVpGUmM3TENRbGV5dS9ndjBZcStJeE9CNDhwYXBJcE5H?=
 =?utf-8?B?Wm51SGNKTjVkOFgxN0VGUm55VFdkRFZ2Y2RzamdGczQ4OW1VbHpXNGE4S1Bl?=
 =?utf-8?B?Y1krbUNDSGo3OEYyNlhsSnpCdkxlNGdJQlVONjcrWUpZUkdaSEpvT0l6SWwz?=
 =?utf-8?B?d3doZWpzM2NnblUxSDV2VnNjbUtmR3pBdDN1aHhRdU0rbTJESjEyb25HS2ov?=
 =?utf-8?B?QmRCMi9QUzR4TzQ4ckhja2tYLzU2dVZMcjgvLzJtTFI1bUZYZ2w3MmtjUmxK?=
 =?utf-8?Q?VXrPvZ1XmV6VJaRAYMwqJFk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <714E9DF662274E46BBE2786C815487BD@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd13185-90e3-4e95-f037-08ddd92eda19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 23:29:00.7090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y+WnMJJ7K8SDwf8qXDyxOC9nqiXXS3Utkj4G9VjwwJ7kC+LkZmSXj8B618w49ktD0JV9uwNWszyrQ1PwQRBysg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6301
X-Proofpoint-ORIG-GUID: MVUk_n1IBs_mpQFnc_FslXydTyLJrRb5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDE3MCBTYWx0ZWRfX8bkxF0Mx+ayU
 LcPGosFOD9/7dRc1wkeEyV5vN+nMpmh+v87U6Oag8Dlq5aLJ8i9YLQczZRqET/aDh6e8mFsZvVS
 /oD9jxc12F55rB5nb63IsghrWKhHMHUtNnIl8ItUbdd0pYwbdIvohYptmlO2Ssaf9pEHG3onngm
 r7MqQ+4561EW+1lKgCy1LMn08oA5bC6xDIWv3zdmU4aiCZ/02isla/MsejLaDf1vgDvWeUCLcYc
 VLvy/GMVBwCtTYUEkMxX5Y3BwdWFLGE9J7RNpZx2zyAnehqPiP4R68q2OWCM2wzwQAMrmaUNm1K
 3IngV7NxktkKUZKMVOQMeMFKvqjn3pUTlafK98Hg5QHtJ0hOHyMRcvL5bVu5WKmlpUSw+eEMRHX
 UrnLXXWnqOIsOAyP0EPL9nF1ZEjVIYX520LQPzcOlb61T2M1MJ7z0mev6b1Cv/Digog4f6oF
X-Proofpoint-GUID: M8LaDOMRRv1hrDBRm-W4lWhaR12hUyxI
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689a7cbf cx=c_pps
 a=e9HlxM+9aOM0yej0CTtRXA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8 a=Jp_1oAmf03KeGE_8HPgA:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
Subject: RE:  [PATCH 1/3] net/ceph/messenger: ceph_con_get_out_msg() returns
 the message pointer
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_05,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=959 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508110170

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDE3OjQwICswMDAwLCBWaWFjaGVzbGF2IER1YmV5a28gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMTo0OCArMDIwMCwgTWF4IEtlbGxlcm1hbm4g
d3JvdGU6DQo+ID4gVGhlIGNhbGxlciBpbiBtZXNzZW5nZXJfdjEuYyBsb2FkcyBpdCBhbnl3YXks
IHNvIGxldCdzIGtlZXAgdGhlDQo+ID4gcG9pbnRlciBpbiB0aGUgcmVnaXN0ZXIgaW5zdGVhZCBv
ZiByZWxvYWRpbmcgaXQgZnJvbSBtZW1vcnkuICBUaGlzDQo+ID4gZWxpbWluYXRlcyBhIHRpbnkg
Yml0IG9mIHVubmVjZXNzYXJ5IG92ZXJoZWFkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IE1h
eCBLZWxsZXJtYW5uIDxtYXgua2VsbGVybWFubkBpb25vcy5jb20+DQo+IA0KPiBMb29rcyBnb29k
Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0Bp
Ym0uY29tPg0KPiANCj4gDQoNClRlc3RlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5E
dWJleWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0K

