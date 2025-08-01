Return-Path: <ceph-devel+bounces-3348-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DC8B187F5
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 22:06:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BA8B18900F0
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Aug 2025 20:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D154C19CD13;
	Fri,  1 Aug 2025 20:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="p0IMrycY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AB0DF71
	for <ceph-devel@vger.kernel.org>; Fri,  1 Aug 2025 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754078771; cv=fail; b=OuReOecXwAubGxKG+ZTQKt+AuqORo0oXflw8hfAxA1OeUArJWUc4rcWO8hDrmVAeY7MNZVn3h6WozLaeyAKuZr6XZoggd13vilCjR3eGVsgx9sSPEMNpQYtQvU6CH0wSGbYkXAB1K//ebyLsaL+cDFk4HEyWnb64xbXZKA02EUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754078771; c=relaxed/simple;
	bh=8W3rcpdoUozJZsaF7y68My34grtK5mcznMlIJLXGoJg=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ad82d89AU+d/9iIOjHgrTOhuDpTyGQTmdHZgCkQCGyCI45kpqIclu/DAYcFtbzQSZELzrVIsznbVsZjONFjcjYSI4/PoRJ5XgWiptWOXLM2nkQTWlm7BXi1xIfaL9E70GzUzoQ5RqF86F2WRfAjEVL47aEEMwvxa2hMiPcSd77A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=p0IMrycY; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 571Ai541015698
	for <ceph-devel@vger.kernel.org>; Fri, 1 Aug 2025 20:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=ZVQUapVKvkKda3k2NH5xVS53rGAaZOwVTRBbiwlGfac=; b=p0IMrycY
	Dngqfu9ns2EJNpy/RZVC0u27g4SvWOTwkO4QT3+Aoak2rJPePn9HIJEIeCz6aG+9
	hYacX8xZrUKkFVgkPw4hEMerA9tMgFWh7+LrdyLY0ZkbvDscUbgxJ/IJbk1Qwzks
	Q3iblQmMhsXRPFAZgjAbvMsa4Y9C1vvVuRFWgjXiTXHSI2YsGoE1dgQlsH/NkHy+
	xzq+eBL3fw6q1XXexwqNyu/BX2cKrAM0XgyiunThTdAQ/yhcbTUjz0KQm5RMAW4E
	zFFSSh62dqS2rk/eDpsgalY3Ho6wzJKyRkeWMVZ6ktQj1r8SH1GZm1Xk/iyAtOO8
	Ft0ea1S2zObMww==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfrarvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <ceph-devel@vger.kernel.org>; Fri, 01 Aug 2025 20:06:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 571K46lc020020
	for <ceph-devel@vger.kernel.org>; Fri, 1 Aug 2025 20:06:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfrarvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Aug 2025 20:06:08 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 571K5DNa022151;
	Fri, 1 Aug 2025 20:06:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfrarvh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Aug 2025 20:06:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icnPWOYQCOX4Rre+jlp92o1zC/iHBYeSeEw7/YSdqCEI11rrHzvOmlpldcOPPnPeqdmV9HpWZzdMHCreirL/bvbQCKUoSB1ULhbbTjbu/FOHT+ZLJ3SRJAWE9HYfBD+BJe7mpKKKA7MCQuu0Gb3qPubrycysNhFZTohYSAG+NC0MQ3EBeCP5Vrvk3p/3oznFbRBkvegGaONKNHuFw6p63tcoVFkuhlDSuojMz5SXzmcLCabBF1vil7pebkuP29FGWdc1zfiOCYNV11uwVKTP6LABCaT1T/y3eG4S626q+kXy/32xu2JXuFtz82DC37iTa6Qa8RZ+MN72oFVjst9cwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqbUYfOIgsdpfVdgp6p11Wx6PRFweD6qHaIgP5V+Tz0=;
 b=hSDk5mjlpWrYmwIIt5b674pSSOaT8CE/YucebKL73mfwJ5VLwUz7x96JQsTlpVh9QZjA4JN/CnFAA+86aOjHaMLdjqu9qYUJ4jSCgjg7HbRWwit/nFqxoAOc6DkFhFOUGS7uVNX5LJYKBCyk8d/WqugTAUI4M9UsMfk7VVON7d0WAmVtufKD7AKqkW6147TRGGyu27PmO59jdTSsbdyrm3yujM94Xco/Kmes5iqVCZ4tYYaEj90yoH+4hnHByW0tkgLdbz3rqsI67nMis6HMAbqjFcNTMR4mlrFL8GSk6+GQQKU6hgecRZOmLKNN06lL1z5IwXq0ktgh6Pv5Gz5e5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by BY3PR15MB4836.namprd15.prod.outlook.com (2603:10b6:a03:3b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 20:06:03 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%7]) with mapi id 15.20.8880.026; Fri, 1 Aug 2025
 20:06:03 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Kotresh
 Hiremath Ravishankar <khiremat@redhat.com>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        Alex Markuze
	<amarkuze@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Venky Shankar
	<vshankar@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH v2] ceph: Fix multifs mds auth caps issue
Thread-Index: AQHcAwuWpZp2fJS0EE6Ajt0uFZcNfbROOVKA
Date: Fri, 1 Aug 2025 20:06:03 +0000
Message-ID: <176b3dae20ab86155b34e8707fed79fc597c5d20.camel@ibm.com>
References: <20250801173944.61708-1-khiremat@redhat.com>
In-Reply-To: <20250801173944.61708-1-khiremat@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|BY3PR15MB4836:EE_
x-ms-office365-filtering-correlation-id: de3cc3c0-0bda-4fec-52c4-08ddd136d7fc
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NFZ3bTRROWhSWGxheVM5UEtraHFmamxpVEJud0s5RmJkWWgxdnRMdEpvd2ZS?=
 =?utf-8?B?b3lqak94Rkt4eU51eFBvSzQxd2NYRkl6V29jSU5xVjZNN0Z0bnVnWUdFVFhT?=
 =?utf-8?B?Z3R3NzVxSlMydDhFR1NTS1dta2lUZy90cERKdTNGeEpJZXN2Z0dSQTZnd29y?=
 =?utf-8?B?Y2E2NVU0RGZYRmozdjZKb0IyMXI0L1N4d1VyR1lSQlZ3YXNaZEFGMjZraEZF?=
 =?utf-8?B?TnhjcXlpM0I1ZmMwT09aeDcwaHJRNGRjOUFrQ1BYUGFCeEpOdDYvL1ZCTith?=
 =?utf-8?B?bW5YUzIxTnFrMEpNWWFMMjU0SnBqYjFhWEY1R0ZMY29wNmFTa01tb1p6M2c2?=
 =?utf-8?B?cnlwK0ZoWVVuaElDSk1kN3AyZVVscFplcFczZmhvc3NjRW9qN0VYdWNWcHNF?=
 =?utf-8?B?WkY5cHdYK2g2a2VxZ3J4c2k4TW8vOGk4QU9qZ2VZaFNVL0d1OFkzU0YvMGlR?=
 =?utf-8?B?elRQalRvTFNUYmVwd21oMGluQmt6YzNNM1ZramJjQWlDWi9wNlgxYmZEQ0t3?=
 =?utf-8?B?UG1EbnlDNyt0T3ljVjcyZnJiSE8wVGpOS1NuaC82OXN5YnpjTmFyRHJabWZk?=
 =?utf-8?B?Mmw4cFBTQ3hVSlZZMjNUSExVaDMyTzVmVmh2cHBDZnBybXYyRm9OcWZKeHkr?=
 =?utf-8?B?d2hjZ3c3dGR6Ti9vVGxFRng5VEtCbWdEK1VZeEcybnZvL2oxc3VhQUpsVjhE?=
 =?utf-8?B?Q1lOR1hGdlp0L2ljaDRhdVRYRnFBZDV3dUMvZFIwTFEvY2hVWTJ3VngxdXRj?=
 =?utf-8?B?WVpJMm9HMWxncXpsQUZRb1pybUVHajVmTWhhMGdaZE40VUhKV2FkODZWOVhF?=
 =?utf-8?B?NEZjSEozVWJ3a1k1VXhKWlJyNE1aVFRNNXhPZ3NtZ2FYekZIZDkxRFdFTW4r?=
 =?utf-8?B?N041ajQ4QUpORFp5MEdWdkVrTkdEendjTWZzbU1haVJwSFpGaHQzSlVkZ2Nl?=
 =?utf-8?B?aUczalJlSmhzS2YxS3NjQ05MT1lHYlZpWDE0ZWdYK0xzRW5RdEVPWHJwV2JH?=
 =?utf-8?B?amV5SkZacE5GQWsvRDBnWnp6a20rRElSaStsbjVwRUt1Vkc2YXBFdXJIdGQ0?=
 =?utf-8?B?ZkdSQkd6MEhYZkRqZzBITTdrSzVtR1JHemhsbzQ1bWhWL1BJWXhVZkRpUlJW?=
 =?utf-8?B?SHh0dlhkcVlwUGpTZTY5eUtmc2pNUHVuNktBVkthUWJZYkxiRnF6aS9kWGJm?=
 =?utf-8?B?TEQwR25ZL1N6K2ZmYnZkbC8wSGlIYzV3dDg3TlVsdnhSd3gzeTJNZm4zeWJI?=
 =?utf-8?B?TUNMSUlwL2xOZXRtY0JBN3RoYnpaT1F4dXZNMkhVRWc2TWcrUW9QeWl0OGxZ?=
 =?utf-8?B?Ulk2ekROSWhmWkdpOUI0bUN0anprQlRxR3djWXI4TWNwaW1ncDVQc2p5Q0U3?=
 =?utf-8?B?N2lmY1FLK2FwT0swRCtiZVhCZ1VCRjdXNDVaVDNsVFdSTnlaT3pnNWhTME9s?=
 =?utf-8?B?OXJCTWlLaGR6b1Q5QzBnT3ZFMXdmYWNHQklCUTRmWWltV1JON1F0WUVxS1Bo?=
 =?utf-8?B?WlQwUHF5eDVyd2w3RXBkY1lZQy9YUVhDdURSbFZpT05Zc1ZGZ1NsZmdSRGk5?=
 =?utf-8?B?V0M3WkFZcWtIQTlTYm1iWm4xMXVadkx2RUtKTkl6QnN0TVdLNFM3WEZQaUZa?=
 =?utf-8?B?ckk5MHhObXIvZGxDYmxnSUFCWmw3T3VtaHFJSTNIenNYUTg0S3diUk9uYWlJ?=
 =?utf-8?B?L2F2M0w1bEd2dnFOcmo4b1c3Z3N0QVZUakNZd2laRlgrMmhBK3NWMDdIbzVl?=
 =?utf-8?B?QnovT2xkQmE1WlZEUGtSMGpRbk1FQ2FWZ0MrS05pd2lGNzlMN2p2VmR3Szdl?=
 =?utf-8?B?SXgvTUMzamlaZldZeTFHNGdETHRWbThhZU5aY1U1UGxKbC9uOVpkRHoyTEtX?=
 =?utf-8?B?eW95MVpUazRaUm93eGhoV3BNaHZyYjZUQ1FMczM5VTZPV2ZtNUM4MmlCbU1Y?=
 =?utf-8?Q?8GKst5h1Mbs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QjhCZHFPRU5pUytMTkdYOExjVTFXb0xpWXR1RDZ2OEo1Z0RTVDlCbkNCODBO?=
 =?utf-8?B?VVo0eTF3R0FFOWp1b2wzUGtTcGhEZTE0VVNPaElJS3BiKy9SRlpYOVpqV3ds?=
 =?utf-8?B?TGR6SVNuaU5EcXprbHNsZlhDMnpVaFNBdWFzM092OFZEcStBdFYzNDVIMGhX?=
 =?utf-8?B?QUxtWStrY2Zqak5NSEFmVXFrU1QvajJSdFpHcithOXFJVFVPUU5zVU4weVFL?=
 =?utf-8?B?YmtoakQrRTBlbGNEalB5QTdDOUpXVmpTMkhkS2FPcHJNUkplTjFDRVl6SG1H?=
 =?utf-8?B?a2RrT3RJSjZEakVOaE5Qd2w0c0tLc3NHbnNnbEFldUFSZUg3V0NIMEdEMngz?=
 =?utf-8?B?OElRM0pkeVlqK2FrdkxUT2s1cHRTOEg0MlRLa3UzOEI5YlFROExQSXgwbDJy?=
 =?utf-8?B?dFE2eFR6bG4xeWZnMSsyeE9NYUpRdDBENHpDMHFveUpXS0I3djRsaUJiSkIv?=
 =?utf-8?B?QS9hV0ZqWTlTS2k0clpsYjM1WXo2NGZPMzJWYWlGRnU0SUNwWWJhcmQzNlVH?=
 =?utf-8?B?eGlXS040NXZETm80STd2RG5NTU5zaTc1aHJ0a3c5Y1h6ZkFwbVNTSldjUUZN?=
 =?utf-8?B?WXVWR3VucC9RR2xjemFheWRIQUVyME5UV2xsNnpESTJaY1pkVXcrMWx3bHlj?=
 =?utf-8?B?UFdha29CRUQ0alFKUlhLMllFSHJiekFINWprR2JnRHFSU1BUbmhuZDM5VDFJ?=
 =?utf-8?B?WjRMQjFkaFppck5QZVo1cU01b3hVTTZhK1dJVnpTb1VQZ2dBTW4xalovWnJQ?=
 =?utf-8?B?YzNWNXZrVVA5bk4xNkdoMmt3QlVDSUZ4RStZYTZmcmhrRnNuVVVkS0EwUVhO?=
 =?utf-8?B?MzlBRVVqV2g3dXdneTNBa2o2Ui8waHhnZVBMZFJ1YkZ6aUdVeXAyV2h2MWlM?=
 =?utf-8?B?ejJiYzcyUk9hN3RRbXN3VUErSHA1OVRQcEZ4SktndENpdmkzYmxYOWlSV01t?=
 =?utf-8?B?S3FNQUxlU1pjcGg1MW41RFZhL3RqU2lHM1NTU2Zwdjg2SjRlNWtycjBoNWFr?=
 =?utf-8?B?eXRYYlRlQW02QmoyTWUvbGVvSWRKUkljSjlwSytXSzhmVGhSTjBNTitqWnlH?=
 =?utf-8?B?V0cxWkxTSkFsYnRpM2dXTTdvQ2hhOEtFZW5aRmJxUEN1cVZoeEozNitLeUk1?=
 =?utf-8?B?WTN6MXNCZ3BtMGhDeXYrdUtEb2pqU3k0U2NhN1A2bzU2UTJXcGNoakM1Y0dF?=
 =?utf-8?B?VVIydnpzd1V2TTJQZGFzaEd5aGNmYkIzdUswWkgvd2dzbHBsTkdGNHBEeGRQ?=
 =?utf-8?B?RXhtT1JOQXFTMHpTSWRVdS9CWE5QMjh1dERNM01jcEtWZ0xQSFF0S0x3TWU5?=
 =?utf-8?B?QkVOVlVIUDF4VDl0NjNQOG9qbXVOTUxncjFCM3FNaEhrbWFVUWFuZVZPeHJn?=
 =?utf-8?B?a0I1NWF0Qy9iTXY2NndhRjBveG5lYVB6N3NEdFhxZnpPWG5lMmRCTkFOaVJ4?=
 =?utf-8?B?NE03dTBPdFpEcGd3TEZDYXlmbmEyY3QzYStIR2h0M2NkQnFLOGhwTUZLdTBU?=
 =?utf-8?B?b3kvOFNEV2JoQk0xLytpN2VtZmlrRUdYTXQrNm9LbnpSV04yOUlnRDhEbzFw?=
 =?utf-8?B?cWJ2M0xYdmJjazJUZ1hVc1U0aTR0elFBeWFkZDNaWkx2NU5ZU1lSUlVGSUtS?=
 =?utf-8?B?VlJEcVp4TXczbUQ3c1J0d3hjTys2eTZpbHVUT3ZqdUN6cDFuSHN0R1l6Wit4?=
 =?utf-8?B?M3RGTTQ4STRzZ3czbnd5c3VJWnp4TkRwMm45Z3hGTm4xZlhzaWY3aTZ6U3Mw?=
 =?utf-8?B?dHd0aFpMR3dsa0hlQWJpTEZ1QWNZbjB2aUhKc2ZGNzJRK0NRbXczM1ozT3l5?=
 =?utf-8?B?R0ZWRWdYRmVSSHpRRjB2bk0wZmhtNXFHc1dQN2JiN29SZW9Fak5sL2wvYTNM?=
 =?utf-8?B?V0UyREQ0UWhNOUxtK0dVVnFxZkRNVUVQdFdXSTcreTVJYlQxU2p6emN1cUt0?=
 =?utf-8?B?dDZvUExMY2c2SUlNTzR6cnRERW5rdWE4MU9XYkxqVjVlZHlKUkF4WDVYbG53?=
 =?utf-8?B?Smk3VVdzRFg1TmtQbW1pOWpIelQ3K01wNDFxMVRsdjNpSGhkakxmTEZSK0Rt?=
 =?utf-8?B?c0s3MXZBZFBvSjdRR1R6ditUUlM0czl2dDkyZkNPL2lidFU2clpCZHZvSmJ1?=
 =?utf-8?B?dE9CRTRENEhqdHZaMDNlRzZGbkMzWkI3SE00WXljR3JPTEQvcW85cjR5ZnV2?=
 =?utf-8?Q?LkhegX5heMTe08xVTcRJG+c=3D?=
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3cc3c0-0bda-4fec-52c4-08ddd136d7fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 20:06:03.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3h1GPr/+mNzWYDAFizxOtALc3UiGEUYQjagcs08h9e0cfITBHV6CEFCTCbxu5lpkrrqrZlcOYLdvT8gh4FT3KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4836
X-Authority-Analysis: v=2.4 cv=Je28rVKV c=1 sm=1 tr=0 ts=688d1e30 cx=c_pps
 a=d3Zdq4q2+BwSKBEBY0tlvg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=4u6H09k7AAAA:8 a=20KFwNOVAAAA:8 a=BOokjy8hzOdu2QGMrBMA:9
 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDE1NyBTYWx0ZWRfX91ltWVOrycEc
 phVeBCZw/gSbAHc90er2sc/3FbmpBFX0OrWThI8amAUE+5tmFJKZtTp+kbCmVwB87F1Q26hnAkG
 BJauoeNkmJFDkgPZSxJrqWFfePexa2AfMLHN6czwF2yEYphdbmqa3BxCn/yUktKQcX3WDmVvE/F
 2eAHH/rP0IPA+zRwVESjPov5Ov896EOTRkHdgcbbKLicbuLbKYp7PtiXLS3em09jl2jv2OCFhW+
 uo5yGVwkiqxIElQ/WEeBVCl8lgVpn6fh1m4s8qpoWIoANrpaI7BWU/qHLftYUlgYgvtqf6kyg86
 WyRGodWHNJKRp2kengh+rAv5XPoQIOECdqvNFXzk+1jTJfVMnAX3eKZofgadWZhZ+hXAzVbW4e3
 kmXdn9k9LQZalNRS8/KQnnNjcZRvqvKD19g3/lisOXXNJv0li8IRSDP9kzITblAmCBpViciC
X-Proofpoint-GUID: M-sRcC_x5eEES9MnAn1A5ISOYLrK3H7-
X-Proofpoint-ORIG-GUID: kBH4QkmzmGc5wOdJlsfpcpSN-Sgfw2Ld
Content-Type: text/plain; charset="utf-8"
Content-ID: <179CEF12FB289D4294CCC22475A29171@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re:  [PATCH v2] ceph: Fix multifs mds auth caps issue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_06,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=2 engine=8.19.0-2505280000
 definitions=main-2508010157

On Fri, 2025-08-01 at 23:09 +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
>=20
> The mds auth caps check should also validate the
> fsname along with the associated caps. Not doing
> so would result in applying the mds auth caps of
> one fs on to the other fs in a multifs ceph cluster.
> The bug causes multiple issues w.r.t user
> authentication, following is one such example.
>=20
> Steps to Reproduce (on vstart cluster):
> 1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
> 2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
>     $ceph fs authorize fsname1 client.usr / r
> 3. Authorize read and write permission to the same user 'client.usr' on f=
s 'fsname2'
>     $ceph fs authorize fsname2 client.usr / rw
> 4. Update the keyring
>     $ceph auth get client.usr >> ./keyring
>=20
> With above permssions for the user 'client.usr', following is the
> expectation.
>   a. The 'client.usr' should be able to only read the contents
>      and not allowed to create or delete files on file system 'fsname1'.
>   b. The 'client.usr' should be able to read/write on file system 'fsname=
2'.
>=20
> But, with this bug, the 'client.usr' is allowed to read/write on file
> system 'fsname1'. See below.
>=20
> 5. Mount the file system 'fsname1' with the user 'client.usr'
>      $sudo bin/mount.ceph usr@.fsname1=3D/ /kmnt_fsname1_usr/
> 6. Try creating a file on file system 'fsname1' with user 'client.usr'. T=
his
>    should fail but passes with this bug.
>      $touch /kmnt_fsname1_usr/file1
> 7. Mount the file system 'fsname1' with the user 'client.admin' and creat=
e a
>    file.
>      $sudo bin/mount.ceph admin@.fsname1=3D/ /kmnt_fsname1_admin
>      $echo "data" > /kmnt_fsname1_admin/admin_file1
> 8. Try removing an existing file on file system 'fsname1' with the user
>    'client.usr'. This shoudn't succeed but succeeds with the bug.
>      $rm -f /kmnt_fsname1_usr/admin_file1
>=20
> For more information, please take a look at the corresponding mds/fuse pa=
tch
> and tests added by looking into the tracker mentioned below.
>=20
> URL: https://tracker.ceph.com/issues/72167 =20
> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/mds_client.c | 10 ++++++++++
>  fs/ceph/mdsmap.c     | 11 ++++++++++-
>  fs/ceph/mdsmap.h     |  1 +
>  3 files changed, 21 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 9eed6d73a508..8472ae7b7f3d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5640,11 +5640,21 @@ static int ceph_mds_auth_match(struct ceph_mds_cl=
ient *mdsc,
>  	u32 caller_uid =3D from_kuid(&init_user_ns, cred->fsuid);
>  	u32 caller_gid =3D from_kgid(&init_user_ns, cred->fsgid);
>  	struct ceph_client *cl =3D mdsc->fsc->client;
> +	const char *fs_name =3D mdsc->mdsmap->fs_name;
>  	const char *spath =3D mdsc->fsc->mount_options->server_path;
>  	bool gid_matched =3D false;
>  	u32 gid, tlen, len;
>  	int i, j;
> =20
> +	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
> +		doutc(cl, "fsname check failed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name);

If fsname check failed, then why it is not error message?

> +		return 0;
> +	} else {
> +		doutc(cl, "fsname check passed fs_name=3D%s  match.fs_name=3D%s\n",
> +		      fs_name, auth->match.fs_name ? auth->match.fs_name : "");

Maybe, we could have one doutc message before the check. Why do we have two
ones?

> +	}
> +
>  	doutc(cl, "match.uid %lld\n", auth->match.uid);
>  	if (auth->match.uid !=3D MDS_AUTH_UID_ANY) {
>  		if (auth->match.uid !=3D caller_uid)
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 8109aba66e02..f1431ba0b33e 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -356,7 +356,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_m=
ds_client *mdsc, void **p,
>  		/* enabled */
>  		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
>  		/* fs_name */
> -		ceph_decode_skip_string(p, end, bad_ext);
> +	        m->fs_name =3D ceph_extract_encoded_string(p, end, NULL, GFP_NO=
FS);
> +	        if (IS_ERR(m->fs_name)) {
> +			err =3D PTR_ERR(m->fs_name);
> +			m->fs_name =3D NULL;
> +			if (err =3D=3D -ENOMEM)
> +				goto out_err;
> +			else
> +				goto bad;
> +	        }
>  	}
>  	/* damaged */
>  	if (mdsmap_ev >=3D 9) {
> @@ -418,6 +426,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
>  		kfree(m->m_info);
>  	}
>  	kfree(m->m_data_pg_pools);
> +	kfree(m->fs_name);
>  	kfree(m);
>  }
> =20
> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
> index 1f2171dd01bf..acb0a2a3627a 100644
> --- a/fs/ceph/mdsmap.h
> +++ b/fs/ceph/mdsmap.h
> @@ -45,6 +45,7 @@ struct ceph_mdsmap {
>  	bool m_enabled;
>  	bool m_damaged;
>  	int m_num_laggy;
> +	char *fs_name;

Let's finish discussion related to fs_name. I've shared my questions in pre=
vious
email threads. Even if we will keep the fs_name here, then, it should be in=
 the
beginning of the structure. But I am still not convinced that we should hav=
e it
here.

Thanks,
Slava.

>  };
> =20
>  static inline struct ceph_entity_addr *

