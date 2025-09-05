Return-Path: <ceph-devel+bounces-3526-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA14B45FB9
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 19:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1388117B95B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 17:12:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F27230E85A;
	Fri,  5 Sep 2025 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gcT0irNE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341D2F7ACD;
	Fri,  5 Sep 2025 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757092324; cv=fail; b=CK/jSb7ZQFWrYC+1+GdY203LY/UWzgzKTEIQ7Gbv9to4DlwioX2XF10dyaJlOh0q7wLRSOWtdg3puMsMFcI5CgbkHvJ90M+pjvQx64Obj9VdKPPAW7Cl2nQ2DEwHxt58qsFYFs55wt2TfCUP1828J5y1Jtw67uTkic2Mfn+fXjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757092324; c=relaxed/simple;
	bh=vWATpa74DM9g9CE7VFBi7kzrkuVk/jLZTY8pXtAT6tE=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=oIaDpN6VIeqobq4joHLJiddrKmPHRKfrx9EHYx2yJ6stWWfxmPI8D8oGdgQVvLsGvwc6igckxyEJEV34MbDivkATrTn7XtG+bHkubh27LNSGDDiERRyNLSBOw9QdD98OkdJHGOCYQE/rHxOHwJ4LUL3kDrcOMe0OqbcqD7J8b2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gcT0irNE; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585GoQqK032215;
	Fri, 5 Sep 2025 17:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=vWATpa74DM9g9CE7VFBi7kzrkuVk/jLZTY8pXtAT6tE=; b=gcT0irNE
	T1szLi4EHx3BxUHYEob82QEHg8ISjyIbgsS4oQS0kmsDLcYZRvuD97fLBQhMx15h
	P5wZ3PMyhrZ8pQZTAgPKIMAMaQYCzB8j7HXTqahos7i52jl1Lxg4gHxHE4fqr1MG
	rF2EocT4RYIv5rAW/I4JM0W3iWrLu+sZP6LTc2Yoi3214oDjc/Yx9hG2Rr1/IOd7
	4izjBmTbd2yT7WpGOCmsH2AVhQ6ssjsw1Yvp5lS787E/0ffvUUvNuPJevjUDuWeL
	eKeIDieHB+ScqsAdwl05iorrSXIHhYebayRAlD/Zp+N6g635R/NH/3dBqdYOYBe/
	+rIjYWERaw0wZA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshfd5d8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 17:11:56 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 585GwUt6003791;
	Fri, 5 Sep 2025 17:11:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshfd5d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 17:11:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I68L+g9dlw9OLUIWDfyi0bvaNuDv0H/aTCPUKgYiKJAcWHTqTyQlL8XfFL+pW0XXTTMbSY8GulN4pZtPUeqTRIKhlgubt45cv06lAQBWPtjRD4+UzyI/UDZQAD+5LOYpix4OjmBQ3No6WPX08Vr//sXtEHJPZ47o0SCWMrrlum7lUclwBnfb+cP3Kg4CuKeAPiQsvHmZbJPvJB4MXR2nMA+mluGOFn+e05LsvO1hsnVTU2m5lgm/vimsqeLvXrhue79Ix0rnZqAp4OmAvZAP+KWgjaI6mfpd5hAvtGGiCvXlTRC/56QousKjixX4JivbHoLDXdpB0A2nV4vHNPDpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWATpa74DM9g9CE7VFBi7kzrkuVk/jLZTY8pXtAT6tE=;
 b=KuLwl22VLWzTU1yUT5lJqhFnjJmSaLTiESYyn+XrDlHUVyDwA0LS9DQc5ak1TEVBNARsdYA0qjX+cAVNeYipQiDQ4sjDU5Kl6g/e1BDnFVbb0DV7XSXQx95FRL5ponhsA69OGbFA+NooWkkd1ijCmWdEmzkqr35licT4zcElNElbJbFRcinHmuM7IGuz8M/zbmhGmoXki3vpXeaLP7CFHqGOqk1nOUO/GrC4VDpBZyYsl2idhY2a8jmwcAT9zD/9ttL5sHTCCEJ9nstkzP/lBOKVG3yavv14/v5uPcWq3IRYjytZJCo2svhzZ8V44mg3WTh10GQPhZ5kft8eO4je3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by LV3PR15MB6524.namprd15.prod.outlook.com (2603:10b6:408:275::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 5 Sep
 2025 17:11:54 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9094.015; Fri, 5 Sep 2025
 17:11:54 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "max.kellermann@ionos.com" <max.kellermann@ionos.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>, Alex Markuze <amarkuze@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>
Thread-Topic: [EXTERNAL] Re: [PATCH] fs/ceph/addr: always call
 ceph_shift_unused_folios_left()
Thread-Index: AQHcGE64qoYmawrjLUelljJPwcgz5rR4baUAgAApqoCACwH7AIAAZBAAgADiYoA=
Date: Fri, 5 Sep 2025 17:11:54 +0000
Message-ID: <b3d2da1abe05087f52a8e770bd8eac04c46b3370.camel@ibm.com>
References: <20250827181708.314248-1-max.kellermann@ionos.com>
	 <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
	 <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
	 <9af154da6bc21654135631d1b5040dcdb97d9e3f.camel@ibm.com>
	 <CAKPOu+8Eae6nXWPxV+BGLBVNwSu5dFEtbmo3geZi+uprkisMbg@mail.gmail.com>
	 <25a072e4691ec1ec56149c7266825cee4f82dee3.camel@ibm.com>
	 <CAKPOu+9MLQ5rH-eQ6SuiXTzFCEhmaZ9s-nKKQ4vpUCyvc9ho8g@mail.gmail.com>
In-Reply-To:
 <CAKPOu+9MLQ5rH-eQ6SuiXTzFCEhmaZ9s-nKKQ4vpUCyvc9ho8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|LV3PR15MB6524:EE_
x-ms-office365-filtering-correlation-id: 1f9ec09b-cf29-4034-7695-08ddec9f4fe3
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnBOMTlGNVZxL2ludmx4UTVWVW1xSU93QnBXZ2JZK2lrdEF2QWVXRmpya3No?=
 =?utf-8?B?cWtLM3lzemFMWVIrbVp5S3Y4SnlkZ0thdGluUEJ5dFpRTU1aVjZkbGJoY3Jx?=
 =?utf-8?B?YjArVHVDL3Z4VUs3RkRSNGk5V1ovZ3JBTzVGVUZaSjZ2NTVMNGhlTVU5c2k3?=
 =?utf-8?B?ZkF6czNvanRpNThqb2tMWWJmT0FRVmIzK2w1YmVnamR4Q1N0dHdvdGQzOGJY?=
 =?utf-8?B?WE85b1AzSlpGQ0tuSWhPSjVvckJtU0toYmNGeGV5dkxvRzQvbWY4MHREcU5p?=
 =?utf-8?B?Nk5tYzBPZ1hwbmF3a0p4QkZnZDFjNGIyNkpLSW9ickFoR1AyOFFQcHR2dFdI?=
 =?utf-8?B?dlFNSUFqN2FTbGs0ZW0xeUcyOW1iSlIzVUtqNGV3aUk4QkZzdjU1emdGN3ox?=
 =?utf-8?B?UzZlQU9ibkxGbjdFNFRjNjVoekFjQU02enFrUW0rVTJwK1VJVi9NZmh5VHdI?=
 =?utf-8?B?K0JFK0cvSTdJTUVjUkVqNVE4TlRQWlo1SzRGMys0cURxT0ZVYzI2bHJ5N045?=
 =?utf-8?B?YXRlTlpZNm5QaTcwakdTUUo3aFh3KzMxOTFneUtmMWdSaG9RUFJxdnhCNmR5?=
 =?utf-8?B?ME1rMEtFM0R2bzJzc1RlTW1FSXkrdWh4bUhHWnRDbHNWOFZoUW96ajZTVTdN?=
 =?utf-8?B?RXR5VWxjSlRMdXRDaEpWOVFlNkxHWjRCNkFtVjFReURLSDl6S1FjWFV5T3JC?=
 =?utf-8?B?WEh6VTFWcmtvSHA0dFZ6V2hENUd3U2FGSWY4QzhFVzU1M2d2VlVVOWNMS0xZ?=
 =?utf-8?B?T1F4dTB3K3NYZkhCK0xtbGFLWXROZk80RHZnZzJKMTM2RlR2SDFlOWlWOGls?=
 =?utf-8?B?TDJaUHN3a04vQ3lNVGxwc1V3aWxXajdudGRBT3RMdTlwRnNOVEhwOTJBOGti?=
 =?utf-8?B?VUlkbkxVcTJVTHRLR3NaRHk0WmZPR2VOWUpCOVJ4Q2VqLytVY2VEYXBHWDlk?=
 =?utf-8?B?MGFYeDJtWUtsSzc3MTd3SWtNd2dXbXhhOHFObU05SkFaenQvaVBISDZzYTFF?=
 =?utf-8?B?UzNCcENlSkEwRFRDcUNpQ2Uwdmt4RXgzZVN4MEdXMFVxZkI3TUhVZk43SkZ2?=
 =?utf-8?B?eUYwY1N2bFFmd0hIMjZqZWNNaHl0NTg2ZWhrbUpNdHM4SytjLzVDQklLWFhF?=
 =?utf-8?B?OGp2UG1LY296UUlNWW9GYjRVU3lZSStleEFhdytDR2w1WXJUemFka0NFZmQy?=
 =?utf-8?B?a0JEM2duQ1hIYlIybFVCRHpDNTQ2T1Z3MzBwaFZIRFNSUGFoaXlpdWVrTFQz?=
 =?utf-8?B?NWMxQk4zOUpsbUhHSDcwcUQ5ZG16c1NMaDl2ZDV0YVFzYU50KzRJd21GUnNZ?=
 =?utf-8?B?WVpvYU84S1diZFlSUXlGWlhDaWw0TGx6V1NOOTlOeU9QWVVUSHJiQTIrUm1N?=
 =?utf-8?B?dCthTktOWDcxbjZleXJYczFYWkZ3TnBzWTJBcHdDbVZSYVdqQkJrbElmZStQ?=
 =?utf-8?B?UTh1OGhqbGNRUDZCaW5IRjQ2SDNnOW4vbmZMVEVBL1VNVlk3c3ArWlNuTUsw?=
 =?utf-8?B?SCt5SmFoaDBVenA3bktva3RWR2tFVVEwRStYR2ticUk0NXhoUVM1bzFZcW5t?=
 =?utf-8?B?TDRJU21YZjR6T0ozYWpubnJ0ak9Qd1dzME4vZUNETGIzdWExeGxnYW9ZWTBz?=
 =?utf-8?B?dmhMbW5mYWp5SEdZR2tqZmJWVy9LaVkrRmhCK0JmOEJldjNoamVMU0lyeEp2?=
 =?utf-8?B?VFpSYmM3K0s2b29icDRnTlZ4NmJOZmt0WldvVWtocjNmRkRIQ2xtSnFmeWVa?=
 =?utf-8?B?bURja0RLMlhpaFIvMDdjcDNnbmR1MGh6TnQ0YkZKVzJ6WUtncjNmcVNHNnRm?=
 =?utf-8?B?a0xLT1VSaFpKaDJXUE9BMWY5Q082ekZIME1XYkd0K0Y1bTJ0akdnQW1MRENp?=
 =?utf-8?B?SEl6WnZKaWV2bG1FYkp0QnZTSGs3ckFLNW9jcmE3MHJiTmhKZkFDMDFiYUNT?=
 =?utf-8?B?VG5RSTBFOGF5SHppVUM4WkpicWw1MmZON3JaWkFnYy9pZnd0VEpHVjJFeFVX?=
 =?utf-8?B?Z1FmSEx6SlBRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1hRRkRST1pzaXhiQkJyeHdMVVF4WThXMWxhbURxbjBwdklxK0FPcXpqVVV5?=
 =?utf-8?B?UWJpWmlHKzlyTVR3TDNNZWVzZXpCK29Ha0RmeTZJSTdBN2FleEgyTlducjZI?=
 =?utf-8?B?cE5DS0F1VUlnUzcvRERsUmFNVkUxdW1xOC9aUGFXdDVNQStNNDNwSmY1TktB?=
 =?utf-8?B?YzhrZWZ3WXdXVXFvam84L1VrOHlpMnl4bDhsK3JFNzM1QXZjZFZ3bUxmdGV1?=
 =?utf-8?B?VUpPdUhqSW5mdVk2SktBc2NiTHlDK0VILy9hL0J1QVl6cHp4WXNEQ2Rsb3cw?=
 =?utf-8?B?NjFTSCtwczZKU1hEMjhySlVUNlZUUFZzZmRPUzdQcEczY1AvbVRhcjI1ajBK?=
 =?utf-8?B?WFk4c0xEZGpDdGxDWHR3L3dtV0lnTUZRM1A2ZHBKMmhEM0dPeS9TbjZjc2Zy?=
 =?utf-8?B?WFh2dEJuUGlLemZxcUpRc3JhVTMrVVNUWXZTa1JDNGpHZk4vTG5DeXo1RmdP?=
 =?utf-8?B?V3hQdjNUOEVPV0oweG9jV3hvOTRmTlNzRC9QQ3E5YmdUMEJ1T2hBNFdKUHM3?=
 =?utf-8?B?WEp5M0s0aTIrd25pTmgzaVF6MURId0ZOMmQ2UEZIYWI0Zmh3QVArSzVMdEZ2?=
 =?utf-8?B?YjI1Ny9XUS9Nakdqa2xNc3VHQU56ay9vbndkekNVKzVTU0hNdnhWR2E3eDBi?=
 =?utf-8?B?WlVzMHVjclhWNEcrY3pBUW90a1o0b3dJb0QvOHRoaFgwbWtLVnJCa0E3OEhC?=
 =?utf-8?B?ZUZjNjJEdWJqWXVCbTNQR1J6eUVVa2YyRjVDeU52RXFXY3V0ekNNYVZWRHpw?=
 =?utf-8?B?VWR0M0pkVFlTemRMT2FHUHEwMUl4OXFZcjRYSHlQUUtlL1ZMc1pFaHNOVmc0?=
 =?utf-8?B?UzNkNHY5Y2VhTGU5UC92QVpTUmI1SHJ1N1NDSVFmU1JBMm11RDNtbHZIVHJW?=
 =?utf-8?B?alZkUnVkV2tIUWtWWGVnbGdWak1UNktqLzVYbnNZZnVyRUpPK215UDBRWTlw?=
 =?utf-8?B?RCtFaUg2UTZEeDIyT0Q5QzRubkp4ZHc1RjJmbGI4VHhyc3lyWkR0eGRvMUI3?=
 =?utf-8?B?UXV0SU9TQ2ZPZTMwY3Z1cVlLWW9vSjhGU0lLSjRXRU1SamduRVYxZUd3NTNv?=
 =?utf-8?B?Q1Z5NmJWcDFraVhtaUU0QVNxeFJYaDA3TGJjM0VSM3hKWVpzUEUxYW5MYjZU?=
 =?utf-8?B?OVJ1eTVxNGtWSzBFcE5vZms2bENveHFlMTluWW96c1RoTzlMbmxIOUJ2Q0ZY?=
 =?utf-8?B?cnZjZ0E5VFFCT1pIRzFzSFJYbUJCaUVyeTVpVjlDMzJoS0k2NmE4WU13Mldm?=
 =?utf-8?B?ZXBXY2dQeThGc3I4M0ZpZEVJN3Fudm9GT2NRcXBnLzczU1QraldTK01XWFNM?=
 =?utf-8?B?L3dpYklzb2UyQXpBMmphbHlGUytaYU5RSFJ0WFdmL3dhNFdLaThoWGY5UGlH?=
 =?utf-8?B?Q1Jya0RUdks0VEFERWZUc29tY2ZBSGkwK1VJYXJpNzQ5eGc5ejl3ZUV0NHFN?=
 =?utf-8?B?Ylp5YVpDRFVkZWdpVjJXUCsvNWw3dlkxR09XZ3kxTU1tcUxjUFJ4QW0xVmxh?=
 =?utf-8?B?V1dPMFpGNmdLR0tSaUF5OTVpTitjWjl1elpHVmltTzJOckZQdXNla3VVSTdK?=
 =?utf-8?B?bElLb25wK3V5aUh5WlJPdzYxQkMxTmU2ZURiakxOK0NUQkFXeTZMYXJGNVFU?=
 =?utf-8?B?VzJrM0MvQVpRR3ROMSthd2ROZDROQ1BXdkFPOUp6NC8zMGd6SzlEVVVMS3gv?=
 =?utf-8?B?VHFDdUhVazB0YTh4cUxZczFCRVRUekdNK245SGZzT3hDS0VJOXY3NTZYckg0?=
 =?utf-8?B?Sm85NHBjQTZOdzQwaUdjVXFTR1RDT1UrSTl4UmptcnJ1TTdKMmlXbE1CVTAx?=
 =?utf-8?B?d1QyaSsxNDNiMGNwSnlzNzkyM1Rxd2NHVEFOb3VIc1RKTUhEZEZGQzR6MkVv?=
 =?utf-8?B?cFhQSWpWRHUxa09mUm5kL3h4T09NQW8zNCtFNUsrRUNYTGlmL1dRbXVJTXBR?=
 =?utf-8?B?L1VBdzU0bGRaSGV0ZTNXSk9rNHE5Y0VvT3JSYXliQzB3UG0yNHNFQVJIWHRP?=
 =?utf-8?B?QnpsQUEwQlpKSmdybHV2cGlUSGI3QjVkUEtlMEhKK2FGWkVNaExTY3FBLzF1?=
 =?utf-8?B?VjdsL0c4NVF3NlJXSjV0T0xDdzlWYWFGVnZXZ0kxVGFBZzBzL1l6UzA4RGZQ?=
 =?utf-8?B?R0dzZDVGaFBkc1JGV2thSmc5VW1nQ3RsWXROMzhCZFkzcXVQNS85UEcvNUs4?=
 =?utf-8?Q?gKMYypKfckOQhaV9dSM9fv4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43D1C816A2DF6B4B82B68951F3CF4898@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9ec09b-cf29-4034-7695-08ddec9f4fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2025 17:11:54.0593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zbuMqMQx/ffc+/V02YsWc5mgpAmmFYwVJ5uewKShycuDumsFs5wql5JhEhGawBfle36BSjVddsi0TwrlxvC3+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR15MB6524
X-Proofpoint-GUID: ruQOUcuO1CCefs1nxTvDt84hGUlYXLiP
X-Authority-Analysis: v=2.4 cv=do3bC0g4 c=1 sm=1 tr=0 ts=68bb19dc cx=c_pps
 a=ph/GQWrRymYAeOse1v/xUQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=175iI9nGJHfhUWSlcLcA:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: 34uXLH79NV3sAZA_9p0KnpQ5W0WjKaBk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAyMDA0MCBTYWx0ZWRfXxPRTgOlx97CU
 reXzvzslS/gfVdAbiEjfosHrYGZQWa4NrMCFnbt+NamM6qtTauu34C78/TewcgD/JrPpyJJzVsb
 N/TxvA/ttb2PyNTdUc/xsGMvg88tkYmAm//VvT7ULTI89kjqJ0U2AOKV4LgiPuoILm3zsHYonjX
 LcLDXcjXE9/9Ngv+o1LPhc5HM5CYrpiAYbGQKVUiqzqs4x6S/k1upSKtNN2mAaNi42yneQ1dm+t
 MsyABclpOq16h5wt9OzmWYWJH38yo0vb3PfGKSIIa9L1xk55pOwqaUShvfFFDuYnrqt4o/sG24g
 oYI+dngF5+N1ISQo9ngKknKM5I2BqsgdkT5z6C6vif5DLPNEG6jCsY9hu5g3Gj6q9l4wox9dnlX
 7l6T7Ixs
Subject: RE: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509020040

T24gRnJpLCAyMDI1LTA5LTA1IGF0IDA1OjQxICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gT24gVGh1LCBTZXAgNCwgMjAyNSBhdCAxMTo0M+KAr1BNIFZpYWNoZXNsYXYgRHViZXlrbw0K
PiA8U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gPiBCeSBhcHBseWluZyB0aGUgcGF0
Y2ggWzFdLCBlbmFibGluZyBDT05GSUdfREVCVUdfVk0sIGFuZCByZXR1cm5pbmcgLUUyQklHIGZy
b20NCj4gPiBjZXBoX2NoZWNrX3BhZ2VfYmVmb3JlX3dyaXRlKCksIEkgd2FzIGFibGUgdG8gcmVw
cm9kdWNlIHRoaXMgd2FybmluZzoNCj4gDQo+IFRoYW5rcywgSSdtIGdsYWQgeW91IGNvdWxkIHZl
cmlmeSB0aGUgYnVnIGFuZCBteSBmaXguIEluIGNhc2UgdGhpcw0KPiB3YXNuJ3QgY2xlYXI6IHlv
dSBzYXcganVzdCBhIHdhcm5pbmcsIGJ1dCB0aGlzIGlzIHVzdWFsbHkgYSBrZXJuZWwNCj4gY3Jh
c2ggZHVlIHRvIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZS4gSWYgeW91IG9ubHkgZ290IGEgd2Fy
bmluZyBidXQNCj4gbm8gY3Jhc2gsIGl0IG1lYW5zIHlvdXIgdGVzdCBWTSBkb2VzIG5vdCB1c2Ug
dHJhbnNwYXJlbnQgaHVnZSBwYWdlcw0KPiAobm8gaHVnZV96ZXJvX2ZvbGlvIGFsbG9jYXRlZCB5
ZXQpLiBJbiBhIHJlYWwgd29ya2xvYWQsIHRoZSBrZXJuZWwNCj4gd291bGQgaGF2ZSBjcmFzaGVk
Lg0KDQpJIHdvdWxkIGxpa2UgdG8gcmVwcm9kdWNlIHRoZSBjcmFzaC4gQnV0IHlvdSd2ZSBzaGFy
ZSBvbmx5IHRoZXNlIHN0ZXBzLg0KQW5kIGl0IGxvb2tzIGxpa2UgdGhhdCBpdCdzIG5vdCB0aGUg
Y29tcGxldGUgcmVjaXBlLiBTbywgc29tZXRoaW5nIHdhcyBtaXNzaW5nLg0KSWYgeW91IGNvdWxk
IHNoYXJlIG1vcmUgcHJlY2lzZSBleHBsYW5hdGlvbiBvZiBzdGVwcywgaXQgd2lsbCBiZSBncmVh
dC4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

