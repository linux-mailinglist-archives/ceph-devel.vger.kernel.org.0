Return-Path: <ceph-devel+bounces-3244-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4A3AEC06D
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Jun 2025 21:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F969171D27
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Jun 2025 19:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3FB2D97BF;
	Fri, 27 Jun 2025 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oYaQ2I+H"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ED919D8A8;
	Fri, 27 Jun 2025 19:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053953; cv=fail; b=RGBycykZ/BGScvuZnfBrGkCgBz2XJe7PysoLzMrrbQ/J4fjuPkA6xnpvHEQH9h9+3teL3DTEcPReMTDn3N0RDjmHgou4u095yaDfCKtnHGJjBHFQTQbSGC/vd7nuNwi4swvvaP/+sTRHBcj+sdtSHkE93PN62XDkiM+BFYekbNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053953; c=relaxed/simple;
	bh=ly2G/Xr9tr0MxTmFznjnGk6V4T68ZPTyzMKi4QfkYKA=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=MrLYiBs2ChTPbSwkKEsJw0ufIwxUkG+S2WGkwc1CHgS7ee3it67snlWZksJL1AG2K01aCuqFSb2GV0KcD7IMqsxFRUqQlgj9CThO5F5+q5THizKAdGTdCeOp3B6P0/mYhSvZhpgg98biPJI1uZAy7i18xFv3Q2dVn5c9nJadDR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oYaQ2I+H; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55RAxDcZ000847;
	Fri, 27 Jun 2025 19:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ly2G/Xr9tr0MxTmFznjnGk6V4T68ZPTyzMKi4QfkYKA=; b=oYaQ2I+H
	YUAkuUIC9xKTzMlf6nLRryqQRJiw+WJl9KOvtjhKLr4FVYRx0oZpwtbTT++N/ZDL
	xNhNNn2Rvepyt7GgEr1ZU25+T0OsxDDqEuV2b044iLqaUIBnHnGUJ0IKpI9Kp3A7
	SVmRyAGgpHzyiamTDqnHD02YhCZX/n32CxH6tKf4sKxfG/R0KA2LkbrZMc5QVd0p
	fOm79XvEKADUcKM7obrN+F/0bohsxwhHHPypOnjjXmzyaLwPr3CtIgJLA1M7Ia/8
	WYSVHBRmrOTCb1nf7dNQPc0gb6+PZByM7T7B950vXpAvPHqXuwy0YCvHZXLVYDly
	e9RLA3DvVB4XJQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dj5ufhp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 19:52:22 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55RJnjrd030051;
	Fri, 27 Jun 2025 19:52:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dj5ufhnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 19:52:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewW6eXTLODegxJGOCVGHdQZ3RnXm9nFakwoKT0rifa+AbxhQr/szID1HVCxFeojOjh+yJdrQlH6i11qVcrdCjTVC//7APJGA33PVNpB0pYwXBOEG9dAxxIEpX1zwXO27kHvdJwlv61z2Ab6y4o7yz6L93QPq9J7zfAjsf/LcU/LW9WNQ5UrYZf732AwUz1/yrzEasLfRPmUKvjwXvYSXOrQLH3eXzbQnGHy3gQuePh/ZaXjxSNv/a6S8H8L7YzeoN4XnnVObiCLQh8if650yMDHBSzLB0CT2+eh08uusJMZhlymu11t6JyDrl37m+fxqXrmCBN1AoC6VeoY7yWe/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ly2G/Xr9tr0MxTmFznjnGk6V4T68ZPTyzMKi4QfkYKA=;
 b=divDSXSZ4xVTTqRgtisJ3yBDOGRgRY9Q4X0Zm6KsAvCt+lnEx02SKwZNe3+WbRYjUQHaOSaoT8LFciJzvC/RIMvxDlth+gbub6Sda3Sag57Bl0A2rWGmpXBUcs4z+xY53KL8oxTPz4Y/KmTfC66H+McYAev4n+oG14pThr7YqhZpHh0yJN16ftnEluaYI6bL33QyIgMw810DBq9YUiwgL4rAIrAHRqJ6zGehSsrf/tTVAckFukL4O5uq6T1WDjbbyiswmF5vPqxxU7UlIBllzlhpcFx8SXBDvIZUSCTtRjSJvsn71hjyJ3t/Jn8Cm2hv3DHqCUJBViDPbGTHAT65bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SJ0PR15MB4727.namprd15.prod.outlook.com (2603:10b6:a03:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Fri, 27 Jun
 2025 19:52:19 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%7]) with mapi id 15.20.8857.020; Fri, 27 Jun 2025
 19:52:19 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>,
        "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "willy@infradead.org"
	<willy@infradead.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
Thread-Topic: [EXTERNAL] [PATCH] ceph: fix NULL vs IS_ERR() bug in
 ceph_zero_partial_page()
Thread-Index: AQHb5eUQviot3ynXHEen1IbiLbnazbQXbi8A
Date: Fri, 27 Jun 2025 19:52:19 +0000
Message-ID: <5a7ba595350d1aabf7e5ba4deeac4d2707a101ff.camel@ibm.com>
References: <685c1424.050a0220.baa8.d6a1@mx.google.com>
In-Reply-To: <685c1424.050a0220.baa8.d6a1@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SJ0PR15MB4727:EE_
x-ms-office365-filtering-correlation-id: 66e9c613-b69b-4e7d-8b1d-08ddb5b4200c
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UEllUzZZRldkU1VTaTdMaVFoaHIvOFZVdkFkdDhlZmNCOHFCMHVGVi9xYkhL?=
 =?utf-8?B?MzhpRG9UYWhoWkZJQjZ6dlRkMGJ1MFVONkpmeXE4dDY0OWNBemxma2lzUXBl?=
 =?utf-8?B?eDlaR0hCR0plRGY0NU1za2hQWWtMTUxOY3NPTWN2VXcwa1pNQ0pjZ255b0d0?=
 =?utf-8?B?cEFFZ0hFTnhzdUlyVVJwbFVFWHhxa3ZxcTJ1VlhBVGFHVWNneGpOOTVORlpm?=
 =?utf-8?B?OTRCa0pHMzkva0RHK2ZNQk83SWphNlRtOUdQSmFiK25xWTkwSmJiMzlTUTJW?=
 =?utf-8?B?aks3aVp6TFpZNlRzd1EwWEQ4N0VUSFVrNUdpemNtSUVKWFZocmtCS2VqY0FW?=
 =?utf-8?B?Qk1ORFZCQnhmak9ZNGNyaFRucGFFUVpFbyszMGdVeW02RTRLQXJDQnVIYndG?=
 =?utf-8?B?K2JNTnBPeE5Tc0pZV0FkdVY2UWRGS2RONURmSDNIQVJ0b1JVclo2VDVGZ2Nv?=
 =?utf-8?B?WnFzVHA2a0Fwcm9SUmlRdC9FYzVxMWd6eEV4dVRkZjRwdFI0eW9aMi9OZGx3?=
 =?utf-8?B?L3hHWU8yOGdnUnVreEJjYkhPVEhYNHQxN0g0ditaVms2N3crVzMzdCtiSy9N?=
 =?utf-8?B?ZXpwMTVyTVQ2ZE9nRXl0NVFHaGRNZEpuTExtVGxoR3BONHJHM29MYU9rWGdD?=
 =?utf-8?B?ZXVJbEpqTWxEMHdBWXA0ZXp0MUFxOXlQZ2t0ZGowT01OakdKelE4QTNvdVZh?=
 =?utf-8?B?cWNtRU5YUjl3c0hnTEpLYUlmTjFDSnZjam1jNkNjOExFYmJzMCtrTkg5dGJR?=
 =?utf-8?B?VWVnVEVOMWdFK2Y3Tk5oeElYemdlaVFNeVBxMEVsVk01YTVPaEdpSCsva3ZL?=
 =?utf-8?B?R0dudnVkOWQ3d2dpa00vMUdGa2tIQXpnTDdyb2ZaMXM2K21naHlwd0ZBVkln?=
 =?utf-8?B?cUVwRk9Xbm9FQ2o4eENYMEJuM2hqb2pWNzc5SjY0UkZodllTWmJOUW1ZYzN6?=
 =?utf-8?B?T0ZnTzFqbnNNY1Jkd21WdWZmMllNdk9BNGxHaTh0dDEzbkF2ajE5R1JLb3k5?=
 =?utf-8?B?SmY4MnYwYkEydE9pVWdsZjI1bmdYMEp6QTlvdzVEd21qY3h5RXhjMFQzTW9o?=
 =?utf-8?B?OWJubUE2bFdTZVZKUWRpUlZkK2dKVUcwc3ZSNzJkN1RMdC95bmxaaGtkZ25Z?=
 =?utf-8?B?S0J2NTJjai84Tyt3YTgrTG1UaW1VY3hkSjgwdEZLc0ZuMWc5WnVrS2wrZHky?=
 =?utf-8?B?Qk5LTU53V2FGaklVM2FWV3JWUk1TOHFQek1rQ3ROaS9aZ2lFRFovM25DOWwv?=
 =?utf-8?B?YjhZb0wvQW9PcWdPVnp5VkRXdm5HNzRIRUZiNzlwb0dBWC84NWYycU13TW9Z?=
 =?utf-8?B?Q2JYRnF3bCtMWmU2Y1hhUG16emtKd2lKUWRVRG56c04vYXFrNWJvbHhNNDQv?=
 =?utf-8?B?MDgvaU9WNThzZEdWaWsvZ1RTYUd3WVBvSGtJUzExUzB5eTEzaUdOTDR1MTJI?=
 =?utf-8?B?QnRuVGdwYkx6NXR4aHBuNzdKSkpCVDFXWXNydXpmV3Bla3FFR01BVndvcmtw?=
 =?utf-8?B?aUl3NmF6OFh2clA0UDdwbldYQlkzWlMyNlJLRXZpNVR1YUFiSEVtTU1DMmdh?=
 =?utf-8?B?WER4a1E4a3dwQjY3RytpREpETmFtQUFHZXVBSElMTVdkVHdMMWRXNURoK1V1?=
 =?utf-8?B?bU9pWmNUdC9wdWlmcEF6d0R6ckUwM0owQnptOEp0YUlXY2NHVXQrTWVnRkFw?=
 =?utf-8?B?RGVCSmZrcXBNcnZXL2s0REI2Ti8yQ0lIWlgxbDVkSTZWQ2o1eXpLNDMwODg3?=
 =?utf-8?B?RllmTjhKbmZlajNLUnZQZ3FOWU9SVSt5NVc0UnNZSDJwbkNzT2RveUl0U2dV?=
 =?utf-8?B?bmFMaDJUS1N5WHFQeWlERXIrVUlSdkU5Q2drRlBFNHJpVkxnbFZIazlrRk80?=
 =?utf-8?B?OFFTK2FSWXBNMjMzU1ZWUDZoUThzWHB0SWkrVTREU0pzemVRaXNiSElib2tw?=
 =?utf-8?B?NFNMd2M5SHl6cnNEM2tCT3o1NDYyeUlvcWR1L244SUk0RVhERDdaRTJUMUxk?=
 =?utf-8?B?SmVSeWFDamxnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cCtDRDQxbW5EanRIeisvUG00d2EreGpoaDBqU1JhSWVzSnpsbWI5Tm9KdW1U?=
 =?utf-8?B?TVBuczZiQkd0ZlhaQ2JzSkNSMm52TFFBT21hM1pyaFlYWWd1U2laVmo2UzQw?=
 =?utf-8?B?aWlGR09tbE01bW9hRTBJVUh4SVJ0MlMyc0J4VTY3MW9qMWZSUE9GeGNmeEdM?=
 =?utf-8?B?ZEMrOERoN2NoL3ljM2JNMGlPdUx2VXN5c2laN1pmUFI0eUVFRkJ4WGV3Q3dL?=
 =?utf-8?B?aXcyZFl1SHdTV0xYblVpb3NSN1IrV3JCY1Nkemk1NUljMnAzV0N0TGkwQUNJ?=
 =?utf-8?B?WjJJQzEzZkZ4S1FqeEh1c1hTSFpweGdRZmdWL2pjTFd3Z3RzY2RWbEdCY0M2?=
 =?utf-8?B?eGprOFFjaUp0TXlmejlQWUNiVkI3QnRkcDBvK0xneHZBbXh0T3JwUDRZT21h?=
 =?utf-8?B?RDNMNnkvdHJvS2h4RURyajhHM3pVN2ZCc0tHWnhiTFAwMnZRU3h2eTk3WVJW?=
 =?utf-8?B?M2pxRUZRY0FLcEZpcndNK2xxZUZ6NWM1QWx3cWdtSk1iV0Q3NmZBbUtkZENv?=
 =?utf-8?B?K2M3Uno0dVFzd0ZIRE5YRldseXU0ZStBSTRaNUtxdHB6VFBST2hQRDB3d3hO?=
 =?utf-8?B?NzkwWVBOMExsbTFTeG8wd2s0MHlpazErbDVZUmFWTXJobzVMWVB1Rjd2KzVZ?=
 =?utf-8?B?eUUwcHIyTU9HOTh5dWxnbFFTMXRiR1BicDM1WE03bm82N1hNQWthRStTb3Ru?=
 =?utf-8?B?N1BHSTBIWDN3M1RoNkhRRlZNaW9wRVZaYzdSL0V4a1FjNEE1Nk5VMGNMSHhm?=
 =?utf-8?B?UTRidUc4YTlOcTRzVnIyb2ZNZ1ZOb1lSUHIrVEdCZ1lPZG8wMzh5VkVyT0hM?=
 =?utf-8?B?R0R0ejhrNkxxZGJuODNYRWh4T2g3bjQ4dzREeEFJWkdhQTZ4WGlMaXptZTdp?=
 =?utf-8?B?YU5QZTNKQWV4UXBlUlJYdzk3S2hvZHN1L3FlSTFhem54bnBxSUZUVTJSOHFT?=
 =?utf-8?B?MlZRT2VRd3EvUXp0WWprbDhHOWhHUnNISS9HcnZlT2F4RmV5b2dPVFRFdUNV?=
 =?utf-8?B?NVAyT0hSMDRWWDQxcDFhNGZPRGgrTjV3alk3YXUzOGNTbUhrdUZRYis5cFFi?=
 =?utf-8?B?aDd3cDROSlR0S3UzVktNZWxYSWNub1VsVXl0SFdvRHFwQzZQeDY0bXdBR0tJ?=
 =?utf-8?B?MUNRNDVQblVEYzdhbnFYK0VYczJMbDZlZUhsVWxKenVIeGZTYk85MFJkTlVm?=
 =?utf-8?B?TXpxSUtsUzJQaXZjWWpVYlprL3Bka2ZwZEF1STMvMzN3WTVuQkJNWURaYnZG?=
 =?utf-8?B?RHpodHBWc2hrT1hjYTMwTnE2KzhOT1dBWjZFeUI0WVMzbndTQ0xIOFU3cFBO?=
 =?utf-8?B?QnpTaTRSVVpGWnhya0ZyR0d1YzZXR1hvanJ4OXQxb1YydVZtMEIwRlY5blpV?=
 =?utf-8?B?TE1rU3FaT2JsSGRBaEpHZEJWMEh5U0phNHovOW85ODlXY2NNVVhaNVV0YVRs?=
 =?utf-8?B?ZGFkbDZHL0FkWnRFK2hmUEZzeWMwZ0lkQVJYSW44Q2w3dW56SWhFbGtYYndv?=
 =?utf-8?B?eDYxK2NWenArdWxCUTNZYTFNK3hmVmJQbWhqSmp6c1N1L2pVQ1I3OWNoYUtE?=
 =?utf-8?B?bGhkZnN3Y3dpZ0YzSzNNUGpWeHFHckpMZ01mMmJxYUR4ZHlHSTBOQ054TWw5?=
 =?utf-8?B?aE9PcVJBVUp4N040amxOYzNBN2NNS3l4cGYwSFVqTmd0MzFoVHpNUjhEYThN?=
 =?utf-8?B?bHF4bXp2OVBhbzlYaTlpdkZOeWgwNzRlak5RNEVtTU9yVEczSTJEUUxoeUhn?=
 =?utf-8?B?VXlsM0txZW5INC9ScmI1N3dPc3U1ZDV6N2dLMVA3emsxMW1IMEJsVVVydjd4?=
 =?utf-8?B?MnpsTUF5WEgwS0d6SjdjVXhNVHg2UUZwRnhKSG9qUGt1SXFXSzRPbVljSTl6?=
 =?utf-8?B?SHdBYzZUZkoxMy9FdHFVRmdEbllnNE5sWUQycC8vdGFtbThVUU9BVFhRR3h0?=
 =?utf-8?B?aDQ3ZEh5Q3BxN1ovalE3REhtam5DVWFHNjlveDMrRjZYd0d2Z0dlMzhVQjdy?=
 =?utf-8?B?dWFORUVhTTg5VHRlOG1TL3RnUkE0d3NaU3dONmVSbnp2b3JPME5aNFV0USs3?=
 =?utf-8?B?SDRBbnZhTS9pdmlvK3Q4MVhlWEJDTm9QYXRHS3VxN25rWkZzNzlDVTJSMWxP?=
 =?utf-8?B?K3RUK3I2U2tLWXU1b1NPNGU3RWtQMWkrY2tVaFZ5a1FhbTFuTmU3VXhXM3kr?=
 =?utf-8?Q?v3rEt+fG2fRw2W9uFUzhe/c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12B5F019BF22EC43A3A8EA6A96620E95@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e9c613-b69b-4e7d-8b1d-08ddb5b4200c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 19:52:19.2790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8Va2mIbfqN7T0Yo7/IcGPfUL2YUvB1Ae7Y+foTdwfu/NLRqWUhdG6JkywQmfO9lic3K6zqEsN2kQT/MRdQV0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4727
X-Proofpoint-ORIG-GUID: vYx4a-_Dp-MJpJBLFD5aNme58VOi6Wno
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDE2MCBTYWx0ZWRfX7JfX/vsLPDda NHpRCscTs6JlYIUL2vs4cSyLOh4Q2Uwr3rcVQ3lNNBYUDdgELpOcMprV0//GbIqESLxiz7S7vKN J2/XEDMmpHP/w2nHoz0aEGPbO9RQePBcZadiDI4uEfQXpeQPvo0kZInA1n1kcylDB2ZBTXpQ0Cl
 319NtyG+4DJyj/g7mqjs38RQigkDFqm09R6XUW2DLAxeYV6/BVI/LF9mOtPNWFQgXxlOCNcwgdk sToK7/e0c1O6Y5oluX1ABc6mO6YlESX1kOft70P0Gt6nDkrFboFEDFn4lpAUw33BMWm6+LUQaz+ D7zVLfCnUBtEhTKDSSmUo1bcdteH1phFD12GSf7HlnaXdVgGPRb6QD4E8q2C/1FKgRfNTUpl29L
 dtZwt3TKzGRebjisvh9AISB6idLrw0VpI7v6j/ILGvuFCKQg3Iu5eXMJgwVp76FQC5k6q2zf
X-Authority-Analysis: v=2.4 cv=MshS63ae c=1 sm=1 tr=0 ts=685ef676 cx=c_pps a=tZtd1XuxjNFQVlRjCScw3Q==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=zfNPeyWy3P16nq-RKGYA:9 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: GDUROltWobbSachHulbv8mLRPYKkcBTZ
Subject: Re:  [PATCH] ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_05,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 clxscore=1011 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506270160

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDEwOjIyIC0wNTAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBUaGUgZmlsZW1hcF9sb2NrX2ZvbGlvKCkgbmV2ZXIgcmV0dXJucyBOVUxMLiAgSXQgcmV0dXJu
cyBlcnJvciBwb2ludGVycy4NCj4gVXBkYXRlIHRoZSBjaGVja2luZyB0byBtYXRjaC4NCj4gDQo+
IEZpeGVzOiA0ODMyMzlmMDMxNDkgKCJjZXBoOiBjb252ZXJ0IGNlcGhfemVyb19wYXJ0aWFsX3Bh
Z2UoKSB0byB1c2UgYSBmb2xpbyIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBDYXJwZW50ZXIgPGRh
bi5jYXJwZW50ZXJAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICBmcy9jZXBoL2ZpbGUuYyB8IDEzICsr
KysrKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDYgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9maWxlLmMgYi9mcy9jZXBoL2ZpbGUu
Yw0KPiBpbmRleCBkNWM2NzRkMmJhOGEuLmY2ZTYzMjY1YzUxNiAxMDA2NDQNCj4gLS0tIGEvZnMv
Y2VwaC9maWxlLmMNCj4gKysrIGIvZnMvY2VwaC9maWxlLmMNCj4gQEAgLTI1MzYsMTIgKzI1MzYs
MTMgQEAgc3RhdGljIGlubGluZSB2b2lkIGNlcGhfemVyb19wYXJ0aWFsX3BhZ2Uoc3RydWN0IGlu
b2RlICppbm9kZSwNCj4gIAlzdHJ1Y3QgZm9saW8gKmZvbGlvOw0KPiAgDQo+ICAJZm9saW8gPSBm
aWxlbWFwX2xvY2tfZm9saW8oaW5vZGUtPmlfbWFwcGluZywgb2Zmc2V0ID4+IFBBR0VfU0hJRlQp
Ow0KPiAtCWlmIChmb2xpbykgew0KPiAtCQlmb2xpb193YWl0X3dyaXRlYmFjayhmb2xpbyk7DQo+
IC0JCWZvbGlvX3plcm9fcmFuZ2UoZm9saW8sIG9mZnNldF9pbl9mb2xpbyhmb2xpbywgb2Zmc2V0
KSwgc2l6ZSk7DQo+IC0JCWZvbGlvX3VubG9jayhmb2xpbyk7DQo+IC0JCWZvbGlvX3B1dChmb2xp
byk7DQo+IC0JfQ0KPiArCWlmIChJU19FUlIoZm9saW8pKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4g
Kwlmb2xpb193YWl0X3dyaXRlYmFjayhmb2xpbyk7DQo+ICsJZm9saW9femVyb19yYW5nZShmb2xp
bywgb2Zmc2V0X2luX2ZvbGlvKGZvbGlvLCBvZmZzZXQpLCBzaXplKTsNCj4gKwlmb2xpb191bmxv
Y2soZm9saW8pOw0KPiArCWZvbGlvX3B1dChmb2xpbyk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2
b2lkIGNlcGhfemVyb19wYWdlY2FjaGVfcmFuZ2Uoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90
IG9mZnNldCwNCg0KTG9va3MgZ29vZCENCg0KUmV2aWV3ZWQtYnk6IFZpYWNoZXNsYXYgRHViZXlr
byA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KDQpUaGFua3MsDQpTbGF2YS4NCg==

