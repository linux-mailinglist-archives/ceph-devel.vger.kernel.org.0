Return-Path: <ceph-devel+bounces-4116-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E985C8C571
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Nov 2025 00:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CA89A4E194F
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Nov 2025 23:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A2E304BDC;
	Wed, 26 Nov 2025 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PFfYJTFq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C899B21B9F5
	for <ceph-devel@vger.kernel.org>; Wed, 26 Nov 2025 23:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764199240; cv=fail; b=PzjPdMh8BFaWU6ps6rN4wnOHqAs90UrL/Gkv3lJfTdOQHSJDKHhpA6HVd584a0wrRBU3Vt81F0/aDT6JsyNy546+YXkNq0R1m2KSlHuzS5w0bBIm5AfyUgDC6IkJeV5dVesCcXdqJxm+Y1OjYtll0h7jVDg8OQrJC9M3vQ1a4R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764199240; c=relaxed/simple;
	bh=kvyAeSE4ByL6214+0AEOxeLivkh9gDYYk8i1JnGGXwE=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=O+hgjBv+s1wOPrIFxFVe0V+Ik96y71aN2aWCTX6liYXeJNTrItKZEb4+NQ9hZqmiAUgsZ+D6GtngIfny/o0QQO7MyfmgOM2GBmCdvT0Ze1jCBMxmhnuF9PP+EMMREbYLf1wJPyPIHHV+NlALpFJpnbxLzbbDBJ/NKr8SDxGc02U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PFfYJTFq; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQDT623013505
	for <ceph-devel@vger.kernel.org>; Wed, 26 Nov 2025 23:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=kvyAeSE4ByL6214+0AEOxeLivkh9gDYYk8i1JnGGXwE=; b=PFfYJTFq
	SbddSJ66ClaAx726ODnUzl2jCjmDrzNLwm5A3O+bc+XhMnIbRPgEFcI9zO6saBsn
	6FL/kmv6fBJQYVTLLNcCvCDPbv98iAtGQbIyf54ZaEtzlvyqXknT0wYRj+r9y6CB
	zCvXiJGLl2fHdOrtK7lZRB+ka4BX1QvFW/Y62TUoXnU6c5xmm3+LxOwf1F6o/rqb
	NBVJ1zsoQQNd6JbrbNkLxCx+EgabI9qTIqiKmlAf8biYyiCihrBCMKBhMsR9n6sB
	RqFl295yB3VoeqLmNOwxZMVFwpy73PKYFEd4Lq4pl0uu+ZKeAWu+yFC+TXRXw0MZ
	g42YO+zgXQXfow==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvet66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Wed, 26 Nov 2025 23:20:37 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AQNHwQc019244
	for <ceph-devel@vger.kernel.org>; Wed, 26 Nov 2025 23:20:37 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvet63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 23:20:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsnTSUyGmGfwAZsrEjwze5W6rSgYCwTa7tOdFdadothmHZmottg5Q5zYlNJSIVKxXHrBllMcmHBy6xtrPPRdpWScV8XUaf6w6kjKa4JJt1eSctoiEJuYMb5AGnfWFWLaF+5ROnIOKMotXJj+Q1xCdHV+EVN42+urLRq5KBjqtVXjFVmg1SN/0IPaILzC5wBR37angPMfpEXLmfrxOBfX0X1FWVwIJgsU4HMdb0ppkwa//SraVp01S2jsM/1oyYvwB2cuq7OFK5sorzLzhzv9BH9dQ2x8tUram/LkQN3jbuszKGkuCWvPez7PMTh/vc1YD5u+TSH0zb/y68KfH6yWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvyAeSE4ByL6214+0AEOxeLivkh9gDYYk8i1JnGGXwE=;
 b=TqfKPPtenVOrzvj3rnWJ1aCFdcKWDlu3q1htiRhu9A1O64RXlu1+D8xA3RYxPEWYiSwid2eLduTNw/Vjj+FRzTCwJAt3SmzxJaPUamPoug+jDB8Tqr183NH+gsHWxHFs8wcoPwEAkneJ6Amw5hY4inzfg2z6RHXlNC1PS4jt2J38V7IYCXRIzR7GNOlje1X/hgzV+Q2/zp/tjK5bHpXGViu5l4uE2dtu1tgUo86MyHfr8GXWww15/odLLEzGznN3DPeDeeWdFWTeKEunD/w8CjZubPiz3YE5UlXu4dlCEJD66PkVbQIypq77fg8omIiEIaEBHublu9mUbSTcclKYgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB5090.namprd15.prod.outlook.com (2603:10b6:a03:3cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 23:20:34 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 23:20:34 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "nix155nix@gmail.com" <nix155nix@gmail.com>
Thread-Topic: [EXTERNAL] [REGRESSION] CephFS kernel client crash (NULL deref
 in strcmp) since Linux 6.17.8
Thread-Index: AQHcXyncmN4ff3am6E6iAs6swpOooLUFmDMA
Date: Wed, 26 Nov 2025 23:20:34 +0000
Message-ID: <cd9c2249b7af5ce848a49c16427e8ac734cbaf60.camel@ibm.com>
References:
 <CABS1u1D4WLBvW_wKsGjtDZgdHMDSAGir4hQ4UwtZPn5SOZ3DvA@mail.gmail.com>
In-Reply-To:
 <CABS1u1D4WLBvW_wKsGjtDZgdHMDSAGir4hQ4UwtZPn5SOZ3DvA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB5090:EE_
x-ms-office365-filtering-correlation-id: 126b9adf-d72a-4ec2-12e6-08de2d4266b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WjVLcHE0Q21yNnRhd3JVQW1DSllXc1dWcXI5bWZDMDdiK29mVnBVdmc3VkVF?=
 =?utf-8?B?elVNeTlyWXVxMGJJYjdrTkFBVmFrUk9HZ2k1RlhKNUpQUlJRWGFNeXQyaDhk?=
 =?utf-8?B?bHNtY0ZuaWZyODlBUU1BYlN3QW9JSGpJOFF3WG83SndBejJ5OWdWa0VNWW9Z?=
 =?utf-8?B?VSsvMmVxWjFsZGxQeWJpdnJzb1hjSGdrNlNPVDJFSGtBZ284eTAzVnJQZHFG?=
 =?utf-8?B?c0JVdFJkdy9PMW16Y2FYOVZ3MVprUlA4Rm1PWHRjQjFFSFhBc1NJMkkrTC9o?=
 =?utf-8?B?MWpjSVRETllmUk9kNUtEYytBNkR2TEhYMVVIZnp0aGZFeGdVaXMwaGZDVVA2?=
 =?utf-8?B?aUp2ZnVkak1raThmMXJLZURmd2RTYzNVUWdHTWtOdmFPRG54Vm8xa1dXOXFn?=
 =?utf-8?B?L2Vsamd4WFJlc1VBQXVnUUpnTDhZTUZhTzl2QUF1TFV6OVVOK1NjV28zRjE2?=
 =?utf-8?B?UDlpQmdIQjNJTjlZZnduZTY1RmRGcmR4R3ExL2ZyYWhIWVZqT2Z6UzRteDN0?=
 =?utf-8?B?ZVIzbFV6c1pHRmtpcGRRZUVMa0dISlE1eWcwYURiT0NoelFxMnJlOCtxaXFx?=
 =?utf-8?B?dU1iOWVDNks3Rk5EV0tMb3BObnJGdXIrN2tNcGVwSEkrOWZ0TFBMQWZQMnd5?=
 =?utf-8?B?QmtkVmpIMkgwMWxZcmV2MmRqQnJsN1J5eTRrZlp6c3lKVmMybk5mbXM2Z1VG?=
 =?utf-8?B?RUdhMHRoV2FGZGxaeTNxOXc5Tk5KQkdXYWo2dnl0ZVE5b05nU3laak9teE9n?=
 =?utf-8?B?K0labmwzdjRnNXo2TGNmeWpaRWtPNG5EeUxEK283L2hBanhaaXkyNE1IZEho?=
 =?utf-8?B?bm1NZ1BUNzZqQVJwRW9NbjIzQzNDcFp5bmQ4RFpKejF3RUFFMThiUkhhVmFa?=
 =?utf-8?B?aVg0SHNEUS8yd2c2K0JGRGJ1azlyOHZZbU5ad0FwaU1iUHVyRUV2cS80ZlBm?=
 =?utf-8?B?VkpXZS9oNEZlQ1R2elc5UjlOanl5UEZnYytkRm4wUjJtSnhjUStkc25BRjN5?=
 =?utf-8?B?NnZ5dGNoOTh6dWlIdDVhODJyWWs5VnBMYVJ2aWs0dUJPeTBndVpIRkMrMUtT?=
 =?utf-8?B?ekhPL3hJamU2SytpSkFBQU9BajVSWVJsVjVPWkZxWEhhNFdWc1piVXRjQUhJ?=
 =?utf-8?B?NndPSVRsbE5FNG83Sit3dXVTZVVuMXFwTjRncHdkaDhXRlVmYzBaTzJvOStC?=
 =?utf-8?B?RVpUbktWRElIOXZRbDlBeUd6b0RVd01CcWJ2Y0liUWtiM0lUWlVtRnUweGc3?=
 =?utf-8?B?aHNncG9nbVN2ZE5oTUFhOXBWU0l2OUNLbCsvVzJ0K0M2dzV6dE83K3NkZngr?=
 =?utf-8?B?cHFKZ1QvbklXZEJsb2xzdDN2Vnhac1krQW9QemhjazhWd1hDcUtQZ0tPaTJ0?=
 =?utf-8?B?Qkt5cVp5dTZWM1hqSDh0S0ZtVGlPMlVJNmUvM29mQVgzYmZnTkN3NUdhS2Fl?=
 =?utf-8?B?REtKWVlRNW8xcXlBOS9rakN4cjZqOWkwaWVTVDI4TGRFLzVMT2xXbEhPc3Vk?=
 =?utf-8?B?S3FhTXppNmQyZTlTeU9rMnlyUFNTRUFIc1FGNGJGYkNJMjRhS3RsVkhaUjV6?=
 =?utf-8?B?K2lYTGhvQ2VVWE1KQVdBRXFCV0lCVG1KVlp4L25PL1dEOHRkOXJZcHhHV291?=
 =?utf-8?B?MklSSEhwUHVMUVhaSkNjdTl1RmVTRDYrYjFnYXd2YndlS3pqU3VNb1oraG0r?=
 =?utf-8?B?RmV1c3ZPZ3NDZ2dIUkhPZnZvcmJucmIvOHZSWitIWUI5QkdKYThiUkJYYkRa?=
 =?utf-8?B?MDg3S3RET1RsUnZPRVBkTWpEZWFub2VRZ2lTdUVqNDlrNDlFSWdocnY2MlhW?=
 =?utf-8?B?a2xCc054TTNxa1VaNU55S09sMFgwN1JqbDlGbnhiWnpNRW4ySldUcGZnQ2hO?=
 =?utf-8?B?RFAyUlRmL2VZdTFMVnIrTEJXL1FxbHRjbHBlVS95VnRVcmJ5OTVNWk13UlpV?=
 =?utf-8?B?THBMam04ajJsbXR6bVRiK3BwMERKdlBUZDNBQ0tLdFJUeEZHcC9pcnBsNXIy?=
 =?utf-8?B?ZCtMQ0h2dk9YeGFkeHk1SGVlbHZ6Wnl4cEprR3hIbDErSzdWUnBxOTU2cElN?=
 =?utf-8?Q?KyAIrg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MDhSV0Q4N0JtNVlTT05LM2h6SXIvZCtiNmlsWTVzUnZSMjFjRStNbHB3K0pn?=
 =?utf-8?B?MkdSaVlMS2JLU0xTNmliY3FtbWFSNmVEcmdscEhvb05TcktIZVpvN0oyZEZD?=
 =?utf-8?B?ZnhTZTZWZEpzUVlOTThWTm16NGM0djhKeU1MMDRGZG5GOG9DUmo3VlY1L3lF?=
 =?utf-8?B?UTFSUFRkNUFycVZGOEgzQnZScEFzL3VVNGtIMjYyWmdwZVVmeTE5VWFTV0Vk?=
 =?utf-8?B?ekY1YTZXbXRvMExTcmR2UTAwSXc3dy9VZnM4WnlpM1NzK3JsSWhoUFl2T3M0?=
 =?utf-8?B?VFBnc1Q0MUJiZHh1WWRlcERxZFdDYWxUdm1Tc0d1YlNaODR2RzZjZWp6VFJQ?=
 =?utf-8?B?Lzgxbk9GNkpRWjY1VkdjaUF6b3hPN3ZmTkFyM1pQZlgwbmFEWllJLzM0Vkg0?=
 =?utf-8?B?WTg0R1ZJbU1vOGxlcHhFWDdBMjkvZjhOMk9vaThuTHBZdS9UQlBIcGZIR3Mv?=
 =?utf-8?B?NnR3TEdNV3F1dkRHVERnd3R1T3RsZ29Vc2UxeWNRc2xZbnlLV0VvdGNzWTR0?=
 =?utf-8?B?RUlwK0dxL2hJYjVpemFueTRnemZSK1M1R2VGNGM2NUpnOTh4M0NWQXNsYXlF?=
 =?utf-8?B?eWw3U0tFSjkyaWw3Z0hGd2w5T0gzRXliU0tJeFkxb3NtcW11NkZNRDh4cFg2?=
 =?utf-8?B?STM5R3lFcHpDN0JzenJBdE0zUVVQQzQ4dzlhWjQ0emNCVGdSWUlkYzArTTVz?=
 =?utf-8?B?U0ZGL0laMlhmS1RLR2E4dWhERlh1b2k2VjgzWUVoYVZNRGlGMVhTMk4xSnZ1?=
 =?utf-8?B?TFpyNktaZWtNakV1ckdWWG1FeHkwKzdEcDNodmdhVmJVdis3VDIySGlyalNx?=
 =?utf-8?B?VkQ1WUR4WEhLbTVwUTZmbkgvTUNwM3UyL2lWMDBOV2tYeVBNaHp0dy9ZY2E5?=
 =?utf-8?B?d3hYUmVFNzZtb25ZUWtPYnkxT3paL2hkU2dzWTk4dVRwVG9tblNobXA5T21p?=
 =?utf-8?B?N2IzMitrZGpEaHlyMXRBdDNMNzA0eXVSNnAvQ3o3MFJqK2ZRQnJkeXl3RzFy?=
 =?utf-8?B?NFFEb0o5cmRzOFJLM0lWaDc1SG9RbzdVL1RqTy9POTdxdEx6cWdGQ0ZabGFX?=
 =?utf-8?B?Y0h1VVhleTFhcS83cUdUQnJoLzFBQjNoVnhlemE3Kzltbm80TXoyU0JuSVVJ?=
 =?utf-8?B?RGQxbFVkZXp2RjQ0UWt2dG1WTzFQMEhHaURiZmM4OVFiWkF5czQ1RnI0Z1Ix?=
 =?utf-8?B?MVFPNDQ0OUhpOTFpUWVPUnFvdGlyZmJhU21mSFhGZlFJUWFsNEV6N0cvKzgy?=
 =?utf-8?B?VTlIK1I5SkdHZzZkckw5S3RxUFhyQWk0bmtuYXFjVTZoUWlMSTlmanAwdThp?=
 =?utf-8?B?MjMrMGNYVkxNc000cFVHa1paM3hKdDdhN29EdUgyWEcycXBlb1RaOCt1V3pL?=
 =?utf-8?B?a3NLeW5MaE1xZU41a1o0ME1VcDZPK2xKRTlkU21YcHhMYjNtY1pvKzRjSG5v?=
 =?utf-8?B?MTIwNlVqL3VUaFpTR25KZlQ4NFp4WEZuTVpCQi9NcEU3eDNuK2xsdWlEZXQv?=
 =?utf-8?B?UU9DMTlNL1I0aGgvNHRnbmJURFN1ekFLb2Q3UTIrTm90MlJwOCttbDNDZ0hH?=
 =?utf-8?B?ODFxSVNSQUdUU0lpTFpGWG91TFQrcXFNOUZoblFDbkowM3NiOTlJWm5BTndp?=
 =?utf-8?B?WXdJU2hYZ0M0YkZ2VHBwcUV5ZHRnbUVKTWFUZVlYUk1xZ0pTQTBJeHFkVERZ?=
 =?utf-8?B?dFM4amc1NFRFaWo0dTcyMzk0TE04ZlJSektKUklYTVllV3R5dnFPNE9GTHRi?=
 =?utf-8?B?Y2NSM2NkTElCQjhjMFhMYTBqZFFLZ2ZXRllLbkpsQTNjYmp2QnhyK1JGamVU?=
 =?utf-8?B?elJqblE1ZVdITkR1ekJ6MHVpRjUvR2J2QnIvLzNOZ3lYK1ozSTVyMHpwZ1Zi?=
 =?utf-8?B?Q2lkUjg2bVVIcFJRUTE0RlZ4WHVXMWo5ZTdTekVGQ2crVllXYjRkbzJyaXJB?=
 =?utf-8?B?cTFodUJOQllldE5hKzgzYkpPbmQ3MmhwWXQ1NlFMdmh4K2pUcmNrTzVBSzZ0?=
 =?utf-8?B?MTJUbHRsWElqRVd0TkNadGdGYTZ1cURSS3lSQmoyeFJ2L0NmU1p5c21OT2dl?=
 =?utf-8?B?M296Um9Rd3hNYVlMNVF1Y2QyTzVlRHhGdFFBQVYwY09CWFQwaDhCOUk4ekNP?=
 =?utf-8?B?NVlQcmY5cWcwMERvL3kxYU95MEpJbS92ZlRmVmQvRlpXT3FqbGo5Y3QrbUlz?=
 =?utf-8?Q?tApSV9fBmk2M2xSAhrpJncU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A57FCF6757DCBF41B4DF327A873A16F6@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 126b9adf-d72a-4ec2-12e6-08de2d4266b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 23:20:34.7093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mw2IqA5dBjyt2F73qjOF+magEtFGZ4jj1Yo4CJGMxLHEw4qZHTIBRFywjVlkNYw7AimhkQwYS5wKtXtyM2SaCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB5090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX1liZC8pFmy6n
 luI3XK2mcmdDZDlVjMlUztT8yLGACShdJMhbf3F+TVWejz7LaamaG3LaA8xBE/96j+eLSbkIMvD
 AtqskUoSacSpv6BT+MD6RtVDGUwL1oTKTH8mAySQ/dL7z+ZJlw3aLMy7qg9ozElqUdzy9cUbcCi
 HbXb3HuqGpwSg2R2neZp9LHvGfNKk5lWk7tatf4rTEL1E7/kGXQlhw2l3NhddJXSHxsdONTetvx
 4g6NE1jRHS/4I3qy4xHmL46Gxnz3pHK2lYEBH2tyvuPmdo/4ppMtnpsAr8qRD1FudMFUYjFPAqg
 eMrpnLkBqPYzEiznLNFz9/JBinXBd8XWFhRWZr2u3+Egyy9nmrVHQ8sdr4EjUhW0P3XDzlJHq72
 t9turl9zGbtbXpcTltIRTDgvKZFlpw==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=69278b45 cx=c_pps
 a=Kwamffe9LshCGz4O85X6AQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=52MWdPDyZX4rvDe_Ik0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 3X5yJQdLy3kVTOCXxOO0kMxmhhuPP42H
X-Proofpoint-GUID: f10YFbWLbUuIg_OpgLJu564m5C8NCrM-
Subject: Re:  [REGRESSION] CephFS kernel client crash (NULL deref in strcmp)
 since Linux 6.17.8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

T24gVGh1LCAyMDI1LTExLTI3IGF0IDAyOjEwICswMzAwLCDQo9C+0LvRgtC10YAg0J4n0JTQuNC8
IHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBJIHdvdWxkIGxpa2UgdG8gcmVwb3J0IGEgcmVncmVz
c2lvbiBpbiB0aGUgaW4ta2VybmVsIENlcGhGUyBjbGllbnQgd2hpY2gNCj4gYXBwZWFyZWQgYmV0
d2VlbiBMaW51eCA2LjE3LjcgYW5kIDYuMTcuOC4gVGhlIGlzc3VlIGlzIGZ1bGx5DQo+IHJlcHJv
ZHVjaWJsZSBvbiBteSBoYXJkd2FyZSBhbmQgY29tcGxldGVseSBwcmV2ZW50cyBhY2Nlc3Npbmcg
Q2VwaEZTLg0KPiANCj4gVGhlIHNhbWUgQ2VwaEZTIGNsdXN0ZXIgd29ya3MgZmluZSBmcm9tIFVi
dW50dSBhbmQgRGViaWFuIGtlcm5lbA0KPiBjbGllbnRzLCBzbyB0aGlzIGFwcGVhcnMgdG8gYmUg
YSBrZXJuZWwgcmVncmVzc2lvbiBpbiB0aGUgQ2VwaCBjbGllbnQNCj4gY29kZXBhdGguDQo+IA0K
PiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0N
Cj4gU3VtbWFyeQ0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0NCj4gDQo+IFN0YXJ0aW5nIHdpdGggTGludXggNi4xNy44LCBydW5uaW5nIGBs
cyAvbW50L2NlcGhmc2AgdHJpZ2dlcnMgYW4NCj4gaW1tZWRpYXRlIGtlcm5lbCBjcmFzaCAoTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGluIHN0cmNtcCksIGluc2lkZToNCj4gDQo+IMKgIMKgIGNl
cGhfbWRzX2NoZWNrX2FjY2VzcygpDQo+IMKgIMKgIGNlcGhfb3BlbigpDQo+IA0KPiBDZXBoRlMg
YmVjb21lcyB1bnVzYWJsZTogYW55IGF0dGVtcHQgdG8gb3BlbiBmaWxlcyBvciBkaXJlY3Rvcmll
cyBvbiB0aGUNCj4gbW91bnQga2lsbHMgdGhlIGNhbGxpbmcgcHJvY2Vzcy4NCj4gDQo+IFJvbGxp
bmcgYmFjayB0byA2LjE3LjcgZml4ZXMgdGhlIGlzc3VlIGNvbXBsZXRlbHkuDQo+IA0KPiA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gRW52
aXJvbm1lbnQNCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09DQo+IA0KPiBEaXN0cm86IEFyY2ggTGludXggKHJvbGxpbmcpDQo+IEtlcm5lbCAo
YmFkKTogNi4xNy44LmFyY2gxLTENCj4gS2VybmVsIChnb29kKTogNi4xNy43LmFyY2gxLTENCj4g
QXJjaGl0ZWN0dXJlOiB4ODZfNjQNCj4gDQo+IEhhcmR3YXJlOg0KPiDCoCBEZWxsIExhdGl0dWRl
IDc0OTANCj4gwqAgQklPUyAxLjM5LjAgKDIwMjQtMDctMDQpDQo+IA0KPiBDZXBoIG1vZHVsZXM6
DQo+IMKgIGNlcGgua28gwqAgc3JjdmVyc2lvbiA4QTkwREE3QkQ3MTE1OTkzQjdEOTFDNQ0KPiDC
oCBsaWJjZXBoLmtvIHNyY3ZlcnNpb24gNDUxQ0U4QTkyRkVBNzYyNTQxOTQ2MkMNCj4gDQo+IENl
cGhGUyBtb3VudDoNCj4gwqAgMTcyLjI3LjAuNzE6Njc4OSwxNzIuMjcuMS41MTo2Nzg5LDE3Mi4y
Ny41LjI1OjY3ODk6LyAvbW50L2NlcGhmcw0KPiDCoCDCoCAtdCBjZXBoDQo+IMKgIMKgIC1vIG5h
bWU9Y2VwaGZzLHNlY3JldD3igKYsbm9hdGltZSxfbmV0ZGV2LHgtc3lzdGVtZC5hdXRvbW91bnQN
Cj4gDQo+IFRoZSBzYW1lIGNsdXN0ZXIgYW5kIHNhbWUgTU9OL01EUyBhcmUgdXNlZCBieSBvdGhl
ciBjbGllbnRzIHdpdGhvdXQgaXNzdWVzLg0KPiANCj4gPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IFJlZ3Jlc3Npb24gd2luZG93DQo+ID09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiAN
Cj4gTGFzdCBrbm93biBnb29kOiA2LjE3LjcNCj4gRmlyc3QgYmFkOiDCoCDCoCDCoCA2LjE3LjgN
Cj4gQWxzbyBiYWQ6IMKgIMKgIMKgIMKgNi4xNy45DQo+IEFsc28gYWZmZWN0ZWQ6IMKgIGxpbnV4
LWx0cyA2LjEyLnggb24gQXJjaCAodGVzdGVkLCBzYW1lIGNyYXNoKQ0KPiANCj4gPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IFJlcHJvZHVj
ZXINCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09DQo+IA0KPiAxLiBCb290IGtlcm5lbCA2LjE3Ljggb3IgbGF0ZXIgb24gdGhpcyBtYWNoaW5l
Lg0KPiAyLiBNb3VudCBDZXBoRlMuDQo+IDMuIFJ1bjoNCj4gDQo+IMKgIMKgbHMgL21udC9jZXBo
ZnMNCj4gDQo+IDQuIEtlcm5lbCBpbW1lZGlhdGVseSBCVUdzIChOVUxMIGRlcmVmZXJlbmNlKSwg
dGhlIHByb2Nlc3MgaXMga2lsbGVkLg0KPiANCj4gVGhpcyBpcyAxMDAlIHJlcHJvZHVjaWJsZS4N
Cj4gDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQ0KPiBDcmFzaCBleGNlcnB0IChmdWxsIGRtZXNnIGF0dGFjaGVkIGJlbG93KQ0KPiA9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gDQo+
IEJVRzoga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwgYWRkcmVzczogMDAwMDAwMDAw
MDAwMDAwMA0KPiAjUEY6IHN1cGVydmlzb3IgcmVhZCBhY2Nlc3MgaW4ga2VybmVsIG1vZGUNCj4g
T29wczogMDAwMCBbIzFdIFNNUCBQVEkNCj4gQ1BVOiAxIFBJRDogNTM2NSBDb21tOiBscw0KPiAN
Cj4gUklQOiAwMDEwOnN0cmNtcCsweDJjLzB4NTANCj4gUkFYOiAwMDAwMDAwMDAwMDAwMDAwDQo+
IFJTSTogMDAwMDAwMDAwMDAwMDAwMA0KPiBSREk6IGZmZmY4YTE2ZDZkYTg3YzgNCj4gDQo+IENh
bGwgVHJhY2U6DQo+IMKgIGNlcGhfbWRzX2NoZWNrX2FjY2VzcysweDEwMy8weDg0MCBbY2VwaF0N
Cj4gwqAgX190b3VjaF9jYXArMHgzMC8weDE4MCBbY2VwaF0NCj4gwqAgY2VwaF9vcGVuKzB4MTdh
LzB4NjIwIFtjZXBoXQ0KPiDCoCBkb19kZW50cnlfb3BlbisweDIzZC8weDQ4MA0KPiDCoCB2ZnNf
b3Blbg0KPiDCoCBwYXRoX29wZW5hdA0KPiDCoCBkb19maWxwX29wZW4NCj4gwqAgZG9fc3lzX29w
ZW5hdDINCj4gwqAgX194NjRfc3lzX29wZW5hdA0KPiDCoCBkb19zeXNjYWxsXzY0DQo+IMKgIGVu
dHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZQ0KPiANCj4gQW5vdGhlciBscyBydW4gcHJvZHVj
ZXMgYSBzZWNvbmQgaWRlbnRpY2FsIGNyYXNoLg0KPiANCj4gPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+IE5vdGVzDQo+ID09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiANCj4gKiBUaGUg
aXNzdWUgb2NjdXJzIGJlZm9yZSBhbnkgdXNlciBvcGVyYXRpb25zOyBzaW1wbHkgbGlzdGluZyB0
aGUgcm9vdA0KPiDCoCBvZiB0aGUgQ2VwaEZTIG1vdW50IGlzIGVub3VnaC4NCj4gDQo+ICogQ2Vw
aEZTIGNsdXN0ZXIgaXRzZWxmIGlzIGhlYWx0aHk7IG5vIHVwZ3JhZGVzIHRvIE1PTi9NRFMvT1NE
IGluIHRoaXMNCj4gwqAgcGVyaW9kLg0KPiANCj4gKiBJIGNhbiB0ZXN0IHBhdGNoZXMgb3IgaGVs
cCBiaXNlY3QgYmV0d2VlbiA2LjE3LjcgYW5kIDYuMTcuOCBpZiBuZWVkZWQuDQo+IA0KPiBGdWxs
IGxvZ3MgKGRtZXNnLCB1bmFtZSwgbW9kdWxlIGluZm8sIG1vdW50cykgYXJlIGF0dGFjaGVkIGJl
bG93Lg0KPiANCj4gDQoNClRoYW5rIHlvdSBmb3IgdGhlIHJlcG9ydC4NCg0KVGhpcyBwYXRjaCBb
MV0gc2hvdWxkIGZpeCB0aGUgaXNzdWUuIFdlIGFyZSBjdXJyZW50bHkgZGlzY3Vzc2luZyB0aGUg
cHJvcGVyIGZpeC4NCkJ1dCB5b3UgY2FuIHVzZSB0aGlzIHBhdGNoIGFzIHdvcmthcm91bmQgY3Vy
cmVudGx5LiBMZXQgdXMga25vdyBpZiB0aGUgcGF0Y2gNCmRvZXNuJ3Qgd29yayBvbiB5b3VyIHNp
ZGUuDQoNClRoYW5rcywNClNsYXZhLg0KDQpbMV0NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2Nl
cGgtZGV2ZWwvOTUzNGU1ODA2MWM3ODMyODI2YmJkMzUwMGI5ZGE5NDc5ZThhODI0NC5jYW1lbEBp
Ym0uY29tL1QvI3QNCg==

