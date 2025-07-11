Return-Path: <ceph-devel+bounces-3309-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68719B02355
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 20:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2E7C4A0CD2
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 18:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088172EAB92;
	Fri, 11 Jul 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P1lSovKf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A31FFC55
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752257310; cv=fail; b=TalVM0v20dY7s5J8UKCh8UBwVcwMshrgg4KVJj8ERdRgHtHSYEIbEsz/aTZp29IFxXRlsbw4leWESfQA5ArPIKgzTwLhHQSasLvhwq7tGFID0w1n7E2J8SnxShNSDNxq6Z4tmOPETOo500de5e8ltUxmFP0kBmVX6yY6D/S2bJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752257310; c=relaxed/simple;
	bh=svjHtZ9ufaKp95+m7KGHUHwGitcFgITK8utmW0INJOY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=CnhWM3FlWBy0GpGz0gTFiBCA8IKf0dQXq79HHcEyz25kkX2TkIt8GXuQpgYMUA6vwc7okCj42rwcKb1AaWSDYov5qJHnduCyxjyCbtaHolv9bOH0mE/hkGx86bM2RY3xix5B2QX8DkfebS76DXnyiPtwSFMw5Dm5wXBAy62/9BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P1lSovKf; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BBRGXJ010388;
	Fri, 11 Jul 2025 18:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=svjHtZ9ufaKp95+m7KGHUHwGitcFgITK8utmW0INJOY=; b=P1lSovKf
	nSZbq13w2BmUQ6/54ezEC7Q/eZFUBSNONs6wyVy0GvksQ6T6dW3MeHO4cvGsK11/
	AOBxsZWj3eSBI0vcXT+IDWaXh12DUWN/cAyiBmVKS7RSIqyVV9O9AQD+bnLrCwkZ
	qjvcMKpDIdP/dx3LdjekHWBynpST4WNdydICFSG6ehDws7sbe2txSh5X5vr1Hy+3
	irHPVynI/xNliugT2tADLGf6sfEyT7Fri6ict+vfdmv04NojYdavxrENDCeSrP4q
	D/0iHkdH7vlJ7kdHJZSifAPQQuxAmf8fReteS6rElqV/2WUd3vbVK3z+8vdZ1UYA
	q6x9yhV+cgLmUw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47svb2cjc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 18:08:27 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 56BHtN8N018925;
	Fri, 11 Jul 2025 18:08:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47svb2cjby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Jul 2025 18:08:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlyugladszL8mfUCYgLR+Tw8QCA6leR+EGXyNMHY30/1t2uRCAz+U7118aypid4iHc1FUa+ESKV926aF7+Xtz69lLaPTzvujEni6VvaJb1BY4aWwDNFkShqADj01HWV58L0HzVuV0Nq5ZCZrP6iKnV19YhLKEmpGPXDgXDVbz8bB2PFkTnO7v0+bZU7boCZfMWlKZG245xZ6Vf200es8PZ3VmZjmb1Yibj0pfWreE+eGTVC5sbKjgM8Aplx/ILM6JKsrJlwXTLrESVV2T95VtwO6r5b64BBmO9sGtcP3zgYq7ovrJ4F9FMH3A4fw9DOS/KYJi841kdqFjmGSx11cuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svjHtZ9ufaKp95+m7KGHUHwGitcFgITK8utmW0INJOY=;
 b=BhJC+wWVHS/pBUAwBg8nQ/mhq4DTGB77Oq7tbAPJPwwk30iuyAv8pGaSsSB4if2azOOGZZ2w56F9u4aSFFBAS1XkM4t977lFm7CBW9d/ILrcZ/rbP4BCoho+dPeyCFtcQocRLEF2tPOOAe6MSDHfr8y7+3P04lb6o9ncfT6h/ARQYuLethWw/muTsd1MyLQXWkgU3OKOVOJq/pQGiNp8mSF54RALY3NIUiHu/iUw+aeS9xRTp03E8hAomYYa/0HXXcBGijGF9ByBLki3oeoC3W7Kou34Tc2H8vKa2rM6pp+p2QZk2+3MjPTEm9sV788L6CCN4LZUsAYtPANEIpBSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CY8PR15MB5531.namprd15.prod.outlook.com (2603:10b6:930:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Fri, 11 Jul
 2025 18:08:23 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8880.026; Fri, 11 Jul 2025
 18:08:22 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "aad@dreamsnake.net" <aad@dreamsnake.net>,
        "satoru.takeuchi@gmail.com"
	<satoru.takeuchi@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: discarding an rbd device results in partial
 zero-filling without any errors
Thread-Index: AQHb8nQ94UnhzvqN+EW56pYL+kxUBrQtOKgA
Date: Fri, 11 Jul 2025 18:08:22 +0000
Message-ID: <bbb5efeac49870dad9783e30df1d37c6fd949172.camel@ibm.com>
References:
 <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
	 <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net>
In-Reply-To: <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CY8PR15MB5531:EE_
x-ms-office365-filtering-correlation-id: e0878615-8c8f-4d4a-354e-08ddc0a5ec64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?anF6UGNCcWx0OUROaGs2OHhnZkJXMTJXYkVYcWJ0aDdWUHFCSWJBVUdGM0Vi?=
 =?utf-8?B?ZUd1bVpOc05neDFrTG5MYVdhSnBZYXFEUFdQMHBGRm9tdktIUnFaQmdFbk01?=
 =?utf-8?B?cW8rb3RVR1dqVk5xbmhua0haRDBUdUR0VHBibUV3NzZqR05Mc0w3QlAzSEla?=
 =?utf-8?B?Wk9BM01TTml6VVd3cjRSRlo0Yk9VczQyZW84QWgxNDZmWGV6aHMxeHpWYTdD?=
 =?utf-8?B?U3FaSVNVVkVGaTQvMWs2RkQ3djUxVU5XUnJBUU0vOFVHTTk5UXVUNk9mK1o5?=
 =?utf-8?B?SU5xVVp5bnZBOEJCa3hRN3U0REh6Zkt1TUttV0NlU0dtd2VuYlFzZlpaRWFB?=
 =?utf-8?B?L05EU1FUbHhmOE0wU2F6K3Q5RUVKQmlUb3d4SkR1d3BHOU1ObVA5TnBjdDd4?=
 =?utf-8?B?bTl3b0x5SUkwYzBWUVd1TE1rcFpQNkVpQU55T2hVbVhScytlZ1RMQ2ppQUFq?=
 =?utf-8?B?Z1ZpOHRhenlKVzRMVjVTNVRtTTFqeHhlamplY2J0WGlKM212T2Y4VG5PbzBX?=
 =?utf-8?B?ZEYwWGs3REpuSXVpemk1dmQyNFQ5d0ttWkVPNklSV2Jwc3lwR3pzR0l4dW9t?=
 =?utf-8?B?WDhad3V3N1lNeDRoeWlLMVA1eVNUWUUyOUUwYVo5WTdhS1NnbW1ZMTRKdFNF?=
 =?utf-8?B?Y2RRYzFkRVZzOWY1V0ZjanlINm13UWd1UmpoUFJGRkxoTDNvaXVWMlRyWFQy?=
 =?utf-8?B?c2pma093RUJuM0tuWHpjTzcrcVpqZHdDMVhDYitLTW9tV1FQc0ZCUjdmZFhG?=
 =?utf-8?B?Wk5JenF2ZzJqREJjQUo3ekFiazZNa0xHUzE5NXlmSGV3NHhnaXpwWC9kMHVy?=
 =?utf-8?B?S05xTVh2NFh3dFd2QWJsRkI2VFRrSU5sMkNiaWdOL01LMk1lVHh0MHhtQzd5?=
 =?utf-8?B?T2xzNmVPM2U3eHJPYlNBU1FnZVVQUHk2N0pBUloyYnJ6alNnVjhtSE5PWFdw?=
 =?utf-8?B?R2pJazRXem5RcytTZDNOdVBTelYxZzFrcXBCZmtZU050SjNpY2g2eFlXQ3hI?=
 =?utf-8?B?bGJoWitZSTB1V0ZvaEw4V0dObk9YbzlyMnp0K2IzNE9rVWl0NmsrcUhLdk9C?=
 =?utf-8?B?eHdTWndBSHVPZTN1OTljUHNPYXVKdXR4ekNlU0ZwM2hlVDIveGIvQmNDWVRn?=
 =?utf-8?B?MThKVXgyS2Z5OEFQckVRWnk3dHhCRjNwa3E5RklBbmZFckcxaEtvcHpDWndW?=
 =?utf-8?B?TXpQRkJXaG5rN21QQnRYL3ludkpITG8wTjJzSisvVzZOVlI2ditaajVxU2Rn?=
 =?utf-8?B?eVp4RTEvWE1Jd0FtVXVCRXI5eWJFNGt3Slk3UnhPTWJydkZ5NXZSeUwxWkxW?=
 =?utf-8?B?RFo0MXJOR1RQZXFlVFZLbDJMaG8xdEpqQWtCNERlcjloWTk1TTZKeVNicGk5?=
 =?utf-8?B?WjR2VlR2dkplZ2YyZGNSUVF5ZTEzUjJzaThmRUVKYUFpMzQxb1NHV3B5NDRE?=
 =?utf-8?B?TDJRZnlzY0tsSEZHNTMxNlVBRjkxaDQvY01GcWlkY3JmVDdtaEIwTDBmMldG?=
 =?utf-8?B?aGRBR2FvcjdCR2pZcnZFMElReXpnWm81QWFDaUtsVTM4QlVtYk04VWhSMndu?=
 =?utf-8?B?a3pHY0pxUlVpcytPZzRMUnZWWWU2Y0IwNGRYZTNpRDduYnBFMzhldjJac1No?=
 =?utf-8?B?Z3BTT2ljUWxvZURnR3FoRG8xTHREd2VsL2liYVdTOVEvZldxemEyMHhYYmlJ?=
 =?utf-8?B?SzBDOXFLdEdvSGhIK1YxRTZneDNFKzVrb05aU3ByM0hvZEUyUnl1TzAwQTZT?=
 =?utf-8?B?MTFQR0RvWmtiVGorUStsQ3l0NTlNVVAyMFB0WWVydnIrSndxMjhzWk5Kd1Jt?=
 =?utf-8?B?Q2dlTU50QWdDT0o3UHJJd0diRThiMFNVZS95NHg4T0luZW9rTUs4a3hCU1lh?=
 =?utf-8?B?aWVWRFFGVzRCM1A4Uk8wbW4vY3JYODRXSlJaYmhyNUlhaUJVYlBweGkxYTl1?=
 =?utf-8?Q?dJ1fGt/UX5Q=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U1NWTW1NUk51dEpPRFh0RjdINkJYN0dOUU5rRGdGN1VUVlg3SHlZLzZyZWI4?=
 =?utf-8?B?TWlMcDAzQ2tiSlUrSEc0a1ZhZ1E2N29XTGdlV3hVOUx5a25DZHRXcVhQTVRa?=
 =?utf-8?B?Q0tDaEMvU1FQTnZtQzNiRnFJVTJnY2Q5UC9zZmxQcDJ6SklWcnJLTXJSVjFP?=
 =?utf-8?B?NW0rUmpxdnZIVnZtLy9TMlhxNnBjZlV6d3loZGJOYTI1bU5pcUVFZys3MEIr?=
 =?utf-8?B?VTAwbkJDYTh0K1NUTlcvRVI4NFdWSWJ2Nk5adFZGcFNJNlJUS0pyVHdkTWRT?=
 =?utf-8?B?R3RxaXlFcjcyWlF6OE5iRmtzM2VpMDVITWhLellvT2I3akdudzlseGNMZUJ2?=
 =?utf-8?B?dWpnT3VmdWlWbG90UkgvQXNpQ3k0V2FMUTNXV0JDaDJhM1NkdTAyZFBXc0cz?=
 =?utf-8?B?bHR6ZlRZRUtqWXlXeXgyVFF2OHE5Y0xTaUptem9oNVVIZGQ0TnlRMmMxS2Ns?=
 =?utf-8?B?NytpL0RUS3JrQTlyWVMvVFBma29zL1FySVJTNyswUkVOejJVa2lFamcwa29G?=
 =?utf-8?B?anhFWXd4cEF5TjRKSVRKZVFtaWdTVFI0UzZrd21MeGp1K3VmZnFiaitwWkwy?=
 =?utf-8?B?TWJCdHpNNm1uZ0JPNTNWQy85T2xETzczRVpTdUlXYWRKdFMwbzdZQzVhVFZu?=
 =?utf-8?B?elQzYlRKa01JZXE2YmNsOTNnbEZFTnZjWjFvTjJYUnk5YUZmbTg1L1ZxVE84?=
 =?utf-8?B?MVU4c2hqTktzelc4WkJuWGZmb1VKOVJmV3N0aTV4QjY0bGVxcjk4UVU2VThT?=
 =?utf-8?B?eHZ6dkNRRmZyZThwWXRpK05uK0dWSnd6dE9lQzlkd0F5RTRUUlhoczh3YWo4?=
 =?utf-8?B?UmxldGFsc3ltNi9qb3BPZUE0eXc0ZWsrQ3VmQlFjSU9lQ1djM1FpSmNIZVN5?=
 =?utf-8?B?dnF2Qy9IRW8wSjg2aVo3STI4b3pUcDZTNC9wYjdUMVNDZ1RZSU8vU29vYnNB?=
 =?utf-8?B?bUxGbUhPYk9GblNxSGpnUU1oVFRySU9zamtqd0c5NG9mMEkvRkoyK3pzWVBs?=
 =?utf-8?B?UGZ1dkFkQmZKSHFVQUJnVWJWbEY5RFI3TTBFUjJjc3RlUEphY0pVZTVmNGJz?=
 =?utf-8?B?Vkg1WXVPWlZDcisraUVpazJjcm1TZEp0N1VubFYwdCsvRTA4S2sxaUVDbkN5?=
 =?utf-8?B?R0ZzYUVTQk14aFZsRUducFlubHEyUzJuSGNIZzU0SnoxZEdOUkRWZ2w2Y2NK?=
 =?utf-8?B?N0tIaFZnQzF6dU1rQUpiQ2p1RDdJNENJQWY0WW0xOXJvTXNUTWI5OHliU2F0?=
 =?utf-8?B?N1ErOEczUUo5Q3ZLV0FDclJrMlZnRGdweVovMEZZMzJ4ZnU4VVF2M3k4VHU4?=
 =?utf-8?B?YUpZY2U1d1Y3TFFFRVovTWlnT2svQ2FSWDJudVFBb3czSGpFbzk3akVBZkEv?=
 =?utf-8?B?RmhvUGJGZHVWVGVFMUZlWVBpZnlMSEwrSENXOHB6Y1ZnU2VIemlwT3FxblZw?=
 =?utf-8?B?dHBRSnNiR3hJTU1tUktmcVc3aElubTAxd1VpSXZoZEtaSkJRdDFKZWloZ0pr?=
 =?utf-8?B?MEtqb3d2Z1ZINlgyOXFZR1d6K2FxeWxxTER6ZGxqUjJiY2dVcmtlTEt5N2VP?=
 =?utf-8?B?Q3dnMlNLUlZodW90NWlRbXN3VFkrTGI2RU9MaFZwMkk1N0dxRmlVMGllRzc3?=
 =?utf-8?B?bTgvZzhLalpFcWpmZTJ0Rmo0cnVNMW5zaFJIOTdRU3IwTTN0djRyZ1NSanVv?=
 =?utf-8?B?YlRNVlpWSFQvQ3p1eDE1bHk2ckFuQURtUi92Z0p2WXNOc3N4SUR2STVpaUFU?=
 =?utf-8?B?UlExOXNReWxyM3daY1hYSVAyWjI4clVHdC9pUzdtdHNTaGk0cVA0TDRGVGNi?=
 =?utf-8?B?M2hCeDcvZjFRQ2VWa24wNUlmUTdnazVhVnZXUUVJQkFyL0hZRnQ3QytscERG?=
 =?utf-8?B?NEdKZTNHd0VkSTBTNHhaQThiM3RYczlZaUx2dVNrWDFpc2w1K3JjSmtSSHJX?=
 =?utf-8?B?dmRNbzNHeW5TNVZZdm40eVZQcnpycVp5R08xeU0wQ28xdUpOMUQ3RzlkbExl?=
 =?utf-8?B?MkVOM3RHdkRwekRySkRnaXlZSnlyOXcxR200dlYwczUyWlo0c2dWbVZZQWFx?=
 =?utf-8?B?eTVuWlNnSVZKRXArQ2JYeEJVTUkvd2xCbEdHbGlsUm1CWmZZaGZVZTJRYTJp?=
 =?utf-8?B?blhsbXNpRmlaQnl6MHcvR1hiOEZJaHdWR0cyRkxGQVY4OWxibHNJVi9tMGEw?=
 =?utf-8?Q?5RZjiBGdXX6OcOytfJ1/JiQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CEEBE66BBC38245AE4A263FBEA49E6C@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e0878615-8c8f-4d4a-354e-08ddc0a5ec64
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 18:08:22.3989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ja3DnsdR6//8Eu8L44HcyoUadHDgo11pyz1G5/TJmk7460kqVVyNBlfXoYTQHxFOCsEGJ3XFLB3AvBobdv19iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5531
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDEzMSBTYWx0ZWRfX11VDA5/cw/nD lP8YP9h8iPh/WW8hRftqNa0iURv1mS6LUEFmN4YJ7DUdscsbvdBlANEah08CpncvDlrYREJOMQK 9zIMJdWR2jE6GC7z1hbsOGYzxe6GgGfc3YoB3kQG3Xy7BxNwgrmwCMwQRqnA+/3uIJvO4d88+Tl
 nipOzNaYv3V6DURA9ai3ks7knMwZpib6H5Q0HUqRzPqzgI1Y5T+irw9rdEN0UK7wmQvtjH3OijQ 7vlednAJmcOLdp3kpFzgu4PxQLTBSnojVBDtpMGO1utLr0RvoJ22yswlQ1d//Zu2arZu3wHZc0J Hf+CDJjDXorwbpgXjN+BOoSqnljYKuWMZZuXpaDgE+OiPj+Q+lzy+4BgArI0odNvXt9gB8TMiqE
 tV/+ruNUe4MswwGRldrhnNPsDqzLKsg3Ml/cfX7FTXhk0gqHfHapA9QkJ7YkFW2Uf99ZIbJM
X-Authority-Analysis: v=2.4 cv=Y774sgeN c=1 sm=1 tr=0 ts=6871531b cx=c_pps a=yMw74TNnxrJwEHXjDMcs+g==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=9gMT4lqxxEVr6Qmb:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=4u6H09k7AAAA:8 a=pGLkceISAAAA:8 a=Q3xzQ3mVLc4vLllu2dsA:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: OmayJtH1dAqMWfbtDewksEmygCzaPOKU
X-Proofpoint-GUID: N-ixkP9UaQLRZrvLZWcwpLQ9FU_T_gYp
Subject: RE: discarding an rbd device results in partial zero-filling without any
 errors
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_05,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110131

T24gRnJpLCAyMDI1LTA3LTExIGF0IDEwOjU3IC0wNDAwLCBBbnRob255IEQnQXRyaSB3cm90ZToN
Cj4gTXkgc2Vuc2UgaXMgdGhhdCBibGtkaXNjYXJkIGlzIGludGVuZGVkIGZvciBzb21ldGhpbmcg
ZGlmZmVyZW50IGZyb20gd2hhdCB5b3XigJlyZSBpbnRlbmRpbmcuICBGcm9tIHRoZSBtYW4gcGFn
ZToNCj4gDQo+IERFU0NSSVBUSU9ODQo+ICAgICAgICBibGtkaXNjYXJkIGlzIHVzZWQgdG8gZGlz
Y2FyZCBkZXZpY2Ugc2VjdG9ycy4NCj4g4oCmDQo+ICAgICAgICAtcywgLS1zZWN1cmUNCj4gICAg
ICAgICAgICBQZXJmb3JtIGEgc2VjdXJlIGRpc2NhcmQuIEEgc2VjdXJlIGRpc2NhcmQgaXMgdGhl
IHNhbWUgYXMgYSByZWd1bGFyIGRpc2NhcmQgZXhjZXB0IHRoYXQgYWxsIGNvcGllcyBvZiB0aGUg
ZGlzY2FyZGVkIGJsb2NrcyB0aGF0IHdlcmUgcG9zc2libHkgY3JlYXRlZCBieSBnYXJiYWdlIGNv
bGxlY3Rpb24gbXVzdCBhbHNvIGJlDQo+ICAgICAgICAgICAgZXJhc2VkLiBUaGlzIHJlcXVpcmVz
IHN1cHBvcnQgZnJvbSB0aGUgZGV2aWNlLg0KPiANCj4gICAgICAgIC16LCAtLXplcm9vdXQNCj4g
ICAgICAgICAgICBaZXJvLWZpbGwgcmF0aGVyIHRoYW4gZGlzY2FyZC4NCj4gDQo+IEl04oCZcyBh
Ym91dCBzZW5kaW5nIFRSSU0gY29tbWFuZHMgdG8gdGhlIGRldmljZSB0ZWxsaW5nIGl0IHRoYXQg
U1NEIG9yIHRoaW4tcHJvdmlzaW9uZWQgYmxvY2tzIG1heSBiZSByZWFsbG9jYXRlZC4gWmVyby1m
aWxsaW5nIG9yIGVyYXNpbmcgaXMgYSBkaWZmZXJlbnQgb3BlcmF0aW9uLg0KPiANCj4gSWYgeW91
ciBpbnRlbnQgaXMgdG8gZnJlZSBSQURPUyBwb29sIGNhcGFjaXR5LGBibGtkaXNjYXJkYCBzaG91
bGQgZG8gdGhhdCwgb3IgaWYgdGhlcmXigJlzIGEgZmlsZXN5c3RlbSBvbiB0aGUgUkJEIGRldmlj
ZSwgbW91bnQgaXQgYW5kIHJ1biBgZnN0cmltYC4gIFdhcyB0aGVyZSBhIG1vdW50ZWQgZmlsZXN5
c3RlbSB3aGVuIHlvdSByYW4gdGhlIGJlbG93Pw0KPiANCj4gSWYgeW91ciBpbnRlbnQgaXMgdG8g
ZXJhc2UgZGF0YSwgYW55IG5ldyBjbGllbnRzIGdldHRpbmcgZGlzY2FyZGVkIG9yIGZyZWVkIGJs
b2NrcyBzZWUgdGhlbSB0aGluLXByb3Zpc2lvbmVkLCBzbyBhbnkgZXhpc3Rpbmcgb2xkIGRhdGEg
aXMgbm90IHZpc2libGUgdG8gdGhlbS4NCj4gDQoNCkkgdGhpbmsgSSBjb3VsZCBhZGQgaGVyZS4g
SSBhbSBub3Qgc3VyZSB0aGF0IFJCRCBzaG91bGQgc3VwcG9ydCBibGtkaXNjYXJkLg0KRmlyc3Qg
b2YgYWxsLCAiQ2VwaCBibG9jayBkZXZpY2VzIGFyZSB0aGluLXByb3Zpc2lvbmVkLCByZXNpemFi
bGUsIGFuZCBzdG9yZQ0KZGF0YSBzdHJpcGVkIG92ZXIgbXVsdGlwbGUgT1NEcy4iIChodHRwczov
L2RvY3MuY2VwaC5jb20vZW4vcmVlZi9yYmQvKS4gU28sIGl0DQptZWFucyB0aGF0IE9TRHMgY291
bGQgdXNlIEhERHMsIFNTRHMsIG9yIGFueSBvdGhlciB0eXBlIG9mIHN0b3JhZ2UgZGV2aWNlIHRo
YXQNCmNvdWxkIG5vdCBzdXBwb3J0IFRSSU0gY29tbWFuZC4gRXZlbiBpZiB3ZSBhcmUgdGFsa2lu
ZyBhYm91dCBTU0QsIHRoZW4gbm90IGV2ZXJ5DQpTU0Qgc3VwcG9ydHMgVFJJTSBhbmQgYmxrZGlz
Y2FyZCBjb21tYW5kIHdpbGwgYmUgc2ltcGx5IGlnbm9yZWQuIEFsc28sIENlcGggaXMNCmJhc2Vk
IG9uIGJsb2NrIHJlcGxpY2F0aW9uIG1vZGVsIGFuZCBpZiB3ZSBoYXZlIHRoZSBzYW1lIGJsb2Nr
IHJlcGxpY2F0ZWQgYW1vbmcNCkhERHMgYW5kIFNTRHMsIHRoZW4gaG93IGJsa2Rpc2NhcmQgY29t
bWFuZCBuZWVkcyB0byBiZSB0cmVhdGVkPyBBbHNvLCB0aGluLQ0KcHJvdmlzaW9uaW5nIGltcGxp
ZXMgdGhhdCBzb21lIGxvZ2ljYWwgc3BhY2UgY291bGQgYmUgbm90IGFsbG9jYXRlZCB5ZXQgdG8N
CnBoeXNpY2FsIHNwYWNlLiBBbmQgaWYgeW91IHRyeSB0byBpc3N1ZSB0aGUgYmxrZGlzY2FyZCB0
byBzdWNoIHNwYWNlIHdoYXQgZG9lcw0KdGhpcyBjb21tYW5kIG1lYW4/IFNvLCBpdCdzIHByZXR0
eSBvYnZpb3VzIGhvdyB0aGUgYmxrZGlzY2FyZCBjb21tYW5kIHNob3VsZA0Kd29yayBmb3IgU1NE
cywgYnV0IGl0J3Mgbm90IGNsZWFyIGF0IGFsbCB3aGF0IGl0IG1lYW5zIGZvciBSQkQgY2FzZS4N
Cg0KPiANCj4gPiBPbiBKdWwgMTEsIDIwMjUsIGF0IDEwOjM24oCvQU0sIFNhdG9ydSBUYWtldWNo
aSA8c2F0b3J1LnRha2V1Y2hpQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gSGksDQo+ID4g
DQo+ID4gSSB0cmllZCB0byBkaXNjYXJkIGFuIFJCRCBkZXZpY2UgYnkgYGJsa2Rpc2NhcmQgLW8g
MUsgLWwgNjRLDQo+ID4gPGRldnBhdGg+YC4gSXQgZmlsbGVkIHplcm8gZnJvbSAxSyB0byA0SyBh
bmQgZGlkbid0DQo+ID4gdG91Y2ggb3RoZXIgZGF0YS4gSW4gYWRkaXRpb24sIGl0IGRpZG4ndCBy
ZXR1cm4gYW55IGVycm9ycy4gSUlVQywgdGhlDQo+ID4gZXhwZWN0ZWQgYmVoYXZpb3INCj4gPiBp
cyAiZGlzY2FyZGluZyBzcGVjaWZpZWQgcmVnaW9uIHdpdGggbm8gZXJyb3IiIG9yICJyZXR1cm5p
bmcgYW4gZXJyb3INCj4gPiB3aXRoIGFueSBzaWRlIGVmZmVjdHMiLg0KPiA+IA0KPiA+IEkgZW5j
b3VudGVyZWQgdGhpcyBwcm9ibGVtIG9uIGxpbnV4IDYuNi45NS1mbGF0Y2FyLiBUeXBpY2FsbHks
IGZsYXRjYXINCj4gPiBrZXJuZWxzIHdvdWxkIGJlDQo+ID4gdGhlIHNhbWUgYXMgdGhlIHBlcnNw
ZWN0aXZlIG9mIHJiZCBkcml2ZXIuIEknbGwgcmVwcm9kdWNlIHRoaXMgcHJvYmxlbQ0KPiA+IGlu
IHRoZSBsYXRlc3QgdmFuaWxsYQ0KPiA+IGtlcm5lbCBpZiBuZWNlc3NhcnkuDQo+ID4gDQoNCldl
IGNhbiB0cmVhdCBzb21ldGhpbmcgYXMgcHJvYmxlbSBvciBpc3N1ZSBpZiBzb21ldGhpbmcgd29y
a2VkIGFzIGV4cGVjdGVkDQpiZWZvcmUsIGJ1dCBub3cgaXQgZG9lc24ndCB3b3JrLiBDb3VsZCB5
b3UgY29uZmlybSB0aGF0IGl0IHdvcmtlZCBhcyB5b3UNCiJleHBlY3QiIGJlZm9yZSA2LjYuOTU/
IE90aGVyd2lzZSwgaXQncyBub3QgdGhlIGlzc3VlIG9yIGJ1Zy4NCg0KVGhhbmtzLA0KU2xhdmEu
DQoNCj4gPiBUaGlzIHByb2JsZW0gY2FuIGJlIHJlcHJvZHVjZWQgYXMgZm9sbG93cy4NCj4gPiAN
Cj4gPiBgYGANCj4gPiAjIGRkIGlmPS9kZXYvcmFuZG9tIG9mPS9kZXYvcmJkNCBicz0xTSBjb3Vu
dD0xDQo+ID4gIyBzdHJhY2UgYmxrZGlzY2FyZCAtbyAxSyAtbCA2NEsgL2Rldi9yYmQ0DQo+ID4g
Li4uDQo+ID4gbXVubWFwKDB4N2YxMmEwOWU5MDAwLCAyNjIxNDQpICAgICAgICAgID0gMA0KPiA+
IG11bm1hcCgweDdmMTJhMDlhOTAwMCwgMjYyMTQ0KSAgICAgICAgICA9IDANCj4gPiBpb2N0bCgz
LCBCTEtESVNDQVJELCBbMTAyNCwgNjU1MzZdKSAgICAgPSAwDQo+ID4gY2xvc2UoMykgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgID0gMA0KPiA+IGR1cCgxKSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICA9IDMNCj4gPiAuLi4NCj4gPiAjIGVjaG8gJD8NCj4gPiAwDQo+ID4g
IyBvZCAtQWQgL2Rldi9yYmQ0DQo+ID4gLi4uDQo+ID4gMDAwMDk5MiAxMTMyMTEgMDEwNTYxIDAx
MjIwMiAxNjE3MzIgMTUxMjE0IDExMjUwNyAxMzcwMzIgMDMwNTU2DQo+ID4gMDAwMTAwOCAwMDA1
NjYgMTIwMzcxIDAwMzcxMCAxMzMxNjIgMTI1MDM2IDAwMDA2MyAxMDAxNTcgMDMyMjIzDQo+ID4g
MDAwMTAyNCAwMDAwMDAgMDAwMDAwIDAwMDAwMCAwMDAwMDAgMDAwMDAwIDAwMDAwMCAwMDAwMDAg
MDAwMDAwDQo+ID4gKg0KPiA+IDAwMDQwOTYgMTIzNjI0IDA0NTM0MCAwNDUzMDUgMTQ2MjE0IDEz
NzYzNyAwMzEzMDQgMTM2MjA1IDA0MTQzNQ0KPiA+IDAwMDQxMTIgMTIxNDI1IDE1NzE2NiAwMTM0
MjQgMTA3MTU3IDEyMTYzNiAwNTY2MDAgMDU0MDc3IDE0NTY1MQ0KPiA+IC4uLg0KPiA+IGBgYA0K
PiA+IA0KPiA+IEhlcmUgYXJlIHRoZSByZXN1bHRzIHdpdGggdHdlYWtpbmcgYC1vYCBwYXJhbWV0
ZXJzLg0KPiA+IA0KPiA+IC0gYC1vIDBLYDogemVyby1maWxsaW5nIGZyb20gMCB0byA2NEsNCj4g
PiAtIGAtbyAyS2A6IHplcm8tZmlsbGluZyBmcm9tIDJLIHRvIDRLDQo+ID4gLSBgLW8gM0tgOiB6
ZXJvLWZpbGxpbmcgZnJvbSAzSyB0byA0Sw0KPiA+IC0gYC1vIDRLYDogZG8gbm90aW5nDQo+ID4g
LSBgLW8gNUtgOiB6ZXJvLWZpbGxpbmcgZnJvbSA1SyB0byA4Sw0KPiA+IC0gYC1vIDZLYDogemVy
by1maWxsaW5nIGZyb20gNksgdG8gOEsNCj4gPiAtIGAtbyA3S2A6IHplcm8tZmlsbGluZyBmcm9t
IDdLIHRvIDhLDQo+ID4gLSBgLW8gOEtgOiBkbyBub3RpbmcNCj4gPiANCj4gPiBBbHRob3VnaCBJ
IGNoZWNrZWQgYWxsIGNvbW1pdHMgdG91Y2hpbmcgZHJpdmVyL2Jsb2NrL3JiZC5jIGFmdGVyIHY2
LjksDQo+ID4gSSBjb3VsZG4ndCBmaW5kIGFueSBzdXNwZWN0cy4NCj4gPiANCj4gPiBUaGFua3Ms
DQo+ID4gU2F0b3J1DQo+ID4gDQo+IA0K

