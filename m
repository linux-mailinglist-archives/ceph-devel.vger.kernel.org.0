Return-Path: <ceph-devel+bounces-3916-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAE8C2E509
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 23:49:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCBFE1894CC6
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 22:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6DD2D4B6D;
	Mon,  3 Nov 2025 22:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nBJwIDLp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C361A9F82
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 22:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762210176; cv=fail; b=C4L2nvfGiK5KvsoIumzbQOXAC5demLeCo+HFKBaH6+BwqTM2Aur87vqJ95R9nEvfg9NCrboio+zDFKTgb2sA0UIJOXJ0gD03c5QpVdn+dHNLM6nqg0KTapb8LVK55idNXjQAzD6Ga0JCdt1fY6uiLJ7JoaUPTz7O5s5vwLGel1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762210176; c=relaxed/simple;
	bh=LWBVIDxamiu6VpvZ8g+gU7g8TZTs2SHkpKsZtTQk6lE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=WZlspDm37MHPfhEs7BDnTxd2qWelLC0CWp9uKwOI6jSFqYcIMD/vKZvSMi+l8/1K9/FFtC3Jm0C8X1D5yHSbIwMQcFQdfw9suxx+3dCiiyV31BlUlcPf/RUeWX3wQJvvqwnp78Whnt5qch0HgZV27yAoJ08QrerEEcna4Le/iE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nBJwIDLp; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3FIEag019513;
	Mon, 3 Nov 2025 22:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=LWBVIDxamiu6VpvZ8g+gU7g8TZTs2SHkpKsZtTQk6lE=; b=nBJwIDLp
	qZDlm4uhshjUhMXsWuZJ9G/lXfy9zsPyazSJfuWEHD8vfej5OZTI5zI6R1+NtXpu
	uSdRcT+h5oBw0ZxJ6VDVtAMrJtanJDm1zxLcvXdb+8aMpfKxqrcniE+qKkJdPs2N
	pxWrRMZ8jzzdKwwTLkYfEIMd89XWOKSM5SeCnOk6FHw5iXXxf/1JgeGzwNkhnry2
	CNr0o878Fq4Ii+1pUEbVmWnovWpriY6fu+7o4WMGuRlIdL9pe1oRdCcSwEgdv4LS
	N0kjIMEXnwEEy2L99h3syWC/hmlRuXuTfKKe4q5ABoiR0DeYA6VIxf4SkQG5bl7Y
	AJ/QkOcttp9zog==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a58mkrxtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 22:49:32 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A3MnVsx017639;
	Mon, 3 Nov 2025 22:49:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a58mkrxtg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 22:49:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dP26OdTFi8o9cDwpw7Sib1UB0joNf2trlaQjXvlNk8h/60UVt1OAsYyiAVi1B2EnPZ1b7j/XHPMzd8qnoUEdIOa/54lpDO8OgBuUKV8ttvYIXqHCiy6kaI2yC72nb9Q9tjIZmu+/upwXIEzkP3ERqC8sxAq5ERIQq9g95NG8O59o8NOOGRf6Jb0jJgWsu7PBLoT+FVvGalpxkHLPzF7csUafgxRrudSEu+9xRsCxXyP82h+mp6pb4XBZhwfGswTjXdh3AdiDwJD+hLE+h7SLD4uGbVy7P4bbd4hvzVK8jaUfhbKSCyp87uVQkM+GQuxffk01T67sS+ZdFbUTg8b50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWBVIDxamiu6VpvZ8g+gU7g8TZTs2SHkpKsZtTQk6lE=;
 b=T6c+VVllQClrdQxTH4wgeOQaqAvqTw9q4TOSbzXayfDuC1rmWK474qj3Xa8+9QtSD9deKhZfa15ws9z70I5DqgSHIylfNboor2t/5t2pdCHovXdPEYRO27KnwKoNWdxW+CPzsFuI0NP3u+zNytDEBgvEaZf9Asupy271zU6+oKHhSCoDG0QVsutiWCIFuzd2pQb0Z7gXVrGykPYA4/6f0w54JjYbj6c5MzF6ebex16xuUpPNjSPEpSdS/kAi2ihsAHQEHJDo5m/EBPKQxSeVnA0lyyxbT6uDZCRt/XX8rnH0jPQ9vuiuoBK1JP2d2Um+D69r5Uy3+Vc2ywjr5yK2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB5812.namprd15.prod.outlook.com (2603:10b6:a03:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 22:49:29 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 22:49:29 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: Alex Markuze <amarkuze@redhat.com>,
        Patrick Donnelly
	<pdonnell@redhat.com>,
        David Howells <dhowells@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 1/2] libceph: fix potential use-after-free in
 have_mon_and_osd_map()
Thread-Index: AQHcTQxWImdgoDHAl0K7lLh0nUnwc7Thjh8A
Date: Mon, 3 Nov 2025 22:49:29 +0000
Message-ID: <2b9a4cb0ffaeb89f4a429b4138a5312f6ca10640.camel@ibm.com>
References: <20251103215329.1856726-1-idryomov@gmail.com>
	 <20251103215329.1856726-2-idryomov@gmail.com>
In-Reply-To: <20251103215329.1856726-2-idryomov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB5812:EE_
x-ms-office365-filtering-correlation-id: 8c8f3532-ec99-4d87-77e1-08de1b2b3f64
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q2dIVDRZS1lqTlMxZWRWb05sdmJFQlpEbFl0WjNDZmY5WFhlOTNDeUQraVp6?=
 =?utf-8?B?OHllL3FCN0hPTFZZUk9VS1YrNFYxblBHS0J4S2ptWlNmQlBxbnYxY2RtTTdp?=
 =?utf-8?B?QjB5blBlKzJlZTlaSjBwUy83Zm5GUk9wOCtZQXF6NG52R3BZK1dxU1RIRmNk?=
 =?utf-8?B?TS91SUdPdFRWVG1DcEJqdzNsanlQNTliYXlqY0tRM0xvdStXQi9EWUVhcWZP?=
 =?utf-8?B?dzd6L1ZNQ2dIcUd5bmoyU2NiRXIzZk4rT1NpK2ZaYkJOKzlSOXRDZ1kvSmov?=
 =?utf-8?B?WnQvZmdFcm0wTzZXZ0RrY3BERWczR25KdzlUMUp0WmZITk85NUtlaUREUW1m?=
 =?utf-8?B?YWMyYjAyRUJTUkI5YlJpTnZSVWxaN1dlSUtJc1ZLdmZLL2oyUG4zNmRxUklB?=
 =?utf-8?B?Y3JVSWV1RzQ2U1orQWNUNTlCeHNsRVpuMVgvRjJQR01scWZPS1kwNGtaRllM?=
 =?utf-8?B?M2w2QVV1eUV1ajhEcld5TmNLKy9IQ28waFR4ZTErdjUxcG53ZEJaTmI2Q3Yw?=
 =?utf-8?B?MlZRbk9wSjVpNE9Eb3VjU2xzOFhHSHBJc0Y2WTBWZFdhNUxBb1dRNTFBelcw?=
 =?utf-8?B?WlNWLzFQWHFpM1ZBblBUeTJueWZKa2FmNEVXeXVFMkJYM2tQRzZtR3BTY3dq?=
 =?utf-8?B?ZkdsQXE1UDFObW5jUDhWWTFpNkJrcGs5Q3VzNHlCNzNvWDRMZWdwVUpKbGF5?=
 =?utf-8?B?NnlRUllybEViNU0wdVNtbnZMMDBFRUZSdk1RVGhTTVdEMnpBeXg1aTdZUlY1?=
 =?utf-8?B?MmlYSStseGVBZjJSOTlLdkRQdEEreWJnNG9VT29oNVJIU1h4clo5d2hESmw3?=
 =?utf-8?B?MytHQjJMWXl5YmUvbUV5V3dmNmhGbE1xcHVJbThWeXlyKzVHa1JZS1l5b2ph?=
 =?utf-8?B?NGdpNVZHYy91dFlyblNjc09FK1FBejU4L1kweENhNnZ0WTBoL2xTSy9YeGsw?=
 =?utf-8?B?djlEV25jTHRxbWRZalhtSUpnRW42UFV1ZXpHZTJPUHdDRTh6dSthYzJmNHRM?=
 =?utf-8?B?MVlSaHdCeUl4MXkwMVZDcE1mYi9pcHZPVFRORTMveTRMd2F1MDVnZ3REcWNH?=
 =?utf-8?B?VkM3aWUyblFEYW5xcXVoL3drV1E3WFR6a1hkRFFaRHlGK3pFMnR2M2t6b1VZ?=
 =?utf-8?B?WlRNaXJjZG1mZU5wNStMVzE2b0VURkhvUEd0TGEyRlJNTU53a1RWRmJzRWFI?=
 =?utf-8?B?MWYycUNGVVNTUEJRMnhDVmJKaDhPekVMQWoxcU41dk5Sc3pjM3FUcTJRVmZy?=
 =?utf-8?B?KzFlUXoxQU4rdlNmdWV6WFpLQjJVUzNCa3ZyZlpFY2RSUHk4U2RMaW9WMERr?=
 =?utf-8?B?dDczVkxyc0l6eFU0U21hSDB0WmViRFkwUkpnZFI1Yzk4UHZMTUZkSERoUGE1?=
 =?utf-8?B?TUoreHNVSjFJbTdiYzZ4KytPUEQ3MmFabEFYeE0yOFNJWTczZkJ2UGdXVkE1?=
 =?utf-8?B?Wkc0UnpQWFdFcmh3MnB4QnFFbmFqN3BOT1poMDF6ZWZEb1RFbENIdEZjN0kr?=
 =?utf-8?B?QlhUY1BoL0J2VGhlV2VvTkNib2Fmc1lqWTRrM2ZWYndKaitTdUZDRURUQTdx?=
 =?utf-8?B?NFN1dXlFTE92akNxT0NYWVhFWVVvcVRMaE56MncvRzU1NnJoRDMyc0Y5USs2?=
 =?utf-8?B?dmc2aE51bTNWWlpCZENTNi8rS2NuQjdhdm1DTzR1RWdUOHlXNHloS1R1TlB2?=
 =?utf-8?B?cTVrcFFMRkNTR09HcGtPWTZQa1dlc2JtTy9KekhYS0pHSXBUS1lqalY5bjJq?=
 =?utf-8?B?cjNkNVE2WkRld1NTWGs2aysrSy9zZGxqbVllTkhOcHZ6VnVPSnNoTDR3UzRK?=
 =?utf-8?B?VmRLN01sNzN3OXk5VHdLajJkVUNKL3Z0aWhyeEtEbUFPYzluQ3pIOG45c1lO?=
 =?utf-8?B?WmFHcGdueExHMjRvOWtLLzhhbXAzMVpWdUVrRXRwaUFRNk5EdDdDbmhpRlBF?=
 =?utf-8?B?T2M3VlJ3bmM2UlBTZFgxYjd6WnI4QUJYQzRySHBxVjhOTVN3MkNSdS9HcEh0?=
 =?utf-8?B?RFZMbGthcklRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aU9sRktZNjcwOUd6WEl3akpPcGh4d1k3SHMvVGVmWW1UN1ZMaU1uUDRRUW9t?=
 =?utf-8?B?M3FYUEwrYkxuNkFRNFFhQkdsUU9UMjJHZ0xSL3o5WGNNOW91cUorNlp5ZFRv?=
 =?utf-8?B?allvdHdKQWV4Z2dFeFMrdHUweThJNER4UDFGZFdtY1lwYjhoakxtRG84YUNm?=
 =?utf-8?B?Z29FeDAxdzdBNGluMjgrU1NQWXpUNmttUXZua3JzS1VQamZUajhyYVVjSG9Q?=
 =?utf-8?B?WGlkSk5MdTc2Nmh4Wm9hWGVnaThjNEM1VlRBWWpWZUVQL0hSYk9XQTc4RUFL?=
 =?utf-8?B?TWxQdGZVVlBjdkIrSEpMSlc1YzQvWHE5c2c1bXdIb0JsU3I3bXRhVUxpMTBL?=
 =?utf-8?B?NFBFQjZXRmVBSVIveDB5SlZuQjlyUGVCV1dlMlJ5YTRkcHFCd1UrVFhZWlc2?=
 =?utf-8?B?RUU5TXRiQzM5Vmw1YkM4QzhPMzhab21mWFNUc2x5elZMaWlQWThycFVqcE50?=
 =?utf-8?B?em9IRFVaSEFERlpoZGdaMDFGU092NkljRlpaMm55MkljVDUwcEtHM0VEVTc5?=
 =?utf-8?B?VG9hMzQyeTJqVkZKWkJwOUJJYzc1eWlvR2lQbHZ2cy8waXpjWmpZQ2Z1S3E1?=
 =?utf-8?B?V05rZmNNSTFqMUthTE84YWs3YlBoUzQ5ZkwrMDJHdTFnZXpDd1VkcjlCdXkw?=
 =?utf-8?B?MFFrbzE1d1o2eFg3V01EWG41T3JlVEhlcnp5OGRBMmRWQ3dVcjJCelY2Mjh2?=
 =?utf-8?B?cFlDOEljMHJ3UWZPQzB6ZlpUa09zVnM1RlhwbFR0a2Y0Z0x5Y241WkFEcEZN?=
 =?utf-8?B?ek9HbS9ORU80QVVBcUJwME1HaHdTQzF6eFlYL0xJbnp6TktPalN5bWd0NXVz?=
 =?utf-8?B?c0c3ZjU1ajhFd1ZMVWJxeHA4NDVVSk1XV0h2MUpnT0RiamRUL21wTUVxOThi?=
 =?utf-8?B?WmFVWWRmSEdOd1lRdGt1ZFZrTUxCOE1LVFJKZ3g5SXZta0UxcUxJN3hZejVY?=
 =?utf-8?B?VHdLYndmQk5lUlF6Z29oWW1DTnlDQ0VaMnZldkVVVjY3UTBCd1ZuU05VMlk5?=
 =?utf-8?B?d0Z5alFFSnlLc2FIOHNXZjdLcXdBQnRTU3UrRzNwOHplVXhGanZtTzNzVGRl?=
 =?utf-8?B?UklrYkhKdHZBSzRKTnpFSGRyTzRVQ3FPWFZMcTN4Ym9KemI3Umtpd2FPbWVt?=
 =?utf-8?B?MmE4NStwcFJGNEdLLzk5cGtwaW1HYjVDYlV4RndzY0hUZU0wRzFBN2k5SWxH?=
 =?utf-8?B?NFJBZXRabGZUSU00SlNJeXBpajgwSVBib2E0cmN5T29Wc000NlpWZ3h4bkJR?=
 =?utf-8?B?M3NSNlE2cmxJNDJoZWdCS2NZc2lsakhRa2hreGZTR0drODNtQXlpNGZFN1B2?=
 =?utf-8?B?SUFJVFFoOXRZOVQ3anB0cGhIaUVsa05TM3RCZHh1T1VLOXJJcHE3RVBOem9m?=
 =?utf-8?B?M1BSN0RWMlgrMXVxSjRsWWN1eTY3bkk4REZOUXVGWGlYdEphRGpNZk41ZzlU?=
 =?utf-8?B?dHQrOFMrOXJ0NldYa0VlbDRnbTlYdDNMUFpFR2FISFlhZWR0aTBoQ2ZkM3Bt?=
 =?utf-8?B?K2tONTQxTG1Mdy9VaUlDQkE3RlcvWHFwbFR3R0RLQjNSMWNhcnhhUHBuZ2Fx?=
 =?utf-8?B?QnZoMGhFL1Y3WUgwaUdYSWxQdTRudi9mTU5GWm5rRWpkMm4wZG9ER1Uzemg0?=
 =?utf-8?B?cGN5U1VuVll0Y1JGeWRMalNERUo1eG4xc1FVNHhOeHdiMXEzeVZqeTU3RVdt?=
 =?utf-8?B?eG9Wb0cxSVBaV0EvcmF3N05rNjRScHpSeWxrQzJmTTFpRWxYZWlBL1RwN1hv?=
 =?utf-8?B?UExMKzJOekI2ZFQ4S1ZDU0hHdzhIQ0V6VW5Na3RVWmt0dkxiV0ZNUTIwS1dt?=
 =?utf-8?B?ei80SzBCTDRYcTdkZFloVmNidHFkNUVXbWpqUXhVVzR6ZDBNYkZMN1dIREQx?=
 =?utf-8?B?Q0w5M0VsVTJMOFplOVQveTRrUURYS3VNc1ZiUGRldk5NYmREMExmNkMzeXpi?=
 =?utf-8?B?djFLd2JTMHRZUjFDRkE4aTliSW5lS0tGSGhVYWhkYURKdkZKL09pNUNLNEdz?=
 =?utf-8?B?MXNhNjgxVGJxZEwxenNySEJlYktNOUhKSkREa3hQNXcvREZmMHRLcGR5YkZq?=
 =?utf-8?B?Y3EvUC9mZlJpQ0tIY3pXSDl2OGp0S0tyNnIxbytVS1ZpTlkxOUlZbUQyeVV2?=
 =?utf-8?B?Rk9HN2ppcWZhSEYybVF3L2tNeVFaZ3NFYThxV2FTUUI1NmVha0pXdTE0M2FK?=
 =?utf-8?Q?zIt+li1GNgODreyZoBxbpWI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C73564F63FE56C49862F1771629599C0@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8f3532-ec99-4d87-77e1-08de1b2b3f64
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 22:49:29.3497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jzruGJ3z91AdLHRn+tGb8HgBtSMUSAm0FpibbeoEuqLbaQ3nt8c/DizoPmVhSANJ8N59r5ULAIQ0GsxQbfpgaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5812
X-Proofpoint-ORIG-GUID: BtGvQl_gzisFNnXJX_JMWQFzOS6r2UYi
X-Proofpoint-GUID: wnh_kJr_TVdDNPBSsvkZ4L3ekVDdNiz_
X-Authority-Analysis: v=2.4 cv=SqidKfO0 c=1 sm=1 tr=0 ts=6909317c cx=c_pps
 a=PWz2vMGk566g1z9MD32Dlw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=DaqwMDlVUFSc5vIAlfMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAwOSBTYWx0ZWRfXyE3K5xd3FxTQ
 CiawmXCl0y1h6bSZ+qtZMlrhsWW/OXx5yi/aUMYknM/Hw1q5X6jQdpvEgCdGh74XlalSpwyIX0r
 qUvNhlITyeMxnqfm6DVI8HZaVHPKUvWKD73lVtSseiP+FUHbYO/8ES8zqQeLsCdBWShBg0YB7s8
 ltpXQlkngzF/yt9zHg/mFAKOk8L2z0gQNQBIX6cBeNd3B22xZKdukxVpr0F46JnAlE2RIVi7hSE
 vYMx/dca72+gthmfWTiduYJTohuIT6Y6bDFn82HciPExYSz+idk2Ff9VfKsusInsNc51uMcJGut
 jAItTsvG8KjocXL1mFFb4TAZOLRVue+2EiB+gYICPcl79kCFObcEVr6uU5QgExjvRT9eq3IIrlH
 xohdykHUexy9XdwNjXzYyyALTmBW4g==
Subject: Re:  [PATCH 1/2] libceph: fix potential use-after-free in
 have_mon_and_osd_map()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_05,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010009

T24gTW9uLCAyMDI1LTExLTAzIGF0IDIyOjUzICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IFRoZSB3YWl0IGxvb3AgaW4gX19jZXBoX29wZW5fc2Vzc2lvbigpIGNhbiByYWNlIHdpdGggdGhl
IGNsaWVudA0KPiByZWNlaXZpbmcgYSBuZXcgbW9ubWFwIG9yIG9zZG1hcCBzaG9ydGx5IGFmdGVy
IHRoZSBpbml0aWFsIG1hcCBpcw0KPiByZWNlaXZlZC4gIEJvdGggY2VwaF9tb25jX2hhbmRsZV9t
YXAoKSBhbmQgaGFuZGxlX29uZV9tYXAoKSBpbnN0YWxsDQo+IGEgbmV3IG1hcCBpbW1lZGlhdGVs
eSBhZnRlciBmcmVlaW5nIHRoZSBvbGQgb25lDQo+IA0KPiAgICAga2ZyZWUobW9uYy0+bW9ubWFw
KTsNCj4gICAgIG1vbmMtPm1vbm1hcCA9IG1vbm1hcDsNCj4gDQo+ICAgICBjZXBoX29zZG1hcF9k
ZXN0cm95KG9zZGMtPm9zZG1hcCk7DQo+ICAgICBvc2RjLT5vc2RtYXAgPSBuZXdtYXA7DQo+IA0K
PiB1bmRlciBjbGllbnQtPm1vbmMubXV0ZXggYW5kIGNsaWVudC0+b3NkYy5sb2NrIHJlc3BlY3Rp
dmVseSwgYnV0DQo+IGJlY2F1c2UgbmVpdGhlciBpcyB0YWtlbiBpbiBoYXZlX21vbl9hbmRfb3Nk
X21hcCgpIGl0J3MgcG9zc2libGUgZm9yDQo+IGNsaWVudC0+bW9uYy5tb25tYXAtPmVwb2NoIGFu
ZCBjbGllbnQtPm9zZGMub3NkbWFwLT5lcG9jaCBhcm1zIGluDQo+IA0KPiAgICAgY2xpZW50LT5t
b25jLm1vbm1hcCAmJiBjbGllbnQtPm1vbmMubW9ubWFwLT5lcG9jaCAmJg0KPiAgICAgICAgIGNs
aWVudC0+b3NkYy5vc2RtYXAgJiYgY2xpZW50LT5vc2RjLm9zZG1hcC0+ZXBvY2g7DQo+IA0KPiBj
b25kaXRpb24gdG8gZGVyZWZlcmVuY2UgYW4gYWxyZWFkeSBmcmVlZCBtYXAuICBUaGlzIGhhcHBl
bnMgdG8gYmUNCj4gcmVwcm9kdWNpYmxlIHdpdGggZ2VuZXJpYy8zOTUgYW5kIGdlbmVyaWMvMzk3
IHdpdGggS0FTQU4gZW5hYmxlZDoNCj4gDQo+ICAgICBCVUc6IEtBU0FOOiBzbGFiLXVzZS1hZnRl
ci1mcmVlIGluIGhhdmVfbW9uX2FuZF9vc2RfbWFwKzB4NTYvMHg3MA0KPiAgICAgUmVhZCBvZiBz
aXplIDQgYXQgYWRkciBmZmZmODg4MTEwMTJkODEwIGJ5IHRhc2sgbW91bnQuY2VwaC8xMzMwNQ0K
PiAgICAgQ1BVOiAyIFVJRDogMCBQSUQ6IDEzMzA1IENvbW06IG1vdW50LmNlcGggTm90IHRhaW50
ZWQgNi4xNC4wLXJjMi1idWlsZDIrICMxMjY2DQo+ICAgICAuLi4NCj4gICAgIENhbGwgVHJhY2U6
DQo+ICAgICA8VEFTSz4NCj4gICAgIGhhdmVfbW9uX2FuZF9vc2RfbWFwKzB4NTYvMHg3MA0KPiAg
ICAgY2VwaF9vcGVuX3Nlc3Npb24rMHgxODIvMHgyOTANCj4gICAgIGNlcGhfZ2V0X3RyZWUrMHgz
MzMvMHg2ODANCj4gICAgIHZmc19nZXRfdHJlZSsweDQ5LzB4MTgwDQo+ICAgICBkb19uZXdfbW91
bnQrMHgxYTMvMHgyZDANCj4gICAgIHBhdGhfbW91bnQrMHg2ZGQvMHg3MzANCj4gICAgIGRvX21v
dW50KzB4OTkvMHhlMA0KPiAgICAgX19kb19zeXNfbW91bnQrMHgxNDEvMHgxODANCj4gICAgIGRv
X3N5c2NhbGxfNjQrMHg5Zi8weDEwMA0KPiAgICAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2Zy
YW1lKzB4NzYvMHg3ZQ0KPiAgICAgPC9UQVNLPg0KPiANCj4gICAgIEFsbG9jYXRlZCBieSB0YXNr
IDEzMzA1Og0KPiAgICAgY2VwaF9vc2RtYXBfYWxsb2MrMHgxNi8weDEzMA0KPiAgICAgY2VwaF9v
c2RjX2luaXQrMHgyN2EvMHg0YzANCj4gICAgIGNlcGhfY3JlYXRlX2NsaWVudCsweDE1My8weDE5
MA0KPiAgICAgY3JlYXRlX2ZzX2NsaWVudCsweDUwLzB4MmEwDQo+ICAgICBjZXBoX2dldF90cmVl
KzB4ZmYvMHg2ODANCj4gICAgIHZmc19nZXRfdHJlZSsweDQ5LzB4MTgwDQo+ICAgICBkb19uZXdf
bW91bnQrMHgxYTMvMHgyZDANCj4gICAgIHBhdGhfbW91bnQrMHg2ZGQvMHg3MzANCj4gICAgIGRv
X21vdW50KzB4OTkvMHhlMA0KPiAgICAgX19kb19zeXNfbW91bnQrMHgxNDEvMHgxODANCj4gICAg
IGRvX3N5c2NhbGxfNjQrMHg5Zi8weDEwMA0KPiAgICAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9o
d2ZyYW1lKzB4NzYvMHg3ZQ0KPiANCj4gICAgIEZyZWVkIGJ5IHRhc2sgOTQ3NToNCj4gICAgIGtm
cmVlKzB4MjEyLzB4MjkwDQo+ICAgICBoYW5kbGVfb25lX21hcCsweDIzYy8weDNiMA0KPiAgICAg
Y2VwaF9vc2RjX2hhbmRsZV9tYXArMHgzYzkvMHg1OTANCj4gICAgIG1vbl9kaXNwYXRjaCsweDY1
NS8weDZmMA0KPiAgICAgY2VwaF9jb25fcHJvY2Vzc19tZXNzYWdlKzB4YzMvMHhlMA0KPiAgICAg
Y2VwaF9jb25fdjFfdHJ5X3JlYWQrMHg2MTQvMHg3NjANCj4gICAgIGNlcGhfY29uX3dvcmtmbisw
eDJkZS8weDY1MA0KPiAgICAgcHJvY2Vzc19vbmVfd29yaysweDQ4Ni8weDdjMA0KPiAgICAgcHJv
Y2Vzc19zY2hlZHVsZWRfd29ya3MrMHg3My8weDkwDQo+ICAgICB3b3JrZXJfdGhyZWFkKzB4MWM4
LzB4MmEwDQo+ICAgICBrdGhyZWFkKzB4MmVjLzB4MzAwDQo+ICAgICByZXRfZnJvbV9mb3JrKzB4
MjQvMHg0MA0KPiAgICAgcmV0X2Zyb21fZm9ya19hc20rMHgxYS8weDMwDQo+IA0KPiBSZXdyaXRl
IHRoZSB3YWl0IGxvb3AgdG8gY2hlY2sgdGhlIGFib3ZlIGNvbmRpdGlvbiBkaXJlY3RseSB3aXRo
DQo+IGNsaWVudC0+bW9uYy5tdXRleCBhbmQgY2xpZW50LT5vc2RjLmxvY2sgdGFrZW4gYXMgYXBw
cm9wcmlhdGUuICBXaGlsZQ0KPiBhdCBpdCwgaW1wcm92ZSB0aGUgdGltZW91dCBoYW5kbGluZyAo
cHJldmlvdXNseSBtb3VudF90aW1lb3V0IGNvdWxkIGJlDQo+IGV4Y2VlZGVkIGluIGNhc2Ugd2Fp
dF9ldmVudF9pbnRlcnJ1cHRpYmxlX3RpbWVvdXQoKSBzbGVwdCBtb3JlIHRoYW4NCj4gb25jZSkg
YW5kIGFjY2VzcyBjbGllbnQtPmF1dGhfZXJyIHVuZGVyIGNsaWVudC0+bW9uYy5tdXRleCB0byBt
YXRjaA0KPiBob3cgaXQncyBzZXQgaW4gZmluaXNoX2F1dGgoKS4NCj4gDQo+IG1vbm1hcF9zaG93
KCkgYW5kIG9zZG1hcF9zaG93KCkgbm93IHRha2UgdGhlIHJlc3BlY3RpdmUgbG9jayBiZWZvcmUN
Cj4gYWNjZXNzaW5nIHRoZSBtYXAgYXMgd2VsbC4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IFJlcG9ydGVkLWJ5OiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBJbHlhIERyeW9tb3YgPGlkcnlvbW92QGdtYWlsLmNvbT4NCj4g
LS0tDQo+ICBuZXQvY2VwaC9jZXBoX2NvbW1vbi5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tDQo+ICBuZXQvY2VwaC9kZWJ1Z2ZzLmMgICAgIHwgMTQgKysr
KysrKy0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NlcGgvY2VwaF9jb21tb24uYyBiL25ldC9j
ZXBoL2NlcGhfY29tbW9uLmMNCj4gaW5kZXggNGM2NDQxNTM2ZDU1Li4yODVlOTgxNzMwZTUgMTAw
NjQ0DQo+IC0tLSBhL25ldC9jZXBoL2NlcGhfY29tbW9uLmMNCj4gKysrIGIvbmV0L2NlcGgvY2Vw
aF9jb21tb24uYw0KPiBAQCAtNzg1LDQyICs3ODUsNTMgQEAgdm9pZCBjZXBoX3Jlc2V0X2NsaWVu
dF9hZGRyKHN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50KQ0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJP
TChjZXBoX3Jlc2V0X2NsaWVudF9hZGRyKTsNCj4gIA0KPiAtLyoNCj4gLSAqIHRydWUgaWYgd2Ug
aGF2ZSB0aGUgbW9uIG1hcCAoYW5kIGhhdmUgdGh1cyBqb2luZWQgdGhlIGNsdXN0ZXIpDQo+IC0g
Ki8NCj4gLXN0YXRpYyBib29sIGhhdmVfbW9uX2FuZF9vc2RfbWFwKHN0cnVjdCBjZXBoX2NsaWVu
dCAqY2xpZW50KQ0KPiAtew0KPiAtCXJldHVybiBjbGllbnQtPm1vbmMubW9ubWFwICYmIGNsaWVu
dC0+bW9uYy5tb25tYXAtPmVwb2NoICYmDQo+IC0JICAgICAgIGNsaWVudC0+b3NkYy5vc2RtYXAg
JiYgY2xpZW50LT5vc2RjLm9zZG1hcC0+ZXBvY2g7DQo+IC19DQo+IC0NCj4gIC8qDQo+ICAgKiBt
b3VudDogam9pbiB0aGUgY2VwaCBjbHVzdGVyLCBhbmQgb3BlbiByb290IGRpcmVjdG9yeS4NCj4g
ICAqLw0KPiAgaW50IF9fY2VwaF9vcGVuX3Nlc3Npb24oc3RydWN0IGNlcGhfY2xpZW50ICpjbGll
bnQsIHVuc2lnbmVkIGxvbmcgc3RhcnRlZCkNCj4gIHsNCj4gLQl1bnNpZ25lZCBsb25nIHRpbWVv
dXQgPSBjbGllbnQtPm9wdGlvbnMtPm1vdW50X3RpbWVvdXQ7DQo+IC0JbG9uZyBlcnI7DQo+ICsJ
REVGSU5FX1dBSVRfRlVOQyh3YWl0LCB3b2tlbl93YWtlX2Z1bmN0aW9uKTsNCj4gKwlsb25nIHRp
bWVvdXQgPSBjZXBoX3RpbWVvdXRfamlmZmllcyhjbGllbnQtPm9wdGlvbnMtPm1vdW50X3RpbWVv
dXQpOw0KPiArCWJvb2wgaGF2ZV9tb25tYXAsIGhhdmVfb3NkbWFwOw0KPiArCWludCBlcnI7DQo+
ICANCj4gIAkvKiBvcGVuIHNlc3Npb24sIGFuZCB3YWl0IGZvciBtb24gYW5kIG9zZCBtYXBzICov
DQo+ICAJZXJyID0gY2VwaF9tb25jX29wZW5fc2Vzc2lvbigmY2xpZW50LT5tb25jKTsNCj4gIAlp
ZiAoZXJyIDwgMCkNCj4gIAkJcmV0dXJuIGVycjsNCj4gIA0KPiAtCXdoaWxlICghaGF2ZV9tb25f
YW5kX29zZF9tYXAoY2xpZW50KSkgew0KPiAtCQlpZiAodGltZW91dCAmJiB0aW1lX2FmdGVyX2Vx
KGppZmZpZXMsIHN0YXJ0ZWQgKyB0aW1lb3V0KSkNCj4gLQkJCXJldHVybiAtRVRJTUVET1VUOw0K
PiArCWFkZF93YWl0X3F1ZXVlKCZjbGllbnQtPmF1dGhfd3EsICZ3YWl0KTsNCj4gKwlmb3IgKDs7
KSB7DQo+ICsJCW11dGV4X2xvY2soJmNsaWVudC0+bW9uYy5tdXRleCk7DQo+ICsJCWVyciA9IGNs
aWVudC0+YXV0aF9lcnI7DQo+ICsJCWhhdmVfbW9ubWFwID0gY2xpZW50LT5tb25jLm1vbm1hcCAm
JiBjbGllbnQtPm1vbmMubW9ubWFwLT5lcG9jaDsNCj4gKwkJbXV0ZXhfdW5sb2NrKCZjbGllbnQt
Pm1vbmMubXV0ZXgpOw0KPiArDQo+ICsJCWRvd25fcmVhZCgmY2xpZW50LT5vc2RjLmxvY2spOw0K
PiArCQloYXZlX29zZG1hcCA9IGNsaWVudC0+b3NkYy5vc2RtYXAgJiYgY2xpZW50LT5vc2RjLm9z
ZG1hcC0+ZXBvY2g7DQo+ICsJCXVwX3JlYWQoJmNsaWVudC0+b3NkYy5sb2NrKTsNCj4gKw0KPiAr
CQlpZiAoZXJyIHx8IChoYXZlX21vbm1hcCAmJiBoYXZlX29zZG1hcCkpDQo+ICsJCQlicmVhazsN
Cj4gKw0KPiArCQlpZiAoc2lnbmFsX3BlbmRpbmcoY3VycmVudCkpIHsNCj4gKwkJCWVyciA9IC1F
UkVTVEFSVFNZUzsNCj4gKwkJCWJyZWFrOw0KPiArCQl9DQo+ICsNCj4gKwkJaWYgKCF0aW1lb3V0
KSB7DQo+ICsJCQllcnIgPSAtRVRJTUVET1VUOw0KPiArCQkJYnJlYWs7DQo+ICsJCX0NCj4gIA0K
PiAgCQkvKiB3YWl0ICovDQo+ICAJCWRvdXQoIm1vdW50IHdhaXRpbmcgZm9yIG1vbl9tYXBcbiIp
Ow0KPiAtCQllcnIgPSB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dChjbGllbnQtPmF1
dGhfd3EsDQo+IC0JCQloYXZlX21vbl9hbmRfb3NkX21hcChjbGllbnQpIHx8IChjbGllbnQtPmF1
dGhfZXJyIDwgMCksDQo+IC0JCQljZXBoX3RpbWVvdXRfamlmZmllcyh0aW1lb3V0KSk7DQo+IC0J
CWlmIChlcnIgPCAwKQ0KPiAtCQkJcmV0dXJuIGVycjsNCj4gLQkJaWYgKGNsaWVudC0+YXV0aF9l
cnIgPCAwKQ0KPiAtCQkJcmV0dXJuIGNsaWVudC0+YXV0aF9lcnI7DQo+ICsJCXRpbWVvdXQgPSB3
YWl0X3dva2VuKCZ3YWl0LCBUQVNLX0lOVEVSUlVQVElCTEUsIHRpbWVvdXQpOw0KPiAgCX0NCj4g
KwlyZW1vdmVfd2FpdF9xdWV1ZSgmY2xpZW50LT5hdXRoX3dxLCAmd2FpdCk7DQo+ICsNCj4gKwlp
ZiAoZXJyKQ0KPiArCQlyZXR1cm4gZXJyOw0KPiAgDQo+ICAJcHJfaW5mbygiY2xpZW50JWxsdSBm
c2lkICVwVVxuIiwgY2VwaF9jbGllbnRfZ2lkKGNsaWVudCksDQo+ICAJCSZjbGllbnQtPmZzaWQp
Ow0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NlcGgvZGVidWdmcy5jIGIvbmV0L2NlcGgvZGVidWdmcy5j
DQo+IGluZGV4IDIxMTA0MzlmOGEyNC4uODNjMjcwYmNlNjNjIDEwMDY0NA0KPiAtLS0gYS9uZXQv
Y2VwaC9kZWJ1Z2ZzLmMNCj4gKysrIGIvbmV0L2NlcGgvZGVidWdmcy5jDQo+IEBAIC0zNiw4ICsz
Niw5IEBAIHN0YXRpYyBpbnQgbW9ubWFwX3Nob3coc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICpw
KQ0KPiAgCWludCBpOw0KPiAgCXN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50ID0gcy0+cHJpdmF0
ZTsNCj4gIA0KPiArCW11dGV4X2xvY2soJmNsaWVudC0+bW9uYy5tdXRleCk7DQo+ICAJaWYgKGNs
aWVudC0+bW9uYy5tb25tYXAgPT0gTlVMTCkNCj4gLQkJcmV0dXJuIDA7DQo+ICsJCWdvdG8gb3V0
X3VubG9jazsNCj4gIA0KPiAgCXNlcV9wcmludGYocywgImVwb2NoICVkXG4iLCBjbGllbnQtPm1v
bmMubW9ubWFwLT5lcG9jaCk7DQo+ICAJZm9yIChpID0gMDsgaSA8IGNsaWVudC0+bW9uYy5tb25t
YXAtPm51bV9tb247IGkrKykgew0KPiBAQCAtNDgsNiArNDksOSBAQCBzdGF0aWMgaW50IG1vbm1h
cF9zaG93KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqcCkNCj4gIAkJCSAgIEVOVElUWV9OQU1F
KGluc3QtPm5hbWUpLA0KPiAgCQkJICAgY2VwaF9wcl9hZGRyKCZpbnN0LT5hZGRyKSk7DQo+ICAJ
fQ0KPiArDQo+ICtvdXRfdW5sb2NrOg0KPiArCW11dGV4X3VubG9jaygmY2xpZW50LT5tb25jLm11
dGV4KTsNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiBAQCAtNTYsMTMgKzYwLDE0IEBAIHN0
YXRpYyBpbnQgb3NkbWFwX3Nob3coc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICpwKQ0KPiAgCWlu
dCBpOw0KPiAgCXN0cnVjdCBjZXBoX2NsaWVudCAqY2xpZW50ID0gcy0+cHJpdmF0ZTsNCj4gIAlz
dHJ1Y3QgY2VwaF9vc2RfY2xpZW50ICpvc2RjID0gJmNsaWVudC0+b3NkYzsNCj4gLQlzdHJ1Y3Qg
Y2VwaF9vc2RtYXAgKm1hcCA9IG9zZGMtPm9zZG1hcDsNCj4gKwlzdHJ1Y3QgY2VwaF9vc2RtYXAg
Km1hcDsNCj4gIAlzdHJ1Y3QgcmJfbm9kZSAqbjsNCj4gIA0KPiArCWRvd25fcmVhZCgmb3NkYy0+
bG9jayk7DQo+ICsJbWFwID0gb3NkYy0+b3NkbWFwOw0KPiAgCWlmIChtYXAgPT0gTlVMTCkNCj4g
LQkJcmV0dXJuIDA7DQo+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gIA0KPiAtCWRvd25fcmVhZCgm
b3NkYy0+bG9jayk7DQo+ICAJc2VxX3ByaW50ZihzLCAiZXBvY2ggJXUgYmFycmllciAldSBmbGFn
cyAweCV4XG4iLCBtYXAtPmVwb2NoLA0KPiAgCQkJb3NkYy0+ZXBvY2hfYmFycmllciwgbWFwLT5m
bGFncyk7DQo+ICANCj4gQEAgLTEzMSw2ICsxMzYsNyBAQCBzdGF0aWMgaW50IG9zZG1hcF9zaG93
KHN0cnVjdCBzZXFfZmlsZSAqcywgdm9pZCAqcCkNCj4gIAkJc2VxX3ByaW50ZihzLCAiXVxuIik7
DQo+ICAJfQ0KPiAgDQo+ICtvdXRfdW5sb2NrOg0KPiAgCXVwX3JlYWQoJm9zZGMtPmxvY2spOw0K
PiAgCXJldHVybiAwOw0KPiAgfQ0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlhY2hl
c2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0K

