Return-Path: <ceph-devel+bounces-3936-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B66CC41908
	for <lists+ceph-devel@lfdr.de>; Fri, 07 Nov 2025 21:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D08734240B3
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Nov 2025 20:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C402303C85;
	Fri,  7 Nov 2025 20:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KevGfmtH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5013D3090E8
	for <ceph-devel@vger.kernel.org>; Fri,  7 Nov 2025 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546497; cv=fail; b=p3+YtXf/qIIsUNaQK2rpn4wv1NVwwCrmFgfT77Mgdyfw2U3ekwvXagHJ8eHrckdXmHUETgJJUXbmrUd6iwlbolSl9TCtyLe2SjBbVRhSlmiAHGxF7jorDxXLhIw6+rRPQPxRcDTYJpo6GtLnq2Ze2G5Q8YpSlW07GSeQW+62UKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546497; c=relaxed/simple;
	bh=DZqZS8dzOOlDTiQtTwraAdAf8rhOso5i9pWBoh8dIVo=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ffbNXjS6x9AnFHZFj8hpCiNZRrPc595qEfoPqw9FmVkDUdTrNTfxNT/B3VnpVe2n32q/l/Rj9Dvybd4ZmHYjI4WtWuqtA6hwJGfGjOeqfEijW72DwShZxBqnFSHeOegyX85jLAfcN42NA+qfdlERY/LUZbtsPu1iv9Eb8Z/5BkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KevGfmtH; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A7EsZQP030409;
	Fri, 7 Nov 2025 20:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=DZqZS8dzOOlDTiQtTwraAdAf8rhOso5i9pWBoh8dIVo=; b=KevGfmtH
	Mi8cTytvbkPbViO1PJob9pOHfLsaEq1XxPJ1ISi/rExIX3EjAg1XRIV7skgBwv4d
	hFF6CLTVp/txZvcEbVwWIyJg5/RK7p+6vYpvYeojOKW1q9qCszzMPD+v/2uvwkIP
	gkGXIXtBvJDz3d/8yCUWOJjJmchGP0zdp7Z+r96Pv9MM8RJZgJ202uTc7erInkvK
	75ttn7BQ2o9FSe/lEsSn08KdON9w6ySikkEqJ3oR88mhCpWive/PbAyK9qj4Q39u
	+WBoioNy3dzRl5DLtJmeedpKuvJG+rIqpaVfLu9SQO1vZ+WnZVXt6d2i6hAC/dAK
	xFnJyrQwEu8qoA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9jxmsmxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 20:14:53 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A7KErYx022749;
	Fri, 7 Nov 2025 20:14:53 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010008.outbound.protection.outlook.com [52.101.85.8])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9jxmsmxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Nov 2025 20:14:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=orOA5D+DzmYQx5c67/BjGg/KKZUI/7c04iqP0PZfSUuoFQUIa6Px/ASKRxysKo+rcDejubTJQMFRYPyuJn4gWBisHvCVkfpxRgj+C3YggKrwxoYNlKf6MnIXGueoDRL3X/KN1e+bYULF4tkkOdnjKeZdFOdLzLuyXrNHAi1aXxe8A3spvBFFU3RQUtcAcL+DWgWt7XHWpukPy25dwQcBPFoQmZJMLuO8cK1Mbgkw6w6NdsJxzizR9Fy6jdFWe1J66CHA9kwzBFHo4yCVf5s0pJ/6ltXHGE9cDXA4n2zd3OPpTtwD5yx6/qrvTxpU6/jvTDBGe1oRl47zgJuCmke0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZqZS8dzOOlDTiQtTwraAdAf8rhOso5i9pWBoh8dIVo=;
 b=NXeKmaHb5Y81z3xHbcTMOVOtEvrVbWSEFOgwL0V1QHJFUo0kEB5CH8zJGS/wQDBUBF75ZlwTRqRFilcHv6qA+bUbLaQnVT0aOPaWXtWiQU8Mm92cPjPe7IYVcZjOfxRU9IzTypq1TAwC69/zxgZN8dfryjAic/HzNTvTOynut1dP9gmP2HeJ0PgFQ2qUu4jtLHZau/7ulUH12mP8lj497Ht+ANCLJ893SIV5bYfgY623pi6lD/JPSW7VHl8OXoxPsWMxjJHHiLVzfDiNahmJNdw7f/dLgMEQ8H4SjLf81KYb46L1NtA6GN0d5Zc5HQi+d47clE/0tfByofDmdekxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB5832.namprd15.prod.outlook.com (2603:10b6:510:290::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 20:14:50 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 20:14:50 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "idryomov@gmail.com" <idryomov@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Thread-Topic: [EXTERNAL] Re: [RFC] sparse read failure in fscrypt-encrypted
 directories for Ceph msgr2 protocol
Thread-Index: AQHcT1iD2xW6Ex0ggEGqemAWsgirprTnDUmAgACaXQA=
Date: Fri, 7 Nov 2025 20:14:50 +0000
Message-ID: <b75514dd0ce612972e1b167592a28588cd93b957.camel@ibm.com>
References: <dfc5c18d506d6183d1c3940dc819616dd24988b5.camel@ibm.com>
	 <CAOi1vP_dh+SgsD7qeWgrrFsyG+-wtrzXJtatF+9pZ6qj_uRZmg@mail.gmail.com>
In-Reply-To:
 <CAOi1vP_dh+SgsD7qeWgrrFsyG+-wtrzXJtatF+9pZ6qj_uRZmg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB5832:EE_
x-ms-office365-filtering-correlation-id: 8cca1e6c-5b9d-49a3-1799-08de1e3a4e94
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bHg3SHozSVhUWThWNTRHRE1CNWFPaHcvb0NvbDJtRHcvMEFuS0w3ZUl6Rm9F?=
 =?utf-8?B?cjM5Sm5hMkRGTURkamwyLzhNWW5GaVNKc2FaSGhIZDkwMklwWW9jMCtMU1hU?=
 =?utf-8?B?TmlqUlFkYmRYZ1JaOHZ3bEtoeEprMEI2b1daa1FTU2hBL1d5RCtQMWhxM3Fr?=
 =?utf-8?B?c3k1R2xRSHNyQXczb3pJNWpMOUZhV05YRFo4SmRhQ0pPSDVjeU0xU2tFQSs0?=
 =?utf-8?B?cHR6a0ZCVzVVbDZDZ3g3dXFjWUo1NFN4TU9Ob1ZLMHhzSC9tTU1nUyt3Z0ha?=
 =?utf-8?B?RmNFdFpLcnY0bWRPM0tBdjNmdzJLUEczSERPZnlOVnpGamJ0QmpFRnRmODA2?=
 =?utf-8?B?TVE1eitxeENtNVc1M2w2b21mYmxMYVB5UGRTMGs4LzNuUVhTa2x1Z3g4VVg1?=
 =?utf-8?B?UDVVcVQ5QU4yZzhSMXdmYTQycUxlSW1FWTJzeDNBdjltb2swQXBJU0Z1Y3M0?=
 =?utf-8?B?RStZWTFSZlQ5VE1DbjQ5OUdjU2gzcTlEYnhvbFhmWUp5Mm0wZEJuaXlGWndT?=
 =?utf-8?B?Z1d1L0FUK3VCSGlXZTB3a253Y2IzM3FLTmxMaDBPaVkwdVR5YUxJZkNKbEZC?=
 =?utf-8?B?dUppZi83WFZqeGU0K0t4SUpOS21MWFAvWlVHdC95Q09yT3BNeHRaT05CU0Mv?=
 =?utf-8?B?UXArQzVIUHB1M0FiY0dHWUVGUHgwaEpFVStyK2Z4a3ovbnk0aVNiQ3MvSElP?=
 =?utf-8?B?cklXa0pyYWRibTAyQStKSlBGUVpKMlJ0UklLTFVMalg2ZkkrUElTVzUvRkZ6?=
 =?utf-8?B?WlY0aHF2cUkyby9GMXlHRDRpSk9TRHl4ZlVQWXd5dnJGRlQ4b1dtc0JURDN5?=
 =?utf-8?B?aU9ZQXBsVnBuY3dmeldVdHhJUC84YnhrQ2ZFSm5meGNITlJwVHVtdDA1NlU5?=
 =?utf-8?B?SUxMdHA5bTVWdEZtQmlhM1NuNFJOYyswNzFVMXBaUTFtWHRZZ2Q2LzVxWEZt?=
 =?utf-8?B?dStFRWZ1L2JwTGg1SkZVZkhoTlZMQzYwNUwvWlV2b29mRXlJalJYaEdtcGk1?=
 =?utf-8?B?OEhtdm53Nmk0Tjh5bkt6alN4TkVydXNZWjFQUVZJdFI3dVZoNXM5ZTJWQVdB?=
 =?utf-8?B?aFoyakVPbUN3cVdkSHFndzdHK05PeXJseUdBWlNDRGxSMVUyK0ozZ1hOd1VO?=
 =?utf-8?B?VUxkdmNTS1RzNW5lVjBtUmJTTUVhNDh5MlFqWHM4N3FKVnJNYWp4QUlXRzhX?=
 =?utf-8?B?R1RBdHlTNWlzUDJWWUdZeXdVdDllYVpyYW0rMVk2WnNydjZhQkdvR3F1SkZy?=
 =?utf-8?B?bVNyeHpMRWhsa3E5ZUt6V0JQT1NSN0ptOXJ2a2tnYmV2R0U0SFI1SEx6Z1NB?=
 =?utf-8?B?MFcvRzcramx5aXdpNWRnTGJ6UksrKzdCRDlTYjJIaE9wcGVJdkVUS1dGNEp4?=
 =?utf-8?B?eEZob0hhcFZweFRXK0o0c3YyVzFOTzg2QXdMRzJteVBENXVyMTQwbGtpUnRY?=
 =?utf-8?B?VjNpMTgxYWtzanpaRFBsQUNUMExGSHdCVVRyUmw3VDM3Q1g3MnNmY0hxbE1Q?=
 =?utf-8?B?aHlRTE9sMHVmSkR4NXh5bU1tVlBqVlF5M0FXeWpMamh5NjZXTDhXSFpGNzhU?=
 =?utf-8?B?anhQUTk1cXVXSk5TNEtVYVJWdzJiWTIxWUhBVGJydHJTNWdZZndxNlVGK0Fs?=
 =?utf-8?B?MjJTWjBQQWhzK3RmcW5JOWhjbG9PSzIzdytGZGJPRHpjNmg1ZHNoUXpHekJW?=
 =?utf-8?B?b0lHTlh6VUlGcC9wOWM3ZU11NldFQk0rNjc0WDZWekwxZWFYQ2VnUVgva2tu?=
 =?utf-8?B?TWRyWi9lMDNqdHlZcisvcXJpMk9yVUtxVDZWVVAxUnI4THFlcTdtU1hyQm05?=
 =?utf-8?B?K3kvR1R6L2hXVXltdTRHOHFwTTBtQUFoT2lzMGdEb1A2cHZvZnNIc0pTbW5a?=
 =?utf-8?B?NFhReGd0U2hoaEpyWGc4d0R4eUJ6elFWblRJU29heWprV1BKaWZOeHMyajE3?=
 =?utf-8?B?a0g1QzZiWHAyVElIZWRiOGhJU2VOaDVSRVZUZkZDNWQydkJVL1gvZDdvTENM?=
 =?utf-8?B?ck5Ka1VPSWM5WkVoNUF6bmZ6UHpwVkdHR3lENFVzVWR5em9EOXFkMmRtcDNy?=
 =?utf-8?Q?SNO5Cv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OGxiQ0M4QVV0VWtwYlUwNGFKZzJJRlBqWkp0cUhWRzk0VTMvSDBSOUtUZHlG?=
 =?utf-8?B?cnJLNlZzY2dtQ1NmOEp3MVhHN3BDTGFYSVdQMDQvZEsyWTRMaTJ6Nm94c1ds?=
 =?utf-8?B?NENXNlF4eTRyeE9tTEZ4dDY0cjNYR1lNcG4xdDBtaEllZTdidmU1dHpRY3RP?=
 =?utf-8?B?L2I0ZTJFM3pxL2laY3d1MmZtVXNQNzYxWnJXbEtaTTBkREdCc2Z3bkJyMTdX?=
 =?utf-8?B?L1QwQjVES1VYbUI1U29XRjRnUElORjQwTGNNN2ZXN3VuOTZOS0l0MnlBdDlN?=
 =?utf-8?B?TWNFN01Vc2YxblUwdDlQQ2FXbitnbzZjbFJQTHNaU0RNTmRhZ2pHQUhwbE9Q?=
 =?utf-8?B?SUZYZEwwNCtMSHFkaHZBcmJZaUhqT1Njck5LcmVEWUk3bksvUCsxbTkzWVls?=
 =?utf-8?B?SnQwOTRlZEJKNGg4VStFR2cxREl0NDZtNEx6MmYxOHR3eGp0VVVoRUliUTJU?=
 =?utf-8?B?N2ZSZ3JXaHJFQkZFZWpTVDJENFRTbGYrRUJWZEJNS3QrY2tTb0E1ZTJ6cTJp?=
 =?utf-8?B?S0lCUnlpaWhzQ2tJcHRLN1NTblo1OTBJdExCNnI2Q1ZFOTc3Y3pIVUs2Q3Rx?=
 =?utf-8?B?cFJjZ0tYSk83NlRPbGx3V0g1dDQ0bGx6aXgyZHp6czFzTVdOMVNQdklIVytD?=
 =?utf-8?B?dEhCSDhDVlZJaHNhSDcyU1QxS0MvbEtlUW52VU1tTzcyNnFCUkJnUTdnbDM3?=
 =?utf-8?B?a1Y2cllzaGpDRjJvaDQwckc5dTlrRHh5MjlRT3JuNmhISE9VWmlqRndlUW8w?=
 =?utf-8?B?bWwxNnBPUlBJbTVhcWp3YkJDeS9JMjVYT051QnhKR1A1SDJYTXRNMEM3bFhn?=
 =?utf-8?B?dGs5eTJzcVA0eUVOMnZWKzBEdlI3SXpjUys3MXkxb1dxMW1rS3RJMCtNREFj?=
 =?utf-8?B?dDdTTm9QTFFiekkxSjA5dWY2L1pvNVIrK2UrMGZWUDBkUzJNTzRvZXpCcVdP?=
 =?utf-8?B?ZGR0dVlVclBhd0lsV3YyQm9BY2xwREhxSHk5aVR2ekRRZUNRN3FkQmxTWmpV?=
 =?utf-8?B?ZTFVQ0pvNm80MHpFTGsyZllTUnNZd250clZPTm1PTHBteTQ5V2ZtVHU4MjI4?=
 =?utf-8?B?dGVwa2pBVFl4WWNoenNpTnVpQktEMkhhRXVVNHNUQ29kTkJ6emw0TWhHSTVu?=
 =?utf-8?B?bFRhbUl2TkJieXlrcDIybmtyYnk2R1NVOXBMd25IdkNjT2VOYUExNm5nRzkz?=
 =?utf-8?B?cnNFVEVkdUJNNDZ0TWg3VjJZbTBZUERvaGRFUVUxdzZrNVk2ejBNWkZFOGI1?=
 =?utf-8?B?UXgrQmxtNy85dFAwcDJ2ekFBYmdRRnNEN3R3eHR0N25OczFGMTlURjFSRm83?=
 =?utf-8?B?OTZZVmhzZWtabW9qUHhMbGtrdjJYbXNCUDlmZHhSUTdUWExJU251Y2FnOG1G?=
 =?utf-8?B?WXVDSFdSVkhjdW1DNXUxNFIxaFhuMnZ0NUNMTlFJRFJLNnB2dXJaT2xoUm9K?=
 =?utf-8?B?WHpaNkFFYTVOQ29OM2pNc01JL1ZCUUJ6bStPcjczVVRaSFA0bTJSWHBkakdZ?=
 =?utf-8?B?YmU4RitxNnU4amVHejg5SE0wcDNkd2RkVzI3UkhSekp6N3JNZi9RZEovMnhy?=
 =?utf-8?B?bUg1TGt2emJmdGRZNUxKWjI3eXIwL2huNitrRy82dnM3TVhCajIwaGJVYjNw?=
 =?utf-8?B?SjZ2N0I2cldJZy9kYnkwWnVQT0N3d1BoQVRUTU1mdjF5ZEloRXNoZm5ub1Yx?=
 =?utf-8?B?R1UxZEtmT004V1ZDcXNORm5XK1BLSmNkdlpYZDN3Vy9pbDhFaHNtcUJxRUJJ?=
 =?utf-8?B?cWZIdlliR3VieFY0andGaVVDTjBtNUNGL3R0TFJrK1pSRDNTVDJFdTlZVGNW?=
 =?utf-8?B?d0ZlcXRhVXRBd0MrSHlLdDRyNEFVMjNtV055cFZFanU0a1NtK1piVjhyOFFM?=
 =?utf-8?B?SHdLVk1wUDJpbVEzdk0yYlNJWjRxbmdQUTR1ZVdCNDczdnMrckVDbDRQeHEx?=
 =?utf-8?B?RldIOEJidmhiWFhhUjZLblVjVC9uWmZ5dnJ0SHY3SE56aUZOVmpMOWNvSHpO?=
 =?utf-8?B?U1pWV0I4eUFYVEdKRUp3emxWTXAybTdId0RJMWpTVXNJcmhVYjlVeUx4YXFB?=
 =?utf-8?B?cUk1K0czWnc3T3Q3QjNHK0VNcWJJanRrYlpPN1pwQkJodlpPYkxnWktaK1R3?=
 =?utf-8?B?Y29QNk1USnFSejAraEwxd2tVTmg4RFI4L3pIZDdLbzI3RWNDRkwwQzhnVjBa?=
 =?utf-8?Q?PpU6RfyElKHJoYFzqlR0JZE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9AAEC3A594A7A40BB0A3B1AC633E7EB@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cca1e6c-5b9d-49a3-1799-08de1e3a4e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2025 20:14:50.7754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbWPEb57e1dR/HnfnyYq7+2sZztuqIZWgLL+8+1EKj0MK8wRIZzi7wiZibnRm/DkT03dN6RfIdQULBJ4NqiaVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5832
X-Authority-Analysis: v=2.4 cv=BZvVE7t2 c=1 sm=1 tr=0 ts=690e533d cx=c_pps
 a=WNBGq+kRZA72juK154DUDw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=75ZE2hV1nCwvtcpqmYkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA3MDEyMiBTYWx0ZWRfX0Ym7FhBsgbOe
 aEs9Z4CowMG8rvLNRlEmDLm13yhTkWAA5VBKWcso65djNdg68kTktchm32JmDtaUxgX3motMFz9
 Boi5ttuC7e1ftO4ocCgb2j2AXjyDrRES1eXlgbd7JUPa0kXJnnduugbx+nHepQpLOZNW/VFe+mC
 SjWCUWkmqBXnZG4TyHZ74ukg6O3D6g23yea2JAHalJeLI/OvBOjLu0k4Xruz7fn6HOIW+cLuH0q
 WnXUxS2sd7OWcwh6DHsjdTpUx4kdaOcnlwyq0DAirniXzkrU3Lci+9GaST/YX++ga/ic3agyRIl
 R2qf6HJeZz4xjC1t37fah7h3lZ2OgYFxOhuf/j0wFoWhYxIFD43iKrVS2tNETkpho11qcnsCj4B
 UgTROyW0LU6ee2kogGUVRbToWH8Dow==
X-Proofpoint-GUID: _-y0K7oHZyCKeCM2aSmhTu7ueP_zgk3p
X-Proofpoint-ORIG-GUID: 9cKcWy5CemGTojpdW9LzdJc2t0kilJ0d
Subject: RE: [RFC] sparse read failure in fscrypt-encrypted directories for
 Ceph msgr2 protocol
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_06,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511070122

T24gRnJpLCAyMDI1LTExLTA3IGF0IDEyOjAyICswMTAwLCBJbHlhIERyeW9tb3Ygd3JvdGU6DQo+
IE9uIFRodSwgTm92IDYsIDIwMjUgYXQgOTowNOKAr1BNIFZpYWNoZXNsYXYgRHViZXlrbyA8U2xh
dmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiANCj4gPiANCg0KPHNraXBwZWQ+DQoNCj4g
PiANCj4gPiBTbywgd2hlcmUgY291bGQgYmUgdGhlIHByb3BlciBwbGFjZSBvZiBjYWxsaW5nIGNl
cGhfbXNnX2RhdGFfY3Vyc29yX2luaXQoKSBmb3INCj4gPiB0aGUgY2FzZSBvZiBDZXBoIG1zZ3Iy
IHByb3RvY29sPw0KPiA+IA0KPiA+IEkgdHJpZWQgdG8gY29uc2lkZXIgdGhlIHNldHVwX21lc3Nh
Z2Vfc2dzKCkgYnV0IGl0IGRvZXNuJ3Qgd29yay4gV2hhdCBjb3VsZCBiZQ0KPiA+IHRoZSBwcm9w
ZXIgc29sdXRpb24gb2YgdGhpcyBpc3N1ZT8gTWF5YmUsIEkgYW0gbWlzdW5kZXJzdGFuZGluZyB0
aGUgbG9naWMgb2YNCj4gPiBDZXBoIG1zZ3IyIHByb3RvY29sIGJ1dCBnZXRfYnZlY19hdCgpIGFu
ZCBjZXBoX21zZ19kYXRhX2FkdmFuY2UoKSBleHBlY3QgdG8gaGF2ZQ0KPiA+IHRoZSBpbml0aWFs
aXplZCBjdXJzb3IuDQo+IA0KPiBIaSBTbGF2YSwNCj4gDQo+IFllcywgdGhleSBkby4NCj4gDQo+
IEJhc2VkIG9uIGEgcXVpY2sgbG9vaywgSSdkIGV4cGVjdCB0aGUgY3Vyc29yIHRvIGJlIGluaXRp
YWxpemVkIGF0IHRoZQ0KPiB0b3Agb2YgcHJvY2Vzc192Ml9zcGFyc2VfcmVhZCgpLCBiZWZvcmUg
dGhlIGZvciBsb29wLiAgS2VlcCBpbiBtaW5kDQo+IHRoYXQgdGhlIGluaXRpYWwgc3VibWlzc2lv
biBmb3Igc3BhcnNlIHJlYWQgc3VwcG9ydCBkaWRuJ3QgZ28gdGhyb3VnaA0KPiBtZSBzbyBJIHdv
dWxkbid0IG5lY2Vzc2FyaWx5IGtub3cgd2hhdCB0aGUgInByb3BlciIgcGxhY2UgaXMgdGhvdWdo
Lg0KPiANCj4gDQoNCkkgc2VlLiA6KSBObyBwcm9ibGVtLg0KDQpZZWFoLCBtYXliZSwgcHJvY2Vz
c192Ml9zcGFyc2VfcmVhZCgpIGNvdWxkIGJlIGEgc3VjaCBwbGFjZS4gTGV0IG1lIHRyeS4gU28s
IEkNCm5lZWQgdG8gZGl2ZSBkZWVwZXIgaW4gdGhlIGNvZGUuIDopDQoNClRoYW5rcywNClNsYXZh
Lg0K

