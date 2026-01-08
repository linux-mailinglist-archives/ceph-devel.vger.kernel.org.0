Return-Path: <ceph-devel+bounces-4336-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 573E4D05FA0
	for <lists+ceph-devel@lfdr.de>; Thu, 08 Jan 2026 21:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 57031301BCC4
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jan 2026 20:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F811328B43;
	Thu,  8 Jan 2026 20:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G2rpSF+P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CAB1DDC07;
	Thu,  8 Jan 2026 20:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902745; cv=fail; b=rWbHPD3v8kNmOiRSECgTk6ju4RXx8kOiKD4dvT4khR9X05qMje1GMTX9JwEFmu9tBJn2Z+saXQV5fbO7PwsUJhr5ZXrfOzW+641I/2dAje/mgfBTvnVYKVDRSI1Bo432bU9vpuEff9UKTiz4V6UzZ9insriO3yyZOazUZo+79n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902745; c=relaxed/simple;
	bh=qMpBCgTGcHekkREtV4R5+YfUIUjh3RiHjZNpkzwSEEQ=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=TOrNhkXyAeIHHYo1OJvxcSdHYkvIYGm3xm5pGw8FY/fbtMkJAB5NJAl0LvvN3fOU3h0lFERM1ufZXj9k1ThMD63HeZrqbYSuwIurwrLc6luQq4BV6ZOQ3AjfMzUmhnpazh76ZmATF3oFQmeYtkiM1aZslU1H9KoN8RBcmoBXIs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G2rpSF+P; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608BHwSj001526;
	Thu, 8 Jan 2026 20:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=qMpBCgTGcHekkREtV4R5+YfUIUjh3RiHjZNpkzwSEEQ=; b=G2rpSF+P
	aLRH2N+levs4W1Tq8TGwzd/1UXfWccKYUd0T4QxR8toMDDFOaB1b0SFLEyO4DDFB
	zbnjhrY9w8Zq8t6kMN9R5msjSpNs8YpzUHm8JsZ3CiJhG2wHKnbDbX9MyjDy3JdB
	7uC3yj6Gcw3vmvGGWKPvRjpJilSDjAxj9sUyVFmf+Vo0fz2Fo+8cDMd58PIrxGf8
	eQHawLURi7PYcxRwBGyssNIJ/CPn3GVJ0WVXwbBcTtZti0Opa+r1Reem0sYlkJWW
	y03PIYpHzSQ9+RwJ+pIOo6lqolR2GaDbhq4Nuy/5tPvhuhNBOvD5+9lhBadQPrd3
	bZV3jatMrY5GMg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhkeyh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:05:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608JwvV9021236;
	Thu, 8 Jan 2026 20:05:37 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhkeygw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:05:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v6UywRxQR2VmqGgrbE3g24BkWpKl90bAJ39at8I9Dai6VTZicPJkoBwvhva/71dNOp0uhx5gvPva3u4ZUyoQGnWPw30QFkr5cFzdxlMw7CMV3H90k9NlBOtTi6VVR1MDoQaUHqrE0EYVXpWu0Ztml39xpHCt2+JIsMZGzTaTQ3dOHR+faZ5BpnXztjz61clbx06ziHupKyKARSoawR1/of1NYXs+I/KLh8pPlZtg9MJt6eTE7PY45zYL0JrAWFTcpYlhoLJ86PA28Q19ygvFeKp7xuFSnuJYjNbOaGEz+Ub2HtoH/ngdC+ZvSYKTiTC2pY0J/vIDyf0C8rgNHdRJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMpBCgTGcHekkREtV4R5+YfUIUjh3RiHjZNpkzwSEEQ=;
 b=F5SE2QuORYkAHIfB2FvGe9UcxyExnDcIXZAlhcNsDLo+563b0uIbHV4YS2IwAAAiInSiguiBODdloAJVlHKbiI3HJfb7MKtxkxx2AqAHGBItyr1a+wjZAZrloXzNZ+AjH2n3eCdzt399BP1ttGUlG2SeNqF2u2M6OLvcnoXc2SJ9ZbbLA05y5FWHFAYr0hR6FNQTqJl0XHd8f3jERyUVEY0POjqBa/436dV9FVUU1sSH+AUMB4hfabVU4751I2r0eVWgmLoMGspLlWUlOgT7lzNR6P95sQLO4iL9Ws8GDBIPcfesH7Hclk4CPwEdvRuwr5uSL1HST4TdiunhrK3YZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ4PPFC6C269E9D.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8c4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 20:05:31 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 20:05:31 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 1/6] ceph: Do not propagate page array
 emplacement errors as batch errors
Thread-Index: AQHcgBjmo+2cKOAqPEebiHXT4t+lPLVItBUA
Date: Thu, 8 Jan 2026 20:05:31 +0000
Message-ID: <7cf9d1f42ed1ffa16dfd54b8d1356dbb5f10e650.camel@ibm.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
	 <20260107210139.40554-2-CFSworks@gmail.com>
In-Reply-To: <20260107210139.40554-2-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ4PPFC6C269E9D:EE_
x-ms-office365-filtering-correlation-id: 5a0640df-df34-4e34-e0dc-08de4ef146e1
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SFc3d2NYUmNscEtsMGJyTTlaeHdna3hjUzJnNXlaV3dkMjNYVndGQ3NhSmRy?=
 =?utf-8?B?UTUxcU5ZcjRtenFUeU1mbElGbkorN2FLU21Ia0JMcDZlWXZaNzJqa1VRU1dU?=
 =?utf-8?B?d2hzSTVJVXMxK0JHaUgxUUZWQnBNaC9lRW8yM0VUSXozcFZNaER6WWpZajZD?=
 =?utf-8?B?VkhZdHJEbzFWS1F6UCthU2llRmlpbTg3MFJEcVQvOW1jaHpVN3c1UkpyeHBL?=
 =?utf-8?B?RFVVR1ZiUVpVRGVqTXBhNW5JU29TVHd1RDMwS1hjTHd4MEt0MFNZeGJ0QkI1?=
 =?utf-8?B?RThsR0Izbk8vYzFaZFN2YnROY05PdlFJem00L3BjSkFsc3hsTTdzYWNTUm13?=
 =?utf-8?B?VzQrTEFZamJjM1Z2Q1h4QWNpOW5nRjZ3bGVwdDMxWmFFQmd4SHJkMDBDQ0ty?=
 =?utf-8?B?L0FrdDlKTzZnRis2SUdBOGtiTVlkdlBtRFVGWXVoRlFwei9sRjdGajd5cVlG?=
 =?utf-8?B?RDhIYXp4M2Y0VVBoSG5Lb0h0Qm5VVGVCMHpreXQ5NTFUMVhySGt2UXBBTHBm?=
 =?utf-8?B?VWpyTml3ZnFaQTVpK001Q3p1ZTd5dU5Kckx0QWlCVWtuK2VPdi9rSnp1ZGll?=
 =?utf-8?B?VHZLQXpic2dMOHR3eE8vbW9zeGJSVnZnUE5Idi9SL25UN2RKejVYb1Z1VHg0?=
 =?utf-8?B?K3FoUDhBV1o0TWxsTXdTb1lscEFoNkl6dlFLZ2w0c2RKR1RmK2dpYUJIY2ho?=
 =?utf-8?B?dFB5VlNXRlhNUzNrQ0dxTnJidG5EazNnbzVGZmFUeGFWSDlCQ1k1am9xU2Fa?=
 =?utf-8?B?eC91d3ZJYkV3cldXYVkyalRzSW5iZ2xveUw1YzlyaHh5NnlaZ0hCUVc0bWpk?=
 =?utf-8?B?dEppTk1sd2lqNHd3elJzSFh0dFU1Z3hBMWlkWmhRU0RCdWd2bVlsMXJCZ2w2?=
 =?utf-8?B?ZTJIWGtXM1dSZVFVTDRxM0ZhMTZLa0tCYzlKMUNXTVdJdmxzRG82SXpWbnpk?=
 =?utf-8?B?NzZxQysxejdybFZvK2dXeXUxaDhjNGZwWkd3VTJzRG1KMGxHSnZPMjdYbmxU?=
 =?utf-8?B?a24yeVEzOWRHcFJ6aWprOEJOSGRjeVdsNGJIWlNFc2d6alI3by8yQ09pdVlP?=
 =?utf-8?B?Z20vL1NKUDFtdENtRi84OWpGT21BUForbCtVRUx2Z2pkdjhWaFo3QVlWZUNp?=
 =?utf-8?B?ZWVwZjUyUU55QzQ4MGwwV01haFpWY3AyQ0JWY2YyR1oyUVI5azNIdDNaTm01?=
 =?utf-8?B?aktYcGNiQnhCKy95bVUvSFJoM1dwaE5mQmVWMnhaV3hjN2NHV2JJcDhqQkU2?=
 =?utf-8?B?MnBNdC9QT2ZsZ01iSDU1aG5xcWh1c3RUcU44UEs5YU5mYU5DZ2FHSlJ3bVEv?=
 =?utf-8?B?NWZqSUd6QVI1TUNKMEI0WnRjR3FTL0FkdEZBQWhOclJVdVZmMWVaaTdSRklR?=
 =?utf-8?B?N1dXTWpJSXJraDd6Yk5oUytSQWVUQzM3UmpDSHhCajNWdWxYRlcrWXRzMGsw?=
 =?utf-8?B?WWJxdGs5SXdxVHlKNlZCV281cTlzbmtJTThZY0RqVVdJd0cwMzlJTGhRdVVX?=
 =?utf-8?B?NTdXV2hRbXQ4Y2Ywb2VYeFJWSTBhL0Fmd0NDSXJtblpZeHB4VGt3cnRyY0xh?=
 =?utf-8?B?Z29TL05KUzlNRm1PTlVuTXl1aUFlOHlVdzcvb1Z1SEMwQk1DYTRIU3kyclc4?=
 =?utf-8?B?Q2tCMkZiRGdFcHhnWENCeDV4ekJNV0JiS3U5Q3FGdndFQUtwOGVQbnI5bkxR?=
 =?utf-8?B?YTJCUEJTU1FrMmdlWWEwOXdBTDNuTlhaZkRldXkxaFZzcWxDbGZ6cGUvVG4v?=
 =?utf-8?B?ZjJ6TThic0E5aUpDK2FZNTNLb3dCNWJlUm1wRE43RXJxZzdxU2RUaHFIdGho?=
 =?utf-8?B?OFU0OGNPVVlMbEtwZUpTTkk2TWxLdFEyVUhDK3dNcnNYUlowdHBCSURlOWNa?=
 =?utf-8?B?RkhBOS9UTnp1bzY4ODRsTmoyWjRQcEZTS1dKME1GblJJdUJBblBnR2xkV1VE?=
 =?utf-8?B?M2JuRGV1MEloTjFvY0IvMjFmc3Z1SDl0UTJDNVh0YVA3SWxoNm1KTzhJZUYx?=
 =?utf-8?B?UDRwcDkzUWJ5MXVPK04ySE5UM0pTVVRJRFhDMlpjMnRZcEN2cWNxeWJlRHJH?=
 =?utf-8?Q?a/p60T?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VHJCNldkN0FWdDZPaWRFUlJDVXQyY2JzMUhKT1dGYjcxb0FDbWkxU3lHcXc1?=
 =?utf-8?B?blREZElSaDB0ci9DVXk0ZmljR1BKZHJOaHBwK2lQNkhxZWEzK0VkUFVVQmh0?=
 =?utf-8?B?TG9aTHpvSVhzQU96ZDdzK3Z1V1BXSTFzaWN2S2tiemVVNW1HL3hoTVRFRGE3?=
 =?utf-8?B?Vzc0Q2N5K1N6QWtGSStUSFVxTjZZM2FabktneU5ZeVZGOEZKZVJqelFMQURl?=
 =?utf-8?B?WXFaZytVa09HeHBpL3BBSUVxREJKa2RDaDdyWWVrOUQ3a2EzU0ltOThvdjN0?=
 =?utf-8?B?d0RReFhHL3FrZldoajI3eER0T2tsTDYvV1NBeGJXczlFNko2QWI3dXpVVnpy?=
 =?utf-8?B?UkpnTW1DT0RnaTZUQ2pHV2k1TU5CZkFnbklCOE1wbHVNYy9nbDd2eTUyVHln?=
 =?utf-8?B?S2JidkFTVGJRdnV5YTlvbVBtdVJMY09vci8yTmE3a2VBdTlPSzFYRkhWWTB2?=
 =?utf-8?B?THowM0NzZmNWdHBqTTJLWmN5NmRrVUNjWnIzZTZQVUJ5OU5VcTNzQzhSaytC?=
 =?utf-8?B?VjQ2WStPRktiTHpFZXZnL2M3NEhuV3FVNHZpcDFHSUd0aFk4U25zQk1MR1hz?=
 =?utf-8?B?VWtCM0pkRVFGWFF5SmhxRzdsSC94YUxabG81bTJJOGZzM0FROEhxVzRhMFRM?=
 =?utf-8?B?cHhKUGpWaGlUa0tNQVlOcjh4MVVBTjNrQkRvQ28zZnkvYTJvakZOSVQyaUUy?=
 =?utf-8?B?S2lXVlZpaW40K1UxSDdYL3dLdHZWQml0TmFmeDBNaWZMYVFrd2NwSGlFYUxE?=
 =?utf-8?B?WDhKeTM4TUFvWis5aitUWStzL2prM2tvd3FDbVR6UG8wMFA0UGpZcWpFdlRq?=
 =?utf-8?B?dGtiNzhBdk9BajU5UlI5WmllSjBkaE9SanJ0RXcxTWhmSS9teUQ0UzlWdy9N?=
 =?utf-8?B?a29adkRWNDRaZVAzVWkrd1lQVTlZRDhBZ3VWVWdQd1JIUTFsdnZYUG5zMVN0?=
 =?utf-8?B?bGt1Y2F0cWlvbmhkdkdjelEyME9zanljakZqRktuckhMMGI4MmpUZThpTlAv?=
 =?utf-8?B?QjlPM0FweGQwRk1BVkJzRCsrYnc1YzZkeGh1V1Y3bFVmVFRMblRXS0M5RzBK?=
 =?utf-8?B?SDdxaHBNWlRYOFdHWlRKRStzWDArVGxNZHJNVkZSbHFITm11M0k1aHJQWXM4?=
 =?utf-8?B?aklxQytNZStBRi9qU29ucEF1WGEvNHBwaERWd3dkNlBVak9aM3orM0NZa3hr?=
 =?utf-8?B?VEtScDFhQXJ4SlVjVFEzelVrQ0FmQnZDZ1ZFNTE5eWw4MVZWV1loR1FkMWph?=
 =?utf-8?B?eGlVMGthV0JHbkExZ1paZXlFcm40eHVlalZPTXRxakVjRnVtT3V4MXEvc0J4?=
 =?utf-8?B?aEd1SEZjdmdyR2ZKNGVGMWY3WCtiOXZOb05yZjdxam5mT3Zrc1Y1UGNqa1hN?=
 =?utf-8?B?bEZTVi9TYnVsZ2lNRnQyUXRjRklSZURENEhXcytVd2QxY2xJckhxNUhQclVJ?=
 =?utf-8?B?S2haMFc1M3dPdDBHM1EyTTc0aStiZ1VXdEtrbkhXSmUrTG11WEZrUkY0NzQv?=
 =?utf-8?B?OXJyMGlheWl5RjdtcFdBZDV3K1pxZ3EyclRxQWc4d1REY1UzT0pSeEkwRHRU?=
 =?utf-8?B?QmY4TFFUaFdHd3RHTndZaFl4ZEcwOVFHZEh6Wjl6Zk5TdE1TWEw1Vm9UQk1T?=
 =?utf-8?B?UUxLZm8yYXhNeDVmQzlTYzhaWFJvdlRrbjNlaGttZjM2TjNTRk1waTg4Rll3?=
 =?utf-8?B?c0ozR2k3b2FacVlVKzQ2c2FNUXdrRHEwT05HejFQWmNNVTBjNXdyZFk2dG81?=
 =?utf-8?B?ckhJeCtjNVhIUFJ3UWRzbzcyeUVDcWM3MEkraGRNNVRJNE5DZzNwTzdJRWkv?=
 =?utf-8?B?a1lQQ2I0dkprZmt3WEhBbHo0MGd2ZDVGa0E5MkJMWWhrVWlOUzFDTGQveFRZ?=
 =?utf-8?B?UEhpS3E5QWxPUFF0cU9sdnNUU2wyQ1dRdHI4WUl0UXcwcG9HWEZvdU1ENmtX?=
 =?utf-8?B?biswS1plakwrRm5oc0dSMG00OUpSQUl1WXN1WjlaMHA1S0VYS09hOHRIWEVn?=
 =?utf-8?B?ejhPaVV4dDVhSTV1anhlck5mdmV6U1dUWWk4Y3dxT2oxYTlyM2grYW5uWE1U?=
 =?utf-8?B?RUNURW1Rb2RvTklHNWFLaVR2K3NQM3I4WGxHMjVsK2J3QmV0d3FXb2RKbUNC?=
 =?utf-8?B?cXZmOUxnN2w2N3pNNzZ2ZUhwL1pDdThMSFVsTjJDeUhZNEhiRklFTzc1TEdi?=
 =?utf-8?B?NjY1MW4yMThvbXYxbnE2MjdIRHNLWWUxcGRVMDVtaTFaMDF5VzZSSlhRd0hY?=
 =?utf-8?B?L3p0bnZsSFFRMGtXMTFaTDNMcWZYSVdyNHNWWldhUDdEbHJIUW50YWlhS3ZW?=
 =?utf-8?B?ZTczNWVNUXVkek5tOGhMUmpsZmM3RUwzVkFRMWZ5TEIzTGlLMGc3WW5JMXBs?=
 =?utf-8?Q?2APCvklNvmmYxAkiP7nfNKXZdY8lnz44ql6F2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76631C250E103B4FAD47AA194EEEBA18@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0640df-df34-4e34-e0dc-08de4ef146e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:05:31.6263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMe7xLDlPmjqy3itBrUiAw5pntdG2cKXu8np7ZT+p1gmgWlZi159LQr7iTT52qwx403ZkdnY6Cy55tbHmGpEfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPFC6C269E9D
X-Authority-Analysis: v=2.4 cv=P4s3RyAu c=1 sm=1 tr=0 ts=69600e12 cx=c_pps
 a=5I5pDAtSp800fId2YpAiPg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=lVx84MYFKFPsGFldyrUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _iM9Dn8fQF3gMSkvlAm580UHCPAZDvUl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0OCBTYWx0ZWRfX+CrwUYz4jUtE
 6UsLk4MFYFklJjEbLrGD+VhXIUDS5jJSJSt8GsQc9pVS/56zBdkiJqLfKACV57V/wCm4cwT8EqT
 Jjr1vgPdLhMjV+wI72qTY7udNQVp8+coV9fTwLgKj894lHjIp2Of800q6OyGhOyAuhdBEOZWt/x
 hQiZr6nLRSFuWlXwovaxIHAf67/EqUrU45/i3ExshJgDRP6BziXlIIpDTuVBPHourAn6dMWnACo
 Pcg7Q3CRiK2wbafTC16YFOdhz78BWuVfp2r7Oim8PE1w/A1yEodrOFakZliyD0VWaxX8sqSC3lF
 1hPC78v5AY/AAXbrlX1McoFRWJ1EjOuh0751aRVR95qnhsytlVikAmbsOoktD906HRJt3yvL/3R
 fqWTehH+s9fQEAJBLWpy1W39t6kVKACR1GNyg76GUATrTM661V+Jb2HqOPn637J1LI4WzC5zJTg
 478TOJotX9VWru/tAfw==
X-Proofpoint-GUID: nXL3tx8yaIAWd5LfPzKjUtl_oU-rQggl
Subject: Re:  [PATCH v2 1/6] ceph: Do not propagate page array emplacement
 errors as batch errors
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601080148

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEzOjAxIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
V2hlbiBmc2NyeXB0IGlzIGVuYWJsZWQsIG1vdmVfZGlydHlfZm9saW9faW5fcGFnZV9hcnJheSgp
IG1heSBmYWlsDQo+IGJlY2F1c2UgaXQgbmVlZHMgdG8gYWxsb2NhdGUgYm91bmNlIGJ1ZmZlcnMg
dG8gc3RvcmUgdGhlIGVuY3J5cHRlZA0KPiB2ZXJzaW9ucyBvZiBlYWNoIGZvbGlvLiBFYWNoIGZv
bGlvIGJleW9uZCB0aGUgZmlyc3QgYWxsb2NhdGVzIGl0cyBib3VuY2UNCj4gYnVmZmVyIHdpdGgg
R0ZQX05PV0FJVC4gRmFpbHVyZXMgYXJlIGNvbW1vbiAoYW5kIGV4cGVjdGVkKSB1bmRlciB0aGlz
DQo+IGFsbG9jYXRpb24gbW9kZTsgdGhleSBzaG91bGQgZmx1c2ggKG5vdCBhYm9ydCkgdGhlIGJh
dGNoLg0KPiANCj4gSG93ZXZlciwgY2VwaF9wcm9jZXNzX2ZvbGlvX2JhdGNoKCkgdXNlcyB0aGUg
c2FtZSBgcmNgIHZhcmlhYmxlIGZvciBpdHMNCj4gb3duIHJldHVybiBjb2RlIGFuZCBmb3IgY2Fw
dHVyaW5nIHRoZSByZXR1cm4gY29kZXMgb2YgaXRzIHJvdXRpbmUgY2FsbHM7DQo+IGZhaWxpbmcg
dG8gcmVzZXQgYHJjYCBiYWNrIHRvIDAgcmVzdWx0cyBpbiB0aGUgZXJyb3IgYmVpbmcgcHJvcGFn
YXRlZA0KPiBvdXQgdG8gdGhlIG1haW4gd3JpdGViYWNrIGxvb3AsIHdoaWNoIGNhbm5vdCBhY3R1
YWxseSB0b2xlcmF0ZSBhbnkNCj4gZXJyb3JzIGhlcmU6IG9uY2UgYGNlcGhfd2JjLnBhZ2VzYCBp
cyBhbGxvY2F0ZWQsIGl0IG11c3QgYmUgcGFzc2VkIHRvDQo+IGNlcGhfc3VibWl0X3dyaXRlKCkg
dG8gYmUgZnJlZWQuIElmIGl0IHN1cnZpdmVzIHVudGlsIHRoZSBuZXh0IGl0ZXJhdGlvbg0KPiAo
ZS5nLiBkdWUgdG8gdGhlIGdvdG8gYmVpbmcgZm9sbG93ZWQpLCBjZXBoX2FsbG9jYXRlX3BhZ2Vf
YXJyYXkoKSdzDQo+IEJVR19PTigpIHdpbGwgb29wcyB0aGUgd29ya2VyLiAoU3Vic2VxdWVudCBw
YXRjaGVzIGluIHRoaXMgc2VyaWVzIG1ha2UNCj4gdGhlIGxvb3AgbW9yZSByb2J1c3QuKQ0KPiAN
Cj4gTm90ZSB0aGF0IHRoaXMgZmFpbHVyZSBtb2RlIGlzIGN1cnJlbnRseSBtYXNrZWQgZHVlIHRv
IGFub3RoZXIgYnVnDQo+IChhZGRyZXNzZWQgbGF0ZXIgaW4gdGhpcyBzZXJpZXMpIHRoYXQgcHJl
dmVudHMgbXVsdGlwbGUgZW5jcnlwdGVkIGZvbGlvcw0KPiBmcm9tIGJlaW5nIHNlbGVjdGVkIGZv
ciB0aGUgc2FtZSB3cml0ZS4NCj4gDQo+IEZvciBub3csIGp1c3QgcmVzZXQgYHJjYCB3aGVuIHJl
ZGlydHlpbmcgdGhlIGZvbGlvIHRvIHByZXZlbnQgZXJyb3JzIGluDQo+IG1vdmVfZGlydHlfZm9s
aW9faW5fcGFnZV9hcnJheSgpIGZyb20gcHJvcGFnYXRpbmcuIChOb3RlIHRoYXQNCj4gbW92ZV9k
aXJ0eV9mb2xpb19pbl9wYWdlX2FycmF5KCkgaXMgY2FyZWZ1bCBuZXZlciB0byByZXR1cm4gZXJy
b3JzIG9uDQo+IHRoZSBmaXJzdCBmb2xpbywgc28gdGhlcmUgaXMgbm8gbmVlZCB0byBjaGVjayBm
b3IgdGhhdC4pIEFmdGVyIHRoaXMNCj4gY2hhbmdlLCBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2go
KSBubyBsb25nZXIgcmV0dXJucyBlcnJvcnM7IGl0cyBvbmx5DQo+IHJlbWFpbmluZyBmYWlsdXJl
IGluZGljYXRvciBpcyBgbG9ja2VkX3BhZ2VzID09IDBgLCB3aGljaCB0aGUgY2FsbGVyDQo+IGFs
cmVhZHkgaGFuZGxlcyBjb3JyZWN0bHkuIFRoZSBuZXh0IHBhdGNoIGluIHRoaXMgc2VyaWVzIGFk
ZHJlc3NlcyB0aGlzLg0KPiANCj4gRml4ZXM6IGNlODBiNzZkZDMyNyAoImNlcGg6IGludHJvZHVj
ZSBjZXBoX3Byb2Nlc3NfZm9saW9fYmF0Y2goKSBtZXRob2QiKQ0KPiBDYzogc3RhYmxlQHZnZXIu
a2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBTYW0gRWR3YXJkcyA8Q0ZTd29ya3NAZ21haWwu
Y29tPg0KPiAtLS0NCj4gIGZzL2NlcGgvYWRkci5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2FkZHIuYyBiL2ZzL2Nl
cGgvYWRkci5jDQo+IGluZGV4IDYzYjc1ZDIxNDIxMC4uMzQ2MmRmMzVkMjQ1IDEwMDY0NA0KPiAt
LS0gYS9mcy9jZXBoL2FkZHIuYw0KPiArKysgYi9mcy9jZXBoL2FkZHIuYw0KPiBAQCAtMTM2OSw2
ICsxMzY5LDcgQEAgaW50IGNlcGhfcHJvY2Vzc19mb2xpb19iYXRjaChzdHJ1Y3QgYWRkcmVzc19z
cGFjZSAqbWFwcGluZywNCj4gIAkJcmMgPSBtb3ZlX2RpcnR5X2ZvbGlvX2luX3BhZ2VfYXJyYXko
bWFwcGluZywgd2JjLCBjZXBoX3diYywNCj4gIAkJCQlmb2xpbyk7DQo+ICAJCWlmIChyYykgew0K
PiArCQkJcmMgPSAwOw0KPiAgCQkJZm9saW9fcmVkaXJ0eV9mb3Jfd3JpdGVwYWdlKHdiYywgZm9s
aW8pOw0KPiAgCQkJZm9saW9fdW5sb2NrKGZvbGlvKTsNCj4gIAkJCWJyZWFrOw0KDQpJJ3ZlIHNo
YXJlZCBteSBvcGluaW9uIGFib3V0IHRoaXMgcGF0Y2ggYWxyZWFkeS4gSXQgc2hvdWxkIGJlIHRo
ZSBsYXN0IG9uZS4NCkJlY2F1c2UsIGFub3RoZXIgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlIHRoYXQg
aGlkZXMgdGhpcyBvbmUuIEl0IG1ha2VzIHNlbnNlIHRvDQp1bmNvdmVyIHRoaXMgYnVnIGFuZCBm
aXggaXQgdGhlbi4gTXkgb3BpbmlvbiBpcyBzdGlsbCBoZXJlLg0KDQpUaGFua3MsDQpTbGF2YS4N
Cg==

