Return-Path: <ceph-devel+bounces-3883-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C15C119F1
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 23:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABFA64601B0
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Oct 2025 22:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E9231B81C;
	Mon, 27 Oct 2025 22:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H4n6mcYA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846A2D94A3
	for <ceph-devel@vger.kernel.org>; Mon, 27 Oct 2025 22:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603021; cv=fail; b=V+5kv2GjaNnXkh2YuimUvGsInWiqjE6xiQHERQp1Wj4gwPOGs6/xdsspuS3sVxVDkTW1Qty0ScOmLWMO950Ru5Pzfq4BAgBcWwnaC+Bd5yEzMmF/ZXiT3Tb2IUGJ+Szr56T63mfuAkz8Ye/BCZpgLOC6ARniLzIabmQte8b0Jck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603021; c=relaxed/simple;
	bh=kC4BmV42OIUMQlc5GPVkLRX0llNleStIYV/oo5PTols=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Hh7YlPxoWuCwSFXNd5cnJrmu3rlCpy+Ai0otR/jMyKTs9GGarZHEMV56SE7YYERtP6jIzsBvM2/+7NKBWZxtedh25lAPdZDfxikDjF9gqXllU9NnZNF4j8+v6jUygOAPcRJB5x6+mD/qI2fjQCw+L5Jjw5nQ04XxRqr7ntk02A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H4n6mcYA; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RDpcA6032463;
	Mon, 27 Oct 2025 22:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=kC4BmV42OIUMQlc5GPVkLRX0llNleStIYV/oo5PTols=; b=H4n6mcYA
	Ik8thKeYz2rjEVfj7V7MVYt6uuu/ULZAlDs0ZtBuMS/lTtbJHQ2dCuEydZNGhWGR
	9lK1WTaiN3BvcQ8p2KTOLECQ6XXEbBkdqlqy00UnGFHgke3Ab1nF1MJ6v4uC3HJF
	51jTfKjqaWbZyRs78kGttNRCgJt05167IT8pssVULtvkm5s2vnDAlehyfORANHr3
	MYoKhVg1+zrJL5ak27ySg096b2TtRsM35MRgriwAPqFvWRr3fR6Dc0Qk/rg/KPCO
	5nNlv+5wCcluoCJHe6bIyoovj5v5xlTjPk6tqrxyCFu07d6rU+l6z8vEZ3UrXuhl
	U6aWMj+UYuY+Rw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p720w2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 22:10:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZF0k+1i3aaT/S0y4y3oAFEcc5a1groJUbbjusmLxDN/Z33S3Opw4QBdro2On5tIWMwehbcMRvpTC+NJxxCDb0ksDstIzLYyqqi5NfVO+xglIcmEVKw/dva3JVndYz0aAHb39VVfNP01bydASCU8pNvuvsutob5hySnUAHgcJI9zlQZdcTUcMadw3veuPZ2hmW4IP5qlujYUPCtmPsfTwPIPef2ALwXUwkYSQnPaLt6r1n8r9OAdRDtXFtK+6rNwVBw4Sct2mQg7DW7SiIHirdkoj5KMmelPkpPE/FRxs6Xspr43UK56YFf1kQoKJpjze8XKvmOK704VMrQ/NXk8Qgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kC4BmV42OIUMQlc5GPVkLRX0llNleStIYV/oo5PTols=;
 b=HdW3kmYt7vmkDprlIGNSwp2pW3YRNhyOMkd8sNbo/qpVDKcvEPyzWlJOopujHEN8J6gwrYx2KVZ6k291Nfau8MDtb8VTD2+uXqRSwdwB+4E0KRTI/ehtqrseDc7enUaE8J9AOKkOZVg+gpwCiyqlbjBvPT+uiVQDbjXyE4onuv+qGD+8gSqlCAVXhQVaC6KfDOayNiml99rkFC9FnCbg78DXtQx0PgwWwn0wKX3B1hwBayEtb7sBFNDyoyQpfMvrC/+Xd5naKeFtLO/xNufWTjqZ27LFXvaesBLl+MGi7VGzzfQes01tmieYawc7JbputTcavz9Qjozh23hAF1WNyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by SJ4PPFADF8EA249.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8b8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 22:10:07 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 22:10:06 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "caskd@redxen.eu" <caskd@redxen.eu>
Thread-Topic: [EXTERNAL] [bug report] listing cephfs snapshots causes general
 protection fault
Thread-Index: AQHcPIJFmAszwYUCkkeEQFwfYy0AS7TWo+CA
Date: Mon, 27 Oct 2025 22:10:06 +0000
Message-ID: <9fb3bc164f5b565d8dab37125ac1452fd3878558.camel@ibm.com>
References: <2XRKV3P9QNXDI.37IHX7CVTJ6SD@unix.is.love.unix.is.life>
In-Reply-To: <2XRKV3P9QNXDI.37IHX7CVTJ6SD@unix.is.love.unix.is.life>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|SJ4PPFADF8EA249:EE_
x-ms-office365-filtering-correlation-id: ae553fce-9b4f-4383-8b54-08de15a5964c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TFc4ci9iV1lHdXZXRW02Q2svOUtXb1RSeGdrMVVaanVDdjlBK01La0ZraFdN?=
 =?utf-8?B?elJwSVgvemE1ZmZBS2VDazgyV3NCcXNVbHNFL3BBMDNseWx2WHgvVFJ0VjQv?=
 =?utf-8?B?L0RpV1pVVnRWMlpzZTlsYUVNazNndWI3dEorNnlWV3NLd0t6ODRZdFpFWUhV?=
 =?utf-8?B?eTBsTWsxeTB5Z2s0RkkxL3lHZW5wUWFiaFBsb0lhelc1d2VyN09QWThTVTBU?=
 =?utf-8?B?OHJBT0pIYUt3ODV3VzIxcWtmalluK2ZpakhnQ09BY2c4VHluQlJaRmVQbUNQ?=
 =?utf-8?B?Ym1ranloam9XZ2NwWHNLZVB6ckFvV0lvK1NEQW1RdEQ4THk4TS9XclFmSUt0?=
 =?utf-8?B?SnUzcjM3NW8vTThDRkhEZFF4cUp4UFVYakdBb0k1azJwSENpVUpmakJvMEhy?=
 =?utf-8?B?aktWaENMeTJPekh1S0c3VE1pWHJ0clRKRVpWOTJLaEJhK1ZNUnhEVklweDJP?=
 =?utf-8?B?elUySkdUTHNQbGZsRE1NOG1KMkNoVE13VnhJQmpubks3Yk9mT2dtSU1QK2ZO?=
 =?utf-8?B?WE1PRXFDQW0xTjc2c05lQUVXOVZFUTdpdUM3eTEzQW1LWmppdGhaNzRJWkgz?=
 =?utf-8?B?N0tkeUJNZWlSaUhBdktaWHlKQlpJM2lDcThGbHNRclNsVmpjUWY0WmdmSTBZ?=
 =?utf-8?B?WWl2SWRGZktYazhoSkkxYnc5MkRWSDl0UzRLektZd1A4Q2pHYXlSRE03V2RP?=
 =?utf-8?B?aE9WanhRVkJNQno0U3lkeG9idzk2WU9CalJOWmY0MUdQMUFUdERXZVhkb0g1?=
 =?utf-8?B?bCtPRWVoakM2YmJsUEVQOWJkRWN4N1czNmx6Tys2N24rODArWDlFY2ZaeDRa?=
 =?utf-8?B?S2hXc204RUsxNitKSHpiMldDbG1yZXlPWmtHQ01TS1E3TmNqRGowUklIZVFu?=
 =?utf-8?B?SUZsQU9pMEE3dmJVNzczRUVJQXB5RjZtZ092ZEZRYmJ0VGhtN3VWTjdxYmdr?=
 =?utf-8?B?TG1RR1lxZVNvVVpldjhXV2RmcGdhOHdSOThsOURjOEVNZjJGL2t4SXg0SzVy?=
 =?utf-8?B?czJ2eVhnZ2NyWHBtMFpJc2RlamN0dFVubFRFdk12OTdFYjF1YkJGNkdvUnY4?=
 =?utf-8?B?QUs2ZG5jN0hxcE5kbEprNUVKc2VDcjhEY3Z2THJ6VCsyOGN4Qm93MG9NN1la?=
 =?utf-8?B?dHBaQlZXMFl4V0lMZWRLdjRxd2RZNmhrZU5zcWEwckRYNlJSbmo1VXhZQlk0?=
 =?utf-8?B?WlBFK3pUTEJ2eDUxZkROUnRwZGladkk4YkpWWlUyVmZOQ1BDYWZneE01OWdw?=
 =?utf-8?B?S0psSllOaFBabXNXMlZjcm1UNXplOG5rUDVnMFFydkpoMStDc096dkRLRWdP?=
 =?utf-8?B?SVpCZjNYSE4xNmRYcko1cldUOW54ckdCYy9mY1R3cEg4U3JCdUxMaGJ4ZWUx?=
 =?utf-8?B?cEZ2czc4ekxTbmErNmlVdXlnSHAyS0hxSWhHUHFjNkJwRy9MY2Irdmg1N2ZC?=
 =?utf-8?B?WFVJd2FtUFNVVjNUbURiY3RyYit2SjhXVnVwYWowbE5WSnlIU2RqK3FqUzNu?=
 =?utf-8?B?eU8yNDRJRXRkcWxMZjc0NFJRTlJsOHp6SUpkOEhEb29UU1FEWURJbmNLRFFs?=
 =?utf-8?B?NllON25xWUNhQlBrSDZ1dHMzdkJ3am5uenZHQUFTMkg4MkpRY2NZRmVXdG5G?=
 =?utf-8?B?NGRaS1BNaWVsOU96bFFCMFcwdit6a2U2amF0T0FtYVJ0OFdVL29FVVFydzIr?=
 =?utf-8?B?ZDAzNGVtQng4VFBzMTB6bFhPamxycWszeVlKMVc0c0l5SXhIbEpjeklrUUwv?=
 =?utf-8?B?ZnJVQkp1WmNha3RkdFU5c2VXTTM2ZTNMSHBWOUdOVEpQTGpOVXkzVnd1THVw?=
 =?utf-8?B?Z29SL2RqRFVXZXlVQS8wLzRybmtHRWR4TEZNTzlqb3Z4SjYrQ0ppK1JLaUda?=
 =?utf-8?B?K2M1Y3Q4dGlrdUdRZ01rbm9LL1FIR0RubmMxUUlFSlhvRlFRNU5JY3lCcE9N?=
 =?utf-8?B?TTBQeUgybitqS0RYUGx2UUcwNXVZQjA4aDBUVSs5VGR6R1lLWFJTOGpJYXFi?=
 =?utf-8?B?eWNIdG9janhRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bmhRVTlTdkpVc0FZby95Qzcra3FRQTIydEVwUE1YSmpjZVJLQU82NFg1eGZP?=
 =?utf-8?B?Z2JFSkI5c3FLVTcvbnZWUzFxVWZYR1Q3cHFxSWNWWlVSVkdjTlV5S0FuNmcr?=
 =?utf-8?B?RGMyZHR1SUE0U1FXMjZaZ2crcEpKZUNNYUxCK2U3dlE5TnRoSWZodEhoRTBj?=
 =?utf-8?B?N2VMZnFKc0U5VTd5QlJsdkY5YllZZWlqZWVCMTQvVGFHQXc2L0JUV21hYlFY?=
 =?utf-8?B?UDMrZy9aL3ZPMlhLMVNWMTAzd0NyOXZJS0ludis2WTl4bm9QVWd5ZUJCaWdI?=
 =?utf-8?B?WjJXekdGaUJlbXRBSk5rdFVpWTJmajlLbHZ6TjZRU1RqclkzMUwxYnFBY0c5?=
 =?utf-8?B?MmwyOUxmbDVBSE5rSzZ4L3gvaVQxd25vcE12cGp4c2EwenNnYzBtY2VMNGRL?=
 =?utf-8?B?U1ZKd1l6U2phc2xVa0pXaTBacXNqTDlUWWNUUE5zMnhLK0RIa0I3aWhmb1M2?=
 =?utf-8?B?em5FOHY5Slo2Ym8xTjFwWXBPQmlka3ZOWnVWekI0M3V0bnpia3NmOUV5MzZh?=
 =?utf-8?B?cTVKSzZLdE15UUM3c0d1L0xKa0l0T0dGVVhRWk1lNXZFU01vVVAxTVl3YXh6?=
 =?utf-8?B?aWREUXcwNWcycDFscHpybDNEeUpyT1RwaEVIaktnRnpRa1dzRWpRRzl6THNR?=
 =?utf-8?B?a1QzcmFXWkQ0NEswVng0N2lEWm83WCs0bXFlSUtrTTlvNS93UFZydk1kL0Nr?=
 =?utf-8?B?aVA5NDl4M2NOaXJGVlo0THBxOG5yaXh4dC9DWEtJc1pucTZ1VkNmRE5sclhF?=
 =?utf-8?B?ajVjNEsxMzlzaUYrMVpZMFBBZXlZaWNZbzBkKzR5QmhpOWtnbUZUQ3AxYk1r?=
 =?utf-8?B?Z1pwa3JhMjJFRi9aNndNM1NsRkJLT3d3Y1BBTm1MMHNxY09maDlFT1doQi9M?=
 =?utf-8?B?bzFoTzRoRWYwSHZ5RTVzajR1MklVRU1RWE9hc3NVck5NcW5WV3BFREVIUVcr?=
 =?utf-8?B?V1pZNkVnMjZCckRKUWtReHh4cmpJM0xVcHZhMHQ0Sk9LTWNoajN5UDlSR1VC?=
 =?utf-8?B?NlJMVG9INmlQdW1iWjNnLzh2U1Q1VFhmcDdBbXh4YjFmYVdSVFVJQ3JzaldM?=
 =?utf-8?B?ZW4vaDhOS0lmeVR0OUtjdWhJS1RlbXBzdGNKVXVob3RHaEpCNzdtbDZTR0dp?=
 =?utf-8?B?L3dWWU1NdEVobmY3ejZBZGFTV2J5akRsT0RqQ3hGcTJrY243dVdERTQvMGxV?=
 =?utf-8?B?eDk2OE1EbVp4RjBLbGZybTRGUStmWnhrSVUvdnlGUjdBNmRNWWZBZnlsRWhS?=
 =?utf-8?B?NFVVWXJpbm9KeERHZnNUak90dk1FRmVPV0NPcFVzbjVVYm9FVm5RS2VzMmJN?=
 =?utf-8?B?c0dJYVNNSnF6ZWwwN3B5aEFhcFFqTUl6SHo1VTFyWlpKMm9CTGNHYVdBZFI2?=
 =?utf-8?B?Q0kwWFpmTVZ4ZUtKYm9QOEt3cTJSOGRyazl5a09lS01waFdXZFBzK2lKeDVt?=
 =?utf-8?B?SThvanVwN0d0MXIvVmJsRTNjQzJTS2lJanYwSEJGRWFucGdra3E0clVGMGp0?=
 =?utf-8?B?THFvbXNmVjdrYVphY2l3OVFkT2ZWWVB1NUpINEJESEg5SHVrRU1sSDhVcHgw?=
 =?utf-8?B?MmVrbm9uOEc1UmR3dXkwL0dLZDVJcGx5eXVJZ0hhNTFJYTdBaW9kekhZMlVS?=
 =?utf-8?B?K2pGdGVVZFNVTVNyNlVtRzdQNVVMb09kQitCS3pKM2ZmQ2N4aWVvY3ZjYlFB?=
 =?utf-8?B?UFJxNlhRV0JFVXVuelNqT0RUR2s1ZlNGL2tCWFJUV1Iyd2pvRDBKVzg3T1I5?=
 =?utf-8?B?K3FwV1cxVUJUdVB2RzlqSXAvVml4dWFMN0JMZWNlc0RPQW5udEM4dkFsSkpp?=
 =?utf-8?B?MlhtbUNGd3VBVXZ6c24vVWlMYVM5anN6UkMycGh4UVFVYm1GOWpMcXEwQ09q?=
 =?utf-8?B?ay84OG03MlN2R1M0OExjTlBiYU5XcW9jd2srcFM5Z2hHa2E3eURyTEJVZk5I?=
 =?utf-8?B?NllwMWFMWnpKTDZ0eldmMFRhWnYwMTZoTVZhTUd6dlZFSkttcWZoRkZ0U0Zi?=
 =?utf-8?B?dHJvWkEzZ01jY3gyc0R0WVhpWmF5dlFzTWUyMGFKUW91R3ZyY2FqbGhEa3Jk?=
 =?utf-8?B?Mytmb2ZnU0svNzlrbS82cG5USUxLSXdES2NVZ3FhM0RUcjJSOGt1a1BBRXBq?=
 =?utf-8?B?dVF3cTVYeldtT3AzSEVXYUNqU0d2cTFCQXd2OG5VcGxOTGlTTkZLZlk2bjdw?=
 =?utf-8?Q?UzNrnhi7toBWAOQ4QqSQU1k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB1CEFB688C8844CBC4F8632D9903141@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ae553fce-9b4f-4383-8b54-08de15a5964c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 22:10:06.8461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OINqs2c0tn8g+PObjeHnpoydRy99xkFJlVGie68cbi4w8rZPubPOiCYtskFEcEv9lZ2pRu9idX1g6bH8l01+WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPFADF8EA249
X-Proofpoint-GUID: sc1fpaTR2IcN_BPX4TFBLQN2Mb99a4Xs
X-Proofpoint-ORIG-GUID: sc1fpaTR2IcN_BPX4TFBLQN2Mb99a4Xs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAyNCBTYWx0ZWRfXwW3kANlb3Xs8
 +mEggVoi2ronGoJvaEMsRQJ2Q75w43vWJ1oDgn2f4SRCSQCPT7iHcYVMmqBByzL1DM0cxFk5PLg
 u5OO0cnXeQivHAOUTSEMVui78LXbFsDjwctyyULwZtccgMSVG8eRzgAJ+Tu60o/RgHL7t2NG6M6
 s2wmb3zSpX4nVV1exO1k+gI8GASS2MA3tK0TEkkfMLcsUY++XeUaDmzu21GgD3YZvQFZDUI4vsQ
 w+TnoPFQCr5IFNa72wNKJLFEl5lPB5KNPjXDIQ5MTk81o/LtkZ8xQfMqaMk/kKnmEZrubbcQ4UP
 DVVF7tIZJi237V4AC9wTE8DJ5L2A3niWHxLNMNvZY03M03RiLrurKdopl0odORtQZdYC3n0I5XS
 EbVMlT/uVeeBHizNhUkjPl/Hzuk0nQ==
X-Authority-Analysis: v=2.4 cv=G/gR0tk5 c=1 sm=1 tr=0 ts=68ffedc6 cx=c_pps
 a=EPZJxM4MYJNUcCtligPUUQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4u6H09k7AAAA:8
 a=ECJ0fpNTBLxyTuZX7xEA:9 a=QEXdDO2ut3YA:10 a=5yerskEF2kbSkDMynNst:22
Subject: Re:  [bug report] listing cephfs snapshots causes general protection
 fault
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250024

SGkgQWxleCwNCg0KVGhhbmsgeW91IGZvciB0aGUgcmVwb3J0LiBDb3VsZCB5b3UgcGxlYXNlIGNy
ZWF0ZSB0aGUgdGlja2V0IGluDQpodHRwczovL3RyYWNrZXIuY2VwaC5jb20/DQoNCk9uIE1vbiwg
MjAyNS0xMC0xMyBhdCAyMDozNSArMDAwMCwgY2Fza2Qgd3JvdGU6DQo+IEhlbGxvIENlcGggZGV2
ZWxvcGVycywNCj4gDQo+IGkndmUgZW5jb3VudGVyZWQgYSBidWcgb24gU3F1aWQgMTkuMi4zIHdp
dGggdGhlIGNlcGhmcyBrZXJuZWwgY2xpZW50Lg0KPiANCj4gTGlzdGluZyB0aGUgc25hcHNob3Qg
b2YgYW55IGRpcmVjdG9yeSBjYXVzZXMgdGhlIGtlcm5lbCB0byBhY2Nlc3MgaW52YWxpZC91bmV4
cGVjdGVkIGFkZHJlc3MuIA0KPiANCj4gIyBMb2dzIGFuZCBmdXJ0aGVyIGluZm9ybWF0aW9uOg0K
PiANCj4gTW91bnQgc3BlYzoNCj4gYWRtaW5AUkVEQUNURUQuY2Fza2Q9LyBSRURBQ1RFRCBjZXBo
IHJ3LHJlbGF0aW1lLG5hbWU9YWRtaW4sc2VjcmV0PTxoaWRkZW4+LG1zX21vZGU9c2VjdXJlLGFj
bCxtb25fYWRkcj1SRURBQ1RFRDozMzAwL1JFREFDVEVEOjMzMDAscmVjb3Zlcl9zZXNzaW9uPWNs
ZWFuIDAgMA0KPiANCj4gLSBzbmFwLXNjaGVkdWxlIGlzIHNldCB1cCBvbiAvIGFuZCB0aGUgZmls
ZXN5c3RlbSBpcyBoZWF2aWx5IHVzZWQNCj4gICAtIG5vdCBtYW55IGNvbmN1cnJlbnQgYWNjZXNz
ZXMgdG8gdGhlIHNhbWUgZGlyL2lub2Rlcw0KPiAtIGVuY291bnRlcmVkIG9uIGJvdGggNi4xMiBh
bmQgNi4xNiBvbiBtdWx0aXBsZSBtYWNoaW5lcywgaW5jbHVkaW5nIHFlbXUNCg0KQ291bGQgeW91
IHJlcHJvZHVjZSB0aGUgaXNzdWUgb24gdGhlIGxhdGVzdCBrZXJuZWwgdmVyc2lvbiAoNi4xOC1y
YzMpPyBEbyB5b3UNCmhhdmUgb3Bwb3J0dW5pdHkgdG8gYnVpbGQgdGhlIGtlcm5lbCBhbmQgdG8g
dHJ5IHRvIHJlcHJvZHVjZSB0aGUgaXNzdWU/IFdvdWxkDQp5b3UgYmUgY2FwYWJsZSB0byBlbmFi
bGUgdGhlIGRlYnVnIG91dHB1dCBpbiBDZXBoRlMga2VybmVsIGNsaWVudD8NCg0KPiAtIGkgY2Fu
IHJlcGxpY2F0ZSB0aGlzIGV2ZXJ5IHRpbWUgd2l0aCB0aGUga2VybmVsIGNsaWVudCBidXQgbm90
IHdpdGggdGhlIEZVU0UgY2xpZW50DQo+IA0KPiAjIEhlcmUgaXMgd2hhdCBpIGhhdmUgdHJpZWQg
c28gZmFyLg0KPiANCj4gLSByZWJ1aWxkIHRoZSBmaWxlc3lzdGVtIGZyb20gc2NyYXRjaCB0byBy
dWxlIG91dCBwb3RlbnRpYWwgaW5jb25zaXN0ZW50IG1ldGFkYXRhDQo+ICAgLSBidWcgaGFzIHJl
dHVybmVkIGFmdGVyIGEgZmV3IGRheXMgb24gdGhlIG5ldyBmcw0KPiANCj4gIyBXYXlzIHRvIHJl
cGxpY2F0ZSAoVU5DT05GSVJNRUQpOg0KPiANCj4gQ3JlYXRlIGEgY2VwaGZzIGZpbGVzeXN0ZW0N
Cj4gU2V0dXAgc25hcC1zY2hlZHVsZSB3aXRoIHJldGVudGlvbg0KPiBEbyBoZWF2eSBSVyBvbiBm
aWxlc3lzdGVtIHdoaWxlIHNuYXBzaG90IGdldHMgZGVsZXRlZA0KPiBMaXN0IC5zbmFwLw0KDQpD
b3VsZCB5b3UgcGxlYXNlIHNoYXJlIHRoZSBwcmVjaXNlIGNvbW1hbmRzIHRoYXQgeW91J3ZlIHVz
ZWQgZm9yIHRoZSBpc3N1ZQ0KcmVwcm9kdWN0aW9uPw0KDQo+IA0KPiAjIE1pc2MgaW5mbw0KPiAN
Cj4gLSBUaGUgcHJldmlvdXMgZmlsZXN5c3RlbSBoYWQgdGhlIG1haW4gcG9vbCBvbiAzeCByZXBs
aWNhdGVkIGFuZCB0aGlzIG5ldyBvbmUgaXMgZWMgNi0yIGplcmFzdXJlDQo+ICAgLSBUaGlzIHNl
ZW1zIHRvIHBsYXkgbm8gcm9sZSBpbnRvIHRoaXMgYnVnLg0KPiAtIEkgd291bGQgYmUgd2lsbGlu
ZyB0byBuYXJyb3cgZG93biB0aGUgaXNzdWUgdG8gdGhlIG1pbmltYWwgcmVwcm9kdWNpYmxlIGV4
YW1wbGUgaWYgdGhpcyBpbmZvcm1hdGlvbiBpcyBub3QgZW5vdWdoLg0KPiAtIFRoaXMgZmlsZXN5
c3RlbSBjb250YWlucyBhIHNpZ25pZmljYW50IGFtb3VudCBvZiBzbWFsbCBmaWxlcyBhbmQgZGly
ZWN0b3JpZXMgaWYgaXQgcGxheXMgYW55IHJvbGUuDQo+IA0KDQpJdCB3aWxsIGJlIGdyZWF0IHRv
IGtub3cgdGhlIHNpemUgb2YgZmlsZXMgYW5kIHRoZSBudW1iZXIgb2YgZmlsZXMuIFdoaWNoDQpt
aW5pbWFsIG51bWJlciBvZiBmaWxlcyBjb3VsZCB0cmlnZ2VyIHRoZSBpc3N1ZT8gDQoNCkN1cnJl
bnRseSwgaXQgaXMgbm90IGNvbXBsZXRlbHkgY2xlYXIgd2hpY2ggcGFydGljdWxhciByZWFzb24g
dHJpZ2dlciB0aGUgaXNzdWUuDQpJdCB3aWxsIGJlIGdvb2QgdG8gZWxhYm9yYXRlIHRoZSBpc3N1
ZSByZXByb2R1Y2luZyBzdGVwcy4NCg0KVGhhbmtzLA0KU2xhdmEuDQoNCj4gUGxlYXNlIGxldCBt
ZSBrbm93IGlmIHlvdSBuZWVkIGFueSBmdXJ0aGVyIGluZm9ybWF0aW9uDQo=

