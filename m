Return-Path: <ceph-devel+bounces-3407-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF20B2196D
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 01:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D67D91A256CA
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 23:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8509279791;
	Mon, 11 Aug 2025 23:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hZERenkF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E011E2798FF;
	Mon, 11 Aug 2025 23:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754954968; cv=fail; b=EestGF3DeIzsiCSTbsDTbQvlo/1vKNTA6Dpw8DKPHxC1Q4xj3hf1SP8+T738mLkkFS1vSC1WWEgn31Yc5RdL19r5KkLAg9jcAxkLZPFtjiv/mttjTxGQ/Fu0apSmesLgSvz6T32GoTOdnmp0axuEH6Sfbat7/4gS3GvoeJvHsUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754954968; c=relaxed/simple;
	bh=fatk42r6RCfAILUDiev1ZvKQMvlGGfsp+nF80JHI834=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=FBUbbWu47LFB6Fwl5/VyRbImHs4M0rGzFW0mRAi1sLBmqazGZHl3JK6dZIq+oq1tq5jV0d5W+NYmOojPo+FbZDIYLKUCCAGzX3GrfjDlcLiPOtxaG1frbTj9d4+LLmBkeJj1pGDRCANzgBBHI4xwFxfBsgsZemD7qboiaMzTtjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hZERenkF; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BERWwJ004417;
	Mon, 11 Aug 2025 23:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=fatk42r6RCfAILUDiev1ZvKQMvlGGfsp+nF80JHI834=; b=hZERenkF
	JptY+wK4o+COWKeYtpNDe81WRhBjIKIRhAw+inx1uIiA3I6syh5D3Lj1/vmZn0UY
	XOcM1TAqiFcGZlGScIV94w3UxEqFWPRuE7lpnS6SHI1m3ZhFW2fmhr8wefY3MrYM
	BpuOdc5EbSyDDz+UR+deQOFO3pb8j6MNwtQVdgXc/5Vyf40/TLhkY5rVMVagJaG6
	4l7w7ZytT5hbxdmB+XV691Vm9zobDD9YKcSv1SuVTkvTpbBY8Oj2tl5GXnmm/rKY
	cvAevrrAGjG7KUuNNohfGiWpV6Hq4whTY294a6YP0OmtWcU10WlL5P78yXd0uaz9
	6qrT7WVqKal9ag==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3qe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:29:22 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BNTMPm026348;
	Mon, 11 Aug 2025 23:29:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3qe4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:29:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGlZ5IqIPTl6UIUjpwqb26DvHewNx3JP+ddJhWLwREu0sZ8klUzgvTLmGiIf82m6h4Eo+xCxDQfjkl9QOJRDm7y2TiTTWmJd4XyTCrNqxmo+CbwLlbJvtKJJmyIMSmpdnn7DCWYPdQln7bx8IRjFmzvC1JacqnoX5hByt2cWrusevNwsdju0Nv3+EFlQJpaB7zGxZCQpKnBV0/6DtHuVL+1qMijVBu+Ez8L/jIkeU54Z1bgxY3Sga3zq1wr0xsZnKTehHXdK5v0JqPp+c+IeAZchkYWbk5XDqE/dHl8ZEFytRalabTLpFVy4VpGhZTuxaUbosE3oXC+cRcttWxOlyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fatk42r6RCfAILUDiev1ZvKQMvlGGfsp+nF80JHI834=;
 b=iF6XGyNN33ZeT6UGdOxyN4A1iCDZjuvQM9XOoeFYeV+FgPfI/YfYMUTosC2yJTB14sfNeJ7sRzHb8VfbdyrruMewfSRbzXw4PWwLmxKPLZlA5jLddo2LSVUebN+xqpT5O0HMH1GixSdtIfb9FVddWV2jFfX5kOqFaOiW7nQqDUaZEyPmXcdxMUm3pJNkv8zPE578X7/MSWm2+S/j5ptZHEBnNJdsfV3VuIT3sSoj8XFRyUMmLmHNm83jGrbIHfzPgozXhaq5biAbe/Zb2HMpb0FqbXYjnTHmPOxLSEDIsPTbgoe0eelU/Er/SUXKVrYeBv5o3VoDPVcTBStTFuWOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB6301.namprd15.prod.outlook.com (2603:10b6:8:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 23:29:20 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 23:29:20 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "max.kellermann@ionos.com"
	<max.kellermann@ionos.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re:  [PATCH 3/3] net/ceph/messenger: add empty check
 to ceph_con_get_out_msg()
Thread-Index: AQHcCxfDgPqdllw8zUCbN+/82/SLLA==
Date: Mon, 11 Aug 2025 23:29:20 +0000
Message-ID: <65cffb7bddf7652e1d7c25bf98a42b78a7ef8c39.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
		 <20250806094855.268799-4-max.kellermann@ionos.com>
	 <57af9acc17e333c80f07e2b15478088b4f14ba12.camel@ibm.com>
In-Reply-To: <57af9acc17e333c80f07e2b15478088b4f14ba12.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB6301:EE_
x-ms-office365-filtering-correlation-id: 2497e0cb-6b01-4707-600b-08ddd92ee5c5
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?a1JtMGdNSWkvdkJwV2l0YkJLVkZEVEdhKzJhdHMycXdjMlJ2Vlk0VzlRSzJk?=
 =?utf-8?B?UTF1bUM0VmNMbDgrUERPTDByUDVMczlUVCtNSGtBSGRTNm9jMTN2UlRyM0xl?=
 =?utf-8?B?QXJzZjVhUCs5QWNZbEFzSklJNmNjL1d0QlhxY2xwdUdaOGxRL3F5V1lwUjY4?=
 =?utf-8?B?MGkva2E1ejBlTkdvYkdZdWRsOFI0eWl3dDY2Szg0ZWxDLy9VejlVc1U3N3pl?=
 =?utf-8?B?RXdwbG5uUGI3QXdKTDRPd0VJNmFDSzZiaFdySTQ2bUh2Z0hzU2R2ZGlMdFQz?=
 =?utf-8?B?aFFiNWVTVDFRaTdYN0FEc0RFU2FEZ2hEQzZnRnNZcXRMMFFLVXg1UERpbVpm?=
 =?utf-8?B?MFZtSDlwVFlSdVVYVkVHUmpJaFVzVWlTcXh0b3hpTnFodk5BTThmbG5WY3BM?=
 =?utf-8?B?TzNHZUlsYmZtc1o1ZDR5VTkyODVmSlZCUWpvTWhNSTF0TDdlaUIwNEVRMFdN?=
 =?utf-8?B?NElUQllZSDVBYU5zVjY5WW1PQkx0eWJlSXcwbW9xRWF1Y2thbmFycDl5UUVB?=
 =?utf-8?B?RHV2cjNiQjhEa1BoOUswZm5UYXdqTStKb0RHd3BHVUdEK1RQUTBSTVlHN01N?=
 =?utf-8?B?TjN6d1VGT281ZGgyQ01XcE1rZ1U4OHFEZGRROFpIV05CNGRFbXVNL0VhdWFY?=
 =?utf-8?B?M3dTaTBQL1NzL3FYb3BmZ3ZWZTgvei9OVmtCSkliNnhsWXFmWml6b05DUVBp?=
 =?utf-8?B?L25qUHdaOXFod1dQMVpWRHo1Mm1yTk9jRTY3WXNWUUlmbVhFQXJkbE12N3FL?=
 =?utf-8?B?a2UrT1BWWkUwWkZtaEFoWGg3aE52cTg0akNWaUk3ckZCVmlKZmxXV2Q3MkR4?=
 =?utf-8?B?SC9lMVZpeXBoODFZdlVDcGwrcE1oZU9teFBkRGNZQThjZENBYmcxRVVjaGQ3?=
 =?utf-8?B?Y3A4a3B1dWRMRE1GRndsTHVWc3laZlZzbDRsVlRnTjRMY0x1Mi9jSHpPZ2VZ?=
 =?utf-8?B?dGxHTUhWV1dKSzl1UGNVMjlLZmJDNDRvSmxlMXdxTEV4TXMzaS9uREVvcUxy?=
 =?utf-8?B?ZWhiWThMQzhOa3lJN3o3NkNDTEFFZkg5OU9WSFppSi8vOHFvZDhoeWd3Rk4z?=
 =?utf-8?B?WVFVUUZPS0FaSlFSSjZtTzJpZlFZclpYQmNZZzZKeEJ3YVNSNUgvT2JnRWVD?=
 =?utf-8?B?RzZ3NnNvUUJSMkRGYlQ3QzROU0lzM2l0NTBGOUpiaE1pYnpWQmkvY1VTM0xD?=
 =?utf-8?B?UVJ3UEZzNUpCYW9kL1YzS0VHaUg5M2MwRjdoMllReHNzdHhTRDdqb1I2YXFN?=
 =?utf-8?B?cU9mNVQ5b1pRem9Ua0FJTllHS1R5QTg5Smx2bis3L1I3emFJY2dqS3J3NzN1?=
 =?utf-8?B?VVFpSmRRd1JVa1dEeXMxSllsWDQwdkYyZUtSSE1aU3p4MVlVSktyN1NQcWk4?=
 =?utf-8?B?ZktEakljV0h1VTduY3o1Y3ROTkt3d0ZmeGFhM3g4SC9EZzV4ZXBVMkhIK0F4?=
 =?utf-8?B?WFhOaWk5TGdlYitqb0tWNVdQTk1aa0lSdmtJd0hRSEEyNEQ2VDVqaHhaYU5o?=
 =?utf-8?B?MzNUS2VLWjBrZVEyTU1yU2hhRVAyQmVJdXRmejhwZFZJRS9uTlo1ckhhL0tP?=
 =?utf-8?B?UmFjQ3dneGZaL3Zpc1hFWWg3S2svb0lHMkZiQkl2dVBZZHdNaGpLb2o5b2Q4?=
 =?utf-8?B?RE9OWmI5bE9UTkZkV3dxZlVDVHEyS2M0c2g0dko3T2gzbThZQ3JaNGVtRDlj?=
 =?utf-8?B?NU1SVkdzMCs5VzFBMnBLRDJVMTFFbXhlZVhqa1JWK0JLQWN1VmlXVFQzUjJi?=
 =?utf-8?B?a3JPR2EwNXRDa2dBWmQwU2l6L0J5MitLL2xhQkxVbXIrQWY4ME04aGpoTTMw?=
 =?utf-8?B?OFIrSHlKN3BsMmlRdHFkWW9uR3FDVmVLWXI0aEo5QjNmVVpwUmhSbkI2TFYw?=
 =?utf-8?B?TGlieWtmSjdPQXF2c1lIaFZTNVkya081UWtTUmR4ZHJ4QWRYaU9ReWwyZ3Uy?=
 =?utf-8?B?aWphUEtwQTJwbS9talI2MVUvYnVzb0psbDUwL3lWckRuVWNRRVZRcXBBN0V5?=
 =?utf-8?B?aG84bEp1U0pRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Qk9pdHVXVTFUSFRmc3NRYWprZGl2SlZIT3lhK2pvUHFhalUvTGljcC9oK3g0?=
 =?utf-8?B?QmtoUTY0R3RTV0RtaE9XZzRhbVlRUVpkN2V2YXJhQ2k0UHZOMnN6T3QyZFhq?=
 =?utf-8?B?UWRyc0krTERiVDlhRE1Nc1NoNHc0SXY3VDcwZUJHcEZWeDhnWVZGK1ZkOUc3?=
 =?utf-8?B?Vm5yM2NEQ0pQK2JOWlB4M20xL3JERVRyVkRtTUlLbzdWbnE5TVFWSElTdi81?=
 =?utf-8?B?SmQ2U2lIUGVYQjlaUTE0VUoyaWYzLzd0elkyM3p4M0FFS1N6NkpwTGU3VUly?=
 =?utf-8?B?dXN4ODBRU1doOGxxUE5LRjkzeERGUGxqbmdydmtGRXNackZsa1VUSlRydE1S?=
 =?utf-8?B?SFNNbnZMcEo2MkZKVGhrbmpJUlp1U004N0ptOVpydkxYQUMvMWlVd0c0SGdw?=
 =?utf-8?B?emVzek15eEFITzEyVk9LR3lVZVJ1cmkxNjdDNVFRTmF1WE1zOHlDbUJFa2Uw?=
 =?utf-8?B?Y055M01XVDN6STRHSjF3Y3VsVWJsNHpTb1htWkJBK2t4Z0tjeW02TjhJTnRV?=
 =?utf-8?B?QVZ6aGRBVjR1R0lWR3piZExyWnZ6VkZ4WWZ2aEpqQ1dWUmpHRzJqVFBtRDUy?=
 =?utf-8?B?ZHdZdlRtQ2pMU0ZQdG1hcklyQ1VpdlVXYUpqQ201eXY1R3J2MFlxOUp6ZVBO?=
 =?utf-8?B?ZFdZRkZxSFdlUkhiYXdxUWt1b1pMbmxsQzROQnZGejF2YnZrN01RTjlGM1JY?=
 =?utf-8?B?N2g0OERGSWI3WG81TDVYUFo3VjdxdTBublBYL3cvVjZCZzc5emUvOGR6VnZL?=
 =?utf-8?B?dHJ4a09JY2ZPeng3TkFiaFVjOS9pL1dnZGRIdnZCd05tOE1odTNvKzM5amY0?=
 =?utf-8?B?bUlRVTNHaWZxdm1yTVl2RzlRWUpWdytpRFZ3em1MNFRyWnRIckhua3pLYXQx?=
 =?utf-8?B?OXdOY2JFMVptaEVDeEVNdFZqWjBmMzUzcTl5NUQ0YXBRdVVFUW53ZEwrRVVo?=
 =?utf-8?B?c296QktoUXNWVjBGb2lzcmVERm9xR1dhTFZZUGhMRlphWG9odHJvVnFpanND?=
 =?utf-8?B?cnIvOWkrWDVTRTYremJmRWRuZWMvMVBPSktkT3dLNjk5YTdjb1pIbTFrWE1k?=
 =?utf-8?B?QkFueHdyQzd1MGN5S2w1eTBlOUhNdkpXbUZqMDhBaDdUSnBNQlY3OGpPSXBG?=
 =?utf-8?B?dlBqbldGUVdxbVA5SU5GSUJ0SjJPZEdGbnpHNmpZdG8ycjhtbzAzbzErdVhM?=
 =?utf-8?B?ZG1jYnc4TGJRYTV3Mm5Mamg1RzVRaEtFWjJEV1JPcEFxZWJGanB4ckpnT3R6?=
 =?utf-8?B?M25TaWhvVHlhQWRuaW5yM0Q1bGdTckJDalJ4WjNSdHh3RVRjaTVrRTJyNWp5?=
 =?utf-8?B?VXNYQjduQ1cySmZaY3kzWEd3N0FwYWZhN2hLOGs5SGxXZG9tY0g5cnRyMm9H?=
 =?utf-8?B?U3ludGFiZTc5T0k4R1c2ZHQ0UDF1SmU2TFZrVEpEazcrWW1vZEQxa21PRWsy?=
 =?utf-8?B?ODRJQ2xjaHNEdFczQnBMTGRQdWo4NEQwRDJMdTRtWTkySEVYT1ROeGJ1Qklu?=
 =?utf-8?B?NmQ2UHkyMEx3SVkvaGJJandFWEJ3aS96RFhpdXJ5OUJjaCtNKzh2SjBnQ2Rh?=
 =?utf-8?B?Q3djUXEvb0lFN0tEb2lLZExkTm03Y1B5NjF0dHpJTjdobUVsdnBMM1JsSk1W?=
 =?utf-8?B?cFVBL1VRTmJrMWMyV2JrVFFDaVhDT1ZBQnMvclN3Rm81UHQvSlBKeEpNQVoz?=
 =?utf-8?B?MVRjNHZOeUp1VUZiTit0WGMrZ0NKSHV4RlpSaTBUSmxYRHBOZjUybDVLVm1Y?=
 =?utf-8?B?WlNBZzkvd3llZlV2L2tTVjJtYU1iekNaY3ZCZEM1ZFlCaEF4NzErcFB4dkVm?=
 =?utf-8?B?RnIvZzBJaTlwbDF6cm1aeXROR2FFdk5vL1FQcWpSM054TUtlNDF0eERjRjVt?=
 =?utf-8?B?SVFCVUVwUllwOXI5Vm4veHI1ZDZiMTBLd2t1ZHN3cWNNb3RzY3JtT3V0NUo0?=
 =?utf-8?B?cFEvVUZFSHV6L0VVUnJNSWM2L3IxUzhXZHBwd0RDTENDdUFabEkrbFhOTmVy?=
 =?utf-8?B?Rmh6SWdVS1NUU0d6YUZXZDBSTmZiTm13b1ZRT3R3ZkNRd0FMTEVwVUhOUXp2?=
 =?utf-8?B?dW8zVVE0MjJ5UHNRS08yS25SM0QrenE1WnNKbG04WXZmN2IvMzRCSlRBMFlC?=
 =?utf-8?B?Rk5vamw0cFFxL0dWaXJWc0NveXRmNWo1Q3NMMkZ4Z3JEd21NSXVLS3pDQTZT?=
 =?utf-8?Q?T/f+kj5RPT62huJHEDkELq0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA82CFB3B62D0B4791ABD55F19E73C4B@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2497e0cb-6b01-4707-600b-08ddd92ee5c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 23:29:20.2624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2HmVu5yZdSypa52QmZcVAhhwaEJN9IShqZZ+Bwwy4PikBhBKHORjRTGhceeyGDjBe96b9zZYQZHodghNO0UPOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6301
X-Proofpoint-GUID: 1qeXViS0kuXSXuoYQK7chcFT-qBkbcpv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDE3MCBTYWx0ZWRfX64MvkRT2RI5K
 ahYj24l1KyQdEpkm3WksK3ln8sRmZ7iEe4o8n4Z0Wub85cHB//Hd5JoMFnBISq9EysraCwH1RwN
 N198EuVBIhw0BcnzXjhxg1iviN6ufeS91YarY+0r8ZymiFmtvwyzHCBOdfZD9B/ZdAg/lskPtD4
 C1tPestP+WX9CNcWROFyP0mUUoYx/R+JBOaLXNZ2YUUwl3HssMvgshOMu7hyky6XB+DHO7UX05d
 ddLn113cznt8iurqmiYAWRXt1lpYMqlRxm5ro8hLMDM44pGg0Be4ibk1C0fOOfizBvPNzqT76oa
 eA3pyDvb7MY/UJtqT3j29TwyMfFT+B8YCD3h0VeCLRotZ+qQfhNuCtQfJry6MDL6nCYwM2rycIT
 j+SKQ8Up3XZWhe+xQD0cmPAkF4M0Hgz17QWl03AzIkSeKYVk9WV+PvhfFrUzrxsJUgLnkeov
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689a7cd2 cx=c_pps
 a=6kUXyxSL3GSgDGyJuzBerg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8 a=4gJQrt2zwPapI98DJosA:9
 a=QEXdDO2ut3YA:10 a=0lgtpPvCYYIA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-ORIG-GUID: -WuS8q8ot-pcWxMP8hv_DAO96L1aWa8o
Subject: RE:  [PATCH 3/3] net/ceph/messenger: add empty check to
 ceph_con_get_out_msg()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_05,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 mlxlogscore=871 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110170

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDE3OjQxICswMDAwLCBWaWFjaGVzbGF2IER1YmV5a28gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMTo0OCArMDIwMCwgTWF4IEtlbGxlcm1hbm4g
d3JvdGU6DQo+ID4gVGhpcyBtb3ZlcyB0aGUgbGlzdF9lbXB0eSgpIGNoZWNrcyBmcm9tIHRoZSB0
d28gY2FsbGVycyAodjEgYW5kIHYyKQ0KPiA+IGludG8gdGhlIGJhc2UgbWVzc2VuZ2VyLmMgbGli
cmFyeS4gIE5vdyB0aGUgdjEvdjIgc3BlY2lhbGl6YXRpb25zIGRvDQo+ID4gbm90IG5lZWQgdG8g
a25vdyBhYm91dCBjb24tPm91dF9xdWV1ZTsgdGhhdCBpbXBsZW1lbnRhdGlvbiBkZXRhaWwgaXMN
Cj4gPiBub3cgaGlkZGVuIGJlaGluZCB0aGUgY2VwaF9jb25fZ2V0X291dF9tc2coKSBmdW5jdGlv
bi4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBNYXggS2VsbGVybWFubiA8bWF4LmtlbGxlcm1h
bm5AaW9ub3MuY29tPg0KPiANCj4gTG9va3MgZ29vZC4NCj4gDQo+IFJldmlld2VkLWJ5OiBWaWFj
aGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCj4gDQo+IA0KDQpUZXN0ZWQt
Ynk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFua3Ms
DQpTbGF2YS4NCg==

