Return-Path: <ceph-devel+bounces-3399-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45322B212C6
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 19:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A5961907D7B
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Aug 2025 17:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD6329BDAA;
	Mon, 11 Aug 2025 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QjezeFyI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48B24315A;
	Mon, 11 Aug 2025 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.156.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931937; cv=fail; b=Tv4lt4f/vgGa9WZ/5Rsy9m5+gowHHS2fK4jyoA7mMDd6MO0r0tRRXuk3wFHjpP7J6X9pj8yhfayfyYxUa2tqEkfs6R8VIglCm5fwGRWyHONrXdYv6PgNMHCfxdriPgnt8fqlHiWyMexbzoC/Ijqo8OeHBqPWNPFrcPgiQolfc/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931937; c=relaxed/simple;
	bh=U8VpQX8qFZcQ1wJAqD5zGUhC9lHfqHdQYonhGcvHL94=;
	h=From:To:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=s6NdLu9ypVzB5SIQvOAp4LPUchZaBO+SLVwqgTl7ix3IUAVTHqUBnRjepMUSyl0VWdJ8gY/+TplK2lT9k4NwID/4EzSEUHUjXmXYsR7qUok8Zy1OgjyqSwYsExtYMYFNT/5JjLoPtuZO8bYIyJKyq5rnRmdhq98WL1cwjris1TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QjezeFyI; arc=fail smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BCcPo9013275;
	Mon, 11 Aug 2025 17:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=U8VpQX8qFZcQ1wJAqD5zGUhC9lHfqHdQYonhGcvHL94=; b=QjezeFyI
	JgI8G4n53lUWwbiY7dZplBXBVTr6kf6u72Vqk4wXe3owCLE7lnPdLThtimnnUfVw
	PaPsLXr7dnWVhjcwP9kgXudUldXi/Jbw/Blo7upTGZ09/2TB/CfPVJthmf4dexyY
	nh8bdL6EuZb+gcS77cHviktXVtYRYRTpNKKWH/1VxCgY5TzJW+Cf04X1YKcEAOSc
	jW7bzbLfBCEfbfb+nmKpG5O1Vsh35GeP/R7LCz6aOd+AKpCP0sFYIxKeaRBvi9Ov
	HdP1foorgWBT/5hKKPmFCmeWNFiwwY14V4XGjBARykqXtfqYUtPW1JnzzPV8S75X
	6PfwJgXA0m+aQQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2ctfbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 17:05:30 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57BH5TUn013052;
	Mon, 11 Aug 2025 17:05:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2ctfb7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 17:05:29 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t23Syan3i4wgUPGj7UhrWwyjweDhwI4jyVg+no0jYi6/ylCWwYlQdJ5Jsqt9kdp1UJxX/8Uh2WmPYKfPbBSp5qOAPTeHtDosq2TS9Q7CMY1BAByk4ARab/jW8lrOgP5RMUVB+YnU7A3hxf7LkoKPH4/iZhlwARiTyPCJimM8qCQekAz8DkQ71o4OgU5x21ELqCWOyN73yx25t+8nXPs7usnr/qXLiaPkFgo3OHN4fFqXWIxuagH7zJfe0ykb5aeF4tDX4vXGOqkiXpNQjWDkjkwIIoHzhJJYC1X0wS9fmWSnAOvbdNIru2WFQ5j+7k2qGy/zZpjK6gHU/X7eVUIFMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8VpQX8qFZcQ1wJAqD5zGUhC9lHfqHdQYonhGcvHL94=;
 b=aDa4Br+LZja5X2gUk7orXpDZ0Rsxnk3bfUL+SH2goM2PAJNEksNM6Ph2Z48Fvddmp59sDw0CikrkAIDq/dwQeS8YkmsOkKMymBUEKDsbSse621eT8a5mNnSc4A07B8xDI24eyAZ4K49sfoqf5DfZb53DKF1kjRm+KZB14FpUenpcl4pJPdyNyDvxoCYCdY9CitCy2XyA/n90blHg73v2eG5eCZg2xXkBd/uk9uYpWp6TutMZTO8qFt/vgsHlyUTn6MzK8qrwBoFuAkBZmpaB2zHEIkzIN3qz0eClc5bz/s9WLaWHop0g0tMIsbRfzF1Mpa7MJXXFD8pK5Fr8svGEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MN0PR15MB5321.namprd15.prod.outlook.com (2603:10b6:208:370::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 17:05:26 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::6fd6:67be:7178:d89b%3]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 17:05:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "max.kellermann@ionos.com" <max.kellermann@ionos.com>,
        Xiubo Li
	<xiubli@redhat.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Markuze
	<amarkuze@redhat.com>
Thread-Topic: [EXTERNAL] [PATCH 0/3] net/ceph/messenger: micro-optimizations
 for out_msg
Thread-Index: AQHcBrdg4TA/1EVXS0aOHp0gtPDty7RdttQA
Date: Mon, 11 Aug 2025 17:05:26 +0000
Message-ID: <bd3cc7be947770f7d3c265253573a8dd97478192.camel@ibm.com>
References: <20250806094855.268799-1-max.kellermann@ionos.com>
In-Reply-To: <20250806094855.268799-1-max.kellermann@ionos.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MN0PR15MB5321:EE_
x-ms-office365-filtering-correlation-id: b6317312-74fc-4d2a-af02-08ddd8f9449f
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eitBdmx6U3NDdmZuV1RNR0hvdkNEbDJkRFd2REQxdFZRVjd6M2YxSGRjNUtN?=
 =?utf-8?B?bFZUVVZsUVpTMzZBOC9pa1k0c0RlanZmd2wxU2dVRStwNUp5L05lc3ZLUFRa?=
 =?utf-8?B?SWVNNkpMaVg1VEFpc1U3U3dlbkwxQi8zZTBLNEhERzBFK05VblBudk5wNHpM?=
 =?utf-8?B?eGs2MVVrbTlTZUsrK3d1Sm80V3RzcUJLd09lek5vUkRYUFdqaDNIY3VEdHgr?=
 =?utf-8?B?NU13NXFRUGJjMzQxa0VJekxaVXpJakxFQ3F1QVp4SU9qNVJ5eHdNeHpxS0pp?=
 =?utf-8?B?TWxqUU82VitvMVFzN2dwQWZlWnRxSU1YQlpuUUZvMkprU2VqL3dDYU01UkR6?=
 =?utf-8?B?ZzFOYjNKbzFDTHNuSnF1MmNJTm00SlU5Tk1kSm9PTUpIWC93N3NBT0d3VjNn?=
 =?utf-8?B?SC9EYmhMNmVrUU9zRUYrbkhmVDR6c3A3THVxS2F2L2ZNTTlubHM5L25OUitq?=
 =?utf-8?B?dXFMNXRrVFZEdlUxU0FZcVZiVVJEN2xqMmx6ekxwc2JzcGhuQUV0bHF4UjVr?=
 =?utf-8?B?a3Z0QnZ6OUdoR2R5ZkRhdFR3TndNY2I4M28rNm52RlZUc3NlQ3FIRVRCdFpF?=
 =?utf-8?B?MER1NUtJb0drZWdxQTdwU3pVUmp3OU9CaloreDc2SVB1cHVlOW9QQlNwZkRJ?=
 =?utf-8?B?UGhaSlpCbXRya2tVOXV6N0dBb0dWb0VNTmV3UUJIdWV0dU96V2U5TnNnNXQ0?=
 =?utf-8?B?Rm5aazRSNWxsTW56WGNBTVQ0aUk4ckRLNjhCT3NPY2tPN28zYytBeWlPZXpQ?=
 =?utf-8?B?VnVGanUveXpCY2N5VHJ5cGlqWTZXWnFRU0p2cUlQaHJhMWNSa29kaU1IbXJV?=
 =?utf-8?B?SS9GdmNEVVR0ZnpFbkxGeUNvQW1LTDM5YmR0dEFzM2txTWRrL1dZT3VMTlYy?=
 =?utf-8?B?d0d1NGVxeXdxL0Z2RWs1YUFUSWZvSTRqckc5MjlZeHU3OEx2RXFXcVN1TEEx?=
 =?utf-8?B?VmRMRFJEM3ltelR0TUs4MVBKa0tRcGYzQ3NJOEpvNktFa0o4V0JkUDBqQ00z?=
 =?utf-8?B?VHdHNXRUeU0yNlZsWWZkcGFYZ0llY2pPQk9NREhTK0JjTi9DV0ZYcHpxazNZ?=
 =?utf-8?B?R2NZQ1RTSGlQa1BFbis4WWd2R21WVktzZkVGdWdjaUtMM0xnNFVVdFg4U3Yy?=
 =?utf-8?B?RVM5WWhpOXQvaG5Nak5Ybm16cjRnUkhsMDIyWWN0TUh0dXBGVDlXRytkd3pn?=
 =?utf-8?B?K3FES0dLUzVkRnpXZzBSb1IveTVxMTFTK3R0SzBDOFZJblUzTms1aVpaWVVO?=
 =?utf-8?B?Q0VsUmdqaEVDb0ZVUkE4dDNqciswenpOQVQ5M1lXTnBlYUdkS2gzVFlOVk53?=
 =?utf-8?B?ZTZMajlBRUtNZS8wNk4zd3FYMnV1SlNLZWRxWWYyOFB4Uys5ODlBdkdBY0lr?=
 =?utf-8?B?eU8yUm4vT2I5Zk15RU1wNHZiTG9XK0t6WjFuNS9NOHZRSXNYS1hpT0VCR3lG?=
 =?utf-8?B?OHo1N21LQUFPbFpRdWV0VURHZFhteHhhTHJMcWJhTDhNY0cvNko0QVEyamZu?=
 =?utf-8?B?SGNwTWJaajNXOFMzQTJlVExhL3lCc2pGY3V1cHBFNUhZdTlBS1kzYzlxS0dv?=
 =?utf-8?B?KzVkOG5EMzZhVndGaUhPWWR4MEw0UEtzRnV0dUlxalJoQUxvYVFwN0lpbS8w?=
 =?utf-8?B?Z2Fwb2x3NGZpSjVzTjArQmhQb0VhUmdKNlZYYmZvMy9GanI0Nlh6VDdFUWNl?=
 =?utf-8?B?ZFpadnpVaDZITjcwclBxY0RGRzZtZFlrRXc5Rks1WmFWaHh3S1lNWlNFQytP?=
 =?utf-8?B?cHNHc3J1OHhjb21YdWJseTdaNElqZXNUN0RiZ3BBaEllZCt3NmpxL21mbGIr?=
 =?utf-8?B?NHFsbDdUL3c5bHlHcWhjbVdSZ3RmNHJOQjdSajZRM25LdDRMVlRZL1I3aEJM?=
 =?utf-8?B?ZGtKOThPSVNIU0ZDcEJRemM2NjhKRnloL0dUekRISGdWUTV4K1RvMjJPbi9H?=
 =?utf-8?B?TXg3RzNNYkV3cDJEUWgzQzB2RTVRcjhMNzE4THNwclM3WnlrS3puRVhscVlS?=
 =?utf-8?B?RWZpc3BPM1FRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dFFIeWhHZWYxS051czlOQS84NEorVmZadGRVdGdoaFpNZHFFeHM3Sy9jVVhi?=
 =?utf-8?B?Wlgwd3N3bHpIY09pejVjd3llN1FnWVVSUjNpeUQ4TGxsb0hQQ1lIUTFqaGdy?=
 =?utf-8?B?djFHQVBoNi9RbmR0bC9vUWY4Zy9uV0s2OWpvOUlVdkxYRERxUk55WDZqK2hE?=
 =?utf-8?B?MkVBRGJsb01QTk9UVnl6bnBodnlMazROeVJxR0E1cWNlV1RVc1ZTSTBDSGky?=
 =?utf-8?B?SlhFM0NGQjhpciswQ3h2S2MyT05iaXdteU44cDY5bHZpYmpvMjBROG4xTms2?=
 =?utf-8?B?ZU5QVWhtVjF5Kzd3UWpXTmhGSWVuVExiaDU3RzNhYjg5MFAycXBpM3FhSVJk?=
 =?utf-8?B?S2ZKZEdNQ2F6TjRjVkJ1T0RNQjdUSXhySzI3Vng3MUFIemNzQ1JCZUZKNllo?=
 =?utf-8?B?RWdaQmQ2ZUpBd3Fjd09IczI4bVBUSk1LeVY0OGRvUTRGN0dxYUI3UUNZcUw3?=
 =?utf-8?B?cXBpMmFRTERFWnBuSmNWaHVGZEhYdTFxUERXanBOOXRtTUk1SitFRTU1OFZ5?=
 =?utf-8?B?MTBxakpNWUNpU1k1cllaZUt4RkR3MUJTZmxjNlRJWnIrNDA4V21FOGkrSTQx?=
 =?utf-8?B?WkkvbVlSckdtUFpIazdFS3VkZmZvSWJmbklsR2h4Zkk0MkdZQTl1YXdocDRm?=
 =?utf-8?B?cnNVdjVFeEh5RWFrdTQxaTVSVk8yL1Y1Vm5LaXgxKzZkMzlDbXlPYnRiMzcw?=
 =?utf-8?B?TWNCUVk5YzhzTkRPMWFXRG1NcEFkODRRT01Rc3dtMWdRaU0vNDRxOXBWTHZD?=
 =?utf-8?B?UXlRNnorM040U2RZQ3Rta3VXQnlLbDNLR3IrR1VBbk5WajZ0NTlLOWMweFox?=
 =?utf-8?B?ZjJhdlJjWDk4YVFVOUdRZzk3amJZNnBkZVlWbGc3SVV2RGpWdlVvcS9xMjJO?=
 =?utf-8?B?SFJGSEZSbVNUS25DN0xMR2ZvZlZubmJHNFNDenJGZHEzV21iTzBHN0Fud3FV?=
 =?utf-8?B?S0hZRlphc01CWlRUZlhweEh4VHYvMjQ5Y2dkQU41NXZ0bFp5Tmx2c3A1R05Q?=
 =?utf-8?B?L2h2OTlWL3Zac05Ha0RCV2tQdEUvVXRkOGlDbHRJL0QwVjZEanJxNU0zbm03?=
 =?utf-8?B?bG5qSzAwQ3BUSWdMRVZGZFlzTDRJRFdLSVppdXZ3VFMzMlNVcGl4MC8ycFhK?=
 =?utf-8?B?aVhYNkZjby9xNDkyMWVqR2c1OVVOYkVpQmJZSzQ4VVN6N3BDaWU5aXNOOE9P?=
 =?utf-8?B?ZGVyeTZVbCtPNTVyc3dBODBscUd0MUVpcmpOb2VZVWFRQTJ1T1VQOVd4N1oz?=
 =?utf-8?B?dTJUQU1DRTkxWkZBQ0pIK3hsR25FVlpXMXdUa3dpTmZCUmFwa2gwKzY0ZVVl?=
 =?utf-8?B?ZEFjVUhxZjh5L2FmWGd6bUZseFZONzU5QlFNcEpRQWI5SFNhN2x0enRhNFdZ?=
 =?utf-8?B?ZlBUWWgrZWtOekVLWnJVbFRlNm8zZmpHZ2pRZTZGS3hPaTB1cTlxdzRwUTlX?=
 =?utf-8?B?RS9PdzN4THFwMzBpRzQ3MUtUeDhRRXdVdk0ycnRiYXhIeTdQc0ZOT0NrL2JC?=
 =?utf-8?B?anYvL1Bkd2gvMmt1KzZqYzhERHdtWlF3VkxiVml1Y3NIaThYVUNnanBNbjh3?=
 =?utf-8?B?Q1BzdFhWcEFPZUhnd1FzSm5jYWhyNjJNZjBNS083bVM5Y0V4eXdIV0FGTk1N?=
 =?utf-8?B?bWZjUkRYbWI3am9YZGFmVWpVYStRSmZJa204dCsxS3N5ZEczNGxsV3hQTFFW?=
 =?utf-8?B?cHRqeVVSbGpWRzhpTCtDcWRjdXd3cUJRd1VtNlhFT2hQSW5HWi9pajhLLytU?=
 =?utf-8?B?YzdRdVV1RTZqNnhPbExTUGUzY0FXb3hraXNqTkg4MDVHMTdRWGJiRzZjOXRK?=
 =?utf-8?B?TndZSGRvZStlQ2FPVm9iMFZQU0dibEd4bXYxalhDQkNQL0Nuc2xLNmpvTjVt?=
 =?utf-8?B?cjJPQWlNdkFrY0s5OE1PNjk3V1BndWk4L1lVbWo5WXJsOUJ1bi9JSXhsb25v?=
 =?utf-8?B?aC9uQlJoeSs1QUhMZ1UrMVlTbU1lTEs0YzBRUlQvMVlBNExTM3M2Q1VmK1Vo?=
 =?utf-8?B?dER3Tno2V05MWkpBcllyNksxaFZjaEJ0SCt3NkREeHY5aDFqaUJ5WGwzNnpM?=
 =?utf-8?B?RE1nbklteG5yUUdrVHQvMU9PM29seWZqTytHOTFFdHpDSXp6ekdjbkhEZTBM?=
 =?utf-8?B?MjNMQ2N6NlQ1NDk5VEJRRXY5UUNDR1F2eFQwZDZuZGRXS3FpZnRmb2tHVkc1?=
 =?utf-8?Q?8ZMds+dfaNN70I3Rl3byH88=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAAC068CF3B7344A9E5708FBC1CB589B@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b6317312-74fc-4d2a-af02-08ddd8f9449f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2025 17:05:26.5747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tdyN7RGZaw9ZNETBvMvgtV+jNjjbthpePh2EfhhqtzA6GIZSlK7sR0XLkheKBME1qCca3ws+WOCRcT4xzNzEUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR15MB5321
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEwOSBTYWx0ZWRfX1P5g5wkjiPVe
 8YQUqq59kViOHGNGRuk2a/ekJliSpCgX10htzTCEJc8xk8d1kuBErv6xB48kZgUODsUhGivUR9/
 Ffaj6GxEpczqz4hFVpFe5nwQWFTCUWW3JKPAHhgqNTGEF3LbPLQKHA0yK8RnPpStnjo50YWCKfw
 wj+y/HDmL9wDu1FRFpDCByuAvTLlvEEFRny0SHfNkjOl3SMFMB5mKchWOt1Zv2hR0sZQvR8p647
 duSfTy1+NrEzdZCOHzm6jkYLpw4uMtYUQsaCL2ZKCuThZ8QPVx7sisNcldz5FJu2fwtuYKeHJud
 GAcd36rnqJTaUEJQRwMh+n5k7X2sqqMm9v/G7fqyEz3PHWi9A2PkK6Z9264qrKiFKuNBZYw1ts5
 UOuxir1t5OT/HBQqXabF4st82UUrcio2vuz4OT1u/aj595L9dj8VvnegVStauIBxwW/HQNQ2
X-Proofpoint-GUID: mVcJ0m_XS_29n-aiCI9xu9mFEjEoYZMj
X-Authority-Analysis: v=2.4 cv=C9zpyRP+ c=1 sm=1 tr=0 ts=689a22da cx=c_pps
 a=23ZrAAxOjRKSzRVqk0KFSw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=VhKz2HA2trGl_-0r1zEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: F96krBIuxxrMd-iNaAI5bEP-pNFGfZPW
Subject: Re:  [PATCH 0/3] net/ceph/messenger: micro-optimizations for out_msg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508110109

T24gV2VkLCAyMDI1LTA4LTA2IGF0IDExOjQ4ICswMjAwLCBNYXggS2VsbGVybWFubiB3cm90ZToN
Cj4gVGhlc2UgcGF0Y2hlcyByZWR1Y2UgcmVsb2FkcyBvZiBjb24tPm91dF9tc2cgYnkgcGFzc2lu
ZyBwb2ludGVycyB0aGF0DQo+IHdlIGFscmVhZHkgaGF2ZSBpbiBsb2NhbCB2YXJpYWJsZXMgKGku
ZS4gcmVnaXN0ZXJzKSBhcyBwYXJhbWV0ZXJzLg0KPiANCj4gQWNjZXNzIHRvIGNvbi0+b3V0X3F1
ZXVlIGlzIG5vdyBnb25lIGNvbXBsZXRlbHkgZnJvbSB2MS92MiBhbmQgb25seQ0KPiBmZXcgcmVm
ZXJlbmNlcyB0byBjb24tPm91dF9tc2cgcmVtYWluLiAgSW4gdGhlIGxvbmcgcnVuLCBJJ2QgbGlr
ZSB0bw0KPiBnZXQgcmlkIG9mIGNvbi0+b3V0X21zZyBjb21wbGV0ZWx5IGFuZCBpbnN0ZWFkIHNl
bmQgdGhlIHdob2xlDQo+IGNvbi0+b3V0X3F1ZXVlIGluIG9uZSBrZXJuZWxfc2VuZG1zZygpIGNh
bGwuICBUaGlzIHBhdGNoIHNlcmllcyBoZWxwcw0KPiB3aXRoIHByZXBhcmluZyB0aGF0Lg0KPiAN
Cj4gTWF4IEtlbGxlcm1hbm4gKDMpOg0KPiAgIG5ldC9jZXBoL21lc3NlbmdlcjogY2VwaF9jb25f
Z2V0X291dF9tc2coKSByZXR1cm5zIHRoZSBtZXNzYWdlIHBvaW50ZXINCj4gICBuZXQvY2VwaC9t
ZXNzZW5nZXJfdlsxMl06IHBhc3MgY2VwaF9tc2cqIGluc3RlYWQgb2YgbG9hZGluZw0KPiAgICAg
Y29uLT5vdXRfbXNnDQo+ICAgbmV0L2NlcGgvbWVzc2VuZ2VyOiBhZGQgZW1wdHkgY2hlY2sgdG8g
Y2VwaF9jb25fZ2V0X291dF9tc2coKQ0KPiANCj4gIGluY2x1ZGUvbGludXgvY2VwaC9tZXNzZW5n
ZXIuaCB8ICAgNiArLQ0KPiAgbmV0L2NlcGgvbWVzc2VuZ2VyLmMgICAgICAgICAgIHwgIDEyICst
LQ0KPiAgbmV0L2NlcGgvbWVzc2VuZ2VyX3YxLmMgICAgICAgIHwgIDU5ICsrKysrKy0tLS0tLQ0K
PiAgbmV0L2NlcGgvbWVzc2VuZ2VyX3YyLmMgICAgICAgIHwgMTYwICsrKysrKysrKysrKysrKyst
LS0tLS0tLS0tLS0tLS0tLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxMTkgaW5zZXJ0aW9ucygrKSwg
MTE4IGRlbGV0aW9ucygtKQ0KDQpVbmV4cGVjdGVkbHksIEkgY2FuIHNlZSB4ZnN0ZXN0cyBmYWls
dXJlcyB3aXRoIGFwcGxpZWQgcGF0Y2hzZXQ6DQoNCkZhaWx1cmVzOiBnZW5lcmljLzYzMyBnZW5l
cmljLzY0NCBnZW5lcmljLzY0NSBnZW5lcmljLzY4OSBnZW5lcmljLzY5Ng0KZ2VuZXJpYy82OTcN
CkZhaWxlZCA2IG9mIDYxMCB0ZXN0cw0KDQpJIHdpbGwgcmVwZWF0IHhmZXN0ZXN0cyBydW4gd2l0
aCBhbmQgd2l0aG91dCBwYXRjaHNldC4gTWF5YmUsIGl0IGlzIHRoZSBnbGl0Y2gNCm9uIG15IHNp
ZGUuDQoNClRoYW5rcywNClNsYXZhLg0K

