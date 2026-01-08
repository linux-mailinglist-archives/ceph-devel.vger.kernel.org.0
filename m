Return-Path: <ceph-devel+bounces-4338-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EE2B3D05FFA
	for <lists+ceph-devel@lfdr.de>; Thu, 08 Jan 2026 21:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8D42730082EE
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jan 2026 20:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D5832B9AD;
	Thu,  8 Jan 2026 20:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PrExV1rl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4001432E6BF;
	Thu,  8 Jan 2026 20:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903099; cv=fail; b=iA1hMlZ39eHyl6NEQgAf6fsWBEbCSkQGRFVuHi/yPd6S0ReVOG0hWzOowEsXJefMFR/NQ3p5yutEFQiqkKfCWbvg0TQxwyH+Yx6tePggVEpJlAvpGIpMIQJAmjjqtoRqYt/H76FTDweBL4quqJ1IXWntVjpiDScvOgUoQWv7nHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903099; c=relaxed/simple;
	bh=yaukF5xfGDqvALgNYjLFBOTthA8T+hd9kb/SPRvB9mA=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=WqxxbNgrPiX7RlzwLPZRV4vusuZiqE9HIzjudjVWurO+1X7G3Dua8v3UZUmaBE0XXak6+rV6sV+fIxU0PSYiQmZvbwiun/x/xX+n1fMP+GjKS63wtExKvDCpOEO6mtZ7W4ymnQsRauLBfHBNuLgELKGLB/cG+kQtlDvaQNp6mi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PrExV1rl; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608AnSgE006214;
	Thu, 8 Jan 2026 20:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=yaukF5xfGDqvALgNYjLFBOTthA8T+hd9kb/SPRvB9mA=; b=PrExV1rl
	2Q83iIemQ3RLgDraperFsGbOSQFcbkTozpg76A0vrjRvHNMXhEiZu3VuQLyuPWmD
	+Wv9w0pOLV/e8EkLk1DGbf0eZZzLT3ETBcfq+5lYWgD47lj9RyBIps+o+foa5jEX
	44+xWFXewCVXGsrAV+Spr5eiFwDnun1Z2gJ7j+rIePOpuH4+PCWEcOJJ6dnKoHRW
	SdabVmKreiQbqrpA57EOTsEJkRtupLXYXlMU9bqlykTc3VGAKbZ0PnUHzVWHvfoj
	9in90JJHf6Bh1Ojw2DKu/EfLSD2HTEm0nhuuhTTjF5imhdB4BBaPZrwjATXSI5XL
	oYkE3YbtTbuLPw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqg7hv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:11:32 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608K9G6W018361;
	Thu, 8 Jan 2026 20:11:31 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqg7ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 20:11:31 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=meuaE+sEfQGcu98f8CI75j6MhlcKjPTpz84sOcSn+ly5TmqqjB/xGJVcqj9JkDnCmZR5GO5DSSrqf556oljWuoDr/YnNH/M5ZIGg7Lsahnx3QfkEBKC9ZHfZ5//Eadp6TjRFPJfXHiBbEJ66U9/MK/rIumizP29l9Kmkwz2+8w6tqGaiB1Yw+2ogEhlf6qC9r/YO8I3ocKJz1Fn+xKXP9O41IIEAAxPg2PUy5W5ATj1aVr3SBGqwoANVD+bL14zViTcB3pVF2KPUeAFh1KWDJGCVVk8V7YEITTKZHf0M0VidvhRbU2INiZAlBYcuEkJxpN4O5o8JC2oQCnJ5w7n4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yaukF5xfGDqvALgNYjLFBOTthA8T+hd9kb/SPRvB9mA=;
 b=EV/WU7n8KWB4AygNvEHOcSov381HBS0AebQW99F31zpp8kSxQSwcknvvispdbJICIGC1oa5rcn0abC/qmC/WnvNLsY5CufmPJHNUOqFsZ5U3caF9lma6v4LuHPcAD+9IjildgnY42MqwG5Aceqv58+N+1z6ktJbwdUyng5fN2DpSRNQnh1QxhK5yg69L50O/BhLvDGQPXwaN63c7/cy0GbCXW6urA1+Ls1hJ8x7Oe3bHlFvBSNxMp2FZW7hHje31BC3BYKattzfST6Jb1YMEwZS7VMm3xg4sQJkbdCDn7R8QL8WToJQeZpn2he1fCFHmweF0i4hUkLuwd378ZfTS2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB4834.namprd15.prod.outlook.com (2603:10b6:a03:3b5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 20:11:28 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9499.001; Thu, 8 Jan 2026
 20:11:28 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        "cfsworks@gmail.com" <cfsworks@gmail.com>
CC: Milind Changire <mchangir@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v2 4/6] ceph: Split out page-array discarding
 to a function
Thread-Index: AQHcgBjp+JhKfZQ3IkWj4Bu08GPBK7VItb6A
Date: Thu, 8 Jan 2026 20:11:28 +0000
Message-ID: <5ccf108f4d05b89c9939fa4dc0a0410f5ad7b887.camel@ibm.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
	 <20260107210139.40554-5-CFSworks@gmail.com>
In-Reply-To: <20260107210139.40554-5-CFSworks@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB4834:EE_
x-ms-office365-filtering-correlation-id: 32dfb08f-d46a-49b0-35db-08de4ef21b75
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OTAxNEYxVmVSN05iRkwyT3psUlQ5MEVISzFjQVRFRk5tMkRvRkQybk50QVdl?=
 =?utf-8?B?anp2OTFWUm5tYjYwY1lGRzhTK2xkVkJLUXY2bUt6M1FQSlVIZXpHOWxnU0Np?=
 =?utf-8?B?bFhzaDlKZG9GWlI2R2tCV3NVQWtRcHI2aTZWekN1VXRpTmUvVGFBWVJLRDZm?=
 =?utf-8?B?TnVrWjUyN3gyMkdEc1V0UUR3NkdqZzQ0Z3QrUjFJdndMbTJyMUxINTA1TVJr?=
 =?utf-8?B?dG41OXNiZG5INTVLd1A3b0JabXBPWXF5dmZmQ25WM2phQUgwOTFtOENFaUla?=
 =?utf-8?B?aEpBR3QzUGxjNDNoTkJ1aytLNnFLYWtOOHBQYlNwbXVrMFdOeDFpbVRZZU5z?=
 =?utf-8?B?VVJrWXpwT0JNeXlUZWQxTnQ1eTBzUW9jZTdkTmYyK29RNFR3T25neFg4VmY4?=
 =?utf-8?B?alJEVEVGNXJtRW5uTmFHNDlpNjdWYnNWNnkzZXFQQXc3R1l0VW96TkJ0QWF5?=
 =?utf-8?B?RnVZZzIwZDRmaU9hUmQrODNPOWdDZnJ5d0FQblBiaUUxT2VpQTVJSmpVSXFM?=
 =?utf-8?B?cUN6MGJ0RUNJSFpOYmNRZEszNExDVHJ5TDJ3bmtHUkxXUFc2M0RTbFRaMkVH?=
 =?utf-8?B?VEVEcnZjS3JnWXkvdjZxaVc0SVBzOEoyVXArMmJPcS9hQ1hPOVM0TEtZallO?=
 =?utf-8?B?U2pXQ3VqZk01VUF4WlZYVWpOQnhxWWdNWWl6SjE4cGt5RFZDZ09IY1NYZW1a?=
 =?utf-8?B?R1V0bU1zdWRTcERXZGJYQnJUQkxha2pxcmc2WkI0enIvT3pOVi81bkVmK09W?=
 =?utf-8?B?WDBXTTR3bVo5RFZqQ0VrakNCN3NXblJoY0dFTm5DN0VGV25wWnBLem5WV3Vm?=
 =?utf-8?B?bTBDUXYwVFZndWxMdHdtbUJsUEZpTmlCaTZEdGFVRXlGclZNUFNpMnZLb1hp?=
 =?utf-8?B?ZmJTUGdIU0xkK01QMjgrMTYxUjdncXdaM1BiWXlianpHVXk0d3hqV3VWYlZL?=
 =?utf-8?B?RVQ0a2xEV3ZLNmVvOFFya29kWnZWdzZ5N09EZzBTdWthYWl3NndMR3ZQcnJB?=
 =?utf-8?B?a203WWphcldrd1A2UkpwbjJlVEVNTjA0K1NvU3k3ZmRuVmhJTkdOemhVT0dT?=
 =?utf-8?B?VkxCbXk5UEh3bVFwK3B5WU1Xa0JTKzV2K1YwZW56M2NwNEhKLzVOc2p6VzlY?=
 =?utf-8?B?SDIzNm9NRHdtS2JCQ05EeVNNV20zWFdlTmo0d0JtcFNIWnlDcU1nQ3pwbHlq?=
 =?utf-8?B?MEVuN29wVHA4akkvZElVSko0bFRTai9vV2xhOHhUdlBBQjZNRnhMdVBPT0FR?=
 =?utf-8?B?c2E4SEU4UHczSEhPTWgzb05BWE1lb3V5aWY2RFpnU1EwdnJHMEhMNXJoTEFq?=
 =?utf-8?B?QWk2dGg3Lzg3TXUxQ004ZnNVZ2xzY2JuLzhRdW5vbDdGd2ZhN2xxbEVXczNn?=
 =?utf-8?B?clNONUdEMDBBOHhJQ2pTQ3FtTmU4VTRCajk1VXVrMjJBbjY5ZGhOUWkzTGds?=
 =?utf-8?B?cmJtb1ZVVFRjdlQrcDhzYlZQSjhUWEtKYjlnc2RwbVo1MU5aa2c0d1hURVFs?=
 =?utf-8?B?bno5Zm9Wc0llNlhBZEhwUENlMHVIUmNZazhZQlduY2ZBb3QxSFE5S0xLVjhp?=
 =?utf-8?B?VHhsQkkzbnZQZzQ3ZlRVRDl2YzJmamlMN2dZM01JZE5wL1kvT2grY2o5MDU1?=
 =?utf-8?B?aEd4ODBCaWVsYkNSMTJ4T3B2NlVOYWh5NDU2eUsreWcvOGtXLzF4K3kyem1P?=
 =?utf-8?B?WXV2YThtVjNpMUxsSHVidkxvb1A2L2NSV1FnQ1AzUW5WeGVCdTJRYktOSGlv?=
 =?utf-8?B?ZDJ4SGlReGt0djhFOFNPZTJNWFRvbVhYN2J1MFkyQWEzT1h3VGIva3ZaUStR?=
 =?utf-8?B?ZUdralZNblEzd2hZRnVJcy8ySmpVc09VaUEzUVZYYVA4YUNkYkRqdkdsTno2?=
 =?utf-8?B?akVRa0hQUnMzRFV2Z21XZldLWjdsYVBWOFVaZXY4eWZ1aUE5dld4czZkZ3NZ?=
 =?utf-8?B?M0tuTDJGNFVlc1ljRzJ2aFFEdmZIOHFBSERKR1VQK0FDcTc2MndpZTFwc0Vy?=
 =?utf-8?B?ODFQclJKM05USnF1b3ZsejR0Q1FVTmZ5MjZZQ01iT09kOUoxYU1iZGhtaTR1?=
 =?utf-8?Q?HD6yxu?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Vm5rUDRxdjN0dFZ4TTgra2pKc2dsZzVIWjBBdkJLamFBUHVlYVpQR2hXRkJ1?=
 =?utf-8?B?eDIxVkxpcUZwMEtBN1hzaTRrZjZHQ2t4T1NpTC9UQzRKcUhQQVhEZ0NKSFZq?=
 =?utf-8?B?eHhmb1BtQWFwcDQ4OXRTWFpUcWlZSmZVb21meVBnOGRUUjlIcUFaUGNZWGZD?=
 =?utf-8?B?Rk9jcDNUeldubFFXZHJNaW1LWjEvODNxNE8yemlhMm9qdDVDdkRrU2hjRmxk?=
 =?utf-8?B?d2lrUUswa3lSL3Y5TWFSQmI4Z1c0QjU4cmVJdVk4Z3ZEbFVGczRvcTZYT2hr?=
 =?utf-8?B?NnMwMnZLcTluM1pickFEcDB0blFQMWhGOW1uVWsvYkNnajBsSG56djhMWjNj?=
 =?utf-8?B?c09zTndUcjB2NjNqYkRac3FyNDdDcW1YVS9zbHdTSFY5UEUyei9GZGpYRjFj?=
 =?utf-8?B?Uld3cnhVRG4vNDNKdzB4czd1R1hMdVJwYnRkbEt4NG1lbWxkVVFFVnpqU21q?=
 =?utf-8?B?T0RESUMyNklETmQ3cGJvL1cwZUJjMlNPL25wN0QrbnV3OTN3VUo3RG1pZ0Vj?=
 =?utf-8?B?aksyRVZucUxWK1E1RzBVeFdmOE51MGNNRUx2eDZCZzZ5SVllSU5ZMWU1bXBi?=
 =?utf-8?B?endvYmV1dVFOYmoweUhqZWRNYzRFb2dPc3BJa3haWjZ5Q2c3SjUzT1EzclQ0?=
 =?utf-8?B?N3FORVZSS282WU13V21aTUFkOE5ubzg4OVNYSkttVWVOUFV0VnRCdTl6cTgz?=
 =?utf-8?B?YXB3R1JhclZUUjJFcGd1N01GV0VML3orNmFROUxlS0FtVzlwWnFybHNrNXlG?=
 =?utf-8?B?eFdqUjREWWpZbEIrSnMweVcrSFI1VFpFQUV5QlMzK2Z2czV1SHM4VjdmOWxZ?=
 =?utf-8?B?dytRdk5kVE1STndxRHo2WHpMbHV0YXF4SjhYbElwVXc1QnMwazc4eTlOVHhv?=
 =?utf-8?B?YkNEYXBaazVlU2V0NVAzOHFGUExuUG82SkxwZ0NXOGVyNHdZdDhvRHVmQzdu?=
 =?utf-8?B?K1RWU1NFdWFWekJxZlgzRFVNVmVlcnk2TWo4MkZCN2NTcXV3emtENVlXbjVG?=
 =?utf-8?B?S3ZWdW1lRSt3Y3NkSFJXaGVWUFhKVUFiZjFQM05hRDJ4WlFNaTAyRzJSSWw0?=
 =?utf-8?B?Snc3YWMvT0pXMFlMS21nTkRYVE5vcy9raG95QnRHT3hWcU9Fb0hwNjRhN1Fu?=
 =?utf-8?B?RDZMbDFtTlVHaFgvaXNRUkRrMDR3cDFMV1ZWdWhuL0FyeVMzUTVWRldUcnQ5?=
 =?utf-8?B?YU1zWVZYN3hoN1ZCdG1taTc3S2lWV2FQTFZJVWs1SVNFR0VwOWk3UC95RkRh?=
 =?utf-8?B?MDk1QlI5OVpBS2FoM0FrU1hjbkdBNzhNRy91djdvamV6NStlRWt2WTBWVW92?=
 =?utf-8?B?T0FPOExKSGV2emxpTUpvem1YbkZvdXZLM0Z4akVFVUE3Vm1GN1RuUmRPd3oy?=
 =?utf-8?B?NG5HR1pvb0ZiVnNZVVkwVXJGQitGbHcrSVFMUERkUDg1eTNmTERZZ05YRzVv?=
 =?utf-8?B?Mis0VlRsdXRsL08yK3N2YWlpeTE4Q2o2c1cyek5SSEpXWk82RDduVWNYZ1lF?=
 =?utf-8?B?K2NZNHZUSG9JT1dacTNXWVlQczJrN0MyTU9EVjIrSSs1cmZhTjVOTGdZdVZw?=
 =?utf-8?B?WnRkVHVvb3dDMjJZcjIvZXJwcnlkUDBYMW0wKzlqcVVmT2lXTm1FRGgzdzU1?=
 =?utf-8?B?cTgrWlJrN004Z3dlRitVVzZ1K2lERC9kVENEQk5sRDB4Wk5RbEpPcmg4a2kx?=
 =?utf-8?B?RitVYjBmNlFFVXJQQTQyWHRDY1VmWSt1b3AwNmJkNU81WFlraXlKUmsvN1ht?=
 =?utf-8?B?UWk1ZG9YbW4zUnFqRFk5YUs4T25KVHRhNzZyUmJuRjdwVzFzcC9EWTJLaVFT?=
 =?utf-8?B?QUVkTHI2RWFFeS93RzJISnNRUkNSdDZIQmhnc1YvLzlFTTJtb2hKUjVsdHgr?=
 =?utf-8?B?Qlgwd241SEVqVUZPWU1VSW1oQThBdmZ6YXlZaXdRM0cxSDB5bGVsUEs4OUp0?=
 =?utf-8?B?SmVoaW9OcHo5UWFkdmwwVnQ2bXNZd2lzZnJWZU96dG1RQnlEVjdFMzhOWmFI?=
 =?utf-8?B?ZWJWNzdUVk1ZTEhPa2orNkpiK1pQMEQrQnNOUXhwNjl4OXM0clJNbWtiRkdS?=
 =?utf-8?B?dWhIaGRtRXl3bWw4TEdRUW9ScVNRd0thQmRrT21VY3kvQTdlaUFqSnN5emtw?=
 =?utf-8?B?aDRVWTdCQVpVR2cwNDNjNmllVE1DK1U3VEhzUUFpSzdJUW5ZclRZc0dGYW8r?=
 =?utf-8?B?cjE4aXVJTjA2Z21FN2U0OUV5SytxckFYUVEyVS9iSk9XSzE2SC82STV2WjZs?=
 =?utf-8?B?MDZvOXF5NW05cUZaMTFnajFvWTJ5OXc0dk9wRkRLTkhSM0NVN0FGV3dPa3ND?=
 =?utf-8?B?WWxFTVRaMnpzNW5KUUx6Zm40YXpua1pWTG5lNnY1R2dvcnd1OE9Na2NNUzhV?=
 =?utf-8?Q?r10VXVL9GeBJPddpfpTgS6Vj/u4/cmRA9jMm+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E985748C99949E4890AD85B4EE8D11EC@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dfb08f-d46a-49b0-35db-08de4ef21b75
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 20:11:28.2666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1u4I3aQ689tGkZWHnEHrGppsYp0EmZrUo0mEn5ZygHC9iudiEmtSGHDOGjuHiQN8FOvaYVfiv4ZrKKvR+HYTVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4834
X-Proofpoint-GUID: fFSwqRkCpBAm26ODG1MLhK1mFmYioOUj
X-Authority-Analysis: v=2.4 cv=Jvf8bc4C c=1 sm=1 tr=0 ts=69600f74 cx=c_pps
 a=LPqnct3xGwQwGN9n+XDEZg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=Xb1VMMrZhxOK7UE7ixYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XuMGbv6G30ffWK5VhuO45h6GClD-LjEj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDE0OCBTYWx0ZWRfX3JMrkFQb5QsG
 pERmhkQT68DsAWqyAPPIcPihsubFEQa7il0WIJRVVimnPq4kZXW5p6alOz0G/OP8G97LwZwpMxu
 qE2DwD1MLkxwNkrqrt4oN4oqcUCIe5j8g2WEXdemmkQq8lo5dTSu06YJAyFyB+Di/EqVCL157Vg
 KdptvTN2oCSmsujckAeSL8lJ3xdvcOioP5oyphB8lh5yXgmQ8683vqfFkt0DYid48tRn98Fr4na
 WGJsIb+fIv03/RDgmpho2o89qP5UntErRwuq3MzYr6SDl/UIQgCy2WF4+a8JbYpiUH4bBkJqoWo
 T8+26eh5P1fcROyxREhK8830/YkkIM5rmaUsr++JA4L791wQXAT80oqxfo1LetPUkm8LHc+N/l3
 zKljLhWqSCMXaQg6ED5i1IeH6WLfNTisc7Drs+ABvaeG/NB0gL7g0EJvb8kU7H69sYKVKSqxlCh
 QN8Po7sbOTlEs9bYvGg==
Subject: Re:  [PATCH v2 4/6] ceph: Split out page-array discarding to a
 function
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601080148

T24gV2VkLCAyMDI2LTAxLTA3IGF0IDEzOjAxIC0wODAwLCBTYW0gRWR3YXJkcyB3cm90ZToNCj4g
RGlzY2FyZGluZyBhIHBhZ2UgYXJyYXkgKGkuZS4gYWZ0ZXIgZmFpbHVyZSB0byBzdWJtaXQgaXQp
IGlzIGEgbGl0dGxlDQo+IGNvbXBsZXg6DQo+IC0gRXZlcnkgZm9saW8gaW4gdGhlIGJhdGNoIG5l
ZWRzIHRvIGJlIHJlZGlydGllZCBhbmQgdW5sb2NrZWQuDQo+IC0gU29tZSBmb2xpb3MgYXJlIGJv
dW5jZSBwYWdlcyBjcmVhdGVkIGZvciBmc2NyeXB0OyB0aGUgdW5kZXJseWluZw0KPiAgIHBsYWlu
dGV4dCBmb2xpb3MgYWxzbyBuZWVkIHRvIGJlIHJlZGlydGllZCBhbmQgdW5sb2NrZWQuDQo+IC0g
VGhlIGFycmF5IGl0c2VsZiBjYW4gY29tZSBlaXRoZXIgZnJvbSB0aGUgbWVtcG9vbCBvciBnZW5l
cmFsIGthbGxvYywNCj4gICBzbyBkaWZmZXJlbnQgZnJlZSBmdW5jdGlvbnMgbmVlZCB0byBiZSB1
c2VkIGRlcGVuZGluZyBvbiB3aGljaC4NCj4gDQo+IEFsdGhvdWdoIGN1cnJlbnRseSBvbmx5IGNl
cGhfc3VibWl0X3dyaXRlKCkgZG9lcyB0aGlzLCB0aGlzIGxvZ2ljIGlzDQo+IGNvbXBsZXggZW5v
dWdoIHRvIHdhcnJhbnQgaXRzIG93biBmdW5jdGlvbi4gTW92ZSBpdCB0byBhIG5ldw0KPiBjZXBo
X2Rpc2NhcmRfcGFnZV9hcnJheSgpIGZ1bmN0aW9uIHRoYXQgaXMgY2FsbGVkIGJ5IGNlcGhfc3Vi
bWl0X3dyaXRlKCkNCj4gaW5zdGVhZC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogVmlhY2hlc2xhdiBE
dWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhbSBFZHdh
cmRzIDxDRlN3b3Jrc0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9hZGRyLmMgfCA2NyAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDM4IGluc2VydGlvbnMoKyksIDI5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2ZzL2NlcGgvYWRkci5jIGIvZnMvY2VwaC9hZGRyLmMNCj4gaW5kZXggNDY3YWE3
MjQyYjQ5Li4zYmVjYjEzYTA5ZmUgMTAwNjQ0DQo+IC0tLSBhL2ZzL2NlcGgvYWRkci5jDQo+ICsr
KyBiL2ZzL2NlcGgvYWRkci5jDQo+IEBAIC0xMjIyLDYgKzEyMjIsNDMgQEAgdm9pZCBjZXBoX2Fs
bG9jYXRlX3BhZ2VfYXJyYXkoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ICAJY2Vw
aF93YmMtPmxlbiA9IDA7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbmxpbmUNCj4gK3ZvaWQgY2Vw
aF9kaXNjYXJkX3BhZ2VfYXJyYXkoc3RydWN0IHdyaXRlYmFja19jb250cm9sICp3YmMsDQo+ICsJ
CQkgICAgIHN0cnVjdCBjZXBoX3dyaXRlYmFja19jdGwgKmNlcGhfd2JjKQ0KPiArew0KPiArCWlu
dCBpOw0KPiArCXN0cnVjdCBwYWdlICpwYWdlOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IGZv
bGlvX2JhdGNoX2NvdW50KCZjZXBoX3diYy0+ZmJhdGNoKTsgaSsrKSB7DQo+ICsJCXN0cnVjdCBm
b2xpbyAqZm9saW8gPSBjZXBoX3diYy0+ZmJhdGNoLmZvbGlvc1tpXTsNCj4gKw0KPiArCQlpZiAo
IWZvbGlvKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJcGFnZSA9ICZmb2xpby0+cGFnZTsN
Cj4gKwkJcmVkaXJ0eV9wYWdlX2Zvcl93cml0ZXBhZ2Uod2JjLCBwYWdlKTsNCj4gKwkJdW5sb2Nr
X3BhZ2UocGFnZSk7DQo+ICsJfQ0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IGNlcGhfd2JjLT5s
b2NrZWRfcGFnZXM7IGkrKykgew0KPiArCQlwYWdlID0gY2VwaF9mc2NyeXB0X3BhZ2VjYWNoZV9w
YWdlKGNlcGhfd2JjLT5wYWdlc1tpXSk7DQo+ICsNCj4gKwkJaWYgKCFwYWdlKQ0KPiArCQkJY29u
dGludWU7DQo+ICsNCj4gKwkJcmVkaXJ0eV9wYWdlX2Zvcl93cml0ZXBhZ2Uod2JjLCBwYWdlKTsN
Cj4gKwkJdW5sb2NrX3BhZ2UocGFnZSk7DQo+ICsJfQ0KPiArDQo+ICsJaWYgKGNlcGhfd2JjLT5m
cm9tX3Bvb2wpIHsNCj4gKwkJbWVtcG9vbF9mcmVlKGNlcGhfd2JjLT5wYWdlcywgY2VwaF93Yl9w
YWdldmVjX3Bvb2wpOw0KPiArCQljZXBoX3diYy0+ZnJvbV9wb29sID0gZmFsc2U7DQo+ICsJfSBl
bHNlDQo+ICsJCWtmcmVlKGNlcGhfd2JjLT5wYWdlcyk7DQo+ICsJY2VwaF93YmMtPnBhZ2VzID0g
TlVMTDsNCj4gKwljZXBoX3diYy0+bG9ja2VkX3BhZ2VzID0gMDsNCj4gK30NCj4gKw0KPiAgc3Rh
dGljIGlubGluZQ0KPiAgYm9vbCBpc19mb2xpb19pbmRleF9jb250aWd1b3VzKGNvbnN0IHN0cnVj
dCBjZXBoX3dyaXRlYmFja19jdGwgKmNlcGhfd2JjLA0KPiAgCQkJICAgICAgY29uc3Qgc3RydWN0
IGZvbGlvICpmb2xpbykNCj4gQEAgLTE0NDUsMzUgKzE0ODIsNyBAQCBpbnQgY2VwaF9zdWJtaXRf
d3JpdGUoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsDQo+ICAJQlVHX09OKGxlbiA8IGNl
cGhfZnNjcnlwdF9wYWdlX29mZnNldChwYWdlKSArIHRocF9zaXplKHBhZ2UpIC0gb2Zmc2V0KTsN
Cj4gIA0KPiAgCWlmICghY2VwaF9pbmNfb3NkX3N0b3BwaW5nX2Jsb2NrZXIoZnNjLT5tZHNjKSkg
ew0KPiAtCQlmb3IgKGkgPSAwOyBpIDwgZm9saW9fYmF0Y2hfY291bnQoJmNlcGhfd2JjLT5mYmF0
Y2gpOyBpKyspIHsNCj4gLQkJCXN0cnVjdCBmb2xpbyAqZm9saW8gPSBjZXBoX3diYy0+ZmJhdGNo
LmZvbGlvc1tpXTsNCj4gLQ0KPiAtCQkJaWYgKCFmb2xpbykNCj4gLQkJCQljb250aW51ZTsNCj4g
LQ0KPiAtCQkJcGFnZSA9ICZmb2xpby0+cGFnZTsNCj4gLQkJCXJlZGlydHlfcGFnZV9mb3Jfd3Jp
dGVwYWdlKHdiYywgcGFnZSk7DQo+IC0JCQl1bmxvY2tfcGFnZShwYWdlKTsNCj4gLQkJfQ0KPiAt
DQo+IC0JCWZvciAoaSA9IDA7IGkgPCBjZXBoX3diYy0+bG9ja2VkX3BhZ2VzOyBpKyspIHsNCj4g
LQkJCXBhZ2UgPSBjZXBoX2ZzY3J5cHRfcGFnZWNhY2hlX3BhZ2UoY2VwaF93YmMtPnBhZ2VzW2ld
KTsNCj4gLQ0KPiAtCQkJaWYgKCFwYWdlKQ0KPiAtCQkJCWNvbnRpbnVlOw0KPiAtDQo+IC0JCQly
ZWRpcnR5X3BhZ2VfZm9yX3dyaXRlcGFnZSh3YmMsIHBhZ2UpOw0KPiAtCQkJdW5sb2NrX3BhZ2Uo
cGFnZSk7DQo+IC0JCX0NCj4gLQ0KPiAtCQlpZiAoY2VwaF93YmMtPmZyb21fcG9vbCkgew0KPiAt
CQkJbWVtcG9vbF9mcmVlKGNlcGhfd2JjLT5wYWdlcywgY2VwaF93Yl9wYWdldmVjX3Bvb2wpOw0K
PiAtCQkJY2VwaF93YmMtPmZyb21fcG9vbCA9IGZhbHNlOw0KPiAtCQl9IGVsc2UNCj4gLQkJCWtm
cmVlKGNlcGhfd2JjLT5wYWdlcyk7DQo+IC0JCWNlcGhfd2JjLT5wYWdlcyA9IE5VTEw7DQo+IC0J
CWNlcGhfd2JjLT5sb2NrZWRfcGFnZXMgPSAwOw0KPiAtDQo+ICsJCWNlcGhfZGlzY2FyZF9wYWdl
X2FycmF5KHdiYywgY2VwaF93YmMpOw0KPiAgCQljZXBoX29zZGNfcHV0X3JlcXVlc3QocmVxKTsN
Cj4gIAkJcmV0dXJuIC1FSU87DQo+ICAJfQ0KDQpUaGlzIHBhdGNoIG1ha2VzIHNlbnNlIHRvIG1l
LiBMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogVmlhY2hlc2xhdiBEdWJleWtvIDxTbGF2YS5E
dWJleWtvQGlibS5jb20+DQoNClRoYW5rcywNClNsYXZhLg0K

