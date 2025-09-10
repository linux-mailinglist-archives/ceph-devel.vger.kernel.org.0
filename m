Return-Path: <ceph-devel+bounces-3568-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D66B51F61
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 19:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE2A21BC1E50
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 17:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E0B2BE02C;
	Wed, 10 Sep 2025 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JnpV3Ih6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0029A2
	for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526473; cv=fail; b=N2cWc6TwsxmTpY4qq3fg3zcN/38Kmd/BGHAxfyaXVn5hxEM22pTXX6X8eTK6KBVohVj3xbQtGQKgLG2Jv8DYJDpZrj9gYyNFEGMPASEZcBgnwf8oiQQKNksG0n6QpyugTIBoHPDoyov49nQSEfBWuR3r/iOf2cimyFDRUzlj+80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526473; c=relaxed/simple;
	bh=hqxq9nzGBvivypAh3lCpmoAGacNIrzroGkh4oXURJHI=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=s2lZQeyccpeJ9RwoppJlI0EC8PF203Wf68Hs87o9C1d/6MYU39UEccZnPxbzxvEKSlxsE+HodUzbwR4VJxj919oCOJTYMLfybf7DYJ3ptIwXe4xqBk4aGi/TNoICtI/kyNX1p4UyOXgTK51z5p4KQSrAcjWnSE76aQnFZWDsKRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JnpV3Ih6; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AFDgMs026821;
	Wed, 10 Sep 2025 17:47:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=hqxq9nzGBvivypAh3lCpmoAGacNIrzroGkh4oXURJHI=; b=JnpV3Ih6
	mYwu2IAM5v0RToaU6hPRrZqL3grWMW1A0xN9sTUsrK40JyGKq1XhzK1+6jevek0d
	OzFNeT7tPg98phQwHsGReXTEnPwFvDY3MaXIsIyc53eHt6kRVCzT2SkoQByd3iuL
	0qMk0K1DPjot5FQiVoshQxXPPtobbDS6ZYmXmrnhhTv0FH0lT2UdSyaEL+mgR0oR
	rta/zL4SvER4J0UMmJKktCiuBlIdCGuYXe6AJQPKZr/Lk3r0aRfWRUO3MWqr4Z6H
	rMxBdMMLa1r7vjd7pq4g8ITvNiYfeVZ0js+Jcluiday/MwfPc+668sA+EqWahhh9
	4xMn0NkhlAmMsw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsyd4j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 17:47:50 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58AHirCK007650;
	Wed, 10 Sep 2025 17:47:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsyd4g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 17:47:49 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YlFbR/owAGqoLqJtr8Tbb7NMcJiOfNadUtfvmPFJYhgPErRmqC2bMcGbl8TnqCJORS/t3ALCqjd9O3dQtHQ43d/MQDzbgABXHUrmVv7bzbfirbk5fcnwf50GuYGlp6CqtZZzVVGJNay2pdjEQchIpPlsgCU+tTGvRirfx3Tb2jLupeI9f+++I7b5qGTIcdkjBEmxqxeZ90SH9TdgzgIRy64SksU0ZKlsv1r9eJtWx2x6kn7DxrWAepD5jWHLa6Q+ZrT0HK0yRuv2v+2wADr7Gmeq+u+vm8ybged+wXpLcoAyhMhIZP0nUNsIFvEgUqI4k7+wYxe4iCuug53R3ob3uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqxq9nzGBvivypAh3lCpmoAGacNIrzroGkh4oXURJHI=;
 b=LhCoRYywTLBEYkVtwl5L37MZ67nNizAhQIH1qkA0vNlfvyAn7D0VQZbFhx/7z8P83i0NV6HJosQR7JT/0nEVQwsZVieNLn22qRV1faSwnveJMzmSSpFZ0s1BENadG5m2p/jwqkS84HpVk620LM54sSCHsOLFWFbXQpZYkwW4TWnnYWPDTbBVQy2Vjs55WMLKPi25F9vQjOBYELxPJteHUs4UV2Ka9UIhfAAvaVdLlN6yVbzqD5nwjjDcbtpnr8daZLNzJEFZtt46j6+yDmlqKtX7ZVeqI8kjyf4P/oGOjgILFvDhMoCJWZy3bSnFmw0AHPuu84oRWuxXvewimW2n4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB5263.namprd15.prod.outlook.com (2603:10b6:510:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:47:47 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:47:47 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Kotresh Hiremath Ravishankar <khiremat@redhat.com>
CC: Venky Shankar <vshankar@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Alex Markuze <amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH v3] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcIkDxfakQrvYlw0aUSTsYelfNRLSMsYYA
Date: Wed, 10 Sep 2025 17:47:47 +0000
Message-ID: <9213aec1d374735d039eb4353d5591508fc1acf2.camel@ibm.com>
References: <20250824184858.24413-1-khiremat@redhat.com>
		 <9f15c800374bc29bb9bf89df3d4949f58195fed5.camel@ibm.com>
	 <CAPgWtC5NtjQo=fB7D0iFzk-xuJZc39sDD4o_EmNR99RfCCLc=A@mail.gmail.com>
In-Reply-To:
 <CAPgWtC5NtjQo=fB7D0iFzk-xuJZc39sDD4o_EmNR99RfCCLc=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB5263:EE_
x-ms-office365-filtering-correlation-id: 6cfabed5-b099-4c88-b0e8-08ddf0922765
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NzRFQVhIbCtFK0pOdXFpQ1JueXB2NE9UOTdLQ2hMdkNZQ3Q5OTNWS1RRbmFx?=
 =?utf-8?B?OWpSdHRjQXZWN1BPZUhGVXEwQ21yU0cxZmdyZVJKSVd6dnlCcXlRclhJc0dD?=
 =?utf-8?B?bGpKNE5UeElkSnVzdVllQ1E3VmJ2UDIwd1Q3YmZUM2tDeGk5ZUJVM0w4K045?=
 =?utf-8?B?bFdVUVVtWW0xT0NtQ2Q3U0I2YUlPZXBxYzErbkdGQW84cU9iZHNTcU5KRWhC?=
 =?utf-8?B?VlB3Ym5uc0pKRlJFTG9PM1NMVXJLMEVxY0dMcjNvZ2RETDB1aWZtbkF6YytE?=
 =?utf-8?B?bEp6dE94ckVNZUozc01Sa0hCVU9sNVVlNkNZUW5DcnBWcFJveE5uWUV2bThN?=
 =?utf-8?B?UkVVV3g1WXMrVGdOckZZK05uSm10aXVmUE9MNTJHTmc2QjhqQlpZQ0w5QTJl?=
 =?utf-8?B?Z1FicUNmZ2YvSzZqcGd3V0lxc3B5eDdFWEpjVnpvdVJRUUtJQXoyQmEwU29I?=
 =?utf-8?B?SUEyMHJZZG5hdjRBcnVWRU4yNEdvK1VDOU44K0V0a1ZKM085YllKdXRxMkdP?=
 =?utf-8?B?VHpLNHkzakxrbTlWNmNJczhJUnE2d3N3NEpFYk00OWF6VWxDcHo1eW0vdG0y?=
 =?utf-8?B?YTRNU1R5Szhic1FyTmRpMGtOc1ZkMVFRU3BGVExSYWxiZzEwRVUvVGhMK2pp?=
 =?utf-8?B?UUNCTjZNNURTamxqMVZzZzJkeUcvM0oxL25XNWFPRWNuUStQZmphU2lWSDlD?=
 =?utf-8?B?akhJeVhaK0o4blcwMEtEWEFiNy9nS244NFJSRmRnL2IzQ21LQTBsR2pIRXRM?=
 =?utf-8?B?OVVjWjhLaWQ0bGhxTlhrbGVYK1ZGajJvNHRBSXVab2ZleEVDMFp5K2czZnM3?=
 =?utf-8?B?N3lWdExMVU9DWUdqN1NWdk1xemZYMys3cW96V0tDOFFTNGRzVE81NlBtMnRP?=
 =?utf-8?B?MWgxOUhpYzZwZUx1RXEybVZ2eHk4YWlRZ29ZSkZlUjh5dWpJY25lWERjRXVI?=
 =?utf-8?B?QzFvc0VLVUdXWkFndUpoVnBlcjZsMFdYcHp2Tk51UmhRVE1rTE8vVHhiZ3lK?=
 =?utf-8?B?RlJxcTVScmdUY0h0ZWNmK21WamthOFEwQXBNSm9vOVR6bkFjeHk2M2VweDUy?=
 =?utf-8?B?S0luTVJrR2NRenBKODJyRDNMYVJyU29oa29BUEVuQk1BN1g5UHNwd2NjT0dM?=
 =?utf-8?B?K3Y5K1A5bHJHdWxpQTVHTWVCd2haNWE1Y0hLU2NNQU8rZXd0SSt4SCtON3pU?=
 =?utf-8?B?ajNuaTVwSEc2ZjBPSlQwek1jUkcyMVlPV1NsZDd0eU1QcFc0NGJZcG8vNTFI?=
 =?utf-8?B?QTV5ZnhNNHhBenRkQWRTY29zcjVicnI5cFFXMkMrd2lseG9Cb3J0Z0tIQzJQ?=
 =?utf-8?B?WFVUUitaT1FsNmpGcmY5UE0xWFBkVmJseFpQRHRUV285OWY4emlpZHVHUG1H?=
 =?utf-8?B?c0MydllFODZPc0JMd2xPLzFKd3VCeXZxRmxrOHNIM3pJZitzSFdmVW9RVjZG?=
 =?utf-8?B?TG9aTlE5QjRxQlNXVUVKMTVhcFFyZm9ZVVNNbXNlWFZ6dlV2L0IwQUlybVBv?=
 =?utf-8?B?Rml6YWJORVREV0ZYd1gwMDZMQ0daTzc4OTdyUWFCazdTN2l0Y2pvYkhUYjE5?=
 =?utf-8?B?RlpOQ2g5K3dVSkFqY2FNY0Y3ZThxTE5LWUtDdDlHVGc3d0FIbVZMUzhKK1VI?=
 =?utf-8?B?MThjWFJJaGZ3M3Y5YUFYYzBqZDEyOCtTNHFMb3RRSHJkWHM2ZTJGV3RtcXRp?=
 =?utf-8?B?NWJnQ0RYSkdRMno2QlE4R1BHNVlZUFhIODQ2YTBBZFEvRlp0TlBwVy9vNnJJ?=
 =?utf-8?B?RDIyQWxTU01jL3ZwcFduUDVMYUt0RnBaMS9Eb0E0M2hYRGlvLzBwZm1ka1Vl?=
 =?utf-8?B?NVgrK0U1b211THE5YUQxbzVuMVVYbEhQcE05Qmw3OVNjcG9tY3FtT2JMQWsv?=
 =?utf-8?B?N091YkNuOVhzM3p1a0MrcVRqNTF2dE5vYU90ZGttQ2tPSURHK0xiRWVqOFNn?=
 =?utf-8?B?a29INU5ReFd4a05HLzVSc3cxSkxDc0trYUxzT20xR3FzZVByVXVHWEVpUlFD?=
 =?utf-8?Q?bSGdlYQS8AuGJaR9Hx1dE+pCUPp4Ts=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ckJRd2ltQllVb2loMUpVbksybWUyY1BKMGtFcTMyQWZZQVQ3UVdpeldXSnkv?=
 =?utf-8?B?QnQ2V21sZnNIQVZSNEtoakxIQys4MFU3dlVUeUw4VGI0VXVXeitGOEJDT3Z2?=
 =?utf-8?B?UTFpZmxnN0U0SFZMeldvTXdQZkl6WHZ2ZEh6QUtPYmwydml4R2l2b2MraFZL?=
 =?utf-8?B?QkwzYlFpOFNhcTFONlhUYlJUY3BmaFd6VzE4TklZR2Yvc1A5YlpSaWpHYTZL?=
 =?utf-8?B?R0FXUEI5c1lrNWxFazUzUFFEZDlxa2NxTU92M3BCTlByWkltTDlsQWxXQVJS?=
 =?utf-8?B?U3I4R2d6ckxyam5lckRkOVBVSEtTb2NOL1JLcmRKZVUrQ05CeFQ5clppdjR4?=
 =?utf-8?B?QkZvbkw1V0x2dnFQNnJ2M2lXU0s3UndFdWk5a3c2Y3RXZ1hoNTNHZTFWdzdW?=
 =?utf-8?B?eHlJcmhxS2NzclliZ0o4dG5BNlE3WFJWWXMyRHlsTTFUWmRRTjhlSXEzYTlX?=
 =?utf-8?B?WkJPY3Q2VXlGWGFHakFKWS92bHRQMkQ1QmNObTM5VVZDeDBVZFBydkZDQU1K?=
 =?utf-8?B?K2lzNno5R2tvaWlGQ1NjcmhyOGU1L3FBemRtbHhvZTdxM0NoK0JHUk9iL1Ry?=
 =?utf-8?B?K2lsQndXTFVFQUZJLzAxNWZrdVk1Rm41M2s2MDZ4NklZV09Fbi9JYVdwSkgx?=
 =?utf-8?B?S2huZUJxV0pyK2JCbUhqbGd3b1d4b0IzT2NiNTdzNlovaDBHL1RVdFdWTHVU?=
 =?utf-8?B?Wi9EV0YvNnlxdEtETFdJK2huQ1dLZXg2c3BIbEJPSHkwZDNuSkxmektvZUdQ?=
 =?utf-8?B?UHJDNjh6UWN0T2VzR0pYS1R1djBpa0RsbzdqMXRLUDVpcnB0TWdTM1NsZ3pM?=
 =?utf-8?B?bHJGbTcrYzA1SE5Hb3JmWTVQYW9CVVpibEplcHNFeHRhTGJ3SkRwVHkzWDZI?=
 =?utf-8?B?QXdjMFJZMzFMQm1aYXJOcTkwdmNFWlMyTzJvMWJweXlIS0ZWVE9saFpBQllr?=
 =?utf-8?B?elRFYkJrb0U2MzdjT1lCZi9vMUtoZmw4Yjllei9jM1AxUllUUDRPWi9NbzVv?=
 =?utf-8?B?eUVmcitxQnIzdUtrSWJGNHpvR2xMTGRxYU5LL01zTjdWSzNxUEh4U1hJeWxQ?=
 =?utf-8?B?eGN1ZmRZREgwRnRONkFEQWtadGhwbEZIVDNabTBKQ0NRMTFxbTJubncvVnlZ?=
 =?utf-8?B?TlFvSW9hOHFya3hBdGMwUFovbHBsZzN3OXJnd2NVVXNYaS9PM2hDOXFHMlg3?=
 =?utf-8?B?SDFkV0EvMnVRUSs4OUFyOVNaN0lxbXBEQTVGbFErdmVuQmRxTnpFcGIxSTZE?=
 =?utf-8?B?TFpwUVZqc0NQSndDVnMxYnF4S0wybFVYeCt3TWlqWHpqKzlnNmhzWmRzMmxQ?=
 =?utf-8?B?bWw3RnpNVTZxSlp1Q0FHTks3b2t5SHJyYW5zUk95NmpDZlZzSnNMVDlhVGlu?=
 =?utf-8?B?UzI1OVdZeXJTSW1NUVBhNWRrdXJ2OFJtVnNhMDRHYzFMU3lQazJXZTRMcG92?=
 =?utf-8?B?RVF3Qmdma2FzVVFuYTB3Y0daQy9yQmd3WWtMMzJOZjBIcjJPc2M0SVdPTjBa?=
 =?utf-8?B?VkVwNmw0M2ZCbUlSOHVHR1d6QWJmVEtDVmx6NCtJMXBhN0RhU2ZjN1hJVlNz?=
 =?utf-8?B?NUdJOEtMWkFlREpFeGtkeWppZnZnOTZzVU51NDJ5L2MvT0pGMGtQQW5BTEpJ?=
 =?utf-8?B?YnpwRVkxRE1EWGVkRkpsVkFoUDZxRzZzblcvRzByMWIzT08wcVlIQ1VBa1Iy?=
 =?utf-8?B?c1MveWM3L3U3VGNMc3BQL1VkWFBQeG9CS1E0NzE2RTVZS3hzRlhLbFRrTUd2?=
 =?utf-8?B?LzZnbXpySmNBcCtFTTZ1YSswVHFjdGtsTHE4cXUvY3JsSVlrUUtFZ2JvMzBh?=
 =?utf-8?B?L0FlMStqcitFN2J0cEZlM1dSUFJLRkhwL0NHUFYxMm5YTUJrQTd0RG5uTGRh?=
 =?utf-8?B?Qklab0wrbUx0Q3ZQaVVVNFpBQ0oxUHUrQ0w3M0I2VDcwT0k2VVdoSkhWeTdn?=
 =?utf-8?B?WjdHdm9rcGlOMXZPdnAzWTRCaWpKRjd6cWZldDJlbkRFMXhaMHllK1RPdkg3?=
 =?utf-8?B?cC9yQWtEUnVxOUNOTStneDZtUG82bVNsTk0wZkVmSFlpSUU0WksySjk4TFNr?=
 =?utf-8?B?V2ltb0t5bjFvVks0KzRrbkVmbnBXKzNHRkZqYjB4clRRd3Ewd1VvdzM3bzdE?=
 =?utf-8?B?WGZhYnpHOEZ5MjRGR0xHYzY1a2dkaHpVb3BVZlVocUFOWE15bGJXZ0pBdHBS?=
 =?utf-8?Q?YefAyp3UVAS4bjmtQLHQsVI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8489A83F83F8547A44FFD83E651040C@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfabed5-b099-4c88-b0e8-08ddf0922765
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 17:47:47.2914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KzzielwMPtye2Qpn6cRQ3OCshuN4Wuo0EfBR5VeRI75rJztAIBD3Rce9UQcx9aFpi/BP5NmkQXbNMhrZFVIyDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5263
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX5tYUIee+oqU/
 CSD1P3iCbqybiPWwxzr5KTn7/Zmar1r/IAkXO475O7t2YoyXhX/ilKQigSlbOHDHc8XaKN5fAqV
 xJYd8utUKzuzrl7KWyMa5I9/uP7M6wbv7Uv/ocQTn5ddpWDmzRrBZQr5VeYD4snqXIWuip17SgJ
 xaryPTvx/f7QUH0VdRVAVU4Yua27hzzrIzQ01PEdSNpxUXIdCG7oRUJWzinrdtUklzP8QGMWHgo
 S4OL+W3aUsBkeEvynG7kWmJ9dTuQIboo7NMU6kebT0OSp1KSD9vm98rAibR3XvWE2cC6HPPJgQF
 Usb5Xba3G4vO/6uAUhMvMx6lCFPlLBKECdAyzVWHyKFGbJsvbCC7WGMW2obdtdZvVgV6fxCzg+O
 zUU5DOJx
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1b9c6 cx=c_pps
 a=IKKnTnttSRAw3yzzHe0h3A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=E8N1a35uw57Vc5KH4_AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fueXna1BAyacp2pPgCh-CXyMDNYryKn6
X-Proofpoint-ORIG-GUID: 1uiaTjkIIbHTj0E6rF7-UvfcYkr9ST4V
Subject: RE: [PATCH v3] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

T24gV2VkLCAyMDI1LTA5LTEwIGF0IDE2OjIxICswNTMwLCBLb3RyZXNoIEhpcmVtYXRoIFJhdmlz
aGFua2FyIHdyb3RlOg0KPiBTb3JyeSwgY291bGRuJ3QgZ2V0IHRvIHRoaXMgYWZ0ZXIgbXkgUFRP
LiBDb21tZW50cyBpbmxpbmUuDQo+IA0KDQo8c2tpcHBlZD4NCg0KPiANCj4gPiANCj4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICBwcl93YXJuX2NsaWVudChjbCwgImZzbmFtZSBkb2Vzbid0IG1h
dGNoXG4iKTsNCj4gPiANCj4gPiBXaGF0J3MgYWJvdXQgc2hhcmluZyB0aGUgbWlzbWF0Y2hlZCBu
YW1lcz8NCj4gPiANCj4gPiBwcl93YXJuX2NsaWVudChjbCwgImZzbmFtZSAlcyBkb2Vzbid0IG1h
dGNoIHRvIG1kc19uYW1lc3BhY2UgJXNcbiIpOw0KPiA+IA0KPiBJIHdhcyBkb3VidGZ1bCBpbml0
aWFsbHkgdGhhdCB0aGlzIGNvZGUgY2FuIGdldCBleGVjdXRlZCBiZWZvcmUgdGhlDQo+IG1kc19u
YW1lc3BhY2UgaXMgaW5pdGlhbGl6ZWQgYW5kDQo+IGFsc28gaWYgZnNuYW1lIGNhbiBiZSBudWxs
LiBJIHRoaW5rIHRoaXMgY2FuIGJlIGRvbmUgYXMgcHJfd2Fybl9jbGllbnQNCj4gaGFuZGxlcyBO
VUxMIGdyYWNlZnVsbHk/DQo+IA0KDQpZZXMsIHdlIG5lZWQgdG8gbWFuYWdlIGFjY2VzcyB0byB0
aGUgcG9pbnRlcnMgcHJvcGVybHkuIEJ1dCBpZiB3ZSBoYXZlIHZhbGlkDQpwb2ludGVycyBvbiBm
c25hbWUgYW5kIG1kc19uYW1lc3BhY2UsIHRoZW4gaXQgY291bGQgYmUgZ29vZCB0byBzaG93IHRo
ZSBuYW1lKHMpLg0KSXQgd2lsbCBtYWtlIHRoZSBlcnJvciBtZXNzYWdlIG1vcmUgaW5mb3JtYXRp
dmUuIEFuZCBpZiB3ZSBoYXZlIE5VTEwgcG9pbnRlcnMsDQp0aGVuIHNoYXJpbmcgc29tZXRoaW5n
IGxpa2UgPGVtcHR5PiB3aWxsIGJlIGFsc28gaW5mb3JtYXRpdmUgZW5vdWdoLiBPdGhlcndpc2Us
DQppdCB3aWxsIG5lZWQgdG8gZGVidWcgdGhlIGNvZGUgdG8gdW5kZXJzdGFuZCB3aGljaCBjb2Rl
IGZsb3cgd2UgaGF2ZSBmb3IgdGhlDQpwYXJ0aWN1bGFyIHNpdHVhdGlvbi4NCg0KVGhhbmtzLA0K
U2xhdmEuDQo+IA0K

