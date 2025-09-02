Return-Path: <ceph-devel+bounces-3500-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B87C3B40D46
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 20:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02C6C1B657C9
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 18:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4B9341ACF;
	Tue,  2 Sep 2025 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TRKX/BT4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27A296BDD;
	Tue,  2 Sep 2025 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756838549; cv=fail; b=bhayJMIZkry9lg/Oe2sRhNzBtMteI2PXmQ3nmOPrwHcCo4w5Az1oARwsg+SsBGnHLnfKSjqOOmWTwfvLOjC3JmuJsOLuYSvb+vUteQeOo8PcbS6RAEmlun3t4Y2pxMzMmpzhzbjNxL3OpGF2+s6V0um10/h3By8VfU+G5xx4GmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756838549; c=relaxed/simple;
	bh=I6huKjfYj+rAQkD3rnP6vFeFLldnMS2tA/0RUQMojHY=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=H8a0H4W3Lwq6pr1nyrN3iDX4bO8LOTXOhv/ZMbxfbWvvsly4RkuH/VoIttoVowOZNvbqe8rfaO9212oTbrOXeqcKkXqd2lDDovWpE2UdCXJvbpwSZcF/KN+OMbYebdOliy2cO6yUKHDMMFxsL/cLU5haZoZfOBcQi0Yl+2j9ULg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TRKX/BT4; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582CDcL9000809;
	Tue, 2 Sep 2025 18:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=I6huKjfYj+rAQkD3rnP6vFeFLldnMS2tA/0RUQMojHY=; b=TRKX/BT4
	WAwwyzJStN2d9xTPcIqJbhkCAHlejEjjtF6Sx7RrCiMRVL/gJ/HPHExFauoaKvVN
	+n/DWvUoD2kfrpOuI6rMSVeYvKJp9BlPwOZVTxuRrnhpYweULWcfDF1YB6RBXyiP
	1j522+0b6E/1TeQPg2qJjDEg2qVkzpHRwDbHaLj/o7hdtAt8HFZBC+N7h0yHn7Uk
	E8Ng1A81dxchdlEsxnwL/YY2MOUYCb21zVBX1Qhu07EBTZ++O6QnUZkDXPDZJzEE
	0pwn7uXHisWSPIiebe0GwApjwdhmEKYRp2fUD4owHWMIQ36cKya0M6JLKlJnn7NL
	e/Fj+H7QD1NzJw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usur06dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 18:42:24 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 582Ig74o018370;
	Tue, 2 Sep 2025 18:42:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usur06df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Sep 2025 18:42:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YTod8Abcj6rZzcgNFhutms4NyXd8b+Z+nhfq+GFdG2DprXM4JlO7LCF7Uw4mfNv4gqLcIUwyVS609yB1TGRxKidkYtJw27vDBJMsJzCODrw5D3b6anIF5kJ3DRPlddbzSxbh3NPZkwH2ls6gfpepIJVnw0RO2R6e2t0i7Dn0Gk+YF+Qw6tM22acQPqdBkESyd+vcBJ/6RzUwTCaLy9BcodJMcmfL3DQnJXB/UdzLvcLGd0s/P6Em/Iuw/V2S2Dol7ZjqArKUScZDWgmLmjONkd4DcSE3iDu6rPY8oetBquBJLj8Xv0OV4ZuVPkM9vkWyP9hzb0PW2P7IuAI2/fQuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6huKjfYj+rAQkD3rnP6vFeFLldnMS2tA/0RUQMojHY=;
 b=jCCRqNlnXGfVwbQzkv51grGwNbHUZuCMMZD43S4EzY0YZxUWxD2zq/zbR6FXp0ZHzYSDh59xJC7UPc8GP3+1KdSM7v+KmWwa9l5UTDURdgoQz5p7AnzD5NH6mAYl0zmC56RTxLVDjLbrD171RMtLBQFDEvMqNKk4VrZcCPUpkiBSag7sGK2NOeCwkA2OOkUsU8ijtbo5pY1QgYGGNNGdJ6wZBgVnW0p1ZeyoPo9xdJpt/OE7KtgErMfcnPQsJxVwbM7zgSDbnqyHIPjxH+P9DnMY7hU7tGiN4U3pRT5M1fCA5hzt79bV9mR09xQiDWqjhTz3XWzC3ubBnEdOKHGOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com (2603:10b6:a03:4e4::8)
 by MN6PR15MB6342.namprd15.prod.outlook.com (2603:10b6:208:475::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 18:42:21 +0000
Received: from SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611]) by SJ0PR15MB5821.namprd15.prod.outlook.com
 ([fe80::266c:f4fd:cac5:f611%4]) with mapi id 15.20.9052.027; Tue, 2 Sep 2025
 18:42:20 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
CC: "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 1/2] ceph/mds_client: transfer CEPH_CAP_PIN
 when updating r_parent on mismatch
Thread-Index: AQHcG1MxVG3FCQYKTEiozhL9JL/wgbSAO/mA
Date: Tue, 2 Sep 2025 18:42:20 +0000
Message-ID: <ae2a652559e30aaea925fc2dfe28602f7216f5b0.camel@ibm.com>
References: <20250901151448.726098-1-amarkuze@redhat.com>
In-Reply-To: <20250901151448.726098-1-amarkuze@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR15MB5821:EE_|MN6PR15MB6342:EE_
x-ms-office365-filtering-correlation-id: 7784aaf5-e017-42ac-858a-08ddea5072ee
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QUhjeXZpVjlFeTlqa053RVk3bXJhazk4TlRoaVlaN2t4RXZrTnZXWTlrUVRV?=
 =?utf-8?B?WVd5bVZIbTRVUlg2cmg0aU56K1M3T0dBOHlNZ1hKQnFLRDhQUC9MWE5Md2Fp?=
 =?utf-8?B?MzBOMjMwcFpmNnlIbG1PK21sRTVzV2RjdkVCYTIxbm10ZEdGWFAvY0txU0pW?=
 =?utf-8?B?Vk5RMU9VNmVSZFFPa05kWXZabVpRSlo2WCt5eHBWQkNGazBYRlBsQ0VLL3BW?=
 =?utf-8?B?TmNDYU8rbHQ0QjBUZm9RQkdzZGFlSUVPNGdrWUl5clpaR2pTdVhDcWRPTU9S?=
 =?utf-8?B?Z0xvN2VIQlI3Z3hId3lOQUltdWU3QkJCcHJsajB3dXNCNStzWGxNc2I1MmEz?=
 =?utf-8?B?eFpxb2hiN0FnZzJCcnRnOFJCT0U3eks1OWp5L1Z1WFI0cGFRTVE1S2tVWUIw?=
 =?utf-8?B?akhINGQ0VTNZN0g4enVFRjJnTGZMZ012MTBIejh2WEY5N2ZGemJmVEE5V00v?=
 =?utf-8?B?TGtHNE51TW5zb3V0VGRvSFBlVHgxSlJ3MGJIL0g0akNqRklzSDR1dUFEM3Nl?=
 =?utf-8?B?UmVqR2RNeXVSQ1BSVUFPajhJVmQra0lpc2UrSm5zL21OYktCY09vcFBaZUpV?=
 =?utf-8?B?S2d3T0FGaXlPNVAvS1lVQldBaERBZmRLZStaOE14MitianM4USszbG9zYkQ5?=
 =?utf-8?B?THdqSEdiaE80QWtFSkZXcVFSNlo5WkpqOWdkWmpBVkdxQ3ZkZ3JMT1I0SVRH?=
 =?utf-8?B?dHNDRGpTa0tiQUZWc1dFNDRZZ1VLalo3Ky84bVpHcUprQzg4cnNYTEczQUNo?=
 =?utf-8?B?N3BJN08wbHdyeDdodnJyeWwvdXpjM0g1MklZK2xjSC9oQVVIRkZCa2V0ME5p?=
 =?utf-8?B?Sm1pUk5CdmhHR3ZhSUpqMmhZT2pzUGsxSmpwa21jYkNZM2lkZnhnMjBtbXVj?=
 =?utf-8?B?Qk1SWE5veWErdG5xT3k3QkZHK3dRdmw0T2VCQ2YxOWNjUmdyT2JzL0dhd29j?=
 =?utf-8?B?VDJGSDdwRW9KWk5VQ28vN2hXUjZxZW9xYnpmNmgyblhmUUc0REVFbnBCK2hh?=
 =?utf-8?B?R0pGbVBrTTdZbk1lUWNacVNmaDF4WkhwcS9sSjIrS0diZGt1aWw5Z3dnSG1M?=
 =?utf-8?B?MHJzQ2puTzdPT1hBUFEySndHTXd4Wjk5b2Juc1lBUUtBOUYrOHlBaTEzL1RY?=
 =?utf-8?B?ZnZESUNGdXJMeXUzUEZ0L3R1LzZiMGNremxBV0VVem9UeXUxTGNFU1pCMGFh?=
 =?utf-8?B?VUcrdVFtRVRPUlNkbDVLZmgxVTFSTUdrZVhLc3RxMXY5RythQk80NHozb0RH?=
 =?utf-8?B?L1R1NmJkd3VLalZmNVZlc2NtRHZGa0hpWVZQOFoyYnhJY0tsdUs0bHZabTlZ?=
 =?utf-8?B?NE9jQVQ0R05ydEFPaWZoUlJKYWgxRk1XSUlZUy80ZE5IRnBCRzM4aEhVdmcw?=
 =?utf-8?B?NVNCaEZBUFkwL0NWeGpMc3dQTm9qeW9uY2pUNUhlUUc3bkF6Vks1eVZva05W?=
 =?utf-8?B?bmI1aFVXanNjMnkvUC95VGpNNFdCanhQSEc1NERPdXpwZit4aC94dHovMDN1?=
 =?utf-8?B?Z0RLam5jcU9Md1pCdXJyalJGU1k2QmVKUmRnaUM1Ulp2MWRiWTNGRkFaQ1BB?=
 =?utf-8?B?N0QwTmE0S2xycjJIT0hZekJLdzJxK1VyT1dMN2l4RGZhVlpDNmxSSktocjlU?=
 =?utf-8?B?bDRWblNzei9tN2puaE00NHNBY21jKzVSWkFVdzlEMGhlVnRVRlczWElYWDcz?=
 =?utf-8?B?Y0xKRzR6U2h4V21nMkZwckljSkY4UTFSZWR3Q3grK0JHdXNtamRYcDQ3dHpk?=
 =?utf-8?B?b293Z0NpV0tMZFNENitJMzQvYlRpU2gySWp4YTZKTHR0cUhhVGJjQ3R4M1dS?=
 =?utf-8?B?azcyYkpxSkZCVkpISHhmalZFVEdxNk1PamlYcGNjdm9kRGRLeDhGWWI3eUpB?=
 =?utf-8?B?MXRtQlh2OG1mVjN3VEFFcE85Y3FNVDBONTJQdHNDejdhK1IybHB3T2ZtbW9v?=
 =?utf-8?B?eUVvNEkyTW9HVUU4TnBlUWNJZGFVdEhJcFRwVUdrWWtEQUNUODlTZ0VDS1A3?=
 =?utf-8?B?QU0yU20vMXFBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR15MB5821.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2VIRHl6R2s0dXJjUXpYMG0zTkRxOUVQQTVlNWNGc3JEMXMxMFp5Y0Q5NTJo?=
 =?utf-8?B?dXZUdlJLVHR2ZFp2NWJPSXRnelBmdllFUFkxVFFMampXUUtGMjU5YnliczZk?=
 =?utf-8?B?STFGRmFrNnNTSUJyMUc0SmpTRDlyQ2xCRW9HSDdUUWwraktBVDNrb0hYMTAr?=
 =?utf-8?B?ZXUwbkNlNzVDVndPQXF4bmxFblhzVFpSWWdJbnk0YjN4bzBNWHB2WlB5WmdK?=
 =?utf-8?B?NHNVY1ZJWlo3ODFSSjh6TzNDVnpiQXJYNm9ESkg4b3hGUGI2R3c1RmVYa3BK?=
 =?utf-8?B?U0lRM2lXbFdtdUdWT3R6YjVDbDRsTGVFZUNWSWt5dzhFMmNIYy9scGIxdVVa?=
 =?utf-8?B?eHdMVi9ISmE3TEZ5ZmdaRUc2cmUyc3o5KzBtam5IdHlaMmVUTCtIWlVuNUll?=
 =?utf-8?B?UkdybFFPbm5TQlk2RW8wc0NIUWZ3N2lTVXkvb0UwN1Y5bDRDT1dxNm1JMStS?=
 =?utf-8?B?VkMxUk1zNy9jTHJ1QlQvVmFvWXBLQkdsb3RyUE5IZnA4aFFudWdRa0pCVU9I?=
 =?utf-8?B?SEMwQVk5NlI5VU9MeGFqUWJmaEVlMmdoYVJLMnI5bEgxNG1aRlROaUFCd0xJ?=
 =?utf-8?B?ZUlmeHgyWkdXVk1YdkFNbCtrY0V5Y0pyQ0s4ZmI1c3JDcGZFelZ0enpGL2V6?=
 =?utf-8?B?ZXpEWGtQSUMzWm9ZSTdKWWg0MVE5ZzYraFFwdWNNUzRMNWZoRGw4VDZlek10?=
 =?utf-8?B?NnVRMUl2Y01WSitONHVraWJYOXY4b1MxVGUwZXF0cklsb0NRN1dlcVN0M0tD?=
 =?utf-8?B?R1lud2NwYU00cjcvdGlEVXMzU3hkOUtjM0I0ZjhseFBJZnpSWTgyMHJ1R2RO?=
 =?utf-8?B?eGo3TGdBOUQ2N1IvTlJhanNJNGUrQ1Ewb0lLRTBPMnFUWEF1WHgwTTB2Y2t2?=
 =?utf-8?B?UzZrMFZaZGFzNm9nTTV3TXc2NDY5dkxXOTNBdHFyODBKcm1zd244T09DY3dX?=
 =?utf-8?B?RFJqZEVGV216S210K2k1RDRzVm40MW1TbUNVdkJNQ1VEMFdXUmVhdlFlbFdp?=
 =?utf-8?B?NWNjUE8rT0lnMXl4R21WWmtnVnZ5K2lIT3A4cmVTT2s5VVhuWHpDN2x3ZWll?=
 =?utf-8?B?M0xkODFxOTJOZmxjd2R2UzZiT3luaDIwQkRBVWhjNDJJY3lwUEpuQjNjWGg0?=
 =?utf-8?B?eUxTU3d5YnFFaGZFVHRreXVLdUM2UGVUdEU1UzhLSnRTU2VrUGJHQmZ0TS9W?=
 =?utf-8?B?MzlOWDl2RXNxSTA3MlA1VzBVTDNjZ0J2U1VSa0VhWjlySlQ1RURIQ2F4cyt0?=
 =?utf-8?B?dzM4SjZqejh6MnpCN244REJEMnRpRTlXNDRuTWhacjdhdWd2L0t5MVEyWWJz?=
 =?utf-8?B?L1RBSm9Sald3bnhwQnJuL1pwUSs0VE1OMjNaamxreWF3aDRKV0hsSzZCay9y?=
 =?utf-8?B?VnN1NmJ0Q2NjcThOQTZiMkh3T2x6TndFOXR2YmtEcFNCNnlGeHp4Tnk2M0dw?=
 =?utf-8?B?Y2ZyUFVnRDMrSDZmelpsWVpTK1QxZEtOeGRGSHBkaXAzaDltSkkvMUFPeVpI?=
 =?utf-8?B?QXZqa0l6enR6QkZoRVpFOXRnbjVmcS9kZjYyU1p2L3pOUTY3cjBWcWJJQi9s?=
 =?utf-8?B?NTZWUUJlTXd6U3VCQ3YwaEZnQXllU3Y2OXNCMGJDZmJrQmx0QWZvU3dCZFA1?=
 =?utf-8?B?MklnTSsyYzNiQzFLbjVXQjdNOUdPblc0dWN2QThudUZzUHNUb3lrWkdIY2Zr?=
 =?utf-8?B?WG9CRkdVSVFQSlJMMzcxUUxvRm8vdGwyNElmZUluK2xSZi9WSXRGM0E1SlFB?=
 =?utf-8?B?OGxDbm9GTGprUlBCY2oyTUFPaVJkSG1jTDJHNEthWWJYdnFldmVidU9HanRp?=
 =?utf-8?B?Y3g3MjB3OWZldG9yam9sdXdVWTd4NTc1c0lHZ0szdnhwMlFKK1dVK21pNkdi?=
 =?utf-8?B?VzZScGtLMXdVTUU4L0RiaEtvUWFONzY2RXJkaEE3WHlYZEtzQ21jN1pXL3p3?=
 =?utf-8?B?M05hS3U3d1AzaURjWGJ4TXVnaGZ3UlFDUG94VHN5aXNBTDJSVkNGT3FYWm9Q?=
 =?utf-8?B?YXhSSFI4ZzI5VU05c3A4WUh3d3FsUUk0RWNJQll4ZmVySDFZQWJBWU05WWZQ?=
 =?utf-8?B?VjJtU011Z3B5dm5weDUvRDI2SG9SK0dlNG9kWUI4bXZxSzcyMGtVMWQ2UXdO?=
 =?utf-8?B?Zk1pZms5WDVMNGRNR1NkcUNoNzNCWlo0NDI5ZFE2L3g0anh1WkxnSkVyREZV?=
 =?utf-8?Q?dlPdXrH+tX5Qft6bqwXilN0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDFB63388099E6429C05CC1E89947716@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7784aaf5-e017-42ac-858a-08ddea5072ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 18:42:20.2879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r0HfU2YVjcCdjxrsMpW2PqGxbmcHVWheRi5OOUJf9cgj1Khw0Ckp/XvybZso8tHwnswGi7cybU+Oo446sXtQHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6342
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX/OtE437Beg0G
 tPB9piDtqhp5FtfNnTkUj6QYESiCweOF7hbO87+fstbCjzA5h1CxJOaVtoCtREPMVMj9XHdeHZO
 HlR18nD7fV7YX5vl1qxW9pjnNDB5o3+i/Meg/IDvwn4ykbyosTm7ZMle6wvvbM0tzLW0cpHyUxI
 oH/q3Fk/B2prdd1WVU8scPmlHy4aKNy/PhFntSUD5ITYz/C27teiQ6Qr0C4N9O9VR6V3vql8UUS
 2s3V6E5E1s/Ub7/UaklnKJRfUCXNItc8tv0lytts5vH0oMzDTqAoilOtHYPU1/XV84BMeFdjr7S
 cQRik8PRyD9XMtljTlCIJFbgo4XzDu6mopOt1PkOLUuDkvgHn/y/t1oegzpvWdnn3IeTi+jmGcr
 J63asDFs
X-Proofpoint-GUID: xonlGME8EcSDTuYUQgtZT6orRz8IvUTx
X-Proofpoint-ORIG-GUID: kF6-tISez5bczL7VQoY-x4-Ennl41jk8
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68b73a90 cx=c_pps
 a=NmDNviYhsTavHyS1iw/olw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=937M4BFL9niS0vtieakA:9 a=QEXdDO2ut3YA:10
Subject: Re:  [PATCH 1/2] ceph/mds_client: transfer CEPH_CAP_PIN when updating
 r_parent on mismatch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030

T24gTW9uLCAyMDI1LTA5LTAxIGF0IDE1OjE0ICswMDAwLCBBbGV4IE1hcmt1emUgd3JvdGU6DQo+
IFdoZW4gdGhlIHBhcmVudCBkaXJlY3RvcnkgbG9jayBpcyBub3QgaGVsZCwgcmVxLT5yX3BhcmVu
dCBjYW4gYmVjb21lIHN0YWxlIGJldHdlZW4gZGVudHJ5IGxvb2t1cCBhbmQgcmVxdWVzdCBlbmNv
ZGluZy4NCj4gVGhlIGNsaWVudCB1cGRhdGVzIHJfcGFyZW50IHRvIHRoZSBjb3JyZWN0IGlub2Rl
IGJhc2VkIG9uIHRoZSBlbmNvZGVkIHBhdGgsIGJ1dCBwcmV2aW91c2x5IGRpZCBub3QgYWRqdXN0
IENFUEhfQ0FQX1BJTiByZWZlcmVuY2VzLg0KPiANCj4gUmVsZWFzZSB0aGUgcGluIGZyb20gdGhl
IG9sZCBwYXJlbnQgYW5kIGFjcXVpcmUgaXQgZm9yIHRoZSBuZXcgcGFyZW50IHdoZW4gc3dpdGNo
aW5nIHJfcGFyZW50LCBlbnN1cmluZyByZWZlcmVuY2UgYWNjb3VudGluZyBzdGF5cyBiYWxhbmNl
ZCBhbmQgYXZvaWRpbmcgbGVha3Mgb3IgdW5kZXJmbG93cyBsYXRlciBpbiBjZXBoX21kc2NfcmVs
ZWFzZV9yZXF1ZXN0KCkuDQo+IA0KDQpJIGNhbm5vdCBhcHBseSB0aGUgcGF0Y2ggb24gY3VycmVu
dCBzdGF0ZSBvZiB0aGUga2VybmVsLiBJIGFzc3VtZSB0aGF0IHRoaXMNCnBhdGNoIGlzIGltcHJv
dmVtZW50IG9mIHByZXZpb3VzIHBhdGNoIHNldC4gSWYgc28sIHRoZW4gaXQgd2lsbCBiZSBiZXR0
ZXIgdG8NCnNlbmQgYW5vdGhlciB2ZXJzaW9uIG9mIHByZXZpb3VzIHBhdGNoIHNldC4gT3RoZXJ3
aXNlLCBpdCdzIGhhcmQgdG8gcmV2aWV3IGFuZA0KaW1wb3NzaWJsZSB0byB0ZXN0IGl0Lg0KDQpU
aGFua3MsDQpTbGF2YS4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IE1hcmt1emUgPGFtYXJrdXpl
QHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgZnMvY2VwaC9tZHNfY2xpZW50LmMgfCAxMSArKysrKysr
KystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL21kc19jbGllbnQuYyBiL2ZzL2NlcGgvbWRzX2Ns
aWVudC5jDQo+IGluZGV4IGNlMGMxMjlmNDY1MS4uNGU1OTI2ZjM2ZThkIDEwMDY0NA0KPiAtLS0g
YS9mcy9jZXBoL21kc19jbGllbnQuYw0KPiArKysgYi9mcy9jZXBoL21kc19jbGllbnQuYw0KPiBA
QCAtMzA1MywxMiArMzA1MywxOSBAQCBzdGF0aWMgc3RydWN0IGNlcGhfbXNnICpjcmVhdGVfcmVx
dWVzdF9tZXNzYWdlKHN0cnVjdCBjZXBoX21kc19zZXNzaW9uICpzZXNzaW9uLA0KPiAgCSAqLw0K
PiAgCWlmICghcGFyZW50X2xvY2tlZCAmJiByZXEtPnJfcGFyZW50ICYmIHBhdGhfaW5mbzEudmlu
by5pbm8gJiYNCj4gIAkgICAgY2VwaF9pbm8ocmVxLT5yX3BhcmVudCkgIT0gcGF0aF9pbmZvMS52
aW5vLmlubykgew0KPiArCQlzdHJ1Y3QgaW5vZGUgKm9sZF9wYXJlbnQgPSByZXEtPnJfcGFyZW50
Ow0KPiAgCQlzdHJ1Y3QgaW5vZGUgKmNvcnJlY3RfZGlyID0gY2VwaF9nZXRfaW5vZGUobWRzYy0+
ZnNjLT5zYiwgcGF0aF9pbmZvMS52aW5vLCBOVUxMKTsNCj4gIAkJaWYgKCFJU19FUlIoY29ycmVj
dF9kaXIpKSB7DQo+ICAJCQlXQVJOX09OQ0UoMSwgImNlcGg6IHJfcGFyZW50IG1pc21hdGNoICho
YWQgJWxseCB3YW50ZWQgJWxseCkgLSB1cGRhdGluZ1xuIiwNCj4gLQkJCQkgIGNlcGhfaW5vKHJl
cS0+cl9wYXJlbnQpLCBwYXRoX2luZm8xLnZpbm8uaW5vKTsNCj4gLQkJCWlwdXQocmVxLT5yX3Bh
cmVudCk7DQo+ICsJCQkgICAgICAgICAgY2VwaF9pbm8ob2xkX3BhcmVudCksIHBhdGhfaW5mbzEu
dmluby5pbm8pOw0KPiArCQkJLyoNCj4gKwkJCSAqIFRyYW5zZmVyIENFUEhfQ0FQX1BJTiBmcm9t
IHRoZSBvbGQgcGFyZW50IHRvIHRoZSBuZXcgb25lLg0KPiArCQkJICogVGhlIHBpbiB3YXMgdGFr
ZW4gZWFybGllciBpbiBjZXBoX21kc2Nfc3VibWl0X3JlcXVlc3QoKS4NCj4gKwkJCSAqLw0KPiAr
CQkJY2VwaF9wdXRfY2FwX3JlZnMoY2VwaF9pbm9kZShvbGRfcGFyZW50KSwgQ0VQSF9DQVBfUElO
KTsNCj4gKwkJCWlwdXQob2xkX3BhcmVudCk7DQo+ICAJCQlyZXEtPnJfcGFyZW50ID0gY29ycmVj
dF9kaXI7DQo+ICsJCQljZXBoX2dldF9jYXBfcmVmcyhjZXBoX2lub2RlKHJlcS0+cl9wYXJlbnQp
LCBDRVBIX0NBUF9QSU4pOw0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo=

