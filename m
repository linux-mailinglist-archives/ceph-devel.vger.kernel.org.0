Return-Path: <ceph-devel+bounces-3715-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C45B9710E
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 19:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C1A12E1CAF
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Sep 2025 17:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D0928032D;
	Tue, 23 Sep 2025 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JM2Js9Et"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03E338FB9
	for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649367; cv=fail; b=RFEd1d9pFQ40yxua0xDvqmc0nwq/1hqtNUdDAq6FVGw1v+Btiq8X8+3ZyUcVuKtlRer66kcunZSZoKwGrPLXUXkdEK1EUXmARBq/r6eAYPWAXkhK6QkzreF8MU1cLHJ10Jw2Qz34uihn5DLLuwEMKl3Zt6hCiEhZ28PXUzVOMfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649367; c=relaxed/simple;
	bh=5LRcPlw4+twzoHDo4ToDUeFDtjxmjNFjRm+O3bNVsjU=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=hYGdbGYuFQEq3bUkhSsKG5n/PzyPbqI40sCdWQCzj/sfo6hlrABumDTh2ObolBJp103jYJUua974oBGiEu+0KMJsk/EFmMHq0LYuXk7blCAHXuAhFlMAvtG1S5mPHY9D6ftXUByiURctbUGIJdNR9kzXKYS/kBRORIjk+s/el30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JM2Js9Et; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58NDmhp0007389;
	Tue, 23 Sep 2025 17:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=5LRcPlw4+twzoHDo4ToDUeFDtjxmjNFjRm+O3bNVsjU=; b=JM2Js9Et
	pZvS3OI/RfjLq5FR926PTGX21IPgI95LmlbbGjceYLNnhU/bkxZK2rpH8rupe18Z
	/a2H+nB4wvk5EzhicJfodzbjva4W56lt8e+JHFBJmyrOqRPEO/lm2nT5p3NyaDA9
	YFpGza+LkzQAZno1IOd5i0pDEFFc6WUNH98G7D7IuX0464hmo57EKct2zu1jpxWm
	+NTHfT4nNC7gunOub3BpI7hpSSqXEHXtdoGHDQQdoi5GFAGuuvzfeUAcRD9zpfvY
	BwRLC1ioHg2HcItReU4Fy2+lcoXCU2V1rgO/4d8H4zo59obcxQ220msyd3usVbUR
	bgmU8djQs0brpg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0jjpgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 17:42:29 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58NHgTZS000761;
	Tue, 23 Sep 2025 17:42:29 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0jjpgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 17:42:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZi6LhToHBQZ+PrLnNciPq7IOAKG6lON46FuqW84kjgDvR3QYEL7HcR/vs7JJhdQ7jMa6+GDHEagLRmXcr6Q3lkbeGjmAKSqetXvQd0pfasj1Hb+htYQorKDjElMuz4UQRb+vzEu5ajOhTrJCYI0L5lqKvQ3Vn3B9BKUQtR3l2hf8JzR/3zH8Q0r4UiLKtGyWnZQ+diRz0grqM0tB0bpbreE2Gw5q4C/rmgdzP7UnBQOA7z0Y/p1XX+MbJ8xWsLoicnQOfLNFkxMfWm/0tSe+VmNN4rq1uhbYQ9K6tKzSxuNKZLq4sVx8GmagFrFG6olQI2N6HDtviPcnCqCXlWWzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LRcPlw4+twzoHDo4ToDUeFDtjxmjNFjRm+O3bNVsjU=;
 b=hglwh9JlL4ziei/HiOmm2FbpqjYRLWgE9GAfD0hGT1GO6a38jMSbzGDlOMA5AAlgCfIR8cy84KOtOJFYBxNTAZfkMh5YX2J0och28kWYFhV/0c4k/iuENJbXzt/dEsJJzez2LBsVfjzai4HkuROmJKgGDEDNZ6zuTI2/5Omnle6ox0GzGKGExGN/F7j/d4WNXVlsq43qC4WyVf4I46HeEirrcCN9PxvYphibT8KPgAYcVqPbUyerhwqluh1JroM1tlDaN9GpDBtjVKqFr/M/twbv7/fqXqImMLvfu8X+Nd+BHywqTOUDDPPsqjQZrZfARYGDJgpOJORlkWIs0mA8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB5317.namprd15.prod.outlook.com (2603:10b6:510:1e0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 17:42:24 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Tue, 23 Sep 2025
 17:42:24 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "raphael.zimmer@tu-ilmenau.de" <raphael.zimmer@tu-ilmenau.de>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [bug report] rbd unmap hangs after pausing and
 unpausing I/O
Thread-Index: AQHcLHahXnUtVWvZCEetixl8fPr2BrShCekA
Date: Tue, 23 Sep 2025 17:42:24 +0000
Message-ID: <b94f8a4b7d70a9fd3603a1cfcb6a708cf6bd44b9.camel@ibm.com>
References: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
In-Reply-To: <36681e9d-fde6-4c5d-bf35-db9d85865900@tu-ilmenau.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB5317:EE_
x-ms-office365-filtering-correlation-id: 0762d0c1-e938-478a-784d-08ddfac88e6c
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?aGlxMDN3dHo4OHdqNmtxdFRkSzh4MndZQ3dMSUNDeUNTMFJFckVLRERhcU04?=
 =?utf-8?B?Zi8zSFZlZkVla0R1OFRVSHl4Wi83eGRuczd2d3k2S1FHc3ZNdUJId3VGTEU0?=
 =?utf-8?B?WHQ4L3hOWXM2VlZlVFB6WThkcjBOVDJla2NMZzBrRXFSdU5maWJscHlsK29N?=
 =?utf-8?B?dER4SDJ6UWllZXFYQmo4UHByUFVoYWd6cUlBZGhNWHFYZkVZMElzdi9iY0dn?=
 =?utf-8?B?Q1lPQXVUMkFiN2xRdU1TRzlaSFJOZVdaTFZoZW80UXRUTVY1VEJLVVpTTjlx?=
 =?utf-8?B?aXNrN1pvc2pEUDB5TkJ6dklVK2Q4cFJJSWc3VkJLVDhrYm5OZUtieEpVckNh?=
 =?utf-8?B?V25IV1FrMnNoQ3ZMUVpkV1ZiZlJVYlJJOHRMSTFLZjM2MUpwVG5XZ2wzVDla?=
 =?utf-8?B?YzVpU0NoSlVOdkZoMlFEZ21QRkRYSkV2Ny9pMFNoQ21HNHRXaFRkeXdSMHJ0?=
 =?utf-8?B?b3RzUGFJL2kwdkdkaU1Pc05DUGxCL1E5ZzhpanVQY1JwK3NIS20ycFovV2ZB?=
 =?utf-8?B?akk3SytNUjhmQjA0bTBCOXpPSXd4TzQvOUJtQ0VMbDJOakJtR2JZbHVia25W?=
 =?utf-8?B?TDU5VHowOWpqSXpDUHJtSGdMWngreWJzYURpSk5ja3g3QWRma0lvNS82V09P?=
 =?utf-8?B?a1dtQmZ2Y3ByTGErb0s3VFdBYmhrQmFmZWgwSGZTOWw4UC9vekV0anJWRjYw?=
 =?utf-8?B?d2I5bDFJcmV3MTFyRTFwRGhRdlIzcDgvVzF2cmJ0WmJ0UjV4SStXdysyalpN?=
 =?utf-8?B?TTZRZGdBRDFSTU81eHhkcUsvYVp1ODZSWVduaUhMd0JxYVVTQzJPK1ZjSUM0?=
 =?utf-8?B?T0FrY0xJZWQ2OENESDhpeDBzTWdzU2JOdVJRYnZiR28rN1ZQTjgrd250K3k1?=
 =?utf-8?B?OWtUMURsbXZHRlVSVTRDL2lwSDBxUDhtNXA1RzJVZHN5akZrSHU2bUVkaWo3?=
 =?utf-8?B?QjV4SDJoSjA4STFMNDhTL2MrYlMwdWpDZTUzM1BWMjNtVDNFZnVKa0gySE84?=
 =?utf-8?B?dkgyNklXb1MxM1FEemJsbldQdFhuK2FPS01LOGpqcWQ1NThCTEk0bGZZQ1pR?=
 =?utf-8?B?TEdnL1ZBU1RubStUL2VBcXFibDRCRnhFdmpzc3MvcklTeFhEc2ZRaEVqcnZu?=
 =?utf-8?B?QU96WWNzcmZjVFJPY2dEQnNXZDNSOWJScWhVeDRVVDNIQVZLMDlJQVhybEFv?=
 =?utf-8?B?Vk8rR1gvNWt6UW1hODE0UGFiclpMT1ZwdkpEemFZc0t3N0Z1cGl2cHB2bEVh?=
 =?utf-8?B?SnRNK1c5S1NZTU5XWk5qZUxibnhCYXduVkVPOGROb0kwTUp3N3M2N0JDeTdU?=
 =?utf-8?B?RVRxNzNYRGJPbHE2eWpVbXRCRloxS2Z2eUZvNlRnMWtuOW5aY1VpUytISXJv?=
 =?utf-8?B?VE53K1h2bkc5NThwTXBnMkJpRTk3bWxmWEdKcW1xZy8yUHdMMUNhU210RXRH?=
 =?utf-8?B?V3Y3cFVucklCWWtqcTRDeFhxemxMcWVpLzhFck5DaGJIdlBXdlY1cHhxNDh2?=
 =?utf-8?B?THZBSG9ib0lxVThEdkVCc3RLL1VCZS9pTUdqNFNlYWhlckphZGdsZG40RFdr?=
 =?utf-8?B?eCtqbXhwRmMwa1lPRys0dnNscXAxa3FlSVhGKzFxdm5lZzNmVzNuaExHL09N?=
 =?utf-8?B?bXVESTREWGpQQy9yZVl1TWxGOG0yYmNQN2RNWmFXbjFDNHUvdHZ6Sk1XR1Jl?=
 =?utf-8?B?bGlnNmtxQ2IrWFlIZkhrQkNYRnNueFBXVm1NVGRrbDJNMVZEVmdUSWVXZW8y?=
 =?utf-8?B?cEd6enNwNXhGSFZEYWRxcXI4Y0JQbUZhWUxnaVlvNXFHNWNIS2plb1FydjVa?=
 =?utf-8?B?Q2NWK1N4NEo2dGVCMThORmplbDdrTU5IQm5mOWgybEErWm9zMzVyUVFBN0o0?=
 =?utf-8?B?WUxGSHhnM3NHcE5CeUJBWUJLT3ZuTTFLOWNtZW1xd3lJNm9iWGEzSDU5Vld6?=
 =?utf-8?Q?ML8q6S6K0z4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c1hvWUx5MFpXSWNvd1hXZ05PdmlWMTJwSzIxQkRSa0k5MGZiUjB0RGNVQlRl?=
 =?utf-8?B?TDEyRVBubGJacnRXYlRqREs5bHZBeDVtMnk0MGtBclo0ODQ5ZzlCbTMxdUNH?=
 =?utf-8?B?b3c5R3ZSdVBEL252ZW9KQjI1VmdvSkZBUnd6R0ZERFJMRkFoTlNwcWNoQUlI?=
 =?utf-8?B?akxQa3hxeUgvc2xmaGxMMkdOOUdxcUlBSExmQzNYeHk3Tk9XdXE4ejlQNVdk?=
 =?utf-8?B?VDhQd0dwQ2tnRXNtcEtBTmJxWGdSTWE0Q1BKZ1pQcXg5UnhxbnF2d2NHYXly?=
 =?utf-8?B?cGo2enllaVVQK2wvY3hMa1QrQngvMkgrRVlZUGU4eFJCSWRoMVRpVmxsRUV3?=
 =?utf-8?B?dFovblJOVHhmeDBTM25jdHl4NEMrM1VqUkk1ZVFKVHA3SkhqQ3BWSzFxdEpQ?=
 =?utf-8?B?V3ZPaFluNUtBNmZPNldNNE1PeGpieVZqU1krYWRSZnJmVi9FckVQYjlQVnBH?=
 =?utf-8?B?UzJtZ1MxakplSTdBYWgyTUtjdzJkYm9JOE42K2Z4ZTBJLzVEdlhiSlRMekVR?=
 =?utf-8?B?THkrWmJLeVFQR1FIWXNvb3VlMW41UVFuWjJCU20zNEdzOU15NjFWM21vcDNZ?=
 =?utf-8?B?Sks5L2xvRGhTUkpaRHR2dGNyOFFBblUrU3pVbkErNVdaM1hPMDRYUjJyNFVS?=
 =?utf-8?B?YVVGYTRHWVdjWFVaNFpXZ1JBN2IxRWZoYk9FczhjOEdyMktjNVNKbjF3cGpJ?=
 =?utf-8?B?aGN6WjNsaUZoMjNCaWV6UUhXUzgya1VJYm84QXZaWXFxU0g5TFF2bzM1dUJl?=
 =?utf-8?B?d3A5TlBnMDYwUkV4TWtKUUpONGd4L0o1cnhYZHBuQU92aG1pY3VkVXJKRTAx?=
 =?utf-8?B?bm9SMmxjMmpkTWJiVlJHTmF4UEhJM0tIb25qaUFrQW9vTXVkaWNQSTVoQ1BN?=
 =?utf-8?B?aW1xVXpvbjZrR3lRWXFLMVNnaWorY1NVcTl3VDRIR25pRVU2T2VsYkE1L2xZ?=
 =?utf-8?B?TVBiekNLTFdjYTdpZFlOMlNwdUh4NFltQjl0MEVIOVk3SkZSd3VtN0FPK1pN?=
 =?utf-8?B?clVwRGREaHV4THRTUW4wcmlaWnhhMktQa0lsMjNRNEN3OWE5RVFJODRsTmVF?=
 =?utf-8?B?eXk4V2RLaWFpQnZqUmR1MUZhVjVNTm9JeDk2WnliTG55NVQ4bC9TVURIdENR?=
 =?utf-8?B?cHhXbVNoY2R4cFArT25yUUhHRVJJL2MxK2FTZSs1TjJsSnlOTWdTVGpXYXUx?=
 =?utf-8?B?SU5kRzlVSmZSNTZXTnBad0xRSU45MmgrVjkxQ3hyaDhGQ0dETmV0cUtqRjJG?=
 =?utf-8?B?RDlZa0tEMnlKck0yNVZFaFJSREhrVitnZDVERnpjcGNsL3UrTiswbVZqSXV2?=
 =?utf-8?B?T2NyQy9SOUpGYnpWMTZ1R2JrQ1g3aUw4SENFMTFoeUxBK3BzVE4wNWF1Q2Z2?=
 =?utf-8?B?cGNYOGIrOGNsQytTc2FHUVp1bzF4c1VIdDhYUTU4ZG1hVXhkWGRJd1ZUY0Ja?=
 =?utf-8?B?WDNZYTdCWnJZTmFpdjhRbVl2YWVITXVPS0F6c1daVU1heUlRRy9EcGdtNjlN?=
 =?utf-8?B?S3FQL3ptalhwVTRTa0kzVFhkY2Q1ODNVRmVTVVdWeGhLRnZHYitBZWFFTDF3?=
 =?utf-8?B?UG0yTjVjTk5Qa09nVnRXWXQ5OVkzaE1ZejgzSnpMNGt4bXVGbFgzc3VxemhL?=
 =?utf-8?B?bDFabks1cUMxbXhRRm16cWd0bUN4SkhYem5PL25xY0RiODVGYkFUdnNaVXc0?=
 =?utf-8?B?dmtaL1NyMGhtUEhCZERxR2ZqWlFUTStJL2tiajI3WVpmalFjM2tzZi9CbXBB?=
 =?utf-8?B?aS9wVC85Zm8vQ0hOMmRsM000eHR5czkvSWw2RTZxdXZJT29nL2RiUjV0TzRB?=
 =?utf-8?B?V2hmTk1NQU1CT29jOVAyVDJGdjhUNFhnNHpnb0NzTDM1WVhrcXlRb2c5T0xn?=
 =?utf-8?B?NktLb0M4ZDdwVUJqRkRjMko3bGNzQXk2dUZITUVHbHBobXhnVVJuc3lkcitC?=
 =?utf-8?B?MTIvRUNNQmpwQ3FVc3dhRlZiYy84cUd0UFBjcjhrOFp5aHdTZWNkOGNBWnMr?=
 =?utf-8?B?Nkxjc0lmUkNtaEJ2dllORkNUaXZET2ZKS050c2lwVDN2akdvTUM4cGk0RGZv?=
 =?utf-8?B?ZDA1VzZHbVl3TVhTRHplN29RL2ZqOTA1dEJLMU42Wjk4M1BkbzUxQXUxdDRZ?=
 =?utf-8?B?bVdTQ2FmY1VKWlE0anh1N0RzbFg4dVR0MCswWjlMbURnS3lnZWFQU2ppbU9T?=
 =?utf-8?Q?SbxGhpWheIqXlpLPBSCFNfY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE19115DFAEA65428AE3B8EFA9ED403B@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0762d0c1-e938-478a-784d-08ddfac88e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 17:42:24.6218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dOBRYwEO4ckfz57VjGqLJ98nz+NATG0lpLyIaKsMxMX15IV3fIOh30z996wD7CKDTy4kyh+6R3gg/yqxSgC+9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5317
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzMyBTYWx0ZWRfX42LZG5ozW0Fu
 b+coW1GCZKnWe68xs7JPXOJFo67Na/FfoGcj7pnU623bdlBdn4UA2g92HyDauSmGop9GeHETIuN
 6/TKOJPAKMPG4qntQEFEPE55+drEWzrAgghlxNkTCR0uJszZrL+etT2/xbe9fKKq/i0PmuryXfW
 cmVJB/HxsGcP/7+Faz06JLfuZhNkd4sfRw7zsc2EC1Jqz31r+sGd2yBjcQrsaZSDrN9URSqpao0
 POp2/X/QXBM/xwg1C8c0Gzm5t77Qt1QruXkwcPzoQlDKKcDv9aZ39JCzm9kzAZlB7ha+NkHOA0a
 vgey5lKrpdK19z23kmd11NT5FrZe3Al1YBndWjdzDJLdzAIwjxFT8htyh4u5/DkQUI5UUnfIpxx
 0fFR+xpl
X-Authority-Analysis: v=2.4 cv=TOlFS0la c=1 sm=1 tr=0 ts=68d2dc05 cx=c_pps
 a=GTrFB3HemkLL5/X2VaS9CA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=4u6H09k7AAAA:8 a=a2pQp0VUd_PqYuCmLQEA:9 a=QEXdDO2ut3YA:10
 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-ORIG-GUID: -AfMj9SqjdWOsvZ55ASD9EpbKSZ0WV_1
X-Proofpoint-GUID: 40aWYof2czTLpJlvuik_UnAx-oDty_LV
Subject: Re:  [bug report] rbd unmap hangs after pausing and unpausing I/O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_04,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200033

SGkgUmFwaGFlbCwNCg0KT24gVHVlLCAyMDI1LTA5LTIzIGF0IDEyOjM4ICswMjAwLCBSYXBoYWVs
IFppbW1lciB3cm90ZToNCj4gSGVsbG8sDQo+IA0KPiBJIGVuY291bnRlcmVkIGFuIGVycm9yIHdp
dGggdGhlIGtlcm5lbCBDZXBoIGNsaWVudCAoc3BlY2lmaWNhbGx5IHVzaW5nIA0KPiBhbiBSQkQg
ZGV2aWNlKSB3aGVuIHBhdXNpbmcgSS9PIG9uIHRoZSBjbHVzdGVyIGJ5IHNldHRpbmcgYW5kIHVu
c2V0dGluZyANCj4gcGF1c2VyZCBhbmQgcGF1c2V3ciBmbGFncy4gQW4gZXJyb3Igd2FzIHNlZW4g
d2l0aCB0d28gZGlmZmVyZW50IHNldHVwcywgDQo+IHdoaWNoIEkgYmVsaWV2ZSBpcyBkdWUgdG8g
dGhlIHNhbWUgcHJvYmxlbS4NCj4gDQoNClRoYW5rcyBhIGxvdCBmb3IgdGhlIHJlcG9ydC4gQ291
bGQgeW91IHBsZWFzZSBjcmVhdGUgdGhlIHRpY2tldCBpbiBhIHRyYWNrZXINCnN5c3RlbSBbMV0/
DQoNCj4gMSkgV2hlbiBwYXVzaW5nIGFuZCBsYXRlciB1bnBhdXNpbmcgSS9PIG9uIHRoZSBjbHVz
dGVyLCBldmVyeXRoaW5nIHNlZW1zIA0KPiB0byB3b3JrIGFzIGV4cGVjdGVkIHVudGlsIHRyeWlu
ZyB0byB1bm1hcCBhbiBSQkQgZGV2aWNlIGZyb20gdGhlIGtlcm5lbC4gDQo+IEluIHRoaXMgY2Fz
ZSwgdGhlIHJiZCB1bm1hcCBjb21tYW5kIGhhbmdzIGFuZCBhbHNvIGNhbid0IGJlIGtpbGxlZC4g
VG8gDQo+IGdldCBiYWNrIHRvIGEgbm9ybWFsbHkgd29ya2luZyBzdGF0ZSwgYSBzeXN0ZW0gcmVi
b290IGlzIG5lZWRlZC4gVGhpcyANCj4gYmVoYXZpb3Igd2FzIG9ic2VydmVkIG9uIGRpZmZlcmVu
dCBzeXN0ZW1zIChEZWJpYW4gMTIgYW5kIDEzKSBhbmQgY291bGQgDQo+IGFsc28gYmUgcmVwcm9k
dWNlZCB3aXRoIGFuIGluc3RhbGxhdGlvbiBvZiB0aGUgbWFpbmxpbmUga2VybmVsICh2Ni4xNy1y
YzYpLg0KPiANCj4gU3RlcHMgdG8gcmVwcm9kdWNlOg0KPiAtIENvbm5lY3Qga2VybmVsIGNsaWVu
dCB0byBSQkQgZGV2aWNlIChyYmQgbWFwKQ0KPiAtIFBhdXNlIEkvTyBvbiBjbHVzdGVyIChjZXBo
IG9zZCBwYXVzZSkNCj4gLSBXYWl0IHNvbWUgdGltZSAoMyBtaW51dGVzIHNob3VsZCBiZSBlbm91
Z2gpDQo+IC0gVW5wYXVzZSBJL08gb24gY2x1c3Rlcg0KPiAtIFRyeSB0byB1bm1hcCBSQkQgZGV2
aWNlIG9uIGNsaWVudA0KPiANCg0KRG8geW91IGhhdmUgYSBzY3JpcHQ/IENvdWxkIHlvdSBwbGVh
c2Ugc2hhcmUgdGhlIHNlcXVlbmNlIG9mIGNvbW1hbmRzIHRoYXQgeW91DQp1c2VkIGluIGNvbW1h
bmQgbGluZSB0byByZXByb2R1Y2UgdGhlIGlzc3VlPw0KDQpIYXZlIHlvdSBjcmVhdGVkIGFueSBm
b2xkZXJzL2ZpbGVzIGJlZm9yZSBwYXVzZS91bnBhdXNlIHRoZSBJL08gcmVxdWVzdHMgb24NCmNs
dXN0ZXI/DQpIb3cgaGF2ZSB5b3UgaW5pdGlhdGVkIHRoZSBJL08gb3BlcmF0aW9ucyBiZWZvcmUg
cGF1c2luZyB0aGUgSS9PIHJlcXVlc3RzIG9uDQpjbHVzdGVyPw0KSGF2ZSB5b3Ugb2JzZXJ2ZWQg
YW55IHdhcm5pbmdzLCBjYWxsIHRyYWNlcywgb3IgY3Jhc2hlcyBmcm9tIENlcGhGUyBrZXJuZWwN
CmNsaWVudCBpbiBzeXN0ZW0gbG9nIHdoZW4gcmJkIHVubWFwIGNvbW1hbmQgaGFuZ3MgKHVzdWFs
bHksIGtlcm5lbCBjb21wbGFpbnMgaWYNCnNvbWV0aGluZyBpcyBoYW5naW5nIHNpZ25pZmljYW50
IGFtb3VudCBvZiB0aW1lKT8NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gDQo+IDIpIFdoZW4gdXNp
bmcgYW4gYXBwbGljYXRpb24gdGhhdCBpbnRlcm5hbGx5IHVzZXMgdGhlIGtlcm5lbCBDZXBoIGNs
aWVudCANCj4gY29kZSwgSSBvYnNlcnZlZCB0aGUgZm9sbG93aW5nIGJlaGF2aW9yOg0KPiANCj4g
UGF1c2luZyBJL08gbGVhZHMgdG8gYSB3YXRjaCBlcnJvciBhZnRlciBzb21lIHRpbWUgKHNhbWUg
YXMgd2l0aCBmYWlsaW5nIA0KPiBPU0RzIG9yIGUuZy4gd2hlbiBwb29sIHF1b3RhIGlzIHJlYWNo
ZWQpLiBJbiByYmRfd2F0Y2hfZXJyY2IgDQo+IChkcml2ZXJzL2Jsb2NrL3JiZC5jKSwgdGhlIHdh
dGNoX2R3b3JrIGdldHMgc2NoZWR1bGVkLCB3aGljaCBsZWFkcyB0byBhIA0KPiBjYWxsIG9mIHJi
ZF9yZXJlZ2lzdGVyX3dhdGNoIC0+IF9fcmJkX3JlZ2lzdGVyX3dhdGNoIC0+IGNlcGhfb3NkY193
YXRjaCANCj4gKG5ldC9jZXBoL29zZF9jbGllbnQuYykgLT4gbGluZ2VyX3JlZ19jb21taXRfd2Fp
dCAtPiANCj4gd2FpdF9mb3JfY29tcGxldGlvbl9raWxsYWJsZS4gQXQgdGhpcyBwb2ludCwgaXQg
d2FpdHMgd2l0aG91dCBhbnkgDQo+IHRpbWVvdXQgZm9yIHRoZSBjb21wbGV0aW9uLiBUaGUgbm9y
bWFsIGJlaGF2aW9yIGlzIHRvIHdhaXQgdW50aWwgdGhlIA0KPiBjYXVzaW5nIGNvbmRpdGlvbiBp
cyByZXNvbHZlZCBhbmQgdGhlbiByZXR1cm4uIFdpdGggcGF1c2luZyBhbmQgDQo+IHVucGF1c2lu
ZyBJL08sIHdhaXRfZm9yX2NvbXBsZXRpb25fa2lsbGFibGUgZG9lcyBub3QgcmV0dXJuIGV2ZW4g
YWZ0ZXIgDQo+IHVucGF1c2luZyBiZWNhdXNlIG5vIGNhbGwgdG8gY29tcGxldGUgb3IgY29tcGxl
dGVfYWxsIGhhcHBlbnMuIEkgd291bGQgDQo+IGd1ZXNzIHRoYXQgb24gdW5wYXVzaW5nIHNvbWUg
Y2FsbCBpcyBtaXNzaW5nIHNvIHRoYXQgY29tbWl0dGluZyB0aGUgDQo+IGxpbmdlciByZXF1ZXN0
IG5ldmVyIGNvbXBsZXRlcy4NCj4gDQo+ICBGcm9tIHdoYXQgSSBhbSBzZWVpbmcsIGl0IHNlZW1z
IGxpa2UgdGhpcyBtaXNzaW5nIGNvbXBsZXRpb24gaW4gdGhlIA0KPiBzZWNvbmQgY2FzZSBpcyBh
bHNvIHRoZSBjYXVzZSBvZiB0aGUgaGFuZ2luZyByYmQgdW5tYXAgd2l0aCB0aGUgDQo+IHVubW9k
aWZpZWQga2VybmVsLg0KPiANCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gDQo+IFJhcGhhZWwNCg0K
WzFdIGh0dHBzOi8vdHJhY2tlci5jZXBoLmNvbQ0K

