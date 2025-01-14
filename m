Return-Path: <ceph-devel+bounces-2440-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53CBAA11101
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 20:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6431918844F9
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 19:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CEBF1D54E2;
	Tue, 14 Jan 2025 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YOn9He0+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC291E495
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 19:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736882260; cv=fail; b=abNJuN0K8Dif+OtFEKUWjyt31FF8Hk4o3GoRUiuVek35BzzlXD0llU/OCczuyumhMvUsyVva5d7mMZwvrgZ9ry5Lsg3NkT1LBGGvBBDfNXM2gI08/INZ0yYNZhctGJ4ZFTj/isjsiQ3O7Hp1PqIdjrV5phvVoss4XfBsO9C2YE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736882260; c=relaxed/simple;
	bh=/yXejSNWa6SL3j0kHrS2dekbxLH5RlyMALb83dvqgI8=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=LYpt4cPaT7OZYpiAyQOwa0zoDerzQAEDsffiNThvGk8/Cq2ZDluvwI2ifkHWcxi8aakb1dmJBKnULXwvMJFi/hUMM5fPWwWZber9I8mL7WtVxG3oT+z+9FZd0YWSNUp23JCmVHcO5o3FduEMAGlG1SSFrqlO8MRzA/kO0ZyoVAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YOn9He0+; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EJ7Khd021528;
	Tue, 14 Jan 2025 19:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=/yXejSNWa6SL3j0kHrS2dekbxLH5RlyMALb83dvqgI8=; b=YOn9He0+
	+pLDp0OvOIvRMPLnN60r1fpUMxWVEx1dsB5fYGKhBWU96pBC/4OaYwQcrJp5mqwG
	ZX9rNfTvAXGz1OtOq85LlKLQnjfLWxM6TSR2xPZX6I9HU8zJXFAo5cTjSbm5X9kk
	jYMJJiagBs4kfqk4+tKRUSfyZoLD1eg+cyKuIFefqBaDP1pXklKWbS5TaZdHDe4n
	UPKUMMhodZ0wFTXwh9th8g8aMCvBxmyWpGjo+xA8JRkPy8FWBps01JDSr7YCQ+2x
	1apmZln9BxvNw03ouk5iBsAtyEhGLO4Lg+YKOVJb+yhOD0y8JXWeSlviFU2jqnQu
	UL1TTwTml5Qb5Q==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 445m432ss2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jan 2025 19:17:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SkcdRyQNoprzzerqBQFMznEV40M012onzcx6EbmpZDc/nV5rzNY5sVzi1pV+bbWbV+xEmkXK9PWwfLBCMSSoaMzA4Hjr15LJcaod7t0ObbBdozloJkH72lHGKmdQLC+4Qy8KUIbZa8+xqK+Gg7z5UMvQZcyTe2diS+pb25BMQFcIEcX1MVsScchVDqDQkjTnt7X+JtPX3CUe1YaWKGvcwF4vmUMJtgodbCO/RaXDEhfT1Om2emFZqBjqnUsThSab/aHRRi3a4e/yHZoQxhGNgGnbMb3oGm+gBwIk+r18WMsJm3SzD1X4fYPff1Z3zlULcyla4KhdUMtxvy9XNGoEsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yXejSNWa6SL3j0kHrS2dekbxLH5RlyMALb83dvqgI8=;
 b=uors7YCE/7MQoLF+d7VVd9fokHHY5B5QjEOgZfMLdJpvcvEJvT7hDnLR2ImL/+ajUKNrCIS1F7InPvD+X7w1a8BJ3ZnqWh4asK0JC8+gaQ0Iyw31Yy5f2r2wUUvHSo6dcUoABDuRjD2xbxvfuM45yrTOvXuyeUgiu3Y2oCLdflal2TED1IxbY1hMxa7e1NPaY1I+wm0SbaL0VmX51VnfZ+T2xqf+3zbawp+ong/dQt7+YVRBipdrMs+z7F1OjD/srm/xwGXV3KSh2tacA/l4UXq8if5pgg+XUt30OPVbgZ4OWgJ7twnpmRhX4oN2aQIBgIj1HdmU/pXSUlULih+mYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ0PR15MB4534.namprd15.prod.outlook.com (2603:10b6:a03:377::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 14 Jan
 2025 19:17:29 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 19:17:29 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "antoine@lesviallon.fr" <antoine@lesviallon.fr>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix memory leak in
 ceph_mds_auth_match()
Thread-Index: AQHbZoKCQKSfajo7Hkaf/kezU/NOk7MWpOEA
Date: Tue, 14 Jan 2025 19:17:29 +0000
Message-ID: <4f32ab766770af99ce9585bdb54e875f7e656588.camel@ibm.com>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
In-Reply-To: <20250114123806.2339159-1-antoine@lesviallon.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ0PR15MB4534:EE_
x-ms-office365-filtering-correlation-id: 1a9a5071-6809-43f0-99e3-08dd34d016cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NzlBZmNtU2dwRGhwbDd1WlROMWxMbTk3ZERzSGNMSkJxQnJzVktmQkxudVRZ?=
 =?utf-8?B?d3oyMjc4VFF1ZTZhR2ZqeVhBbnF2Qm9ERElmYTVUZFlFOFNibVM5eC9zblBm?=
 =?utf-8?B?RmxTM3BFNVE0TDlRc3RGS013bnpCTnZ1eXU1VmNaWGRlRG9iU05EODlPWTBj?=
 =?utf-8?B?RU40SURRSC9CNEhHTjZ1NkIxb1VSbEpSRTRrRTUzb0xrdGhFY1VhUmJlMU13?=
 =?utf-8?B?SU5zZmZmU3cxU2tRTWVuUnBNT0pwRDRJZldoS0M3VkVlc0ZMOXo0SWpaNTNE?=
 =?utf-8?B?Sjd1TDkzeGIybkRHVFNubU1qWVBZM1cyZWl3K3M0WUoyK0t0OUNzSFVFc0V0?=
 =?utf-8?B?emNMQngvMWxoRXE3OXEyNXZnYkNLa1MxSGx6NzkrYkhWVlBzRlFHblUyUGUv?=
 =?utf-8?B?K0pZbGFPVFptY1dZSVZUTi9jZUQxU0UyTUdIaVJaMmRJVGEwcWx6SVluRUE1?=
 =?utf-8?B?aW9DcThuZFlma09UUVpHbnJibFNXWUpQWjdYamFldzkxVVBZY2J3RmhUTG9u?=
 =?utf-8?B?UThDL0pxS1NRQTZ6dGJnVW05Y1VDNnVLQ1NoR1BhN1JsZU5QMFZCakRlaTBD?=
 =?utf-8?B?SHdoQWJabXpxQzUxTjdib0dMaWVoY2tJU2JGV1FHSDl0cy9oWjBuU3VLS0tD?=
 =?utf-8?B?dEhaSWpJMkJRVytCWERDTGY5WDltajRLN254SGN5RTgvdE1Ub3h6ejIzMmVv?=
 =?utf-8?B?TmpiSm1kRXQvR0Y1N3dBWW0xZ3dZeTRpZlNhb1QzNVRJVGpkTnVmVHdXWWV2?=
 =?utf-8?B?aGFma2tEdTlSTGpnNlR6aTdsZTJ3N1k5bnZGdVZOak5ROGNHMEc3TitidnVO?=
 =?utf-8?B?YlN1eGlIT2NySnNFZWhWRE52WEtpWGlnWWxFY0lSOWtCVDVsK3kzR3pLOVNa?=
 =?utf-8?B?d0RnVGZ4ZjBSVzFES1NPTFVtUWwwUXZaR0RjRHd5eXZLeVptSlVjSEY0NlZZ?=
 =?utf-8?B?UUZJM1FvbzVYQktYTzQwSDdPMVRsUUJ3ZTVoTWtrTy9CdXptSW1IQ1pMSzF2?=
 =?utf-8?B?UlEwVTQ2NUhRbDA5ZFNEU0VBOGRNOTJyajdhVjdkR2dRTHhPQjlVR0pGN0sy?=
 =?utf-8?B?SjkrazEraGxEclVKUUdFWjlham5HWFFRTzZ3ZXI4ZStNVjZQQ21OclgwcjE1?=
 =?utf-8?B?SEs5QzBncFFIVFh5cmJ2NTh1bVR4aXQ1UkRKeXZRcGFTSWRuV0c0NjlsWnk5?=
 =?utf-8?B?dm9kZmp3dEFuYTNDdkY0c3NMWFZCcGdkQVFrcWU5QlloNjZNV1NQcFp6Qlgx?=
 =?utf-8?B?TENoUWZxQ016T3VmQkwvSHFSQVBFVVZpZ3c5UCtId0pqWGtCK3pZNTBsb3FC?=
 =?utf-8?B?NmZTRDI4dHF1V1FJcEJBYm5KOFJTVnBtK0lvZmhheFJvUmhyQ0VZeFpRMG9X?=
 =?utf-8?B?UFBtUWFJd1ZYcGVYS1NoU29sMkpZUXhFM2J5NUdjMEVKdkE2UDN5RkFJL1pN?=
 =?utf-8?B?ei9zQjlEQk80VDNyZ0NHRmJWTGRpclVvZEJaREQxU2tSRTZtVVlVUWNvcjJm?=
 =?utf-8?B?M2hUUC9NcU9iQ0l3alE0bGc4SVJ2ZDIzU2k3bG00Wk1yQ3M4WFJRMGVLdEV2?=
 =?utf-8?B?N1g1Vm1qS08rZWowUUhSdUNNeHNKRVZrdUJFZDRxcEtpVzB1aGMvSEdGSW1w?=
 =?utf-8?B?U0ZlREtFaUxxMnFQYmFHckRoYitCbnRpL1VncUdsUlY1SEJpUVd5OEE2Njlp?=
 =?utf-8?B?RWVzZ08wRXdtb3Q0dHhPWDRCbjh1UFp0bXQ0SXJHYlo3S0hNTU9pUHZnY1RI?=
 =?utf-8?B?RExaNFo0RDQ5VWtrL0d4UHBlL1NXZGUzY1U2WEZ4TmcyclpKMjFEUWtJMEFF?=
 =?utf-8?B?TFdVSFQwNVRoMGlNbjR3WU54V0NSdE0rRGtUS2JZdGN5LzY4bFNTTW5nekJ2?=
 =?utf-8?Q?NT5Nuc502g+u5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cC9jbUJuQk1BTzRKV2RqejJzbHNySmh4MFM4Qk5VQ1NUbVlmWEREU0dZMS9K?=
 =?utf-8?B?T1lOM1JwSUI4WnBpTXdJMEttbndNb25ZRlM5eURJWU1qOXBjUUJ1RXVRNDBa?=
 =?utf-8?B?OS9XUTdHbXJoVEJJR1pTZEg2ZG9VMGFtTG9QUXdQMXgyS1IvRlg4QlFTVkhx?=
 =?utf-8?B?c1JSTzJCVVBRNU5HenIydjhRQ3V2U1JsMVdpRUErWDZWUHkveFhKTEpwa0dL?=
 =?utf-8?B?akhIS21IOER1WFJmTW05Ui9EaXZoTDQ5ME1YU0pCM3UveE9lK0JGSkM1MFlo?=
 =?utf-8?B?K3NweitTS3ZZSXFRbExFYjN2UDU3U0lVaUNubG1sRUdSYW8xeDdZemVTdGQ5?=
 =?utf-8?B?MHRBRzlQa0kvUzNYeVFaV01VWHUxY2RaQ3VLQmpHM0lMQ1BoNXdBeElSdTJo?=
 =?utf-8?B?YVIwZmttL0U1SGwvWFpXZ3ZkNmhmWU9aTHRaV243U1h2bUU4b3JlSmhnM1BU?=
 =?utf-8?B?TEFrUU9pS2UxRnZIU0xZN3hLeGc5cmpiRFd3KzlkejhEUnpkRU1FS3NKUytI?=
 =?utf-8?B?OXROeXVpQW9PTk5VdFZHemY1UlBQa3BLTFYydWYrWEM2OEJQUm1EaDRDU1pV?=
 =?utf-8?B?TngxYWJneDFNZkZsMWM2V2lzOTN4dkt1K2dJSU52OExZN3N6MjVtU2I4dTdP?=
 =?utf-8?B?eStyOXFnUzE0Q1lFNVlEMWRUOUVBRFM3Z0lhNldOZ3VEK2phRTRSdWhtdzhB?=
 =?utf-8?B?dHczUHNHdFF0NmlpVDNiRXpIN0llNzN5RFJseSsxOVFyWW1JN1kzU1dnRVNV?=
 =?utf-8?B?YW9wbUhwMW80RG9NSmp1MC8zdDJyWWZ4THBSd0tTWDBYZHFTc2FCdlJhSUh4?=
 =?utf-8?B?M1NkeVhlaHJxUXA0Ry85L1owSjUreEhFVDY4SGlhM2dOTDFHMGIxVkdWZncx?=
 =?utf-8?B?SDRzK2hHdXRTZGJLc2JUaTVJWCtKYXFpcVoxWVlQRURiUVdRZHV6M0tQL0J5?=
 =?utf-8?B?OC9Gb3FKWnhKQ3JlSWZybE8vMkErTmk1ZVJCZ1JPMlY3Vk1ERjV5c0tmaFh1?=
 =?utf-8?B?YXh6WW5iYmFSdzB6ZFNSQ0ttZFlHYTVwTjRhenRxVE0xYlRZU1d6VnJyekti?=
 =?utf-8?B?aFZoRWhYRXFESHlqK3ozRnlvd21weGRiSU1ieERGQkl1UGE0NDl0SksrWks5?=
 =?utf-8?B?VXNZVFZkcHhmai9hcENoRHBOK1ZVRDhQSmIwWmwwcHNxdDdVYlJzYjQvSnlp?=
 =?utf-8?B?WE1tdTc3MWlGQldBM0hWMGVrUmlQNkE5UTFQSkRBeTRrNTRscWdwU25McFMw?=
 =?utf-8?B?eGk5d2lmeXBPRmJESnFhN1I5YzVNb25lNTBDZU9BZitTTHdvQWMreVlnRWh3?=
 =?utf-8?B?Y0MzenlGSTEyekRVcnNycVZqY0ozV0l4SHE4V2FKN0ZBOThNM0NjQjVOOG5G?=
 =?utf-8?B?eERqbkU5MmhVNnJYbWtLVkluUmduSFI3NUtMT2l4dFRIVFNzY3hQSGc3N2NJ?=
 =?utf-8?B?cHlDcHpMS0VGLzNhRmRGRFk0S2N3T3pLSk1PVlEyZC9oNmhXeERYbkFOczlV?=
 =?utf-8?B?N3NEZ3F1cEZYQXI5WXlETThXNnIrYkZ2eDBWNkhLeUpvbXgzRkVrbTJ2L3dv?=
 =?utf-8?B?U2NFV1NOenQ2bWs5QWlpT2YyZzNtb3NNNHBuYjNvbHFVTFBqWncvRXRoNC8z?=
 =?utf-8?B?b3lYOUhzZCtvOEdiV3hSTlJITzNhc1ljdUtxRGhuUGhpL1ErbjMvYzFqeUgv?=
 =?utf-8?B?VzVDSUl2MjZGV1RxOVRHQWJDdlQ2aE53RHFOdjQ3R2NJVFMwQ2hMaGpkeUVo?=
 =?utf-8?B?WXcyU25LeDdIdEtGempWRDBrZTMzeS9zZ0tPdzlwSCtJNWM5Qzc2bGpHVUh1?=
 =?utf-8?B?Z2pqSUd5cDJqTTJtNnVSR2xpSzkrSkFySFQ1am9qQTdtRFNXN1JBT1orZDVa?=
 =?utf-8?B?aGR1QzdMYkk3Z3JYK0x6ajduenR2aFdtTVRwQzVPNmtYL1FwdVRqaGFTbVRh?=
 =?utf-8?B?Qk1mVG5ueTZ3VFhybjUyanltMFR5Y2drc0ZybldOZ2QwK29TVm9nb0owd1dm?=
 =?utf-8?B?dnlOenZWNFN6bE9VczJsUHJycVZZcFhIblRiMzJTaVdIZFpEZHBuVUVTZm1B?=
 =?utf-8?B?OFBKTHh6NzN4S2doMW9pQ0syZ0Y5T3JDazBZVTNOWkdYZXMrSWxrcVRyWmJr?=
 =?utf-8?B?M2RTSm52Q2hacnE3TDNQSzc3MUs0bWFhcFVnUDVIMzN5RHIrZWxBbjMxZnlI?=
 =?utf-8?Q?DIJft/RuHO6d97G9QWk49ok=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21438D1AD2505F4A9F38C7770DFE4C2B@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9a5071-6809-43f0-99e3-08dd34d016cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 19:17:29.6660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S3qJ9LPVzuIvugJkFsRdzCAmKHA+ug6v6wlVS9ZcaMQrnN73Q1hBuwND2yG2QL0rnk2GS2v/z0d+0q/2ny3+MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4534
X-Proofpoint-ORIG-GUID: vvJYEAZrOtvYcOM791glPFt_kjwqryab
X-Proofpoint-GUID: vvJYEAZrOtvYcOM791glPFt_kjwqryab
Subject: Re:  [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501 clxscore=1011
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501140141

T24gVHVlLCAyMDI1LTAxLTE0IGF0IDEzOjM4ICswMTAwLCBBbnRvaW5lIFZpYWxsb24gd3JvdGU6
DQo+IFRoaXMgd2FzIGRldGVjdGVkIGluIHByb2R1Y3Rpb24gYmVjYXVzZSBpdCBjYXVzZWQgYSBj
b250aW51b3VzIG1lbW9yeQ0KPiBncm93dGgsDQo+IGV2ZW50dWFsbHkgdHJpZ2dlcmluZyBrZXJu
ZWwgT09NIGFuZCBjb21wbGV0ZWx5IGhhcmQtbG9ja2luZyB0aGUNCj4ga2VybmVsLg0KPiANCg0K
RG9lcyBpdCBleGlzdCBhbnkgd2F5IHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUgaW4gc3RhYmxlIG1h
bm5lcj8gQ291bGQNCnlvdSBwbGVhc2Ugc2hhcmUgYW55IHN0ZXBzIHRvIHJlcGVhdCBpdD8gSXQg
d2lsbCBiZSBncmVhdCB0byBoYXZlIHRoaXMNCmRlc2NyaXB0aW9uIGluIHRoZSBwYXRjaCBjb21t
ZW50Lg0KDQo+IFJlbGV2YW50IGttZW1sZWFrIHN0YWNrdHJhY2U6DQo+IA0KPiDCoMKgwqAgdW5y
ZWZlcmVuY2VkIG9iamVjdCAweGZmZmY4ODgxMzFlNjk5MDAgKHNpemUgMTI4KToNCj4gwqDCoMKg
wqDCoCBjb21tICJnaXQiLCBwaWQgNjYxMDQsIGppZmZpZXMgNDI5NTQzNTk5OQ0KPiDCoMKgwqDC
oMKgIGhleCBkdW1wIChmaXJzdCAzMiBieXRlcyk6DQo+IMKgwqDCoMKgwqDCoMKgIDc2IDZmIDZj
IDc1IDZkIDY1IDczIDJmIDYzIDZmIDZlIDc0IDYxIDY5IDZlIDY1wqANCj4gdm9sdW1lcy9jb250
YWluZQ0KPiDCoMKgwqDCoMKgwqDCoCA3MiA3MyAyZiA2NyA2OSA3NCA2NSA2MSAyZiA2NyA2OSA3
NCA2NSA2MSAyZiA2N8KgDQo+IHJzL2dpdGVhL2dpdGVhL2cNCj4gwqDCoMKgwqDCoCBiYWNrdHJh
Y2UgKGNyYyAyZjNiYjQ1MCk6DQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYTY4ZmI0OT5d
IF9fa21hbGxvY19ub3Byb2YrMHgzNTkvMHg1MTANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZm
ZmMzMmJmMWRmPl0gY2VwaF9tZHNfY2hlY2tfYWNjZXNzKzB4NWJmLzB4MTRlMA0KPiBbY2VwaF0N
Cj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZmZmMzMjM1NzIyPl0gY2VwaF9vcGVuKzB4MzEyLzB4
ZDgwIFtjZXBoXQ0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYWE3ZGQ3ODY+XSBkb19kZW50
cnlfb3BlbisweDQ1Ni8weDExMjANCj4gwqDCoMKgwqDCoMKgwqAgWzxmZmZmZmZmZmFhN2UzNzI5
Pl0gdmZzX29wZW4rMHg3OS8weDM2MA0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYWE4MzI4
NzU+XSBwYXRoX29wZW5hdCsweDFkZTUvMHg0MzkwDQo+IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZm
ZmZhYTgzNGZjYz5dIGRvX2ZpbHBfb3BlbisweDE5Yy8weDNjMA0KPiDCoMKgwqDCoMKgwqDCoCBb
PGZmZmZmZmZmYWE3ZTQ0YTE+XSBkb19zeXNfb3BlbmF0MisweDE0MS8weDE4MA0KPiDCoMKgwqDC
oMKgwqDCoCBbPGZmZmZmZmZmYWE3ZTQ5NDU+XSBfX3g2NF9zeXNfb3BlbisweGU1LzB4MWEwDQo+
IMKgwqDCoMKgwqDCoMKgIFs8ZmZmZmZmZmZhYzJjYzJmNz5dIGRvX3N5c2NhbGxfNjQrMHhiNy8w
eDIxMA0KPiDCoMKgwqDCoMKgwqDCoCBbPGZmZmZmZmZmYWM0MDAxMzA+XSBlbnRyeV9TWVNDQUxM
XzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ny8weDdmDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbnRvaW5l
IFZpYWxsb24gPGFudG9pbmVAbGVzdmlhbGxvbi5mcj4NCj4gLS0tDQo+IMKgZnMvY2VwaC9tZHNf
Y2xpZW50LmMgfCAzICsrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL21kc19jbGllbnQuYyBiL2ZzL2NlcGgvbWRzX2NsaWVu
dC5jDQo+IGluZGV4IDc4NWZlNDg5ZWY0Yi4uODljNjllOWMwM2I5IDEwMDY0NA0KPiAtLS0gYS9m
cy9jZXBoL21kc19jbGllbnQuYw0KPiArKysgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiBAQCAt
NTcwMiw2ICs1NzAyLDkgQEAgc3RhdGljIGludCBjZXBoX21kc19hdXRoX21hdGNoKHN0cnVjdA0K
PiBjZXBoX21kc19jbGllbnQgKm1kc2MsDQo+IMKgCQkJCQlrZnJlZShfdHBhdGgpOw0KPiDCoAkJ
CQlyZXR1cm4gMDsNCj4gwqAJCQl9DQo+ICsNCj4gKwkJCWlmIChmcmVlX3RwYXRoKQ0KPiArCQkJ
wqAga2ZyZWUoX3RwYXRoKTsNCg0KQXMgZmFyIGFzIEkgY2FuIHNlZSwgd2UgaGF2ZSBzZXZlcmFs
IGtmcmVlKCkgY2FsbHMgaW4gdGhlIGxvZ2ljIG9mIHRoaXMNCm1ldGhvZDoNCigxKQ0KaHR0cHM6
Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjYuMTMtcmMzL3NvdXJjZS9mcy9jZXBoL21kc19j
bGllbnQuYyNMNTY5Nw0KKDIpDQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4x
My1yYzMvc291cmNlL2ZzL2NlcGgvbWRzX2NsaWVudC5jI0w1NzAzDQoNCkFuZCB5b3UgYXJlIGFk
ZGluZyB0aGUgdGhpcmQgY2FsbC4gSSBiZWxpZXZlIHRoYXQgaXQgd2lsbCBiZSBtdWNoDQpjbGVh
bmVyIHNvbHV0aW9uIGlmIHdlIGhhdmUgb25seSBvbmUga2ZyZWUoKSBjYWxsIGFuZCBnb3RvIGZy
b20gYWxsDQpvdGhlciBwbGFjZXMuIENvdWxkIHlvdSBwbGVhc2UgcmV3b3JrIHlvdXIgZml4Pw0K
DQpUaGFua3MsDQpTbGF2YS4NCg0KDQo=

