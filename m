Return-Path: <ceph-devel+bounces-3745-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF01CBA53C4
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 23:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8990188C3B6
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Sep 2025 21:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4021626B2D2;
	Fri, 26 Sep 2025 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HZ2cSg4d"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8D017BA6
	for <ceph-devel@vger.kernel.org>; Fri, 26 Sep 2025 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758922872; cv=fail; b=BbnseMLl6VVnl243O1r4nh9wsqaxLD+slLVZ+i5OFLBCvzr8BAIvixy8eRn5wINkQTHKl4istF/235fITEijd/9XXjgNESH2WRBhnAh68TIyxoC2OyZ16QI7Ex+Ee5QTC/iySp163MnHduYB5VE0329x5RmS7g4ajxR6GcN8NgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758922872; c=relaxed/simple;
	bh=0H/qzUdGV7zZS9RsUivGnKsG5o1z4CZBKCndoc9UQbY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=txBlTKpCohl8nHshUrgiHgu7rDTgDBffcldBDzotl5wqZWx4oe/78I1GSE4KBM0J4Kt7QNuWP2U5jyM4yPAE4zoQdKfE/R0rJxVbEFiSX0wIFXKGGS0arInD2col048y4YK1UHj5prGWpcOi2onckbd+4KXsGdDfRwYcdr3VI/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HZ2cSg4d; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58QEQj0q029313;
	Fri, 26 Sep 2025 21:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=0H/qzUdGV7zZS9RsUivGnKsG5o1z4CZBKCndoc9UQbY=; b=HZ2cSg4d
	1MS940th4E32usC1APNqF0Zx5eICJ6cbZ/4nvk4Gc5qwox/GjF6SevVJIbXmM7EA
	91qht12xw13U8QaLhcT9roKwvVFUi9ZDn2Z7UWifrYBDR9Ho/oCh69whCcVOV69s
	vOtKxTTeEy98abXlgF/mAj4ndJprRCddhqGmAS7bZ3lpgnK18yhfvpw+rSDSFnbL
	hafaOQnH5kkUn/M/9+SNNADUh27lkP+ebc7vv4u7PuQcR80hAYI8HGS4njltACbU
	9Ol4VqEqXxpGFkAiiEiG00o2iyab0C0y3nV/BSCbH4HbwJ3lw0dLCt+rkv2Qv0Oj
	kVP5hk3mViZSMA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3yevf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 21:40:52 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58QLbxDJ001092;
	Fri, 26 Sep 2025 21:40:52 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbb3yeva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 21:40:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boJKsqw/1rQuYZKx0ofKFByPBvR1XUVzaZVvpI6gBHmY/62/lbHLw61SeVlPj3RCgpsjzL/YwkvH8HN/Smt2FyAubOIoJYvRhZ6xK4Sttl/1IWgL+3U8q5R1Ytl9A5K1nCfstM4VOiKGaNr4lQNqw7H64In2IQjyPT/ubZGRBGQwZntlCapp/Od+qGKxHWLTIrFMJU37vwtkotIr2MzY+ci+vNT/2ThG/yncIUVB1WGDlaDL2QFnZiCNgQRUJnnIUEAfx69mFn1i76jTD41YsulnGarHVSF7AYGduBN7Oz0Z2/3706E9s0yezfSSC7FfDniXbreD9s/xqMa7yXi/Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0H/qzUdGV7zZS9RsUivGnKsG5o1z4CZBKCndoc9UQbY=;
 b=iL/4eeLE4Rgz+j5P6LMXULsIuHU/W5bEpVM7yuwYJAHYslOe9ngIYi3VA6gGyfoELNpqXdR1N3WF1lhimxiC98WPsrnEF1VpTfDAKV7/o8WEjadyOPzscSvcXxq+4KhxrR9te3MWn2AAKBvJ6lkov3KjFsBlIfXCJ+cP62GVVxK22gkXNUiWydEEyNSQTfFqXbLOGLyMP8treitGuVMmsb3uf+rKQV9ktZzZmXJTWIIu4Hkpe+eHVY1UAoMCy8SnR9/o9CyRRoYN0/VJ5US7X3DkJS/QACECkcnMVe5qeHFsgts0XXFQ87PC6wqb1obhlxkHBOaFIF2WuDZazFSPVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DM3PPF70060AA38.namprd15.prod.outlook.com (2603:10b6:f:fc00::41e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Fri, 26 Sep
 2025 21:40:50 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9137.017; Fri, 26 Sep 2025
 21:40:49 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ethanwu@synology.com" <ethanwu@synology.com>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
CC: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Thread-Topic: [EXTERNAL] [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
Thread-Index: AQHcLgktI8SRjR6iz068ZMwWtn5xlLSmAGCA
Date: Fri, 26 Sep 2025 21:40:49 +0000
Message-ID: <d9f111e47c7b9ab202f27bf46956c3a5f4d51671.camel@ibm.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
	 <20250925104228.95018-2-ethanwu@synology.com>
In-Reply-To: <20250925104228.95018-2-ethanwu@synology.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DM3PPF70060AA38:EE_
x-ms-office365-filtering-correlation-id: 098acf55-f375-4739-b712-08ddfd455c46
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?U3pKUU5WN3pqRXl4UGxKdXN3SFpRdHkxTUtIdmt1NmRBbWQyRWJkQzNXYVBW?=
 =?utf-8?B?T0R5ZlIyQ3F2MFNSMHhMcnVYUE4xMTA0UjdveEdDOW1kUGd1Y1hUS2VkSzNh?=
 =?utf-8?B?UzRUVlc0N0UzYlFxWjd1VWpOTThVV1VBd2VxaUQzUDlMUUsxRHRGSWJTUTh6?=
 =?utf-8?B?R2U5UkFpQVhNUExZUGQzNDlhVDA1Ui9YSit5L3ducml6VlZJTlBNUllieDFw?=
 =?utf-8?B?M0pUMS93WXpTLzY3cXFFTXpZYnREZzdaU3NOR25zNm1qRE1PUy9vaWtmQ0Vn?=
 =?utf-8?B?L01CaC9tWlJxNzlYa3YxR01wdnZRYUVzd1NMZ1ZTZ1BZekNRZ3A5UTlQWmdN?=
 =?utf-8?B?M3phT0JBU0dLdnZ6NldUQVllZU16SGZ1Wlh2UFVuWTBUVmZFUU9oTnVpTkhT?=
 =?utf-8?B?LzdnMkltSllUQ0dSZm5GRGJBS1pBR2M4a0Nkd1Job04wOElWMXlWYUp1OFo5?=
 =?utf-8?B?T1ZZTThsTUwzVGxpUTBlcnljbno1NGRqbS9GUk44dHZsZjIvbXhLZXE1akJq?=
 =?utf-8?B?SkxCRGVJbjdHVXVTK2lVWkNaQXVCKzZkV3liQWlUNU1ZQ2ZHalFuQnFRc1Y2?=
 =?utf-8?B?S3c0S3RTL1I0WGszeFY1VmtnVEQzMnNGNS9LNWZUaFM0SE5RZFdscWs4cExv?=
 =?utf-8?B?djNlOHd4Zjlyb1NxOTdvOGNLZGNzdHVqZW43Rkw5a3dhRkVrMTlFRHgrZVNn?=
 =?utf-8?B?WFhRVjhZckR1STNteE9PZk5waVJOek80cnJ2bVVodGtpdjZVYWhhS09vZEt1?=
 =?utf-8?B?MUlDbk1INW1ZOUdhOGxRS0VQNE91VU1YaUJ1cHZxQXdoQmVBZ2xXQ1BTd1lu?=
 =?utf-8?B?eFo5alZoNTVrTXZFY1FlMlYySC9NRUk3RTNDMnoyUXJLaFUvcktINkl2alpJ?=
 =?utf-8?B?TkpVSTBEdjhIRExMZER4VHdiQzhHQXdiLzgzZVROMk9yTFNTMEI0REpDa29q?=
 =?utf-8?B?MEhHZm82R0VzNlM1aEhHcUtjMVRpZ1ByOGhuTWxyU1ludTRKUE1hdnhTdThs?=
 =?utf-8?B?MjByNFFDUTZOTTN6RjhKREtqUXJoWHZmL05CdzVQMDFXQmtvNlFOMTZhcVU5?=
 =?utf-8?B?K0Y3b0NLVGhyaTVYWlBiRzZlM0k2ZG5KT0NBQ1pmdDNKbUFBY2tlNDNnNndH?=
 =?utf-8?B?aC91Y3dVNC9WdllBcnVPc0ozT3AyV05RQ2svSS9OVlU3TXJIV3JaNXRHR1lj?=
 =?utf-8?B?azgyVkJRbjZQdlRvbnBtQ3dlRHRjLzRjWW44ZEJDc2w5L1VKQkRudHNJM3Vh?=
 =?utf-8?B?RExicllsZEd1MFBOUEJBTEc4bDJLNWFobnJCSVVrSC83K2pSb2x3YkJPMFR5?=
 =?utf-8?B?VmF5OEtoZGx5MVc3N09RUFFVL2wzVWduS0RadDU2ejlsU2l3ekwzWTNOSFAv?=
 =?utf-8?B?MC9JWU1YcWh5cmVWT0xuUWJXYVpUTS9DYkV5bjltaXJCOXJNRndsNmMrUTZ3?=
 =?utf-8?B?ZVpFckg3NG9zZldsU3phbjB2R3ZpS0ZaQnBKM215YTVFclRBNURrTlRTTUZN?=
 =?utf-8?B?eSs0M0s0WVloaFU0NnNpbk43MWdmT3NFTmcyUzRDc2ZCeFZzZXVqODgrZitw?=
 =?utf-8?B?MXhPYzdIVTJwckpvc2ErYW0rVDd3TmNMWFpwZGR2ZHBRSGFLOVdzcjJKMit2?=
 =?utf-8?B?NVVQOEpVeTdyVGh6OHR1QitHcExicVBCVGxadTVkeDB6Y0tRdGMvVGhxUWpq?=
 =?utf-8?B?QXloKzZ3UEZ4VDhMckk3czBRY3NvbDBEUERkMW1XOGpvYjg4SGhIcGUzSUdY?=
 =?utf-8?B?RFN5b2NKZSs1RWpGajJJZnJuSkhiRTJQRlZkdEhueHFicDBGNnRzWFA0cUZU?=
 =?utf-8?B?SWt0b0FCVGhYdEkwTFJnd2xudGhiekl2a3htNWs4am5CRy9zYjZWSDhlcnEw?=
 =?utf-8?B?UUVPdWt3TDVlT1lxRlRYWm41WE13QjlsVzVLTEhudGhmNmpOcnpZWjdCV2l2?=
 =?utf-8?B?dmNQRTJaSElOVTlqRUJsMHl5bDNDVXN2SnRNdTU0SnhLYkh4aSttQWtHODQv?=
 =?utf-8?B?SWxQdjZRY3VsWlR2eCtGUkl5L3I0SGtMVnQvb0k2eTdwWGFoVDkyUE5UZk96?=
 =?utf-8?Q?bNIMkO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlVrYkVLdUdIK21Td0xNSVhNQWphNUEwZi8vNUdGOG9KT3loeVhnakl0YVNi?=
 =?utf-8?B?bWZ4a0d2cnZ6MjNqNVlSY3E5VG8rNkhIbU5vcDZYN0dHRkFmL1ZxcndHS0RH?=
 =?utf-8?B?N01paUp0L2dGdG9iV1NHYnNocHk3aDNQRXF0UnJiaDMvc0ZaVkdFUFBDRTN6?=
 =?utf-8?B?Tno0Z0ZVYmpFZjQyeDhCSDZVTE9pODNDNDJGWlJIQWtaM1psL2ttaUhvdGNU?=
 =?utf-8?B?OEk5WWJZdWsrZUFuWDQvUVl1MG9YbnZLNmF6MGg2Skp2UDdXL0FyeUVweDQy?=
 =?utf-8?B?RnN4VkcyUFlVWnl1MGNFTk9SS1h6Nmx4UjlEcE0zYmsrYlZHVnZPL1ZBL0U2?=
 =?utf-8?B?ZjZvVVQrOW9MT0xPekFYMnA1MDJucWVYNm52R1JITGdMVDNLL01QZnBMVEc4?=
 =?utf-8?B?T0ZzNFhOblNTa2ppOFY2Nzl5ZEJ1L0txQlRKa2N4cGxOQXBUa1dKZzZEc08w?=
 =?utf-8?B?K1FsVTZtRVpZMWVnODVJTFhnRWIzRURUVXg0NVFvUzRHYUdWYVNOYVZPMU8v?=
 =?utf-8?B?WEROVTI5YlBKM0FyRVNkZU8zbUtWYXhudVBTczI0MU9SUnBvTGVhOGZPQ1Zi?=
 =?utf-8?B?cU1XNGpHRWFkL1hCWTQvRGlRQTBvWUY3MjZIWXVibUtTWEpPTFNkT2MvWTJz?=
 =?utf-8?B?ZjZwVEVDUUxBYlorOXhSUnp0bVpzK2d0VTRtUVIvZlVmRmNlZE9DWExhckJR?=
 =?utf-8?B?RndaWlBQK2drUHBtZnRrL2dweGxxbFkxQlNrVENTbldGdXNSbHRoeUtZZmRw?=
 =?utf-8?B?WkcvTHRVZm1neWhsWXNGUThKTlB4TFNnWWtsaHY5SW4zcHlQSS9tVDJWWGNo?=
 =?utf-8?B?TmRYVW9xa2ZsaUJRRzVOMnpXRkVJbVl0Ukl6SXFTQXZjS1UyRVljQ2E1UzVm?=
 =?utf-8?B?SnZOMlo2ZVM2czB2ZFkza0Z4NnJFVGREdGlyMFVSMVBZN0NSSVNzRkFIbGVN?=
 =?utf-8?B?MGdPSi8zS3hJTy9aR3p6VGUrM3ZpOW1wdkVNQnV4eHdjYVZpS09ZaWZQVllG?=
 =?utf-8?B?OWwwK1RCejFPTHlDM2liRHN5S1JEQk1TRUNHc1YzZnhsVnBwL2UzOUZFU2c0?=
 =?utf-8?B?OVhLSTBjRHhDRlBXaTdMRE8yVWZuSTR3a2ZiS292TXRoRXc1Ti81bjh6Y0Zx?=
 =?utf-8?B?RGdPdXJWNU1wODNFVlpRZDB3VnZYYmFVdlA5Y2l0cHZyaHhEeXMzTkovSThR?=
 =?utf-8?B?Z2ZwMnROVXVuc0VPZzBHOGR4SUxQMHRnSVZmS3dZSnM0VDZBTHVHRjg1UVUz?=
 =?utf-8?B?bm4zSTg5QmdXRk9BSmxnemN0RUpaWEZxMDFjMm1XTEpOTDdrdGowNEFCWHR5?=
 =?utf-8?B?VUQxc05lcHg3MEFUUXFLWWdLcUpSRENqelh4dFdnRFBhZG12TllKZ0IySzJN?=
 =?utf-8?B?b3M3aGZCbVZ2RExLeXVENzRCUjZOd0Y1Ky9EM2t2dDJaMmZZbkFoa0NXQ0tV?=
 =?utf-8?B?LzY1RmxCRmZTNTBWRENpS1B5M0xxL2JqbW1tYllyVlZvOWNZdk1DWFFoL0NO?=
 =?utf-8?B?dVpUaHNncVNaK3oxNGpOVTVKekVCZHFueXg5bG1WT2JuTkFRU2dqSzMvdTkx?=
 =?utf-8?B?WmgrajQzVGFvSnRsQmc2NlRsbGZ0OGJ4U0NqdzJvZkxGZE5JMlAyeEFrQ25w?=
 =?utf-8?B?K1l5NzdFd2Zqcm85TUxGOENGdk9CY052Q2RyVWROakc1b0EvcnJxSTlHRGxa?=
 =?utf-8?B?UkFPbjcybVlMeXZTeXJCMVplNTRSOFJBQWgxM2doUnNzcXZ4elhic2poMFVr?=
 =?utf-8?B?OWlhb1pxemV2eVhxRUlvaElPTldDMW4vdzZCQXR0c3hxQmNtZXhUYWpJTm4r?=
 =?utf-8?B?blRDMTVxRmd4R01KVXVqNDd2T0o5QVQwSjlGYi9xNEhOVWx1L1dGajFqbnRu?=
 =?utf-8?B?T0pqUFlCc2JqZ1pESnZvM0pEak13NEl3SHpSSFR3NjhINFBmVkwzajZ2QTlz?=
 =?utf-8?B?bnNPYUdZNWtZY0s0RU14MDZXTGNuQXBqR3FCQ0cvSFRTaGhSVkxWL21XZEdx?=
 =?utf-8?B?cVQrYmcrSmhlR3FrNXNGcTgwZHV1LzNmSndsaHd6NndHSmcyY1V3KzJxSkQv?=
 =?utf-8?B?SlZxQVBvZ3Y0VEdSeURHMDVOMFhrd05abEtPaWp6QnYwaE81ZEg5dVNNVFYw?=
 =?utf-8?B?aHpZSGc3bUZzOTJ5MGpKN21RRFJ2dmE4WFEwVndsMlJoUTAwUGEvbzdMMTd1?=
 =?utf-8?Q?otT8/FeWgCYvaS5zJmqKkug=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C373E9756FCC44C83034B900D537CB0@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 098acf55-f375-4739-b712-08ddfd455c46
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 21:40:49.9152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfcgiZ0OkP8h/IiknHzYysyLpfPWgVLNWvUYSDqgaD8BpKsnoyw/nqIWNS36pjPwcLbUQNzojJsdA0MhM2II4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF70060AA38
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX5u6sz6QqHnEH
 Sd23VDs6V3hgX+PafltgF7jHx88ZviqJz1eFVd9PxRmx9UshvCuCd6+tR1zhBP7egpdDiMLTQRt
 85ZgKFy/zA+c+yVdMsLci0VZU7dwpIkMBSjnr8Tfhv/alhzuaiBqg0hC6qaGBrCtPHlv5YJmfEW
 2XysxIb1v2GIPWftDKRG4XAaT2uRTSHi5bPCM+PMfMmwaFDklzwTcARy0k/7ulXRBwghPraKySP
 yoc00mIF404Q/UfsWYVmfNdDFDNr8T6izqULMxQJLSWAOb01ceYicbhBO/GTsbWQhvHaXV+Bl2X
 zJowbEI5Gv73eB/cVbOPeyHqQp0OA6tQOcNLqJS4Vo8eaHSg9nL53zG5AMTyMJ+s4ughc8noeSl
 xY23QljlM//qCkjyaR24zp4uqHWy8Q==
X-Proofpoint-GUID: Ql7Jk4aoZxbMysfLulbd0W-TUdomTM4C
X-Authority-Analysis: v=2.4 cv=T/qBjvKQ c=1 sm=1 tr=0 ts=68d70864 cx=c_pps
 a=FRwzarAYk3lDJRtuO2pFeQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=LM7KSAFEAAAA:8 a=VnNF1IyMAAAA:8 a=qbhD1xvcCa7mYHvVm84A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: swXjraRPtBXACiegzMegbvGVJm_VBLHr
Subject: Re:  [PATCH 1/2] ceph: fix snapshot context missing in
 ceph_zero_partial_object
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_07,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDE4OjQyICswODAwLCBldGhhbnd1IHdyb3RlOg0KPiBUaGUg
Y2VwaF96ZXJvX3BhcnRpYWxfb2JqZWN0IGZ1bmN0aW9uIHdhcyBtaXNzaW5nIHByb3BlciBzbmFw
c2hvdA0KPiBjb250ZXh0IGZvciBpdHMgT1NEIHdyaXRlIG9wZXJhdGlvbnMsIHdoaWNoIGNvdWxk
IGxlYWQgdG8gZGF0YQ0KPiBpbmNvbnNpc3RlbmNpZXMgaW4gc25hcHNob3RzLg0KPiANCj4gUmVw
cm9kdWNlcjoNCj4gLi4vc3JjL3ZzdGFydC5zaCAtLW5ldyAteCAtLWxvY2FsaG9zdCAtLWJsdWVz
dG9yZQ0KPiAuL2Jpbi9jZXBoIGF1dGggY2FwcyBjbGllbnQuZnNfYSBtZHMgJ2FsbG93IHJ3cHMg
ZnNuYW1lPWEnIG1vbiAnYWxsb3cgciBmc25hbWU9YScgb3NkICdhbGxvdyBydyB0YWcgY2VwaGZz
IGRhdGE9YScNCj4gbW91bnQgLXQgY2VwaCBmc19hQC5hPS8gL21udC9teWNlcGhmcy8gLW8gY29u
Zj0uL2NlcGguY29uZg0KPiBkZCBpZj0vZGV2L3VyYW5kb20gb2Y9L21udC9teWNlcGhmcy9mb28g
YnM9NjRLIGNvdW50PTENCj4gbWtkaXIgL21udC9teWNlcGhmcy8uc25hcC9zbmFwMQ0KPiBtZDVz
dW0gL21udC9teWNlcGhmcy8uc25hcC9zbmFwMS9mb28NCj4gZmFsbG9jYXRlIC1wIC1vIDAgLWwg
NDA5NiAvbW50L215Y2VwaGZzL2Zvbw0KPiBlY2hvIDMgPiAvcHJvYy9zeXMvdm0vZHJvcC9jYWNo
ZXMNCg0KSSBoYXZlIG9uIG15IHNpZGU6ICdlY2hvIDMgPiAvcHJvYy9zeXMvdm0vZHJvcF9jYWNo
ZXMnLg0KDQo+IG1kNXN1bSAvbW50L215Y2VwaGZzLy5zbmFwL3NuYXAxL2ZvbyAjIGdldCBkaWZm
ZXJlbnQgbWQ1c3VtISENCj4gDQo+IEZpeGVzOiBhZDdhNjBkZTg4MmFjICgiY2VwaDogcHVuY2gg
aG9sZSBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogZXRoYW53dSA8ZXRoYW53dUBzeW5vbG9n
eS5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9maWxlLmMgfCAxNyArKysrKysrKysrKysrKysrLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9mcy9jZXBoL2ZpbGUuYyBiL2ZzL2NlcGgvZmlsZS5jDQo+IGluZGV4IGMw
MmYxMDBmODU1Mi4uNThjYzJjYmFlOGJjIDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2ZpbGUuYw0K
PiArKysgYi9mcy9jZXBoL2ZpbGUuYw0KPiBAQCAtMjU3Miw2ICsyNTcyLDcgQEAgc3RhdGljIGlu
dCBjZXBoX3plcm9fcGFydGlhbF9vYmplY3Qoc3RydWN0IGlub2RlICppbm9kZSwNCj4gIAlzdHJ1
Y3QgY2VwaF9pbm9kZV9pbmZvICpjaSA9IGNlcGhfaW5vZGUoaW5vZGUpOw0KPiAgCXN0cnVjdCBj
ZXBoX2ZzX2NsaWVudCAqZnNjID0gY2VwaF9pbm9kZV90b19mc19jbGllbnQoaW5vZGUpOw0KPiAg
CXN0cnVjdCBjZXBoX29zZF9yZXF1ZXN0ICpyZXE7DQo+ICsJc3RydWN0IGNlcGhfc25hcF9jb250
ZXh0ICpzbmFwYzsNCj4gIAlpbnQgcmV0ID0gMDsNCj4gIAlsb2ZmX3QgemVybyA9IDA7DQo+ICAJ
aW50IG9wOw0KPiBAQCAtMjU4NiwxMiArMjU4NywyNSBAQCBzdGF0aWMgaW50IGNlcGhfemVyb19w
YXJ0aWFsX29iamVjdChzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiAgCQlvcCA9IENFUEhfT1NEX09Q
X1pFUk87DQo+ICAJfQ0KPiAgDQo+ICsJc3Bpbl9sb2NrKCZjaS0+aV9jZXBoX2xvY2spOw0KPiAr
CWlmIChfX2NlcGhfaGF2ZV9wZW5kaW5nX2NhcF9zbmFwKGNpKSkgew0KPiArCQlzdHJ1Y3QgY2Vw
aF9jYXBfc25hcCAqY2Fwc25hcCA9DQo+ICsJCQkJbGlzdF9sYXN0X2VudHJ5KCZjaS0+aV9jYXBf
c25hcHMsDQo+ICsJCQkJCQlzdHJ1Y3QgY2VwaF9jYXBfc25hcCwNCj4gKwkJCQkJCWNpX2l0ZW0p
Ow0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChjYXBzbmFwLT5jb250ZXh0KTsN
Cj4gKwl9IGVsc2Ugew0KPiArCQlCVUdfT04oIWNpLT5pX2hlYWRfc25hcGMpOw0KDQpCeSB0aGUg
d2F5LCB3aHkgYXJlIGRlY2lkZWQgdG8gdXNlIEJVR19PTigpIGluc3RlYWQgb2YgcmV0dXJuaW5n
IGVycm9yIGhlcmU/IEFuZA0KeW91IGRlY2lkZWQgbm90IHRvIGNoZWNrIGNpLT5pX2NhcF9zbmFw
cyBhYm92ZS4NCg0KPiArCQlzbmFwYyA9IGNlcGhfZ2V0X3NuYXBfY29udGV4dChjaS0+aV9oZWFk
X3NuYXBjKTsNCj4gKwl9DQo+ICsJc3Bpbl91bmxvY2soJmNpLT5pX2NlcGhfbG9jayk7DQo+ICsN
Cj4gIAlyZXEgPSBjZXBoX29zZGNfbmV3X3JlcXVlc3QoJmZzYy0+Y2xpZW50LT5vc2RjLCAmY2kt
PmlfbGF5b3V0LA0KPiAgCQkJCQljZXBoX3Zpbm8oaW5vZGUpLA0KPiAgCQkJCQlvZmZzZXQsIGxl
bmd0aCwNCj4gIAkJCQkJMCwgMSwgb3AsDQo+ICAJCQkJCUNFUEhfT1NEX0ZMQUdfV1JJVEUsDQo+
IC0JCQkJCU5VTEwsIDAsIDAsIGZhbHNlKTsNCj4gKwkJCQkJc25hcGMsIDAsIDAsIGZhbHNlKTsN
Cj4gIAlpZiAoSVNfRVJSKHJlcSkpIHsNCj4gIAkJcmV0ID0gUFRSX0VSUihyZXEpOw0KPiAgCQln
b3RvIG91dDsNCj4gQEAgLTI2MDUsNiArMjYxOSw3IEBAIHN0YXRpYyBpbnQgY2VwaF96ZXJvX3Bh
cnRpYWxfb2JqZWN0KHN0cnVjdCBpbm9kZSAqaW5vZGUsDQo+ICAJY2VwaF9vc2RjX3B1dF9yZXF1
ZXN0KHJlcSk7DQo+ICANCj4gIG91dDoNCj4gKwljZXBoX3B1dF9zbmFwX2NvbnRleHQoc25hcGMp
Ow0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQt
Ynk6IFZpYWNoZXNsYXYgRHViZXlrbyA8U2xhdmEuRHViZXlrb0BpYm0uY29tPg0KVGVzdGVkLWJ5
OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0K
U2xhdmEuDQo=

