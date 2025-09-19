Return-Path: <ceph-devel+bounces-3696-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33157B8B001
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 20:51:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D65AE16439C
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 18:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5799C2690F9;
	Fri, 19 Sep 2025 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dZq2Hc1t"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3A6268688;
	Fri, 19 Sep 2025 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758307895; cv=fail; b=ZD9aB4tbGH7oPHQV4nmYVtg5U3UIkIJHwkMDhFxCTRrEaBKmTH0V8Y70a6pnAvro3nBQPRRaDRCUkbrM6o5LXgVs9VNfdEJ6jlbYjOLFIHsMasu9nXXi7Xazbetca2wJwzROQjl+81bOoXfORt6g2FEF59pKM9+C48CVjt1YQdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758307895; c=relaxed/simple;
	bh=E3XUJyT3S2TcDNqzXeU+6j35/UBqzJnGIHachMbX8xI=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=L9/RvFkgG45IdN/jr/nlLUBDtMOP4FD5cn6XvhTJ9GZXYERG5aiABZjKqYoRRrIHLhnAvKVPax+a+HQ43TXQeAHMV1gQsqxJzPtM2plO1ONrwZEWjCfNmMMCNiRmLpg5nyr15/Nuk1ILXSPQnVz37gFeRjJuCqBd6Vj6VdiebHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dZq2Hc1t; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58JAORN0027677;
	Fri, 19 Sep 2025 18:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=E3XUJyT3S2TcDNqzXeU+6j35/UBqzJnGIHachMbX8xI=; b=dZq2Hc1t
	XNYpLGO/1LrL7YHjJx2hjcUkIv5o7qGEbqjnOPijwsn2M1qMUMfjxyV3Acq3Z3Yj
	nWy5pcuNRhgamMEY2OO9Nbh6Yi2Qw/exMXRvaA0o5omQ2UFghqTlz/ZLDFQi1Pum
	2MmeFofllSbVIBG3ugHMYAYddXimIrkt/ngnNuZbliDcDnvzEVvc87gyezGI8rmU
	uaj4Ru/BN0JTPt+5mb2dEG9g3w+lUFcNmKaVN19gZ/6FotJeYofW6PzJbVNSN4nw
	gYQ7a3qORDaaxg7xTyE6YwqXgN/3dYycJVHXIi+HWaNetz8JyGGmb5WA3/x2qQZe
	GcM2YPTEGtvecQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4pjpw3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 18:51:25 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58JIpOBU009040;
	Fri, 19 Sep 2025 18:51:24 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4pjpvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Sep 2025 18:51:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBEZuNpfodP1ikkry0xLHSu7lp6boBIcMEc7iL5o6Y2dam7zqlkmDhyFpDNRg97PWNrTx4BCNpPKBs3uOMxwBdxR+4DRdMARnS2T5oz3n1P2jyhNFHw78guvlsY1RkApebnpuanAkMUtesd8HngvZriwXv0GEPv61mpZ1jj/RfZpiW90WdlQKCoFaZAttZ2fNN/NhK7E0sF0UeXG9Y+mhkQwHTZDhMVpDGMYDMmILH+cQO8o8ZAj/78dmxcNwH7RfdvAJUNTA++VubP6XpFn50HrQ/pNdMy9JsaiS6Ln62TX2UNUTA9ye44jEh83plSyVaJydU+8nFTU1VSRzJUnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3XUJyT3S2TcDNqzXeU+6j35/UBqzJnGIHachMbX8xI=;
 b=tl6JQNYY6hKyT6OPc8vPdEU1ySwfhNLo4gB2z9ukfh4wBYHGr2iV7k/+wyE1cTNtDe2Ys558htz3kNgQb3rJX51YgGJx2iU0n+tKC+7U1NLTMvX8aEuwUDcI7HaYYJY3trgM6u7U0Ci4d43luuFlc559NvoqnoE8+HLXDC/07m9oGh1v/o3PvANeSmjGcVtBi7U66m5ZA7Vrbp8TO6ghPordgfd/a+XrjaKW/uHxt5EnZciekxDFKiYm2nMBiDQt7UYUk+p7jbu3SiVGxR0u3xTVyyaK1CNQK/DwrZNOZHO3WJENY/YvmEhDACX6xST1KJZdyjaJ+sENuCu0RqBjHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by SJ4PPF77A0A50D1.namprd15.prod.outlook.com (2603:10b6:a0f:fc02::8ac) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 18:51:21 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::7a72:f65e:b0be:f93f%6]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 18:51:19 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "lyican53@gmail.com" <lyican53@gmail.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] ceph: Fix potential undefined behavior in
 crush_ln() with GCC 11.1.0
Thread-Index: AQHcKQ3x2RlbiGvXF0GmNaNKGmqQ67Sa2qgA
Date: Fri, 19 Sep 2025 18:51:19 +0000
Message-ID: <d6ccd709466d1460baf6e9b0bcec212007172622.camel@ibm.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
	 <e6987f0268bd7bceddbd6ec53fa174d07cfa3114.camel@ibm.com>
	 <C8E92D42-0336-45DD-A415-EA8588DE731D@gmail.com>
In-Reply-To: <C8E92D42-0336-45DD-A415-EA8588DE731D@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|SJ4PPF77A0A50D1:EE_
x-ms-office365-filtering-correlation-id: c762195e-919d-4400-e967-08ddf7ad8599
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cGcwMUVSTXdHdlNtSUxMcCtVOEYycUU1K21aZkR4QkpPTFFEMXhWVWREejBS?=
 =?utf-8?B?OTdDS2llWnJWNjVkNXNRaUxmeHViTnNJelR3THpkQmtVZUl4WC9PUHI4QzM1?=
 =?utf-8?B?RVBUOHVNcWQzanZYRUZRa0Q0VE5KL24yTWtBb1VZYUFlblBxMnhyTCt3VWxB?=
 =?utf-8?B?UWRHTGt5Q3RnM204dDcvYXNLdm9iMEtsMWpmV3hYY3Z5ek0yZCtPdnZkZVRY?=
 =?utf-8?B?Rk9WUmpwM1FWNFhkdVg1UHlBbWRmbzRwV1FFdlhmM1ZxNCtnZjgrOGRmUVBI?=
 =?utf-8?B?dHJ1bkhJeFZzNHNHc0V0dmdBbXRnQS9wek5sNG1kc1lEZGVibEdiT1Ztd25x?=
 =?utf-8?B?MHd4cUpydXJQQXNPMFR6STFaUUx3akc4VHcyNktROVZocm9BcDdhd285MnZq?=
 =?utf-8?B?SHltTytSY29FMWhUTmFMbHk5eTJsSk9VM3pSVlNURGRueEZzR3A4Q0xpeEZu?=
 =?utf-8?B?cFpVbERacFBrb05WSVFKQ0luYk13V0tUc1VFeDFYMW9VUFI0YUs0QXFEQlJn?=
 =?utf-8?B?Tk9JUlpMSTRaNzhkQ2c4SlJIUlVnUVpFTGJURG1SWnlyYUdVMmxZWlBnaTEv?=
 =?utf-8?B?RGdtcjFxbFU0dHd0S05BcDBPMWtzWlFkZElpSVFVUmFvenhtK1JFaVp1ODhP?=
 =?utf-8?B?RE9vUVNRVnBwNkpReTd2K1BnSDJrRlZTcHVvWDJDMVZtckNxR1VOTWpsVEUy?=
 =?utf-8?B?TG9ESWRySnN2SFRldWtYaEZZdzZ0RnJqQlBCOUFOUk9DaytXblk1andyR1VR?=
 =?utf-8?B?bG8xM0dCc2pLS2hQaGszWXE1clZ4REVjT2hrMlpkb1ZYd2pRWXpwbmZKeHVT?=
 =?utf-8?B?cjhud0RKT24zMWlCQ0tpOGVLTC9uajRzbC9HZmE2SXNFaUFRT2J0VXRUdHdx?=
 =?utf-8?B?SXNQTStmeElia0lVRkpTdXUyOEJtTDZOc3l1L1NQdEQ3N3l0UnJHbnNFRmVB?=
 =?utf-8?B?RTcxY1RwTElwbjF1S0JlZ0lyK0FLTzNGZEVPQWcybWR5VHduSEpUb1JxQ3A0?=
 =?utf-8?B?N0RSdHhLVUw4eDczSXVpUElUY2lXZXU1YlFiYWY1Mnk2THU5MjN3T2RhbS9P?=
 =?utf-8?B?cFJiUXZYdFhRRjJVbGRuOGZwelJIa3c3WWx2cVJBR1diNGpoS09GcG50V3JB?=
 =?utf-8?B?YTRYaHMrdDhtTGdCbGU1a2RONk5uQVJlMldxdktjb2xkaVVPWHhOSTNsYWtP?=
 =?utf-8?B?bGx0UzN4dFVYak9hN003QURwWkxYd0QvRzgwc3phOHA3am9EeGJ6MlNZWk00?=
 =?utf-8?B?QnlVdmZ2ak1TWnBWbDZ5RG1LZDl0ZnBIbEN6QnoxM1lJbUc5NGFFdzh0dEN3?=
 =?utf-8?B?N0Y3bkxJWXl6em0zOUxkaGdKQlc5YmlkR2FsMTYvdzFXWXdiVllhZkl3S3lo?=
 =?utf-8?B?bDcwTCtLWFFteDJKNFliaTllSklxTk8vTnh0ZW5FbGsrME44NjlPakg0ajF0?=
 =?utf-8?B?NGMyQ3RUdm9RNEJrVWdpbDJnOTM1RVQwQXNXbFhDZE1Wc1ovK2I3cTcwS3ZB?=
 =?utf-8?B?SGM1Z1k3ZTFCTjZzSXcyRGh2eEFJOXZHR1ZmekxEVFR3aDdVNUxKSDVjdUJP?=
 =?utf-8?B?OWkrZXBrTE41dTZXZzMrNTJVdVNwUHlTRUpMS0RoeGxaejJJNFF6SHJsRDdS?=
 =?utf-8?B?TjlRdFNaSzBDc1Z6VnhrYnBsdi9KdEpFaFRlWGc1a2NFMFZ4V0UxRHpQTHFN?=
 =?utf-8?B?dUltZFh6b1N3QnRvdEZXS2xxZ3BHWjhVbTByNCtCcWZaM1JuTmlDL2huaktP?=
 =?utf-8?B?eGYvdjBncnB0WU5LamlGaGdnakpWQkpaR2hXTWtnQ0s5ZDRBc0xKc0diVFZL?=
 =?utf-8?B?RXpvQkJ2SEFZYnhmUTdKUlJNLzF6MHFwV0NkTGlUQWovYkFGMGRPcHJWRmJr?=
 =?utf-8?B?aVBqVmZDcjJZckt2NGVOR2lDNUFUZmozcXVvUzZ6U2hqdjNBd2NSamxURjFz?=
 =?utf-8?Q?eUxdI7ls1Lw=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K3lpVXhKU3NqV3ZnMU4wWWIvaDM0eGtwZTcyRUhtd0NNdnBTVU9STVdYNHpR?=
 =?utf-8?B?NCs0NHdLZzRITkZBc2crM1BnM3pqRU5XQ2NvdjNleGdPdXJ1MTRURnMrN1g3?=
 =?utf-8?B?eHExSE1aWTQ3Rm9MVTdEQi9DMXk5a0lNdnhQZk9Uc2M4b1pZMThDSU84Rk9M?=
 =?utf-8?B?bXFKZ2dtbjFBSnpBVU4wZEwwQ1owZzI4dFhnQnQzbm9uT2c5KzRHZ2VwaDhx?=
 =?utf-8?B?Zzc1R3h1TDZUNno4NDRxeHB0SUlqRDRkVlptbXh1QjEybEc3T2JSMUtYK05G?=
 =?utf-8?B?L3E4eWJISU9xZEkvNlFLR1dOdWs1RERuRXdnc2ZJVEg0YTc4VWpPa2hsd2NJ?=
 =?utf-8?B?bDF3SVBUdFJ2RHJXTUZaYzRCeWFuZ21mN0hNNGtEYTM1ZGpSK1k0YXJ0L3VW?=
 =?utf-8?B?S2JLeGJ1MG0razlGQkt2SnZxSFdGYlgyVzIrT2xxUmJvb25EOW1YQmlXQnRE?=
 =?utf-8?B?OXprWWlKNi9maE41WGhoT2NPY2JsdFpZYkpwWUV6SmJoamFHR3A2SEVkNlB2?=
 =?utf-8?B?aE9UQ0o5U3F1amNVeTRGbURUWmE0TUVHNWVjSVBPbEFCNDIyNFNsTkpEN2ZB?=
 =?utf-8?B?eWZxUEFWSklZV3dVQ2l4OGFZVWVwbnVDTlVDSVJvd3Y3cG1qcW9rdWFmb2g5?=
 =?utf-8?B?TEJrQVV3c2U2VnNCM0dmanJWOUZIbkZwMGdRZWVrSTRoTFFnMGJ4QVBRcWQ1?=
 =?utf-8?B?Ly9NZEZ0K3hVVHNPK29uK2ZQUGN0QzR4NHhZYy9vVDFOR0lqaWJtcThWamdO?=
 =?utf-8?B?eSs5Mk11RzdmMDU2cWxFSzF2dDhmRS9pSkFhL2tnemlnMlp0WlJPTDQ1c0Yw?=
 =?utf-8?B?V3MvME1sa3E0VUV4K1JmdWR4YXR1VTR0OE1qUDdhS1dRWVlsQVBXMkUvNkp1?=
 =?utf-8?B?SExqM05oUi9wMi8ycklFM1RLWTVCdmU5WE9PQlVYcEVtcVpvWkNmVE9LNURS?=
 =?utf-8?B?eTA1WWpDRFRSdWkxQkVXelJkdXhjem5mUGhsaThvOEFmdVIzK3RWc285Z1Y1?=
 =?utf-8?B?cjZDcEVIbzI2amFrU1poc3RzMFFWVkdJTDF5WGdrcUpRZVY1c0dCSVRHZ0Nk?=
 =?utf-8?B?L2FaUXdpN1dYQWwyOEtwNFpXd3Qrd2lkcWc4M29nM2M2dzFnOUc3YXZwR2Js?=
 =?utf-8?B?bnAzOTVxMDE4ZUNicTM0NnZvejFuNWpSUmtwVlo3ZWtqSTdwNmZaLzk2Z004?=
 =?utf-8?B?c3BFWVE1V3RLeStkc0gxaXBZVGFJT05pekFOMlN2OHVac1NXVjJOMWJadjhw?=
 =?utf-8?B?ajU5cVRkUkNqZjVLa290VnZWQyt0eG1ab0xrWVVzdEhmdm91dTluaWdGVXZO?=
 =?utf-8?B?UVM1ZHN1OFd0T2V4dFhYbXpQYVJUMmx2bnR3RkQrUkJGVVdERzM2emcrMFNj?=
 =?utf-8?B?d0Jrd01hMy9saU1YeklqcjdtN1hwckZDMXl6REZoODROMkVqdE5GdjJBdDBM?=
 =?utf-8?B?bWpjZ2pWelU0NEwyNkcwOXcxV3hEV1J3UGJ2TEo1WGdIc2kxekhQK2d5RHAy?=
 =?utf-8?B?NkF4Nk5MMGFydzFCMWFxSGpuZW5rTjY4cktjR3BkYmFTakcrNmJRaDg4RUhv?=
 =?utf-8?B?WW92SS8rdTNaL2RZa0xQc0sraTA1SlRtUC9OeGRQaUE5WkkyUThnbkZPTjdn?=
 =?utf-8?B?VWt5YVA2Nkl6NU0vY0ZpZ0V2NjFzSkwwbTRlRERsVHFNeDhCYnFrc00zbWFr?=
 =?utf-8?B?VFlnM3Zweml5YmJaM3cvM1g0NjlIZkFobW9BazhGbEFSSlN3dGQ0T1NXNUpu?=
 =?utf-8?B?VjRRcUpBZFpwa1c1VmN6QkkvTkhxa3NSMnNiODE4Zzd4di9GalBtSjBKVmh4?=
 =?utf-8?B?MlZ2VjlYVVNXNE82VitTNmtMTkFRbEVYSWFOd0dwcGtnYm5kR3RnakpLdm9W?=
 =?utf-8?B?d00zaFlSUkV5N0Rka0I4TDFYbTVTcXdCWUVvY3hCM01xZmtCME9jS3RkK2tL?=
 =?utf-8?B?dXA5MjE4MDlTS3BhZDFkdFJtVmZRNWhEaUczdTd0QzNDUUNxeDh2L3JyY2hq?=
 =?utf-8?B?Q2o0MDFyemkxZS9ZWHFraTlUZWNWNWtGNVQ5VjVFZXBjYUcxTTB5TjFhRDE1?=
 =?utf-8?B?Q3dST3JDL25IRTJJSlV4VDk3RnZqVFF5TFdjcEVGVm02SnVJTVNYSjhRS0Ry?=
 =?utf-8?B?a0c0UldUSG40T2pwaDhCMnNIbUliYlE3Wmt3K25RSS8vYlovWWZQb3UwcWxv?=
 =?utf-8?Q?vZEXImpdzeoNxOh/Z25tLJw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2F2D6CC899D454498EC0132EBB022C5@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c762195e-919d-4400-e967-08ddf7ad8599
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 18:51:19.9093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NoS5I/pEo47bXPRaB0WcsaV9OhsveknO1xPLChCMXE/hN/Co9igWK8aDEeTkZH2EwHlzxcVc42Ev9S8mFwXmUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPF77A0A50D1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX/4r65DwEEbv/
 zZMPYQ8JFGK9NOHY14H0vLy3VySIysRKLHMK2aXXKly952Ppw60DoCM0bCC8dS2NFEloTal2Z5z
 TLWtg56JyhXIzkWBere09lKbQb2qf3yUvy2gKpo89ghidst/8wN7zvCWusDVLlcGcZ9LXBaROA7
 IgZsTQn5xmkyUCGQPdCoNBtYytZwSttSv1Q73MWD7RACYJMl7nRFekGGHP1Yz0Id3GAzEZWws80
 u9lw5P3FPu5E+9y4qa17nXzoNlcrKYLgjEOQ9bD1bc3iqIJf4K+7aMYfpbB4qpFs1/WdDTjR88F
 9MotHEXoZ5ColU6DtoEhD2KoxbRgxDo9ranbhMYDtxD9jqHQnei2LvBDKjFrBRF6qUvUTpwwIRu
 HRc3ZUYG
X-Proofpoint-ORIG-GUID: 5e1vOUih3cyQbTsgEh4XmBfm7KcVaO6o
X-Proofpoint-GUID: JppZIFucyznVRSsgJQP4cu8EAtCgBta2
X-Authority-Analysis: v=2.4 cv=cNzgskeN c=1 sm=1 tr=0 ts=68cda62d cx=c_pps
 a=9z8yexD6E2gW5LInT/Y/IQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=P-IC7800AAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8
 a=wvpoYDT-oJ9IY01O0NcA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
Subject: RE: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with
 GCC 11.1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_02,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDEwOjM0ICswODAwLCDpmYjljY7mmK3vvIhMeWljYW7vvIkg
d3JvdGU6DQo+ID4gMjAyNeW5tDnmnIgxOeaXpSAwMjowN++8jFZpYWNoZXNsYXYgRHViZXlrbyA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPiDlhpnpgZPvvJoNCj4gPiANCg0KPHNraXBwZWQ+DQoNCj4g
DQo+IEhpIFNsYXZhLA0KPiANCj4gVGhhbmsgeW91IGZvciByZXZpZXdpbmcgbXkgcGF0Y2guIEkg
YXBvbG9naXplIGZvciB0aGUgaXNzdWVzIGluIG15IG9yaWdpbmFsIHN1Ym1pc3Npb24uDQo+IA0K
PiBZb3UgYXJlIGFic29sdXRlbHkgcmlnaHQgYWJvdXQgdGhlIHBhdGNoIGFwcGxpY2F0aW9uIGZh
aWx1cmUuIFRoZSBtYWluIHByb2JsZW0gd2FzIHRoYXQgSSBmYWlsZWQgdG8gcHJvcGVybHkgc3Bl
Y2lmeSB0aGUgTGludXgga2VybmVsIHZlcnNpb24gYW5kIGNvbW1pdCBoYXNoIEkgd2FzIHdvcmtp
bmcgd2l0aCBpbiBteSBvcmlnaW5hbCBzdWJtaXNzaW9uLiBJIGFtIGluZGVlZCB3b3JraW5nIG9u
IGNvbW1pdCBmODNlYzc2YmYyODViZWE1NzI3ZjQ3OGE2OGI4OTRmNTU0M2NhNzZlIChMaW51eCA2
LjE3LXJjNiksIHdoaWNoIG1hdGNoZXMgZXhhY3RseSB3aGF0IHlvdSBtZW50aW9uZWQuDQo+IA0K
PiBJJ3ZlIG5vdyByZWdlbmVyYXRlZCB0aGUgcGF0Y2ggdXNpbmcgZ2l0IGZvcm1hdC1wYXRjaCBi
YXNlZCBvbiB0aGUgY29ycmVjdCBjb21taXQuIEkndmUgYWxzbyByZWZpbmVkIHRoZSBmaXggYnkg
c2ltcGxpZnlpbmcgdGhlIHplcm8tdmFsdWUgY2hlY2sgdG8gbWFrZSBpdCBtb3JlIGNvbmNpc2Ug
d2hpbGUgbWFpbnRhaW5pbmcgdGhlIHNhbWUgc2FmZXR5IGd1YXJhbnRlZXMuIFBsZWFzZSBmaW5k
IHRoZSB1cGRhdGVkIHBhdGNoIGJlbG93IGFuZCBraW5kbHkgcmV2aWV3IGl0IGFnYWluOg0KPiAN
Cj4gLS0tDQo+IA0KPiBGcm9tIDI0NjVkOTk3OTc3NjRhZDQ1ZDczMTVmMGE0YTBmZTBmNWU3MTEz
YTEgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxDQo+IEZyb206IEh1YXpoYW8gQ2hlbiA8bHlpY2Fu
NTNAZ21haWwuY29tPg0KPiBEYXRlOiBGcmksIDE5IFNlcCAyMDI1IDA5OjM0OjE0ICswODAwDQo+
IFN1YmplY3Q6IFtQQVRDSF0gY2VwaDogRml4IHBvdGVudGlhbCB1bmRlZmluZWQgYmVoYXZpb3Ig
aW4gY3J1c2hfbG4oKSB3aXRoIEdDQw0KPiAxMS4xLjANCj4gDQo+IFdoZW4geCAmIDB4MUZGRkYg
ZXF1YWxzIHplcm8sIF9fYnVpbHRpbl9jbHooKSBpcyBjYWxsZWQgd2l0aCBhIHplcm8NCj4gYXJn
dW1lbnQsIHdoaWNoIHJlc3VsdHMgaW4gdW5kZWZpbmVkIGJlaGF2aW9yLiBUaGlzIGNhbiBoYXBw
ZW4gZHVyaW5nDQo+IGNlcGgncyBjb25zaXN0ZW50IGhhc2hpbmcgY2FsY3VsYXRpb25zIGFuZCBt
YXkgbGVhZCB0byBpbmNvcnJlY3QNCj4gcGxhY2VtZW50IGdyb3VwIG1hcHBpbmdzLg0KPiANCj4g
Rml4IGJ5IHN0b3JpbmcgdGhlIG1hc2tlZCB2YWx1ZSBpbiBhIHZhcmlhYmxlIGFuZCBjaGVja2lu
ZyBpZiBpdCdzDQo+IG5vbi16ZXJvIGJlZm9yZSBjYWxsaW5nIF9fYnVpbHRpbl9jbHooKS4gSWYg
dGhlIG1hc2tlZCB2YWx1ZSBpcyB6ZXJvLA0KPiB1c2UgdGhlIGV4cGVjdGVkIHJlc3VsdCBvZiAx
NiBkaXJlY3RseS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEh1YXpoYW8gQ2hlbiA8bHlpY2FuNTNA
Z21haWwuY29tPg0KPiAtLS0NCj4gbmV0L2NlcGgvY3J1c2gvbWFwcGVyLmMgfCAyICstDQo+IDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL25ldC9jZXBoL2NydXNoL21hcHBlci5jIGIvbmV0L2NlcGgvY3J1c2gvbWFwcGVyLmMN
Cj4gaW5kZXggM2E1YmQxY2QxLi4wMDBmN2E2MzMgMTAwNjQ0DQo+IC0tLSBhL25ldC9jZXBoL2Ny
dXNoL21hcHBlci5jDQo+ICsrKyBiL25ldC9jZXBoL2NydXNoL21hcHBlci5jDQo+IEBAIC0yNjIs
NyArMjYyLDcgQEAgc3RhdGljIF9fdTY0IGNydXNoX2xuKHVuc2lnbmVkIGludCB4aW4pDQo+IMKg
wqAqIGRvIGl0IGluIG9uZSBzdGVwIGluc3RlYWQgb2YgaXRlcmF0aXZlbHkNCj4gwqDCoCovDQo+
IMKgaWYgKCEoeCAmIDB4MTgwMDApKSB7DQo+IC0gaW50IGJpdHMgPSBfX2J1aWx0aW5fY2x6KHgg
JiAweDFGRkZGKSAtIDE2Ow0KPiArIGludCBiaXRzID0gKHggJiAweDFGRkZGKSA/IF9fYnVpbHRp
bl9jbHooeCAmIDB4MUZGRkYpIC0gMTYgOiAxNjsNCj4gwqB4IDw8PSBiaXRzOw0KPiDCoGlleHBv
biA9IDE1IC0gYml0czsNCj4gwqB9DQoNCkkgc3RpbGwgaGF2ZSB0aGUgc2FtZSBpc3N1ZSB3aXRo
IHRoZSBuZXcgcGF0Y2guIFlvdXIgcGF0Y2ggaXMgdHJ5aW5nIHRvIG1vZGlmeQ0KdGhlIGxpbmUg
MjYyLiBIb3dldmVyLCB3ZSBoYXZlIGNvbW1lbnRzIG9uIHRoaXMgbGluZSBbMV06DQoNCjI2MAkv
Kg0KMjYxCSAqIGZpZ3VyZSBvdXQgbnVtYmVyIG9mIGJpdHMgd2UgbmVlZCB0byBzaGlmdCBhbmQN
CjI2MgkgKiBkbyBpdCBpbiBvbmUgc3RlcCBpbnN0ZWFkIG9mIGl0ZXJhdGl2ZWx5DQoyNjMJICov
DQoyNjQJaWYgKCEoeCAmIDB4MTgwMDApKSB7DQoyNjUJCWludCBiaXRzID0gX19idWlsdGluX2Ns
eih4ICYgMHgxRkZGRikgLSAxNjsNCjI2NgkJeCA8PD0gYml0czsNCjI2NwkJaWV4cG9uID0gMTUg
LSBiaXRzOw0KMjY4CX0NCg0KVGhhbmtzLA0KU2xhdmEuDQoNClsxXQ0KaHR0cHM6Ly9lbGl4aXIu
Ym9vdGxpbi5jb20vbGludXgvdjYuMTctcmM2L3NvdXJjZS9uZXQvY2VwaC9jcnVzaC9tYXBwZXIu
YyNMMjYyDQo=

