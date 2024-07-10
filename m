Return-Path: <ceph-devel+bounces-1515-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C0B92D80A
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 20:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11A3928566E
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 18:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B178196C9C;
	Wed, 10 Jul 2024 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="MhSiVtxW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D119580B;
	Wed, 10 Jul 2024 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635046; cv=none; b=sbnvSbR91PB+K6pFk18K8k/bd26hj08bI4SrDiuh6tH4ZT51ske4s8paKLVtmC67NTualbTjKYDf0xX09LfbqXIi0/Ju4pIqsdPhM26aatYsy8G/yaFZYMadkGueaRtN1GcPiGPDpuH31ZlXzI6sTa/TUdPobsMBskoKkGEP2U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635046; c=relaxed/simple;
	bh=WtpRa4xiQ1qNOnmfmePnx9yWjyXo7LYTsm+BC1oCOQY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=Bg+pSGj5JeTKKoRJcKnIupEN62p4CdRbMPDuojDDXdYIM3EuViAFxYWpu6O6rBzKUbXWufRZ/wbfMf+n2kkmmje8PihhwAg30DnXBQOQi6LMlpY7B7IuKBEOwwUxK0bVOF04amwngLLqvh6h4Ofc4eH9UNIQkhlZkgqQKfgtNZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=MhSiVtxW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46ACWEfa011903;
	Wed, 10 Jul 2024 18:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	upO1q7UqDwCuQ6QLFOEiDF+Q8CwpGosAr4b+J/eawts=; b=MhSiVtxWaVTKrhD8
	nKeBhCa4J9LTJj9OpBq6I+NwwrLkQUpmcviw3inTZC3Vii8YhWqA5L888SJ8doD2
	JxPcDlhtLy+QiUc1DrkP6W/YzuWth42zl2kOOy5c8leM4zu8nRj7w52bg9brSZLE
	E+Z2ZuOaA+JU9VGxRtvw39Sw7lhqCjKNDK5Lp/mlr31Hw0pl70a2zBOjclKT+Raa
	myM/7dTkr28LvNnImiUCULz/BoOvfpCveuJ7U+5Gy00ZZG+LR+rTAm8iNbC0YaPK
	t0sjA8OysuQ9mI1GSe2I3iEBLYJ2db4FwiJHt793TqtTwwYbkZybq5HvFydPkhXZ
	U8Swbw==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 406xpdsvnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:31 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46AIAC61028829
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:10:12 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 10 Jul
 2024 11:10:12 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Wed, 10 Jul 2024 11:10:04 -0700
Subject: [PATCH net-next 2/2] libceph: fix crush_choose_firstn() kernel-doc
 warnings
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240710-kd-crush_choose_indep-v1-2-fe2b85f322c6@quicinc.com>
References: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
In-Reply-To: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        "David S.
 Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: LrxBBlL1OzgaKpHzNzOicAglcVAa70E6
X-Proofpoint-ORIG-GUID: LrxBBlL1OzgaKpHzNzOicAglcVAa70E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_13,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407100128

Currently, when built with "make W=1", the following warnings are
generated:

net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'work' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'weight' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'weight_max' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'choose_args' not described in 'crush_choose_firstn'

Update the crush_choose_firstn() kernel-doc to document these
parameters.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 net/ceph/crush/mapper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 3194d5090963..16a0f7e63d37 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -429,7 +429,10 @@ static int is_out(const struct crush_map *map,
 /**
  * crush_choose_firstn - choose numrep distinct items of given type
  * @map: the crush_map
+ * @work: crush workspace initialized by crush_init_workspace()
  * @bucket: the bucket we are choose an item from
+ * @weight: weight vector (for map leaves)
+ * @weight_max: size of weight vector
  * @x: crush input value
  * @numrep: the number of items to choose
  * @type: the type of item to choose
@@ -445,6 +448,7 @@ static int is_out(const struct crush_map *map,
  * @vary_r: pass r to recursive calls
  * @out2: second output vector for leaf items (if @recurse_to_leaf)
  * @parent_r: r value passed from the parent
+ * @choose_args: weights and ids for each known bucket
  */
 static int crush_choose_firstn(const struct crush_map *map,
 			       struct crush_work *work,

-- 
2.42.0


