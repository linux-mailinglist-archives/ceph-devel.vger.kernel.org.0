Return-Path: <ceph-devel+bounces-3405-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C3CCB21968
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Aug 2025 01:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C36B462AB6
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 23:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3912701C0;
	Mon, 11 Aug 2025 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="URpkDtoA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6061DED7B;
	Mon, 11 Aug 2025 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754954922; cv=fail; b=l8ydqADBgoH+OLFpSu6gtaiTAX4Sw+jC/L59xOh/dL5pYtSvL/VDKk0Gfw96Xh2+c03iY+BMdwzCSNdmPxP2F34J86kplutXwgss+D3hSYMUdAzArQJBubfNIibu70NMX3VaEPURVbGVMxe/gs9OTAzl5HSygXzXGg5iCEnccSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754954922; c=relaxed/simple;
	bh=UaI12Tbj8+4OeK0TFebFfP5cvttF8bJLaKoLBOxDkRI=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=ek1SxaSGlMUaCGCe70l/ovpsfk1fZX58XmEVQmLCpQlPeE8ST1BZib8VJL2T1Qv/KnVNmygsGulEdXFN5Q0fg/akEbTByfdkN5RLSwFUP5N1cQyka9/nkp9yND0LJLypMPeTkV3fCpS1nX4CEmCc7w7BGBb8u8MEWhgfAnAKvm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=URpkDtoA; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BHsVWD027712;
	Mon, 11 Aug 2025 23:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=UaI12Tbj8+4OeK0TFebFfP5cvttF8bJLaKoLBOxDkRI=; b=URpkDtoA
	YNhohZZvKGkonEzRf7IQazPnFe72NoF0cdpLLFZW9q8FTH23HTmIJjGRVrtX34pr
	CTNh+tHUirsYSozUtseAI7HiGDu8UFFOM3Yxn2BXVxkghoIMxppfWFkbHo3w5STE
	q8vZfAHWqK2MGtEu++zX6FvyUdRFKy0DEA+ky46OVXxvif6T7eAX22xAXp5SKi7L
	xC83h5HIZiVVOpQxqaCSq6XeTwJjFnGiKJ8eAj3k4qWF3op7I7B47OEcG+LRzDed
	7U1qYW5BpWCIT8c4riA9YxzMIZVcxyircMrG9dQ6Suux/Namnnn8BU3PyEb97USr
	OE1uDxuBTMja8w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3qd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:28:37 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BNSa5I025433;
	Mon, 11 Aug 2025 23:28:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2072.outbound.protection.outlook.com [40.107.102.72])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duru3qd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 23:28:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bm6s+OILrLBfovt6oR3PPfhp1H4FxzfHx+jhNhp5Xywg6qx5aV1wauF0hDXqHzYTxLqtIqKhQi+i7cOYx8htAJaQrpMbdB0o2TDr7KXK1xpvZ8gOr776FeW97FEszMFJMuGiIMBbndo57xwUcD6kp+qGBwsYVEg1hQFMVMXwEPaliU4zWHPwtaA6L4QIpzFvhEI9L2JZw4wN2bNIMqKKUS55eqEwWNWmh3pTGfwQmEcHn4C+l558rR9sWtlpAMXCPR6/HM8P+jddu5HbhdW9JsWrtRL+p5h36RmA96Uv0KCJ/pjVttqcS4uMGXLW2tWRwMxtIICJ+4iVS+p/hPFhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaI12Tbj8+4OeK0TFebFfP5cvttF8bJLaKoLBOxDkRI=;
 b=imgFwPUer2Q1f8+qDhB1acPq/qX1hTLg8MMwDSThHeBN/nLMa3139dmGpc+xb22kLtCFWhk88QTOPWVgtirrNppLQcXesCOej9ya0PI4TrVZZr2gKymCEVoZDXFSp/CXyjTUKd9qAkzTYZu3QHJ5Zo3q1q6idjiBgnIsnDXYO0uNA9mNhd9k3nWNGHzGaSjaWRygMWSCmNXNB2GlgDCC/FcbJdZ6JWP5W8Jl0H8zbE+C1iGdkbpBgW2sC+Sae/eDSysBBquvpniEkPVdcPTGbiDT8XPS6oSCYZ9Pr5pfQbOTWPks7HCptWTu6mpxGr7G4wpJtpSQ+a6byC3fVE1uKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by DS0PR15MB6301.namprd15.prod.outlook.com (2603:10b6:8:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 23:28:34 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 23:28:34 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: Alex Markuze <amarkuze@redhat.com>,
        "max.kellermann@ionos.com"
	<max.kellermann@ionos.com>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re:  [PATCH 2/3] net/ceph/messenger_v[12]: pass
 ceph_msg* instead of loading con->out_msg
Thread-Index: AQHcCxeoD6ntpmhdokeOrBCPpFtP+w==
Date: Mon, 11 Aug 2025 23:28:34 +0000
Message-ID: <e056ee7c035bd6213573b48d041057f3b31f3aef.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
		 <20250806094855.268799-3-max.kellermann@ionos.com>
	 <26848b81fd001e5ae67137f5d171e98a1e384a21.camel@ibm.com>
In-Reply-To: <26848b81fd001e5ae67137f5d171e98a1e384a21.camel@ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|DS0PR15MB6301:EE_
x-ms-office365-filtering-correlation-id: 5c016df6-2e23-431f-eb15-08ddd92eca89
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dlRIVFNSOTZWc0FSQnVQQllnQkxwKzI5TXlaWEg1a3g3VHJaU3BzemxFbnlC?=
 =?utf-8?B?ZThrUHNZcEJuRndaVWxUQ0s2L1hVeHlDQVRGM1Ruc2hMYSs5OXpPTndIUWhF?=
 =?utf-8?B?eHBva1BGUTVVeThNdHNZTytDZFdqSFdGNC9VYWtSUDdvcEpsbGJEU3lhcW1m?=
 =?utf-8?B?Wk9rSmo3dkxSa2dpOThGV2plOCtvcmhxREpST3pUQ1NkQUZIQU5GTzlueEdR?=
 =?utf-8?B?bGIwYmVXcmRRVjVWNG5LMUdVejFvb0VJRWtCS2xxdmRCN1phbGVnQWtHb01W?=
 =?utf-8?B?WWxYQXExYVVMa1BnRGpYN05GdnJOUGo0MC8yQzNGdWxieEEvdW9XMi9PWGVS?=
 =?utf-8?B?cVBDa2h2Y3dDMEVIbU9BVXlxc012MFV0cW9udlo3Y2lKOVlXejN1V0l5Zy96?=
 =?utf-8?B?OUtUS2VVckprd0MweSthNVlxT3JGNU8zNzg4eWY2aURMTkJGZ05zQUpWQU05?=
 =?utf-8?B?TjdHK3o0QmsyM29sRzV4VitRYjMwdGY0MXhiNmZsb3F5OEVMbW04b2Q4NzBv?=
 =?utf-8?B?ais0OExadXpxRnk0bDNubTdDMWFCczBvaWUvbDNDaTBSbmJtb0wxZnBtL1ls?=
 =?utf-8?B?YWh3cjJROXRrNXlxWmNDUEZndjVRSEpkYXNtU0ZpbTdtbDN6TWRxOVJYbFBa?=
 =?utf-8?B?N241bmE4R0dhWFNxU3UrVVBrbkhXRXVMQkxRUFc0QkRwcVA4MEg5d1Qvdnk0?=
 =?utf-8?B?OVBWTVNobk5iMEJjTlM5R2JUNW8vdmVmemFsYmczQnlucnRlTUxFVHRlZFRt?=
 =?utf-8?B?Q3RkOVIwaWdTanZSYSs1K3BEd1IxM3FUek5mbWR2MUZkRFJ0TFRwZ2cyaG1L?=
 =?utf-8?B?dmRtRk5GME13T1ZNTXMvMW12N29RNitFZENMUDBSNTlrL2owbXQwZkNTaTJW?=
 =?utf-8?B?MjI5NXRFb0JJQWVBWXNLTS9sR1JGbXRDYVVHU0k2M0thRExoMEY5bTRzeGV5?=
 =?utf-8?B?c2xrRGRxNVRwYUtNbzFNZUdwelA5VCtDemg5eFN6aFdtaW1TSkI2ZldNa0pw?=
 =?utf-8?B?R1ROaE5jMlp1NE44L2Y2bFcrenJDOVRKQzlzMjBiMkxnTS9qKzBKNnlObHBZ?=
 =?utf-8?B?K0JBVmJoS2N6aWYrMGw2cERRK1JET1Y5V1MweUJjWkpRSkRkTVoxQWZiSnVO?=
 =?utf-8?B?ZjA0MVdnQ2NabVhHY0tvVStXaW5hclNzS2lubUpyZUE4TXRNdDl0SjE3cjkx?=
 =?utf-8?B?dGUvM0ZscTZ3by9BOUdaMk5rczk0bzdna3gxNFhHeWVmd1VXaFk0aFdhTjJN?=
 =?utf-8?B?QXk0eHlsdDNSZUJ5V0R2U202Z2RPbHhGVytWdFY0MmlnaDFBdEVNbTV3eUpK?=
 =?utf-8?B?Q3o3WEM0d3dWRUlNUGFPZjd5NGtvZXRtQ0Nzd2VmRjRqM0ozc3E0UjBlWXBC?=
 =?utf-8?B?V3BnTGd5Ynk0K0xpdll1OUljc0JhL3Z4bW0rVGtad2FlS2FDbnRJVkU4bnV4?=
 =?utf-8?B?V2xiQU4rNUMrSVlYdndOWG9HTC9kTFJNdFJnSnMyY0tlODdyaVdEd1o2M2lG?=
 =?utf-8?B?TCtKWTFmQVF0b1RSYXdlM0lQNnBsRDVnZDRRWFhmZnlBcG85bmZCSnU4dnhN?=
 =?utf-8?B?VWR1R3NtUWtWU3Y2dUdxQ1JQNlpZZ3FBMmFCMjk4WlpVUTUwR3ozUGhYSDBI?=
 =?utf-8?B?N3pYRllIY0Q5SklmVjFaUlJPb1lCb01FL2p5YnZvQ0o0S3NqcDJNcjd2eEdH?=
 =?utf-8?B?VzBCdEJGNDlXdERXQnlVeFZQZ0RTUnVOcEZyZDJ1bDMzb05rcFVlUWQxSW50?=
 =?utf-8?B?QWZmYkphVnFsRGs5bEd1dTJFbENTZmxDWm9vRDVsWUZIR09vc0U3UXVwYU1w?=
 =?utf-8?B?OHNqSWdxUEdWNmNxamVGOVJVejNlZUZYL3Mza3JuK0d1L25tTXFqN2RUQ0Zz?=
 =?utf-8?B?a3NZMWxmSjFuQy9LQURLREdmbE9GYlBZNFc0Y1FIREVrQ0UvV2pjS1p5WnpN?=
 =?utf-8?B?dHpWaVFzeDVGd3dmMTJvaVJiSXRQT1A0REhIQ25FS3ZNV2JqWDlXZU1LYWxP?=
 =?utf-8?B?SS9ZaHkvc0tnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MWFlV2syM3JYNkhSVHE0SjFnVVptdDhLT01EWGVCR2d6aXprUkVXM3hmNmZR?=
 =?utf-8?B?RG5NYlNtWFV1NnZOT2ZaVFN5a2hCbzM0WC9EZ0xHUEN2RlBRZDNicUEzdzk2?=
 =?utf-8?B?TmVuVCs4OG1VRVZvMjNhMFhjRG1OcVlER2JjSXd2bFJXQkFITEFJUEZZdGNI?=
 =?utf-8?B?SEl2SG5FbDUwYTFsVG1ybzRNYVV4ejd5RFZwaWVmR2xBU29ERmo4aUN4dDNX?=
 =?utf-8?B?V0h0Y1ZiV0NZbENIUnFmTUcwU2EycnRuTmI3dVJCVHQ5Smh0emFaanZIbFFR?=
 =?utf-8?B?UXo5aWR1S3lkODB5TmZaWDd2b1d1akVKUERxNW5UZzI5RllONzRNbjgyYm5O?=
 =?utf-8?B?Zy9oQUhZSC9Ca3B3Lys3MW5jVTUyNURHdThFM29DZDBhNW9UU2FUZkJKbUEw?=
 =?utf-8?B?UmpxSTgyWXlVT3lkeERzcEVXK1ZqV0ozSjZ4d1hwQWovR2VDVzY1Q0V0N01X?=
 =?utf-8?B?emRKdENWVmxoQjNZWUNRTTg0NGRXMkN1b0VteUNaczJFaDhpN0xYdVpOVnd6?=
 =?utf-8?B?NGI5aUpFaGE1bzF3eCtPWXlCcXRQQk8xY21YckJTTVY5U0RWcWlrbzI3Y082?=
 =?utf-8?B?azBIRXM4OEFrYjlTTCtSdnEzd3pwWEkwMVl4aDFYQm1yUWIwcmd0dW9sYldl?=
 =?utf-8?B?OHJ0YUZLeFV1NFlTb2NiRWlGYUExclhhUW4wV24rc1RVRHRwTW44YVZuTlNI?=
 =?utf-8?B?NzFDNGxqeERkaXhqanlPN2ZBYmVXMXRZOUFWdk5YYThhaXlTNHNpTWJmOFho?=
 =?utf-8?B?M0tWZDdRbXlxS1lQWDdTUVZhUENxSUUyTXBKVzRDMjJZQThRODRGc2lPbmR2?=
 =?utf-8?B?dm0zOEova2g1L3RMbVBPZE02bG5uMHYwQUxjM2JkempGVTdNRGkxUDRBYzJL?=
 =?utf-8?B?WkxjVWZrdU1wcldDNmo3Z04vUFB3QUF0cFhyMlQxVGFLaDA2Tjlyd2o4cWFw?=
 =?utf-8?B?dkc3dXVUK3BYSzliOXVUbDVwWVVQdzZoNWNMa0Z5eDlvV2VhUERVQzJoeDhE?=
 =?utf-8?B?SWJZQlJOT1ZmSmpiQXV6RkJFTy9Oa3hSYmdFNU1wWmRxQzQ4UjQzMWxXT2dE?=
 =?utf-8?B?S1U5WTg4Z1J3anZxRmFOTTB6WWx5Uk1uODFMUEIwb285RjhFRDUvajdhVjFZ?=
 =?utf-8?B?YVB2VXYyZVV2ekhmUC9iTGNxbFUyUGVlYXlVdHN1YXBCZFV1ZStZVjhUdzdV?=
 =?utf-8?B?bzUxQUczekFYUlM2YTNkUi91OXVvUXVla2QvajlYVVFrY2VnZlgvVVNoUWhj?=
 =?utf-8?B?SWhRZUh4MWN2ZEhuaUtic0h5SUxDcnlvNjJDUnZUa3Z6OWxWZVNQakY5QmtD?=
 =?utf-8?B?WDRFUDJkWXpyb1dDS0tjUElBTmxXZmZBMGVscU94NTNKeFVtdXlMU1NrWWJp?=
 =?utf-8?B?ZHc0aXVyajUwUXkyamlnaE5VNGl0M3JWQVNJVmFXdHpIMlcwWUx4bW9iYXVV?=
 =?utf-8?B?TFVrbkN5d2tuT2trcHFlRjhtank4VVlodXdhamlUclB4L1BQQXlFazd6Ulpw?=
 =?utf-8?B?L0N6encwUFk0MlJSRzlzd0FGVkRVVUZKZFRWeWtyUGNucktLMjlqaGUyNTd1?=
 =?utf-8?B?U1ZHeUxmOVVtVnZ0UjNOa2hiWkkwVXdsaklJT1lZUGZ0NkRKUkZ3WFpiLzRk?=
 =?utf-8?B?SG9ONzBDaThoWXlHZExZZmlEUGdEYTNHOFd5R0RrQlhENWhNNWR5L1lsTWEy?=
 =?utf-8?B?MkpUd3VKVFF4QUlhMW42OEk4SVArS2xSeE56NFV1VmFEMTdRWmVCem90U1R2?=
 =?utf-8?B?Vm9LSng0MXhNZjNwcVZubENsU1VRR2ttS1lOM2xrRitHalR6dTgxa1A3VTZI?=
 =?utf-8?B?SFZPSnZKbWUwMVNzY2hDak9rWDhSTnBSeUJXMEczdERyV1hlZ2VUVDBSR3Br?=
 =?utf-8?B?K2xabUZadC9iaS8wVGVJNXlZbjVhdXBXanRTbkJ6bHZRbEpiRTUyaHZJTkdo?=
 =?utf-8?B?ZnB6N2ZkeXMySzVKc3JJQ25KeFBKSHN2RWJvbDJpRFZBeExYMitjekdCcGVk?=
 =?utf-8?B?aGFNb1YwU0lGRW1YdVI0QmRNRUJPaG13eC95Q2plYlZSWlIvZDk5R3ZKZWZv?=
 =?utf-8?B?b1F2bFNESThxU2tmOEpKWlpnM04xcWdncFY0dEQwRkltOUh3UzZTR1ZyS01Y?=
 =?utf-8?B?amNjc1p2VmZpU0ZxYVFpdzdRbzRlNFg3TUhhM3JTRE9ma2tJSXpuRU1PZUZZ?=
 =?utf-8?Q?DqVYC25y/Unxd1PbvmKjIIw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <713293D80F05FA468013C15C97895785@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c016df6-2e23-431f-eb15-08ddd92eca89
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 23:28:34.6046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ro5xy9mUxlVWhT3RWtY1Qeyc3TKDUy50omavj5RuN2oVG7VcfcqZ3ojVxUyZ7YcC4yaRpCeOVafQ0IQ9E8r8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6301
X-Proofpoint-GUID: rPH8VpVzolwT4QUV3lOEhsYYC-bj3HkP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDE3MCBTYWx0ZWRfXz4irOiiMdIBN
 FL6OulzUkWfS4kceRl9STnrWKpbHUgRm7GhGYe/UGgWk1uY7eaPcQ4L8PobzEORrbuXmrHsjIXM
 l7pl3Ze/g1Kgv6mb5r/8RQ7QpYXu5vgZkumhPhEXlHWBhk8eQXQSd0879+KeBP6dqLs8Mc45JDW
 6XgRLcCGf8EuZEgGOhhAYOJju+aSAw5F+OimK0juGrlXKJtco11I21t0m8Sb8WD5dQIf7nITi/c
 NloihS1BWijQz6gFnCYOWGnc2ikJSUvffNKku1qla9O91O9kI7GSW8oMZLm364UjTOERZjPvefu
 tLUO5jvjzLYGTsxOM9hc4Bc5nszW0qEm9ggzqzAFrd2W2J5qLOkWlXZK402nJ8oBb3mjfKiCA3x
 2MwNJ1/3N9N265kJtu0UXPVaLTtir2lTDIEFIKPHF2Nht+pt4ERwxBrq4OLvbz8ZaXKWbvOe
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689a7ca5 cx=c_pps
 a=8zgc5sNXbLROI2sqcl/dsQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=UgJECxHJAAAA:8 a=VnNF1IyMAAAA:8 a=f5fNGPBrlcbZzHKat7gA:9
 a=QEXdDO2ut3YA:10 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-ORIG-GUID: V14ynbq2UNCxpn7DtpDbJUtrxzgQCgNJ
Subject: RE:  [PATCH 2/3] net/ceph/messenger_v[12]: pass ceph_msg* instead of
 loading con->out_msg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_05,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110170

T24gRnJpLCAyMDI1LTA4LTA4IGF0IDE3OjQxICswMDAwLCBWaWFjaGVzbGF2IER1YmV5a28gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAyNS0wOC0wNiBhdCAxMTo0OCArMDIwMCwgTWF4IEtlbGxlcm1hbm4g
d3JvdGU6DQo+ID4gVGhpcyBwb2ludGVyIGlzIGluIGEgcmVnaXN0ZXIgYW55d2F5LCBzbyBsZXQn
cyB1c2UgdGhhdCBpbnN0ZWFkIG9mDQo+ID4gcmVsb2FkaW5nIGZyb20gbWVtb3J5IGV2ZXJ5d2hl
cmUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogTWF4IEtlbGxlcm1hbm4gPG1heC5rZWxsZXJt
YW5uQGlvbm9zLmNvbT4NCj4gDQo+IExvb2tzIGdvb2QuDQo+IA0KPiBSZXZpZXdlZC1ieTogVmlh
Y2hlc2xhdiBEdWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+DQo+IA0KPiANCg0KVGVzdGVk
LWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtz
LA0KU2xhdmEuDQo=

