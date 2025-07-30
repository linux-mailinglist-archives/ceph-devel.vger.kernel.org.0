Return-Path: <ceph-devel+bounces-3338-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC36B16857
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 23:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96AF3563C3A
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 21:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F8622068F;
	Wed, 30 Jul 2025 21:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aj6idzHp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C661921B9E5
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 21:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753911542; cv=fail; b=GudcYUYunowWNjjYosr5HfyVwHLStYrkWFDi8uLtvHpLRISQgwkyAjhAdhZ5bqNhLVNbYLmM7YsuHn6wqeCoUz7PiWn41OS+2rPKgZ7cPqbhKkIboT9CGdD9W7E3PjVro8YLcehwjZNXiGVnAx6TrHDV8gp7OdZ+B3jD5BX9UwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753911542; c=relaxed/simple;
	bh=xx7zE+QW23tMXkWlXTEWf/Yd7ah77tGBP597y7haZsA=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=QtGhd4B53dAf8zc13w8TvbuDCoHJsspRAJcfVE7b2YnS3wuxKysJpsH0SlUD4hbYIgl3G0rnPO6kBmNbygAXVj4M/I97Sqnu4L/wrHGrhgF/5D/6hir/vz/x31w2cGnWl4sDSXASpJOIT8NMkPZQy50FaEAFXKqaxZ5Uhe4ug3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aj6idzHp; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UCeBRS026014;
	Wed, 30 Jul 2025 21:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=xx7zE+QW23tMXkWlXTEWf/Yd7ah77tGBP597y7haZsA=; b=aj6idzHp
	jIADrLAYlURereY9jsrnlRPj2lDmoggeaVNb+Ix73uBh3CJTkuKA60aOkeCIE1KR
	ZvTHvD0d2gD+oBHLFTaHhBliiDMwBwWZdnfx4SYj9Fdx7yvOCOKaYiXSoRzUawDr
	O4eVX7tuKhlTR2Masrd6d6meGE1GBOWZvgkfcDAg5llrjlYida5Yljyp9/R/zbJ0
	zJNEIjVit5Y0R7bWwriTuJYbB1SCYNxLbPfkWsPicmPzmoS2hACDzSjMjMUagg9o
	cIz4TNlvPtYpk1jOx16eEOoCWq0B8akHHgTFAbRgRRDjg/MTTAyjqtYaKQPKJd6M
	Wj2Ct+UHLUeyGA==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 487bu04rf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 21:38:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y0AM1Zg8zCStIWrG8todcfjuLHW4alGZmA4CUXhjNmxq0QVn5MF4OxIyR9uzGKQv66XxqwROwJeuhhv9FzZO3SN3Q7K8HuHZylibNrPoyrvmhf99eMr+cATDpwuuhxTUt5WeGgjGNO9h2uc3DWzLVka5vi0H7yyNZhaRztgTOxHqy9UMMOUDlcYNh1C7x3KTOy9mVSxiOF1ThGQVdEOh6UQ+NSm0Edpay0MgShZsByKtbENlLF1nHCXVmiKmHoAZAWnnnphWrWaFFjW3uOCBqSCjiaxYLL7+XbVaW/HFBsrW2BXWvRUgjWnPFiqmx5VDA088v81JfVFt7lEn/z+B1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xx7zE+QW23tMXkWlXTEWf/Yd7ah77tGBP597y7haZsA=;
 b=MUJtDZVamGS//XO1trotp90Kbwg3snwyPZFRHMNkrdCq7vFa2Pcfz08Cn7uQIQezb7O/plNtWqkBbLgs2yXfj0gFVXJVFwJ2Z8PRFyGkLnxl08wCo40rjK7xXohO78ld83ojbzASfnlL+xG92Q3qOHxMmcdp98t4IsZ8rjLJ4Z67wINq2zXK+HOuv57yDuidB9AR1UokfVYcJIl+PTEbUkXo24NLyX2yqLA+uqe3lAKYFbVofHgyxkIFY6j1lGP2v0yvwAIvxPDWPh6iojQOkexrt1zqcx0hbUhWG/9cUuPo3/K1L8xdLRhPatHpp1PsH2FrR6TKIzxUuRnSOss2Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH0PR15MB4495.namprd15.prod.outlook.com (2603:10b6:510:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Wed, 30 Jul
 2025 21:38:55 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8880.026; Wed, 30 Jul 2025
 21:38:55 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 2/2] ceph: fix client race condition where
 r_parent becomes stale before sending message
Thread-Index: AQHcAWVWl5whmFTZ80CMH0iHNN+10LRLMeYA
Date: Wed, 30 Jul 2025 21:38:55 +0000
Message-ID: <4b14172543092167ca910eaf886b5bda06c32bc4.camel@ibm.com>
References: <20250730151900.1591177-1-amarkuze@redhat.com>
	 <20250730151900.1591177-3-amarkuze@redhat.com>
In-Reply-To: <20250730151900.1591177-3-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH0PR15MB4495:EE_
x-ms-office365-filtering-correlation-id: 1731e081-1bca-424e-b487-08ddcfb17c17
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?b2VuZ2pmSDBMMzdGMlg5VmdtajZIb01WQVlaZUVoeGJ2M21LY3hpUlBUU3dt?=
 =?utf-8?B?aXhyVG9yYWZMdTVEd1RIQkpDOFY2YWlKa09XbmtkSXZUUkVQUjhud0gxOU9X?=
 =?utf-8?B?SG5LLytjZmw5MXlzVmdHckVHcHBIbTVESzBlWGxaa2hZbTN1U1JLVzdTY0ZK?=
 =?utf-8?B?L0w4NVFaYkFQcFZoeVJRUGhEMWZWa1h1ZUJ3NWg0R3V2TlhLQi9JSEcydXBM?=
 =?utf-8?B?V2lpZE5IN1EzdnBUUlIrM241VHRENDErYXZZZ0xpMWxkMzdNV29CRmsxakoy?=
 =?utf-8?B?R0F4VjRpTUdDZzdvSDNUaHhUTkt5TWlZcWl3NlJ0VlBqaHgxZWNiYlNYNytG?=
 =?utf-8?B?TDAwR2pGMnUzVnNpczgwYUM4R2Q3dCs1bVIyTzdvYzFPNmM5aDVJdmUvN2hW?=
 =?utf-8?B?QU5qLzhIS2dwd0k0RS9MOTdRU3VaQWxpV2p5VzljSHVvbk4ySTFoaE5CeVha?=
 =?utf-8?B?U3hpQUZpWE1TSm5obUg3cUIvVWtTRGR2Z0o1REwvMS9UeFdEODFMVzNNdGtN?=
 =?utf-8?B?THRTa3IzclpxUHBQSDhBaEQwYzNGWHJLTXhsWFEwZlRxZlJuREhYcVEyVjVq?=
 =?utf-8?B?YlRSV2ttSXR0Z285bXlsaDUxL0dWbUpreGFiWTlvOU1WcUoyN3ZhUUFpRzBY?=
 =?utf-8?B?VVVFYXNUNWVEQVJlRmYwWlRUbkFKZGZwVEJaand1NFUvMnVkamMySy91Mnp2?=
 =?utf-8?B?RlJ2Qk5ncE51THhJRmFEdW1WM2lSTmRNeHp0UEJ1OCtiWUV4MmRnUC96THFm?=
 =?utf-8?B?VDlMWlpoK2xJdENXdHRHVFprQVR0ZXVtbzVtc2IxT21tSDZ0WUpwUEtEQjdy?=
 =?utf-8?B?UGF4YXdHMWVSZ3R4QmpvN3IyTXkyM0dCeVNzRGVCMVpZWWZpWnhlTlRMU2FC?=
 =?utf-8?B?ZjJoelhQeW4wbllGeWpqenN6VWRQOVFYenpZT1JEYW1kNDhrTkY0ZGVSWmU1?=
 =?utf-8?B?S1FIQUI4R1lxY2M1Vnl2QTh2eDhpL0lJZXZQMGNuMXRHUEVjYlVhcVY4YVVZ?=
 =?utf-8?B?YlgwS25nbHZIeldUc1JuYVNqb1hhR05KRjgvakhKVllNamZqdVcvaGdtWkxp?=
 =?utf-8?B?Q2F5cVlIc04vbXlUamtxR1RvL3hRdzJpK2d1bHIrVVozUGdZUkdXdythU0Ny?=
 =?utf-8?B?Z0p1bFYvRExsVE1ZUHZxN1FTUFNueXR1NTFmbGlnc0ZYUmFqY3FMTFZhRDdZ?=
 =?utf-8?B?OXlwY2JodmZaQzNrMTNYSnhNSjhNeW10cmxNNnJubnpMblhLaVowdDg1YXBW?=
 =?utf-8?B?OHpVZlRocG9VazYzRGlxZ1B5Z05rOW5CQi9sUGxxc3E1a0piM2RkQjRWNWdi?=
 =?utf-8?B?NzVHMTV3ZERPc3VGNnA5VWtXRzNOV05PdTd6WXJTTDd4bkdUbit1dmVYNGFr?=
 =?utf-8?B?NFpSa0FaaDl2b2NoSEJMRmlVK2Q1bHFvS0dyOEIyeXBiNXo4TS9YNEpOa0tj?=
 =?utf-8?B?WVBVOUtYWDJuR0cwRGs1MlhFbjdYTm9kdUtxVW9iU1lMOExOckVubS8wdWdI?=
 =?utf-8?B?M2pacDZQRUNxQ21mTFFOZWJRTVdUUFVCN3NERHVJREJYS3EvdDlxM0VzaHo4?=
 =?utf-8?B?MFdkRjk4SjN2WHVpd05sSVFPbTJkWVpGK2hWQmgzektWK0ZtS1hFZHJZK1dQ?=
 =?utf-8?B?VWZaOE1uMThWOXFlZTUxRHkzbU9yWDVNcUk0TWRSM3Vnb3FXY2t1OVRab1hS?=
 =?utf-8?B?ZmZJL0ZTakFXNTVxMkFFamFvVWNOTU5DVFQ5dDk0MUtUYjF2Y2N6c1FpNEto?=
 =?utf-8?B?UmdGRzhCZEcxR1dteFhUQ1BlWTUycVkzcDVkVWZqWG1YZ3lseHpVRkp4aUhj?=
 =?utf-8?B?UVRuaXVDNkN0bExabXNLQjNUTDFBdDJCbklOU001eFpZT2RheVpaYmQ2M1dQ?=
 =?utf-8?B?L1ZhUEFwZjU5a1VqMWlwVGtTbGxCU1dmSXd4U1R2amR6SktCWmRDYnVlRzY3?=
 =?utf-8?B?aFFCb1dmVW5vdmJIakEvcmtqTG5KSEF0QzhQVGJYaHVTZHBYWGQvN2dnbE4z?=
 =?utf-8?B?MmMvMG1UZnBnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S3lQVHZlQjVRVkZONk9sZVRDSnpwNEFMRjRpOHRIb094VVFydzhydmdBd2wz?=
 =?utf-8?B?eXBKMmVtVzUrNGdnbU83Mmt0akJ5R2NSekt1MFlQNXVBQ1R4SEtXdUNkNk5L?=
 =?utf-8?B?c2didTc2U1l5bVFlZWsxd1BDU3RZTmlXQWM3bzYvOTg1M0FNa0p4MHRlYmps?=
 =?utf-8?B?YlE2Wmw0cXkyRFZ0bFF6cEFEVW1pK1JrR3EwUjJBd0hFY05OMGd1YS92UWdM?=
 =?utf-8?B?ekVRanE5Yzl5RHdHelFKU09YQlZ6UDhwSEZRZUcwa0IwMkZJbnNjYXlJWm02?=
 =?utf-8?B?YmdWZWRzMEJ3YmMyTWZoRHorNCtFMXY3WlpMMjhTTHMwN3VVWmVsYUk5RW1x?=
 =?utf-8?B?L0QwS2o3OWVZUmhGWVpFT0R5QUtlNTRxQnZ5R3BRM0NYbERVQ3EvSFZRZ1VD?=
 =?utf-8?B?QXdSOHlLTG9vZlV0dkdtL0ZEeDhrTVFTZjRSUFd1U2xNTVNlMVhyYmFld3hO?=
 =?utf-8?B?cHdDNXdZWGd4Z0I3TDZDVlhWMDhxdG5CSGw5VVdGaUF6eUM2QzY4czljaDgx?=
 =?utf-8?B?ZUFndDNsSHVya2toRnNyZXdhUWhRMitUUlNHZXloTndZeDRmRmM5VFJ2TmhM?=
 =?utf-8?B?Z1ZSalAya2FHdVdwbEphZVRIRjFRQW1QL3EzWGlja0JKZmRjbTVlY2FzZllN?=
 =?utf-8?B?SmIyM3FlRDEwRERWZ3AzTHVqekNYYmdaRmFKazhJZlM4L1FsQnNvdVRvNERi?=
 =?utf-8?B?SUlTYmdHQ1lJN2hxc2JKVlJWWkNQdFZySTZXMThXRkg0aW1pQkw1U0QvbkRW?=
 =?utf-8?B?NjVPRE9QVXVHcUhMRWlBbW11bE8vNFpGcG1CNzBqTTVYOEVhUHlvMlcxbEFa?=
 =?utf-8?B?ZWZZbTg4NjVkbUhjaVZKby9ZOGlwYmhRWGZ0WFBEb3o2Y21WbXg3cjd5L0VV?=
 =?utf-8?B?ZWs3UFduZ0JNTUtSSEduYmN0RlpaNitxTzVTdzhlR2loRTdyUEtvM1IrTjl6?=
 =?utf-8?B?TTNkTE9LNnFDaXhVNDc0TkdqR0trcHg4VzdsZmdCM2NUb0JabHZTdnhEVjhI?=
 =?utf-8?B?RUVRd3NoSFFKN09hS0RBbnB5SW9vSXg0cW85VDhKM0U0WmZmaGdJSkNKSTda?=
 =?utf-8?B?clg4RVM5UEphWTkyNkpNbnY3VjRva0pyU3dPVk9DNkVsMUVTSXArMVp0WEds?=
 =?utf-8?B?MFM4a0tvS0VhTklOWUJmck14RFJNVllGVFFMbXBPc2lFTHl3R1hMKzFHSGwx?=
 =?utf-8?B?b3FCd25CSnNYZUw4L0VWOEZlbFRPVUl0ZzMrUXc5OStieTRpNGttNzRZaEN2?=
 =?utf-8?B?UUJUOUg4L2ZGQ0h5ZTh5eWFqekhpNTFvN1A4cDExNzYvN3pkWjdiU25VcGpz?=
 =?utf-8?B?dnNPaGF0c0ticDI4R01MU0FWM2duUmJ5NDZSeDZZWkRsRzZGK3R4QUNoN0U3?=
 =?utf-8?B?dFIvajZPQnBUNWw2cjcyRUVLck90QXdOMlpTUlYycjdscklxZHR0V1ErZjRu?=
 =?utf-8?B?cWQ3bVNSUCtXbGZ4YzZPSldocUxBTXJQN3FCZ29xQ2R5WDVKQkZxdXNIYTdp?=
 =?utf-8?B?RXlReWlsSHdJS1hpRmtJZzhHNHFzRm9YL0xDT3ZBUFNZb0xHNitxckdOVUFq?=
 =?utf-8?B?eW02T3Jtc25qdk5WY3FjcC9HV3hPNXlpOEVVdk1UWUpZekZkUlc3UXdWMC81?=
 =?utf-8?B?Z2gzaGtVbTdxbVlSUE1MTzg0UEJkdG50N1VJMW1nVXI2N2FUYkU2WTNGR1Jx?=
 =?utf-8?B?NWtFODFGM2huVkNFWDlyMnhuU0EzYjdTNTZ4UkR5RG53U2VmMnZWNGsxeWdN?=
 =?utf-8?B?UFpUb2pNb1EvRCt5WGVRS1lXbFpGR3Q0TWFFWW5DbVgvQmJHQnhoZ0NFRXZR?=
 =?utf-8?B?QVVITllCRVNwcDNJcVQwaEl4Zm9NVEhKaGdKbzBUSmwrOWFRaXpVUm1kNlZ2?=
 =?utf-8?B?ZmxMZ2lxRnJTb2ZTcmsrZGtRR1NhTEtZc2w5ZGVwL1VmcDNkT0JRc1JRcFJ0?=
 =?utf-8?B?TFpGNTEwK2N6YkprbXZoZDlJWk5aV2pLUWhuKzljcTZxTllTdWlyTkl4M2Zv?=
 =?utf-8?B?emRKVHJtK2NicXF2T0U4Ri96R2x0L1FpS3I1YzFVZUZES3JVTnRiek93L3Zt?=
 =?utf-8?B?bUxDby9adVN3ZXdRV1I2WjNaV1FIcHdTQ0ZYRlNSNjEwTXBjZDZwNVlzU2VJ?=
 =?utf-8?B?ODlKNWxLZDV1QjhMeGVmTE5YVEx5WkFXc1dZODh5M0s0SDBYVVdPMTlTRm01?=
 =?utf-8?Q?tTmvOi82CpzQHE29Rr2gC3w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DACA47D28BABE6498411EF30D779A667@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1731e081-1bca-424e-b487-08ddcfb17c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2025 21:38:55.3953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O1EbPUHTbrVTW8Mpnn5Oz8a74cWo5lXuIeUZKiG0TUOyBsdw3Cj6LhTq8GDAJo5gWER6H79qAOVW9s9BDKybQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4495
X-Authority-Analysis: v=2.4 cv=ZNPXmW7b c=1 sm=1 tr=0 ts=688a90f1 cx=c_pps
 a=Yg7HqpqKeAJeJ+XEsPQ2sA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=ibslXRTsAy_r8WSI5UoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gBtP5Q3EonbxbNZSSPRhHju5C-VdmCQ2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDE1NyBTYWx0ZWRfX9NS1DDGKf2rk
 dJcWcSBbhf8wxom+B6QBk1GcHOtYvQ+uEjPPBOY37niS3psqLjes3lzfv6GUpu5xOWrZaSvTNnM
 4JODwPYg8XYdcP2Z+kjGjsZYT3zMetuILlKZarQ/LeZNZct4cWStiVjFIwJf74LANUJvTzAUzbP
 ReYW4+APvN7U/1yP5njh9vnJ0kC2PRRSn7AJAkKGOra/RrG8pOkQHx8/1VC1Qir0MKi/C8SOxNM
 1q3Quo4O5rAue8rKURi5MH/bk9+8JnFFpezLbkR1Uk+bd2wVHifOMKpdf4Y8FQOkV546POGri3i
 8VA5wUTNymLRXvUmGkGzL7Ar3OLmM67WZbF6Ao1H44Qxis9ECsYaOj5t/C+RZiZquRvDN5iH9yP
 bj1P3LEKm2N+3tTobCcwPomDbsco6hZ5nxPjA3NARkgebyXs2wG0wVB3nd1+Gi2mTuInx1/o
X-Proofpoint-GUID: gBtP5Q3EonbxbNZSSPRhHju5C-VdmCQ2
Subject: Re:  [PATCH 2/2] ceph: fix client race condition where r_parent
 becomes stale before sending message
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_06,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507300157

T24gV2VkLCAyMDI1LTA3LTMwIGF0IDE1OjE5ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkncyBpX3J3c2VtIGlzIG5vdCBsb2NrZWQsIHJlcS0+
cl9wYXJlbnQgbWF5IGJlY29tZQ0KPiBzdGFsZSBkdWUgdG8gY29uY3VycmVudCBvcGVyYXRpb25z
IChlLmcuIHJlbmFtZSkgYmV0d2VlbiBkZW50cnkgbG9va3VwIGFuZA0KPiBtZXNzYWdlIGNyZWF0
aW9uLiBWYWxpZGF0ZSB0aGF0IHJfcGFyZW50IG1hdGNoZXMgdGhlIGVuY29kZWQgcGFyZW50IGlu
b2RlDQo+IGFuZCB1cGRhdGUgdG8gdGhlIGNvcnJlY3QgaW5vZGUgaWYgYSBtaXNtYXRjaCBpcyBk
ZXRlY3RlZC4NCg0KQ291bGQgd2Ugc2hhcmUgYW55IGRlc2NyaXB0aW9uIG9mIGNyYXNoIG9yIHdv
cmtsb2FkIG1pc2JlaGF2aW9yIHRoYXQgY2FuDQppbGx1c3RyYXRlIHRoZSBzeW1wdG9tcyBvZiB0
aGUgaXNzdWU/DQoNCj4gLS0tDQo+ICBmcy9jZXBoL2lub2RlLmMgfCA0NCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQyIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvY2VwaC9p
bm9kZS5jIGIvZnMvY2VwaC9pbm9kZS5jDQo+IGluZGV4IDgxNGY5ZTk2NTZhMC4uNDlmYjFlM2Ew
MmU4IDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2lub2RlLmMNCj4gKysrIGIvZnMvY2VwaC9pbm9k
ZS5jDQo+IEBAIC01Niw2ICs1Niw0NiBAQCBzdGF0aWMgaW50IGNlcGhfc2V0X2lub19jYihzdHJ1
Y3QgaW5vZGUgKmlub2RlLCB2b2lkICpkYXRhKQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+
ICsvKg0KPiArICogVmFsaWRhdGUgdGhhdCB0aGUgZGlyZWN0b3J5IGlub2RlIHJlZmVyZW5jZWQg
YnkgQHJlcS0+cl9wYXJlbnQgbWF0Y2hlcyB0aGUNCj4gKyAqIGlub2RlIG51bWJlciBhbmQgc25h
cHNob3QgaWQgY29udGFpbmVkIGluIHRoZSByZXBseSdzIGRpcmVjdG9yeSByZWNvcmQuICBJZg0K
PiArICogdGhleSBkbyBub3QgbWF0Y2gg4oCTIHdoaWNoIGNhbiB0aGVvcmV0aWNhbGx5IGhhcHBl
biBpZiB0aGUgcGFyZW50IGRlbnRyeSB3YXMNCj4gKyAqIG1vdmVkIGJldHdlZW4gdGhlIHRpbWUg
dGhlIHJlcXVlc3Qgd2FzIGlzc3VlZCBhbmQgdGhlIHJlcGx5IGFycml2ZWQg4oCTIGZhbGwNCj4g
KyAqIGJhY2sgdG8gbG9va2luZyB1cCB0aGUgY29ycmVjdCBpbm9kZSBpbiB0aGUgaW5vZGUgY2Fj
aGUuDQo+ICsgKg0KPiArICogQSByZWZlcmVuY2UgaXMgKmFsd2F5cyogcmV0dXJuZWQuICBDYWxs
ZXJzIHRoYXQgcmVjZWl2ZSBhIGRpZmZlcmVudCBpbm9kZQ0KPiArICogdGhhbiB0aGUgb3JpZ2lu
YWwgQHBhcmVudCBhcmUgcmVzcG9uc2libGUgZm9yIGRyb3BwaW5nIHRoZSBleHRyYSByZWZlcmVu
Y2UNCj4gKyAqIG9uY2UgdGhlIHJlcGx5IGhhcyBiZWVuIHByb2Nlc3NlZC4NCj4gKyAqLw0KPiAr
c3RhdGljIHN0cnVjdCBpbm9kZSAqY2VwaF9nZXRfcmVwbHlfZGlyKHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qg
aW5vZGUgKnBhcmVudCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN0cnVjdCBjZXBoX21kc19yZXBseV9pbmZvX3BhcnNlZCAqcmluZm8pDQo+ICt7DQo+ICsgICAg
c3RydWN0IGNlcGhfdmlubyB2aW5vOw0KPiArDQo+ICsgICAgaWYgKHVubGlrZWx5KCFyaW5mby0+
ZGlyaS5pbikpDQo+ICsgICAgICAgIHJldHVybiBwYXJlbnQ7IC8qIG5vdGhpbmcgdG8gY29tcGFy
ZSBhZ2FpbnN0ICovDQoNCklmIHdlIGNvdWxkIHJlY2VpdmUgcGFyZW50ID09IE5VTEwsIHRoZW4g
aXMgaXQgcG9zc2libGUgdG8gcmVjZWl2ZSByaW5mbyA9PQ0KTlVMTD8NCg0KPiArDQo+ICsgICAg
LyogSWYgd2UgZGlkbid0IGhhdmUgYSBjYWNoZWQgcGFyZW50IGlub2RlIHRvIGJlZ2luIHdpdGgs
IGp1c3QgYmFpbCBvdXQuICovDQo+ICsgICAgaWYgKCFwYXJlbnQpDQo+ICsgICAgICAgIHJldHVy
biBOVUxMOw0KDQpJcyBpdCBub3JtYWwgd29ya2Zsb3cgdGhhdCBwYXJlbnQgPT0gTlVMTD8gU2hv
dWxkIHdlIGNvbXBsYWluIGFib3V0IGl0IGhlcmU/DQoNCj4gKw0KPiArICAgIHZpbm8uaW5vICA9
IGxlNjRfdG9fY3B1KHJpbmZvLT5kaXJpLmluLT5pbm8pOw0KPiArICAgIHZpbm8uc25hcCA9IGxl
NjRfdG9fY3B1KHJpbmZvLT5kaXJpLmluLT5zbmFwaWQpOw0KPiArDQo+ICsgICAgaWYgKGxpa2Vs
eShwYXJlbnQgJiYgY2VwaF9pbm8ocGFyZW50KSA9PSB2aW5vLmlubyAmJiBjZXBoX3NuYXAocGFy
ZW50KSA9PSB2aW5vLnNuYXApKQ0KDQpJdCBsb29rcyBsaWtlIGxvbmcgbGluZS4gQ291bGQgd2Ug
aW50cm9kdWNlIGEgaW5saW5lIHN0YXRpYyBmdW5jdGlvbiB3aXRoIGdvb2QNCm5hbWUgaGVyZT8N
Cg0KV2UgYWxyZWFkeSBjaGVja2VkIHRoYXQgcGFyZW50IGlzIG5vdCBOVUxMIGFib3ZlLiBEb2Vz
IGl0IG1ha2VzIHNlbnNlIHRvIGhhdmUNCnRoaXMgZHVwbGljYXRlZCBjaGVjayBoZXJlPw0KDQo+
ICsgICAgICAgIHJldHVybiBwYXJlbnQ7IC8qIG1hdGNoZXMg4oCTIHVzZSB0aGUgb3JpZ2luYWwg
cmVmZXJlbmNlICovDQo+ICsNCj4gKyAgICAvKiBNaXNtYXRjaCDigJMgdGhpcyBzaG91bGQgYmUg
cmFyZS4gIEVtaXQgYSBXQVJOIGFuZCBvYnRhaW4gdGhlIGNvcnJlY3QgaW5vZGUuICovDQo+ICsg
ICAgV0FSTigxLCAiY2VwaDogcmVwbHkgZGlyIG1pc21hdGNoIChwYXJlbnQgJXMgJWxseC4lbGx4
IHJlcGx5ICVsbHguJWxseClcbiIsDQo+ICsgICAgICAgICBwYXJlbnQgPyAidmFsaWQiIDogIk5V
TEwiLA0KDQpIb3cgcGFyZW50IGNhbiBiZSBOVUxMIGhlcmU/IFdlIGFscmVhZHkgY2hlY2tlZCB0
aGlzIHBvaW50ZXIuIEFuZCB0aGlzDQpjb25zdHJ1Y3Rpb24gbG9va3MgcHJldHR5IGNvbXBsaWNh
dGVkLg0KDQo+ICsgICAgICAgICBwYXJlbnQgPyBjZXBoX2lubyhwYXJlbnQpIDogMFVMTCwNCj4g
KyAgICAgICAgIHBhcmVudCA/IGNlcGhfc25hcChwYXJlbnQpIDogMFVMTCwNCj4gKyAgICAgICAg
IHZpbm8uaW5vLCB2aW5vLnNuYXApOw0KPiArDQo+ICsgICAgcmV0dXJuIGNlcGhfZ2V0X2lub2Rl
KHNiLCB2aW5vLCBOVUxMKTsNCj4gK30NCj4gKw0KPiAgLyoqDQo+ICAgKiBjZXBoX25ld19pbm9k
ZSAtIGFsbG9jYXRlIGEgbmV3IGlub2RlIGluIGFkdmFuY2Ugb2YgYW4gZXhwZWN0ZWQgY3JlYXRl
DQo+ICAgKiBAZGlyOiBwYXJlbnQgZGlyZWN0b3J5IGZvciBuZXcgaW5vZGUNCj4gQEAgLTE1NDgs
OCArMTU4OCw4IEBAIGludCBjZXBoX2ZpbGxfdHJhY2Uoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwg
c3RydWN0IGNlcGhfbWRzX3JlcXVlc3QgKnJlcSkNCj4gIAl9DQo+ICANCj4gIAlpZiAocmluZm8t
PmhlYWQtPmlzX2RlbnRyeSkgew0KPiAtCQlzdHJ1Y3QgaW5vZGUgKmRpciA9IHJlcS0+cl9wYXJl
bnQ7DQo+IC0NCj4gKwkJLyogcl9wYXJlbnQgbWF5IGJlIHN0YWxlLCBpbiBjYXNlcyB3aGVuIFJf
UEFSRU5UX0xPQ0tFRCBpcyBub3Qgc2V0LCBzbyB3ZSBuZWVkIHRvIGdldCB0aGUgY29ycmVjdCBp
bm9kZSAqLw0KDQpDb21tZW50IGlzIHRvbyBsb25nIGZvciBvbmUgbGluZS4gV2UgY291bGQgaGF2
ZSBtdWx0aS1saW5lIGNvbW1lbnQgaGVyZS4gSWYNClJfUEFSRU5UX0xPQ0tFRCBpcyBub3Qgc2V0
LCB0aGVuLCBpcyBpdCBub3JtYWwgZXhlY3V0aW9uIGZsb3cgb3Igbm90PyBTaG91bGQgd2UNCmZp
eCB0aGUgdXNlLWNhc2Ugb2Ygbm90IHNldHRpbmcgUl9QQVJFTlRfTE9DS0VEPw0KDQpUaGFua3Ms
DQpTbGF2YS4NCg0KPiArCQlzdHJ1Y3QgaW5vZGUgKmRpciA9IGNlcGhfZ2V0X3JlcGx5X2Rpcihz
YiwgcmVxLT5yX3BhcmVudCwgcmluZm8pOw0KPiAgCQlpZiAoZGlyKSB7DQo+ICAJCQllcnIgPSBj
ZXBoX2ZpbGxfaW5vZGUoZGlyLCBOVUxMLCAmcmluZm8tPmRpcmksDQo+ICAJCQkJCSAgICAgIHJp
bmZvLT5kaXJmcmFnLCBzZXNzaW9uLCAtMSwNCg==

