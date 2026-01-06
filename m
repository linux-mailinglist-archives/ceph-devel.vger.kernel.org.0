Return-Path: <ceph-devel+bounces-4272-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C15CFB4FC
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 00:01:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D870F301CEA2
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 23:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B0F2550BA;
	Tue,  6 Jan 2026 23:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cIm/gOdr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D4F2FBDE6;
	Tue,  6 Jan 2026 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767740471; cv=fail; b=ufFefGfIxkrX1HeeZ0up0YY2eNXNMF73NLu4n0YGZrUbsZtjF28+qH8MyP9EEHkVfzinHZgu7SXQiHde2JDPs7hlgxBX6r5sLUnsvPxxL8x5YpcDCUye2xm84EUCBPkjM2G37vACngCip5i+CpmHi266T4r+7DpVZax87xUXAh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767740471; c=relaxed/simple;
	bh=aGuhmnav+e4QW08GqokjdPxtfcCbUvSr8DdnHIbj8jE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=sFhIXyd9jiyafadbZrZxHffvPFXX0kt7TEbamFLQy4iFsS1UgUj7tfIoYhtbx9/h021qQDwK4vBd9/dkr8cQksLAOiJlDIX9TKHa39bTZpt/d9bhmsvummbC/Wp/aTy1wIGSMKwlRY6gMSdF9gI6c35z7tUKLtRHWTnEvvRkOIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cIm/gOdr; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 606ET8SF028927;
	Tue, 6 Jan 2026 23:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=aGuhmnav+e4QW08GqokjdPxtfcCbUvSr8DdnHIbj8jE=; b=cIm/gOdr
	Z+q/S+n4ozK76lATY1cKiuypXUHUKwS9yCQwUA/sRPaQh/8w0/SxnWmGi4U4zVSM
	Jd2f0ngkvGjMBuepNVrIwIvVvYgzwxm8e3KpaNvA74GCHvPPQDzQUGBjL6DyKSpE
	Q/jxHtEiXYO5dJsjGpnamgkkQPwoDWLGiedypT5DG0XoYUR0o0eexrPz/ktlI7D3
	yLThh6svB2HgTD667nbX4KliqdKzZWmUnAVtxqzViUKaFUyfW2wNmHRIwmt3pK3J
	/aN3zC/gePKcbCiHjCXSa0B6CDj3Vn8Ja2/MLylWNnUt1pVGMubJ4g6tApYJ6MQt
	um4LzML5en2IpA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshewc1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 23:00:55 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 606N0twJ025760;
	Tue, 6 Jan 2026 23:00:55 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4beshewc19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jan 2026 23:00:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxGJCtzCQkaPwwFVyt9u5iFL8FYs7eEwa338Edu0U3xhTTLQ4wlHXYh4TpIIpdMJuGnKV6acYvGQyW8DxdPNRZXYD+Fe9CAr89bCtGzabmFQzR1K7qgAQZQJBXSlFXojiIcGbhKZ8OFt+nxND7mbx8Su2HKQMMWxIYqXHHR5FukC24dUTqNNH+1Eex2f6sFjJ9fX6hNLlrcYs5IB3MhYD/wgLoeYkENzKhIBkJYYkgg2mCYVX8iCAb0WI+aNWxuFViY2yJSn2NSgwY0uCx/Ukqjcu+xl6C5kwdm6sxpt94BH4qQQbbxjiNG4+eqrpOSu+NTi3kOH9yA7Su1wfrEQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGuhmnav+e4QW08GqokjdPxtfcCbUvSr8DdnHIbj8jE=;
 b=E7w1UWGng6qPGLaWEA7pBNSYRcCUXKNwZZs4Z65SyMqxwRU9XJPj/tLCeWL5OqkatjI6cTVUSppLscWziTgbxgVnlPLeIyOAznop0Sy1ercVEL/oEzK+m69RgL45gmHeg+BbANFKVZEp0sdnbKCNk9br2vUZOZmCYRN3X8EfQNyU7eJyZMD1GUj2Bvbl7uZRVy71NdUL8Dp0qIgqllsI7cypgF0RZ2CK0Iy0lqg3NLtnBxpzstvyk+QX7fUlplkFbWm9WmBis8dNNGvExR2iVZeyGWxXCZuiF67LNxh6NzNzsy/kEGZCy0jXCom205OSxxMQ6VcqYJhNcsQneR6VnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by CH3PR15MB6308.namprd15.prod.outlook.com (2603:10b6:610:166::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 23:00:48 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 23:00:48 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>, Xiubo Li <xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "brauner@kernel.org"
	<brauner@kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [PATCH 4/5] ceph: Assert writeback loop
 invariants
Thread-Index: AQHcftktUjR53lc7ZEK7coKIhWTfSrVFwuIA
Date: Tue, 6 Jan 2026 23:00:47 +0000
Message-ID: <a3a4413f8d9c7df1fc53b2421c9256496f682a4c.camel@ibm.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
	 <20251231024316.4643-5-CFSworks@gmail.com>
	 <5fba25f7b85276411c091cb7206b2dc057d89c68.camel@ibm.com>
	 <CAH5Ym4ig7uBdereXpL8T3Cjn1zqzRxG1VwXb59rwHQjTQKWrPw@mail.gmail.com>
In-Reply-To:
 <CAH5Ym4ig7uBdereXpL8T3Cjn1zqzRxG1VwXb59rwHQjTQKWrPw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|CH3PR15MB6308:EE_
x-ms-office365-filtering-correlation-id: 9c604b6c-8fe9-470b-82c2-08de4d776e6f
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?T0dTek1RbzRtZXRzaHJkL2tkZ1FFemxxTWxqTEZxcTdFcEFKY1VSelpFaTd4?=
 =?utf-8?B?bnBPUnNGeUdXejZxeDJaMmsrOEh5NURaaWt4V0VEM2xwRlh4TWZOQndKK1NL?=
 =?utf-8?B?bFBBSkNpczY4Q0pueHYyTExNTDBHNHRLb2tUSTUrdjlJenVBWmZpdVZTKy9J?=
 =?utf-8?B?TEJHZGhjbDcxNGw2bXRGSmVMZzlkU0V3N2h0b25WQ3ZEdEpSeTI1RkhMSDNU?=
 =?utf-8?B?YndXYzZsWDlQTlBXNEUrNDhxNnBIamcrWkNQWXZpRTlCUFdNUDQrL3p5RERn?=
 =?utf-8?B?WDhGWjJtOFR1YnJCa0pDSVJCMU4rV3B4bEdpTVlMaG96Qkx0K284cnpDNTFq?=
 =?utf-8?B?WktaUWI4clkrOVNsM1htbS9QOFZ0TzhLR0dSOEhJS3M2SDVnUkdCNDRacjIw?=
 =?utf-8?B?NGlhM3VpcWpvbklNQU1nRitlY2tncXo3eEI3Q0Qyckxad25VYXFaa2dLb0Z0?=
 =?utf-8?B?eFQ1UmxFVk9LaW5aeklJa1VvM05MbTNCZ0JrNTVHeXJPYzI4WmhzUWtmVVZP?=
 =?utf-8?B?SUNnVWZaSklaV0sxYWZQZUI0WmhvNU4wb2FLQ1UvMzdxY3lzS0EyNm5mcFFN?=
 =?utf-8?B?MkhqVFZOZ0tUUG9uaEVHcXJnTUxScjQzS215WThGemw4MnFNSFM0UUFGamtD?=
 =?utf-8?B?ekpqYUxoeERYbTJockxyZ2VCR0RHcW9FTmdDb1FlMndNalJUUzkzUThGUUxG?=
 =?utf-8?B?YnRnOXJCZmZFWHdZS0h4WDY0TjVHSHhkZUxYZDduMER6WHMvaFhVSGdTMFFP?=
 =?utf-8?B?bnlsNnRXUytjSEZLOU5WYjZHWjBzcXI1MGREZ0dRWVhhYlcwekxwSTk4QWUy?=
 =?utf-8?B?eVJySjNMOWRTUFM4R2p2MWppcUJSQ1VaQW9jcGpNY2dtaHJDT0RMS3JDUmJz?=
 =?utf-8?B?emJ2WUZXUzVDT0ZxODhtazNHY2k3dGxFczZGV2pOT2t3K2xBK1phZm92VTZJ?=
 =?utf-8?B?b2Vpc21JOVIvaXRoSXVKelhDbzh0RW5IMXB0TEpNdWp4YW1wRmdyNWt2bzcr?=
 =?utf-8?B?cENSL1krQldMcDRJN0JCNlEzUVRqb2xoMXpyK0xYSUtkYzhqVFRZQ1d2dWhO?=
 =?utf-8?B?TGxWWDNHbmdlMk9QbVhUZm85bFB3SzJjMWdhc083V0FJVnBnUndJNmx3WS9o?=
 =?utf-8?B?MWJFQ0R6b2ZyYzYvc1U0UXdma1lZUnJZQjhRVUxmNFNBQVVIYkJuTHhTazBX?=
 =?utf-8?B?cVhra3BrRUR1NnNCQnNLbzV3ZVdPMFhtMFlmVFpVRjRncWsxbXpGbTFGb0k0?=
 =?utf-8?B?c2VCKzhYLzUxRDlPZ0FSbjZtNjlyaE5jeWo5Q1FwYk9YYW82dFBHL1F6QTZ3?=
 =?utf-8?B?OWdQMkYyL0diOTlPa3RmaDFXdGtjK1h3U3VqQmxoS1A4Z0grNm5udDdmV0l1?=
 =?utf-8?B?YytTdk1RN1huZFBEbEVHQkt4Wkw2MStMS0NFZGZENUp6RVBXVklIZUZWazZR?=
 =?utf-8?B?d2J2TW5Uc09xVW9yMHRXa2F0ejdxM1VVMzF1RzIxYXJXdXpFRVhkZnBhR3Bm?=
 =?utf-8?B?VmdNQzNPbXJ1eWkrWXcvWFJxMmtQbGU0S3pDSTIyazkvT3hpQ2xWQnVQTkJx?=
 =?utf-8?B?Tm80VitYeW03MXJhenBkNWRmTzNhTWxyYmQvbkV2d3ZVcjJvY0R1cWVoSHpB?=
 =?utf-8?B?MnZzdGNNVWpnMk9IS3RGczh3QTBnNjJZd2FOZThPUkF6ZTZvUkJjQThDUzZx?=
 =?utf-8?B?Wk5yUlpMcHQ0aVNSaWUzdjZSa2RuditBWVFXSHJKeXc0NVp1V3JoM3lRU2pO?=
 =?utf-8?B?TGl0V0JVbG1LdEdJRitkT05xdGpSYmdZc1NKVXg3d2toVjNGbDFWa0VxdGFO?=
 =?utf-8?B?QkhCVVNBVTRNcWwvSnB3ZWxTRjJoYWpiSXhqOFJTaktrVmswOTltZTNIc2pV?=
 =?utf-8?B?OEhSMWNESEl0anhnakkwUU02NEUwNWlURy9UZlRUd2lnY1FaaUZEOEplSUN4?=
 =?utf-8?B?Z1FFUHRnOHB4YkhlYVNBeEN3UXRWVEZmNXEyNUlBQ0NiM0lsT3h0dlNGUVQ4?=
 =?utf-8?B?bXRXaFAyUkFvemxGTWdycEZOeTd3ZlBuQUVGWDVTM2ozaGRCRE5FREZ6MzFO?=
 =?utf-8?Q?8kZlm1?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2dZbVdiUFJrVTZBNFR4elVMVmtpVUVqcXNtWU9RSXlYWjhpcGZ2bTJydVRS?=
 =?utf-8?B?WVBRYnEwL1RUUFFGSDNwcDhINGQweCtHMDNxaVNIY25xVWJhTnJGaHlITytE?=
 =?utf-8?B?YUh6eGR6aXFGTEpENGNjYXBURTN6Q1V4U0RNdEhYY1o3MHdNL2Y2b1llYk5u?=
 =?utf-8?B?Vmlla0VUMnVxMjUxMWN4UjRtNGxQQ1RLMXdJcjE1YVZjY2ttZ0psaDYvTTJN?=
 =?utf-8?B?L1FGTW13bTlWdTk0dHdOTHZIQTFmdTFOcE9vWmIxK3BNd051OTV1Vk4zRFBB?=
 =?utf-8?B?ampyZ0pUa0I5VmxYM2tkR2toUlV6czAwcldraG5lVXZoY0tHM0dHU2dLbEpz?=
 =?utf-8?B?RTBpdldXLy84Sm1HaDdIc2JjRFlBTEVtRzhKMGlaQjBpQjFFMVZQdWhYeStS?=
 =?utf-8?B?ZHhVemNVRVIvb1JIYzRIWkVUV2xpNlhXRlRGVGJXdUZZWGt2Z2hFRlY3RzEr?=
 =?utf-8?B?elFvbDZHR2doUmpRT3UzUmpnZC9RN1VTQW5rSFY5TG43ZVFhWUJaQ1h5TXFz?=
 =?utf-8?B?RW80T0x3bUFHWTYreVV2V0pHd2ZTK2tNU0h2akM5Y29aRW9FSzc1UjNCZlFx?=
 =?utf-8?B?VHB3UHM3dStINHB2dkNnQW12Q21DWmVyQ21Ta1NPdTdsNVVFSmZPMzI3Tk02?=
 =?utf-8?B?QXJJTEk2aitHU2RpWVdrZ0FIWCtZU04xbC9jdVlwYU14Q2d6UDR5OTg5cEFt?=
 =?utf-8?B?ZHFrM3psTmVFTWt6L0R1anVqS0hVL09MQkRuNW1JNXFTemlmL1NvL084VmtC?=
 =?utf-8?B?TWtRVjBnamdSUG42M3J2U2xCbC9nQ2ZUUXJkSm9ZOGNwSmVMM1M0OWcvek9t?=
 =?utf-8?B?VGl5R0lvZmVRZjNnMVk0dElNYTdkYjNEYytYdWZySVZGUml1L05zcVpTWnMy?=
 =?utf-8?B?cWJGZzd5NDhLQ0UvSFJhNVpBN21IRGV1Uit6RDdwcXhUYmIvb1JPUHo3RXhM?=
 =?utf-8?B?MzgrSHZ5bUE1b05NbjloNlNpMkR2UlpwSVZLZzFwelRCcFZTQy9nK3RMNUk4?=
 =?utf-8?B?SThwRFFVcjdWRzRXeTFnWEFBcGpCT3VEZUEvUW5RUnVqV3BqUlc1WkZFRnd3?=
 =?utf-8?B?MlJ6N2FZNnd0WGRsUHVVbys4NlBqeHZ3US82T2lUeWVleXpXVmxEUGFmVy85?=
 =?utf-8?B?enNtcFRJNmF0Z0NHb1lTNm0vWU9GbjhmUjRsemxaN3pzYjFBZjNoRGZwOVJl?=
 =?utf-8?B?N3NaaWlOcGRJbTFPeTduWjlockM5RlprZ28xd1BNQmRHai9RUklRalRlWVRN?=
 =?utf-8?B?RGlWR1hRMWJyVFBRZHJPZGlEQ2gzOHg0bkFIN0U1d0pGYVJ0WnJJdm5weDZH?=
 =?utf-8?B?eHpvcklNaW5lTDZ0R1hmTlgwN2RyK2d0NDB1ejBCaUdlbEhZSTcvNndUS0Nu?=
 =?utf-8?B?cUYwOW4rOERoWDVqanhRckJiMCtiajc1ZHJNdHpDdklJaWhMdG11QnN4TE9U?=
 =?utf-8?B?elBlckJLdjdHaUFRRE5GSkp3Ukp1NjJQdTlMZDBhTXJkVW1TV1NDQ3FMZUcx?=
 =?utf-8?B?S1I3OTEzUDdhYUhVSVRtajhtL21FTzBxMDgwbXdFRm52MlpXaTg5aElHcFQ3?=
 =?utf-8?B?YVVoVXA3aTMxL25WUS91bGNvak94eUV6ejhTYVJ5b1lIejQ2eDRCZ0V5MFJG?=
 =?utf-8?B?ODlLR3JOSW1MbWV5aTFVcmlTSVQ1N2IyNUVqdE9iTjZrUjlzdEs0alFPRE5Z?=
 =?utf-8?B?RE5YWERNbmRFNjFqdForeVlXZXNlalczUWcwRDA4SS9wdjZNanRNeWtPbzNQ?=
 =?utf-8?B?T29qMUswWkNoN1pvaTkxaWtYV1lXYnp5azVmR040b21jMkhQeHNIUlV1cGpn?=
 =?utf-8?B?Y1hybGVQb1hwRnpvVjdMR01jeWZ5VXMvUmNpeTY0QUtHc0hpMFFsNXhKZFlZ?=
 =?utf-8?B?YnBSOU5KZ0tIVEVsaGZHV2dhcHpxNXloZytnYm5FRlRXZzVKK0duVzlwQ0Qz?=
 =?utf-8?B?S2sxS1VpcE9YWGlkdGZmdjBLcTZ5UmlhcndjcmhvODEzeWEzY3ZBendvRlJR?=
 =?utf-8?B?RE84MWs5Q1NNMWVDRExPaWYza0ZXQUJuWU54YWI2aGNsWGVYQTNIeFhyOGFj?=
 =?utf-8?B?TTJjdDM0TVdzdDlzK083UnZ6QzBmKzVab2JUZW94cEJDSkpIK0E2L1B3NTFs?=
 =?utf-8?B?Y2xnaUwvUk9xQkxqejByME1zWVRHMjc2V0dpc0FPRFM0OHB6dStUNTgzZjRq?=
 =?utf-8?B?amxMRDhwdThETVdIemJpM0d0eXVCcHZnV3d1QUQvZW8zQXBGd3ZFK1RjOHpu?=
 =?utf-8?B?WS9NMzZnVDFUczNBbnV4VS9SZXdlRnQ2L0hnWjBicitzUVlJaHZDbnFaSXY1?=
 =?utf-8?B?QTMwazlIUzNSVTY0UERnaFB6bUQzWUExZEdsenk2OEJVNjh3dnJVaWNNRmZk?=
 =?utf-8?Q?wEjg79etg5S1N67KAj14m0eXKi7mkncDFlQTm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D78238F20013A04C9D5803E4E38A89EA@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c604b6c-8fe9-470b-82c2-08de4d776e6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 23:00:48.1961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NmsG0t558y5ICIqQWzNTtroMZUEK5pcyh2LxtPrcL47RK7qDfjCWlntnbZ0QIz2T3IOUQrrVIoe6O4wKAqvlgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6308
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE5NyBTYWx0ZWRfX9JnidTLGTGvc
 uN8CpV+YjC2OreJeaBw9nm6DpBT/Af5Zl/OH/aEcFTEYLBXUDf7nAiGW/mdcjS3h/GEBxs2w0QU
 stYam8b+wxOYQmqXoft8rdct20gD0xPQL91hTEZtpkE2TLWYmtCe2KRQoANZoMLsDDLuqQDF9Mt
 f7G0MOvOrC62Z8vxARt5ud9eg+j+u5co1WN3G93NWX/CJXrmhVI2a/SwfNmXwR5FaR3orFY00dh
 l52x7E3mjJZxAtJTDZ2sx930y/1JzrjUjpp/R5wRzoHJLLrSsKV0QANE4L2xYeKoTSID5Ru5S8f
 5u0U4eyNj61EKpYoWFfSksn8vncBdmsNUpY2l8b/bKvPW7N5wY9AT6OyZMAFt90eWgK4jeKhHId
 NUkCzrIdMRD9GbSHWEWCs1dmxGzrW87iMAH0OxB0+WEjtsrx+DtcixifOEBTb6GRzBnIwzh2v8T
 kCsXwPaGHnEJ5iLcRMA==
X-Proofpoint-GUID: L10xAa66ubeiBwOFiA67cWREx5VUNkjy
X-Proofpoint-ORIG-GUID: n89St_1y9yLw-5Yo0psjT-MdQlpcSLDq
X-Authority-Analysis: v=2.4 cv=AOkvhdoa c=1 sm=1 tr=0 ts=695d9427 cx=c_pps
 a=VTZ9QiboGVM1ljQMw9N7kA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=yyJs51SPzAULiKaTTNQA:9 a=QEXdDO2ut3YA:10
Subject: RE: [PATCH 4/5] ceph: Assert writeback loop invariants
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_02,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601060197

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDIyOjUzIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
T24gTW9uLCBKYW4gNSwgMjAyNiBhdCAyOjI54oCvUE0gVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2
YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAyNS0xMi0zMCBh
dCAxODo0MyAtMDgwMCwgU2FtIEVkd2FyZHMgd3JvdGU6DQo+ID4gPiBJZiBgbG9ja2VkX3BhZ2Vz
YCBpcyB6ZXJvLCB0aGUgcGFnZSBhcnJheSBtdXN0IG5vdCBiZSBhbGxvY2F0ZWQ6DQo+ID4gPiBj
ZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSB1c2VzIGBsb2NrZWRfcGFnZXNgIHRvIGRlY2lkZSB3
aGVuIHRvDQo+ID4gPiBhbGxvY2F0ZSBgcGFnZXNgLCBhbmQgcmVkdW5kYW50IGFsbG9jYXRpb25z
IHRyaWdnZXINCj4gPiA+IGNlcGhfYWxsb2NhdGVfcGFnZV9hcnJheSgpJ3MgQlVHX09OKCksIHJl
c3VsdGluZyBpbiBhIHdvcmtlciBvb3BzIChhbmQNCj4gPiA+IHdyaXRlYmFjayBzdGFsbCkgb3Ig
ZXZlbiBhIGtlcm5lbCBwYW5pYy4gQ29uc2VxdWVudGx5LCB0aGUgbWFpbiBsb29wIGluDQo+ID4g
PiBjZXBoX3dyaXRlcGFnZXNfc3RhcnQoKSBhc3N1bWVzIHRoYXQgdGhlIGxpZmV0aW1lIG9mIGBw
YWdlc2AgaXMgY29uZmluZWQNCj4gPiA+IHRvIGEgc2luZ2xlIGl0ZXJhdGlvbi4NCj4gPiA+IA0K
PiA+ID4gVGhpcyBleHBlY3RhdGlvbiBpcyBjdXJyZW50bHkgbm90IGNsZWFyIGVub3VnaCwgYXMg
ZXZpZGVuY2VkIGJ5IHRoZQ0KPiA+ID4gcHJldmlvdXMgdHdvIHBhdGNoZXMgd2hpY2ggZml4IG9v
cHNlcyBjYXVzZWQgYnkgYHBhZ2VzYCBwZXJzaXN0aW5nIGludG8NCj4gPiA+IHRoZSBuZXh0IGxv
b3AgaXRlcmF0aW9uLg0KPiA+ID4gDQo+ID4gPiBVc2UgYW4gZXhwbGljaXQgQlVHX09OKCkgYXQg
dGhlIHRvcCBvZiB0aGUgbG9vcCB0byBhc3NlcnQgdGhlIGxvb3Ancw0KPiA+ID4gcHJlZXhpc3Rp
bmcgZXhwZWN0YXRpb24gdGhhdCBgcGFnZXNgIGlzIGNsZWFuZWQgdXAgYnkgdGhlIHByZXZpb3Vz
DQo+ID4gPiBpdGVyYXRpb24uIEJlY2F1c2UgdGhpcyBpcyBjbG9zZWx5IHRpZWQgdG8gYGxvY2tl
ZF9wYWdlc2AsIGFsc28gbWFrZSBpdA0KPiA+ID4gdGhlIHByZXZpb3VzIGl0ZXJhdGlvbidzIHJl
c3BvbnNpYmlsaXR5IHRvIGd1YXJhbnRlZSBpdHMgcmVzZXQsIGFuZA0KPiA+ID4gdmVyaWZ5IHdp
dGggYSBzZWNvbmQgbmV3IEJVR19PTigpIGluc3RlYWQgb2YgaGFuZGxpbmcgKGFuZCBtYXNraW5n
KQ0KPiA+ID4gZmFpbHVyZXMgdG8gZG8gc28uDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IFNhbSBFZHdhcmRzIDxDRlN3b3Jrc0BnbWFpbC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBmcy9j
ZXBoL2FkZHIuYyB8IDkgKysrKystLS0tDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2ZzL2Nl
cGgvYWRkci5jIGIvZnMvY2VwaC9hZGRyLmMNCj4gPiA+IGluZGV4IDkxY2M0Mzk1MDE2Mi4uYjM1
NjlkNDRkNTEwIDEwMDY0NA0KPiA+ID4gLS0tIGEvZnMvY2VwaC9hZGRyLmMNCj4gPiA+ICsrKyBi
L2ZzL2NlcGgvYWRkci5jDQo+ID4gPiBAQCAtMTY2OSw3ICsxNjY5LDkgQEAgc3RhdGljIGludCBj
ZXBoX3dyaXRlcGFnZXNfc3RhcnQoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ID4g
PiAgICAgICAgICAgICAgIHRhZ19wYWdlc19mb3Jfd3JpdGViYWNrKG1hcHBpbmcsIGNlcGhfd2Jj
LmluZGV4LCBjZXBoX3diYy5lbmQpOw0KPiA+ID4gDQo+ID4gPiAgICAgICB3aGlsZSAoIWhhc193
cml0ZWJhY2tfZG9uZSgmY2VwaF93YmMpKSB7DQo+ID4gPiAtICAgICAgICAgICAgIGNlcGhfd2Jj
LmxvY2tlZF9wYWdlcyA9IDA7DQo+ID4gPiArICAgICAgICAgICAgIEJVR19PTihjZXBoX3diYy5s
b2NrZWRfcGFnZXMpOw0KPiA+ID4gKyAgICAgICAgICAgICBCVUdfT04oY2VwaF93YmMucGFnZXMp
Ow0KPiA+ID4gKw0KPiA+IA0KPiANCj4gSGkgU2xhdmEsDQo+IA0KPiA+IEl0J3Mgbm90IGdvb2Qg
aWRlYSB0byBpbnRyb2R1Y2UgQlVHX09OKCkgaW4gd3JpdGUgcGFnZXMgbG9naWMuIEkgYW0gZGVm
aW5pdGVseQ0KPiA+IGFnYWluc3QgdGhlc2UgdHdvIEJVR19PTigpIGhlcmUuDQo+IA0KPiBJIHNo
YXJlIHlvdXIgZGlzdGFzdGUgZm9yIEJVR19PTigpIGluIHdyaXRlYmFjay4gSG93ZXZlciwgdGhl
DQo+IEJVR19PTihjZXBoX3diYy5wYWdlcyk7IGFscmVhZHkgZXhpc3RzIGluIGNlcGhfYWxsb2Nh
dGVfcGFnZV9hcnJheSgpLg0KPiBUaGlzIHBhdGNoIGlzIHRyeWluZyB0byBjYXRjaCB0aGF0IGVh
cmxpZXIsIHdoZXJlIGl0J3MgZWFzaWVyIHRvDQo+IHRyb3VibGVzaG9vdC4gSWYgSSBjaGFuZ2Vk
IHRoZXNlIHRvIFdBUk5fT04oKSwgaXQgd291bGQgbm90IHByZXZlbnQNCj4gdGhlIG9vcHMuDQo+
IA0KPiBBbmQgdGhlIHdyaXRlYmFjayBjb2RlIGhhcyBhIGxvdCBvZiBCVUdfT04oKSBjaGVja3Mg
YWxyZWFkeSAoc28gSSBhbQ0KPiBub3QgImludHJvZHVjaW5nIiBCVUdfT04pLCBidXQgSSBzdXBw
b3NlIHlvdSBjb3VsZCBiZSBzYXlpbmcgIml0J3MNCj4gYWxyZWFkeSBhIHByb2JsZW0sIHBsZWFz
ZSBkb24ndCBtYWtlIGl0IHdvcnNlLiINCj4gDQoNCkl0IGxvb2tzIHJlYWxseSBzdHJhbmdlIHRo
YXQgeW91IGRvIGF0IGZpcnN0Og0KDQotICAgICAgICAgICAgIGNlcGhfd2JjLmxvY2tlZF9wYWdl
cyA9IDA7DQoNCmFuZCB0aGVuIHlvdSBpbnRyb2R1Y2UgdHdvIEJVR19PTigpOg0KDQorICAgICAg
ICAgICAgIEJVR19PTihjZXBoX3diYy5sb2NrZWRfcGFnZXMpOw0KKyAgICAgICAgICAgICBCVUdf
T04oY2VwaF93YmMucGFnZXMpOw0KDQpCdXQgd2hhdCdzIHRoZSBwb2ludD8gSXQgbG9va3MgbW9y
ZSBuYXR1cmFsIHNpbXBseSB0byBtYWtlIGluaXRpYWxpemF0aW9uIGhlcmU6DQoNCiAgICAgICAg
ICAgICAgY2VwaF93YmMubG9ja2VkX3BhZ2VzID0gMDsNCiAgICAgICAgICAgICAgY2VwaF93YmMu
c3RyaXBfdW5pdF9lbmQgPSAwOw0KDQpXaGF0J3Mgd3Jvbmcgd2l0aCBpdD8NCg0KPiBJZiBJIGlu
dHJvZHVjZSBhIGNlcGhfZGlzY2FyZF9wYWdlX2FycmF5KCkgZnVuY3Rpb24gKGFzIGRpc2N1c3Nl
ZCBvbg0KPiBwYXRjaCA0KSwgSSBjb3VsZCBjYWxsIGl0IGF0IHRoZSB0b3Agb2YgdGhlIGxvb3Ag
KHRvICplbnN1cmUqIGEgY2xlYW4NCj4gc3RhdGUpIGluc3RlYWQgb2YgdXNpbmcgQlVHX09OKCkg
KHRvICphc3NlcnQqIGEgY2xlYW4gc3RhdGUpLiBJJ2QgbGlrZQ0KPiB0byBoZWFyIGZyb20gb3Ro
ZXIgcmV2aWV3ZXJzIHdoaWNoIGFwcHJvYWNoIHRoZXknZCBwcmVmZXIuDQo+IA0KPiA+IA0KPiA+
ID4gICAgICAgICAgICAgICBjZXBoX3diYy5tYXhfcGFnZXMgPSBjZXBoX3diYy53c2l6ZSA+PiBQ
QUdFX1NISUZUOw0KPiA+ID4gDQo+ID4gPiAgZ2V0X21vcmVfcGFnZXM6DQo+ID4gPiBAQCAtMTcw
MywxMSArMTcwNSwxMCBAQCBzdGF0aWMgaW50IGNlcGhfd3JpdGVwYWdlc19zdGFydChzdHJ1Y3Qg
YWRkcmVzc19zcGFjZSAqbWFwcGluZywNCj4gPiA+ICAgICAgICAgICAgICAgfQ0KPiA+ID4gDQo+
ID4gPiAgICAgICAgICAgICAgIHJjID0gY2VwaF9zdWJtaXRfd3JpdGUobWFwcGluZywgd2JjLCAm
Y2VwaF93YmMpOw0KPiA+ID4gLSAgICAgICAgICAgICBpZiAocmMpDQo+ID4gPiAtICAgICAgICAg
ICAgICAgICAgICAgZ290byByZWxlYXNlX2ZvbGlvczsNCj4gPiA+IC0NCj4gPiANCj4gPiBGcmFu
a2x5IHNwZWFraW5nLCBpdHMnIGNvbXBsZXRlbHkgbm90IGNsZWFyIHRoZSBmcm9tIGNvbW1pdCBt
ZXNzYWdlIHdoeSB3ZSBtb3ZlDQo+ID4gdGhpcyBjaGVjay4gV2hhdCdzIHRoZSBwcm9ibGVtIGlz
IGhlcmU/IEhvdyB0aGlzIG1vdmUgY2FuIGZpeCB0aGUgaXNzdWU/DQo+IA0KPiBUaGUgZGlmZiBt
YWtlcyBpdCBhIGxpdHRsZSB1bmNsZWFyLCBidXQgSSdtIGFjdHVhbGx5IG1vdmluZw0KPiBjZXBo
X3diYy57bG9ja2VkX3BhZ2VzLHN0cmlwX3VuaXRfZW5kfSA9IDA7ICphYm92ZSogdGhlIGNoZWNr
IChzZWUNCj4gY29tbWl0IG1lc3NhZ2U6ICJhbHNvIG1ha2UgaXQgdGhlIHByZXZpb3VzIGl0ZXJh
dGlvbidzIHJlc3BvbnNpYmlsaXR5DQo+IHRvIGd1YXJhbnRlZSBbbG9ja2VkX3BhZ2VzIGlzXSBy
ZXNldCIpIHNvIHRoYXQgdGhleSBoYXBwZW4NCj4gdW5jb25kaXRpb25hbGx5LiBHaXQganVzdCBo
YXBwZW5zIHRvIHNlZSBpdCBpbiB0ZXJtcyBvZiB0aGUgaWYvZ290bw0KPiBtb3ZpbmcgZG93bndh
cmQsIG5vdCB0aGUgYXNzaWdubWVudHMgbW92aW5nIHVwLg0KDQpJIHNpbXBseSBkb24ndCBzZWUg
YW55IGV4cGxhbmF0aW9uIHdoeSB3ZSBhcmUgbW92aW5nIHRoaXMgY2hlY2suIEFuZCB3aGF0IHRo
aXMNCm1vdmUgaXMgZml4aW5nLiBJIGJlbGlldmUgaXQncyByZWFsbHkgaW1wb3J0YW50IHRvIGV4
cGxhaW4gd2hhdCB0aGlzDQptb2RpZmljYXRpb24gaXMgZml4aW5nLg0KDQpUaGFua3MsDQpTbGF2
YS4NCg0KPiANCj4gV2FybSByZWdhcmRzLA0KPiBTYW0NCj4gDQo+IA0KPiA+IA0KPiA+IFRoYW5r
cywNCj4gPiBTbGF2YS4NCj4gPiANCj4gPiA+ICAgICAgICAgICAgICAgY2VwaF93YmMubG9ja2Vk
X3BhZ2VzID0gMDsNCj4gPiA+ICAgICAgICAgICAgICAgY2VwaF93YmMuc3RyaXBfdW5pdF9lbmQg
PSAwOw0KPiA+ID4gKyAgICAgICAgICAgICBpZiAocmMpDQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgZ290byByZWxlYXNlX2ZvbGlvczsNCj4gPiA+IA0KPiA+ID4gICAgICAgICAgICAgICBp
ZiAoZm9saW9fYmF0Y2hfY291bnQoJmNlcGhfd2JjLmZiYXRjaCkgPiAwKSB7DQo+ID4gPiAgICAg
ICAgICAgICAgICAgICAgICAgY2VwaF93YmMubnJfZm9saW9zID0NCg==

